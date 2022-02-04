/*
 * CalendarView.swift
 * Created by Michael Michailidis on 02/04/2015.
 * http://blog.karmadust.com/
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 */

import UIKit
import SnapKit
#if KDCALENDAR_EVENT_MANAGER_ENABLED
import EventKit
#endif

public protocol CalendarViewDataSource {
    func startDate() -> Date
    func endDate() -> Date
    /* optional */
    func headerString(_ date: Date) -> String?
}

extension CalendarViewDataSource {
    
    func startDate() -> Date {
        return Date()
    }
    func endDate() -> Date {
        return Date()
    }
    
    func headerString(_ date: Date) -> String? {
        return nil
    }
}

public protocol CalendarViewDelegate {
    
    func calendar(_ calendar : CalendarView, didSelectDate date : Date) -> Void
}

extension CalendarViewDelegate {
    func calendar(_ calendar : CalendarView, canSelectDate date : Date) -> Bool { return true }
}

public class CalendarView: UIView {
    
    public let cellReuseIdentifier = "CalendarDayCell"
    
    var headerView: CalendarHeaderView!
    var collectionView: UICollectionView!
    
    internal var selectedDate: Date?
    
    public var forceLtr: Bool = true {
        didSet {
            updateLayoutDirections()
        }
    }
    
    public var style: Style = Style.Default {
        didSet {
            updateStyle()
        }
    }
    
    public var calendar : Calendar {
        return style.calendar
    }
    
    public internal(set) var selectedIndexPaths = [IndexPath]()
    public internal(set) var selectedDates = [Date]()

    internal var _startDateCache: Date?
    internal var _endDateCache: Date?
    internal var _firstDayCache: Date?
    internal var _lastDayCache: Date?
    
    internal var todayIndexPath : IndexPath?
    internal var startIndexPath : IndexPath!
    internal var endIndexPath   : IndexPath!
    
    private let resetToTdayBtnTag: Int = 999

    internal var _cachedMonthInfoForSection = [Int:(firstDay: Int, daysTotal: Int)]()
    
    var flowLayout: CalendarFlowLayout {
        return self.collectionView.collectionViewLayout as! CalendarFlowLayout
    }
    
    // MARK: - public
    
    public internal(set) var displayDate: Date?
    
    public var delegate: CalendarViewDelegate?
    public var dataSource: CalendarViewDataSource?
    
