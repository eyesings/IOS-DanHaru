/*
 * CalendarDayCell.swift
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

open class CalendarDayCell: UICollectionViewCell {
    
    var style: CalendarView.Style = CalendarView.Style.Default
    
    override open var description: String {
        let dayString = self.textLabel.text ?? " "
        return "<DayCell (text:\"\(dayString)\")>"
    }
    
    var day: Int? {
        set {
            guard let value = newValue else { return self.textLabel.text = nil }
            self.textLabel.text = String(value)
        }
        get {
            guard let value = self.textLabel.text else { return nil }
            return Int(value)
        }
    }
    
    func updateTextColor() {
        
        if isToday {
            self.textLabel.textColor = .subHeavyColor
        }
        else if isAdjacent {
            self.textLabel.textColor = .clear
        }
        else if isWeekend {
            self.textLabel.textColor = .red
        }
        else {
            self.textLabel.textColor = style.cellTextColorDefault
        }
        
        self.textLabel.font = self.isToday ? .boldSystemFont(ofSize: 17) : .systemFont(ofSize: 17)
    }
    
    var isToday : Bool = false {
        didSet {
            updateTextColor()
        }
    }
    
    var isAdjacent : Bool = false {
        didSet {
            updateTextColor()
        }
    }
    
    var isWeekend: Bool = false {
        didSet {
            updateTextColor()
        }
    }
    
    override open var isSelected : Bool {
        didSet {
            
            updateTextColor()
        }
    }
    
    // MARK: - Public methods
    public func clearStyles() {
        self.bgView.backgroundColor = style.cellColorDefault
        self.textLabel.textColor = style.cellTextColorDefault
    }
    
    
    let textLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17)
        label.textAlignment = .center
        return label
    }()
    
    let bgView      = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.bgView)
        self.addSubview(self.textLabel)
        
    }
    
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func layoutSubviews() {
        
        super.layoutSubviews()
        
        var elementsFrame = self.bounds.insetBy(dx: 3.0, dy: 3.0)
        
        let smallestSide = min(elementsFrame.width, elementsFrame.height)
        elementsFrame = elementsFrame.insetBy(
            dx: (elementsFrame.width - smallestSide) / 2.0,
            dy: (elementsFrame.height - smallestSide) / 2.0
        )
        self.bgView.layer.cornerRadius = elementsFrame.width * 0.5
        
        self.bgView.frame           = elementsFrame
        self.textLabel.frame        = elementsFrame
    }
    
    func updateCellUI(toggle on: Bool) {
        self.bgView.layer.borderWidth = 2.0
        self.bgView.layer.borderColor = on ? UIColor.subHeavyColor.cgColor : style.cellColorDefault.cgColor
    }
    
}


