//
//  danharuWidget.swift
//  danharuWidget
//
//  Created by RadCns_SON_JIYOUNG on 2021/12/29.
//

import WidgetKit
import SwiftUI
import Intents
import RadFramework

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let color: String = ""
    let title: String = ""
}

struct danharuWidgetEntryView : View {
    var entry: Provider.Entry
    
    var todoData: [TodoModel] = {
        return savedTodoListFromUserDefaults()!
    }()
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    var body: some View {
        
        GeometryReader { geo in
            let widgetWidth = (geo.size.width/2) * 0.9
            let widgetHeight = geo.size.height/CGFloat(todoData.count/2) * 0.8
            ZStack {
                HStack(alignment: .center, spacing: nil) {
                    LazyVGrid(columns: columns, spacing: 3) {
                        ForEach(0..<todoData.count, id: \.self) { idx in
                            let todoModel = todoData[idx]
                            if let todoIdx = todoModel.todo_id,
                               let todoTitle = todoModel.title,
                               let todoColor = todoModel.color {
                                Link(destination: URL(string: "danharu://movetododetail?todoidx=\(todoIdx)")!) {
                                    Text(todoTitle.decodeEmoji())
                                        .frame(width: widgetWidth,
                                               height: widgetHeight)
                                        .background(Color.colorFromHex(hex: todoColor))
                                        .cornerRadius(10)
                                        .font(.system(size: 15.0))
                                }
                            } else {
                                Text("")
                                    .frame(width: widgetWidth,
                                           height: widgetHeight)
                                    .background(Color.colorFromHex(hex: "BCBEBF"))
                                    .cornerRadius(10)
                            }
                                
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical)
                }
            }
            .background(Color.colorFromHex(hex: "FFFCFC"))
            
        }
    }
}

@main
struct danharuWidget: Widget {
    let kind: String = "단, 하루 위젯"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            danharuWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("단, 하루 위젯")
        .description("위젯을 통해 쉽고 빠르게 원하는 곳으로 이동해 보세요.")
        .supportedFamilies([.systemMedium])
    }
}

struct danharuWidget_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            danharuWidgetEntryView(entry: SimpleEntry(date: Date()))
                .previewContext(WidgetPreviewContext(family: .systemMedium))
        }
    }
}


class NetworkManager {
    func fetchData(completion: @escaping (NSDictionary?) -> Void) {
        
    }
}

struct GridView<Content: View>: View {
    let rows: Int
    let columns: Int
    let content: (Int, Int) -> Content
    
    var body: some View {
        VStack {
            ForEach(0..<rows, id: \.self) { row in
                HStack {
                    ForEach(0..<self.columns, id: \.self) { column in
                        self.content(row, column)
                    }
                }
            }
        }
    }
    
    init(rows: Int, columns: Int, @ViewBuilder content: @escaping (Int, Int) -> Content) {
        self.rows = rows
        self.columns = columns
        self.content = content
    }
}

func savedTodoListFromUserDefaults() -> [TodoModel]? {
    var needModelCnt = 6
    if let savedData = UserDefaults.shared.value(forKey: Configs.UserDefaultsKey.listForWidget) as? Data {
        do {
            let jsonRst = try JSONSerialization.jsonObject(with: savedData, options: JSONSerialization.ReadingOptions.allowFragments) as! NSArray
            var dataDic: [TodoModel] = []
            jsonRst.forEach {
                if let dic = $0 as? NSDictionary {
                    let todoModel = try? JSONDecoder().decode(TodoModel.self,
                                                              from: JSONSerialization.data(withJSONObject: dic))
                    dataDic.append(todoModel!)
                    needModelCnt -= 1
                }
            }
            
            let emptyModel = TodoModel(todo_id: nil, mem_id: nil, title: nil, fr_date: nil, ed_date: nil, noti_cycle: nil, noti_time: nil, todo_status: nil, challange_status: nil, chaluser_yn: nil, certi_yn: nil, use_yn: nil, color: nil, created_at: nil, created_user: nil, updated_at: nil, updated_user: nil, certification_list: nil, challenge_user: nil, report_list_percent: nil)
            for _ in 0..<needModelCnt {
                dataDic.append(emptyModel)
            }
            
            return dataDic
        }
        catch {
            print("occur error \(error)")
        }
    }
    return nil
}

extension Color {
    static public func colorFromHex(hex: String) -> Color {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return .gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return Color(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            opacity: CGFloat(0.9)
        )
    }
}