    public var direction : UICollectionView.ScrollDirection = .horizontal {
        didSet {
            flowLayout.scrollDirection = direction
            self.collectionView.reloadData()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        self.setup()
    }
    
    // MARK: Create Subviews
    private func setup() {
        
        self.clipsToBounds = true
        self.translatesAutoresizingMaskIntoConstraints = false
        
        /* Header View */
        self.headerView = CalendarHeaderView(frame:CGRect.zero)
        self.headerView.style = style
        self.addSubview(self.headerView)
        
        
        let resetToTodayBtn = UIButton(frame: .zero)
        resetToTodayBtn.setTitle("오늘", for: .normal)
        resetToTodayBtn.setTitleColor(.heavyGrayColor, for: .normal)
        resetToTodayBtn.titleLabel?.font = .systemFont(ofSize: 13.0)
        resetToTodayBtn.tag = resetToTdayBtnTag
        resetToTodayBtn.addTarget(self, action: #selector(resetDisplayDate(_:)), for: .touchUpInside)
        self.headerView.addSubview(resetToTodayBtn)
        
        resetToTodayBtn.snp.makeConstraints { make in
            make.width.height.equalTo(self).multipliedBy(0.15)
            make.top.trailing.equalTo(self).offset(-5)
        }
        
        
        /* Layout */
        let layout = CalendarFlowLayout()
        layout.scrollDirection = self.direction;
        layout.sectionInset = UIEdgeInsets.zero
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0

        /* Collection View */
        self.collectionView                     = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        self.collectionView.dataSource          = self
        self.collectionView.delegate            = self
        self.collectionView.isPagingEnabled     = true
        self.collectionView.backgroundColor     = UIColor.clear
        self.collectionView.showsHorizontalScrollIndicator  = false
        self.collectionView.showsVerticalScrollIndicator    = false
        self.collectionView.allowsMultipleSelection         = false
        self.collectionView.register(CalendarDayCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)
        
        self.addSubview(self.collectionView)
        
        // Update semantic content attributes
        updateLayoutDirections()
    }
    
    override open func layoutSubviews() {
        
        super.layoutSubviews()
        
        self.headerView?.frame = CGRect(
            x: 0.0,
            y: 0.0,
            width: self.frame.size.width,
            height: style.headerHeight
        )
        
        self.collectionView?.frame = CGRect(
            x: 0.0,
            y: style.headerHeight,
            width: self.frame.size.width,
            height: self.frame.size.height - style.headerHeight
        )
        
        flowLayout.itemSize = self.cellSize(in: self.bounds)
        
        self.resetDisplayDate()
    }
    
    private func cellSize(in bounds: CGRect) -> CGSize {
        guard let collectionView = self.collectionView
            else {
                return .zero
            }
        
        return CGSize(
            width:   collectionView.bounds.width / 7.0,                                    // number of days in week
            height: (collectionView.bounds.height) / 6.0 // maximum number of rows
        )
    }
    
    internal var _isRtl = false
    
    internal func updateLayoutDirections() {
        
        var isRtl = false
        
        if !forceLtr
        {
            isRtl = UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft
        }
        
        if _isRtl != isRtl
        {
            _isRtl = isRtl
            
            self.collectionView?.transform = isRtl
                ? CGAffineTransform(scaleX: -1.0, y: 1.0)
                : CGAffineTransform.identity
            self.collectionView?.reloadData()
        }
    }
    
    @objc
    internal func resetDisplayDate(_ sender: UIButton = UIButton()) {
        let date = sender.tag == resetToTdayBtnTag ? Date() : self.selectedDate ?? Date()
        self.collectionView.setContentOffset(
            self.scrollViewOffset(for: date),
            animated: sender.tag == resetToTdayBtnTag
        )
        let distpatchTime: DispatchTime = sender.tag == resetToTdayBtnTag ? .now() : .now() + 0.5
        DispatchQueue.main.asyncAfter(deadline: distpatchTime) {
            self.displayDateOnHeader(date)
        }
        
        if sender.tag == resetToTdayBtnTag { selectDate(Date()) }
    }
    
    internal func updateStyle() {
        self.headerView?.style = style
    }
    
    func scrollViewOffset(for date: Date) -> CGPoint {
        var point = CGPoint.zero
        
        guard let sections = self.indexPathForDate(date)?.section else { return point }
        
        switch self.direction {
        case .horizontal:   point.x = CGFloat(sections) * self.collectionView.frame.size.width
        case .vertical:     point.y = CGFloat(sections) * self.collectionView.frame.size.height
        @unknown default:
            fatalError()
        }
        
        return point
    }
}

// MARK: Convertion

extension CalendarView {

    func indexPathForDate(_ date : Date) -> IndexPath? {
        
        let distanceFromStartDate = self.calendar.dateComponents([.month, .day], from: self.firstDayCache, to: date)
        
        guard
            let day   = distanceFromStartDate.day,
            let month = distanceFromStartDate.month,
            let (firstDayIndex, _) = getCachedSectionInfo(month) else { return nil }
        
        return IndexPath(item: day + firstDayIndex, section: month)
    }
    
    func dateFromIndexPath(_ indexPath: IndexPath) -> Date? {
        
        let month = indexPath.section
        
        guard let monthInfo = getCachedSectionInfo(month) else { return nil }
        
        var components      = DateComponents()
        components.month    = month
        components.day      = indexPath.item - monthInfo.firstDay
        
        var date: Date?
        
//        let date = self.calendar.date(byAdding: components, to: self.firstDayCache)
//        print("dateformatter \(DateFormatter().korDateString(date: date!, dateFormatter: "yyyy-MM-dd HH:mm:ss EEEE"))")
        
        if let firstDayMonth = Int(DateFormatter().korDateString(date: firstDayCache, dateFormatter: "MM")),
           let firstDayYear = Int(DateFormatter().korDateString(date: firstDayCache, dateFormatter: "YYYY")) {
            
            var year = firstDayYear
            var month = firstDayMonth + components.month!
            if month > 12 { month -= 12; year += 1 }
            
            let day = components.day! + 1
            
            let selectDate = "\(year)-\(month)-\(day)"
//            print("selectDate \(selectDate)")
            
            let dformatter = DateFormatter()
            dformatter.dateFormat = "yyyy-MM-dd"
            dformatter.timeZone = TimeZone(abbreviation: "UTC")
            date = dformatter.date(from: selectDate)
        }
        
        self.selectedDate = date
        
        return date
    }
}

// MARK: - Public methods
extension CalendarView {
    
    /*
     method: - reloadData
     function: - reload all components in collection view
     */
    public func reloadData() {
        self.collectionView.reloadData()
    }
    
    /*
     method: - setDisplayDate
     params:
     - date: Date to extract month and year to scroll at correct section;
     - animated: to handle animation if want;
     function: - scroll calendar at date (month/year) passed as parameter.
     */
    public func setDisplayDate(_ date : Date, animated: Bool = false) {
        guard (startDateCache..<endDateCache).contains(date) else { return }
		
        self.collectionView?.reloadData()
        self.collectionView?.setContentOffset(self.scrollViewOffset(for: date), animated: animated)
        self.displayDateOnHeader(date)
    }
    
    /*
     method: - selectDate
     params:
     - date: Date to select;
     function: - mark date as selected and add it to the array of selected dates
     */
    public func selectDate(_ date : Date) {
        
        guard let indexPath = self.indexPathForDate(date) else { return }
        
        self.collectionView.selectItem(at: indexPath, animated: false, scrollPosition: UICollectionView.ScrollPosition())
        self.collectionView(collectionView, didSelectItemAt: indexPath)
    }
    
    /*
     method: - deselectDate
     params:
     - date: Date to deselect;
     function: - unmark date as selected and remove it from the array of selected dates
     */
    public func deselectDate(_ date : Date) {
        guard let indexPath = self.indexPathForDate(date) else { return }
        self.collectionView.deselectItem(at: indexPath, animated: false)
        self.collectionView(collectionView, didSelectItemAt: indexPath)
    }

    /*
     method: - clearAllSelectedDates
     function: - clear all selected dates.  Does not call `didDeselectDate` callback
     */
    public func clearAllSelectedDates() {
        selectedIndexPaths.removeAll()
        selectedDates.removeAll()
        self.reloadData()
    }
}
