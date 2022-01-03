//
//  danharuWidget.swift
//  danharuWidget
//
//  Created by RadCns_SON_JIYOUNG on 2021/12/29.
//

import WidgetKit
import SwiftUI
import Intents

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
    
    let data = Array(1...6).map { "\($0)" }
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    var body: some View {
        
        LazyVGrid(columns: columns, spacing: 20) {
            ForEach(data, id: \.self) { i in
                Link(destination: URL(string: "danharu://movetododetail?todoidx=\(i)")!) {
                    Text(i)
                }
            }
        }
        .padding(.horizontal)
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
