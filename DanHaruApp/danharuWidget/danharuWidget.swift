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

struct Provider: TimelineProvider {
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(),
                    todoList: savedTodoListFromUserDefaults() ?? [])
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        let entry = SimpleEntry(date: Date(),
                                todoList: savedTodoListFromUserDefaults() ?? [])
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> Void) {
        loadTodoListDataFromServer {
            var entries: [SimpleEntry] = []

            // Generate a timeline consisting of five entries an hour apart, starting from the current date.
            let currentDate = Date()
            for hourOffset in 0 ..< 5 {
                let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
                let entry = SimpleEntry(date: entryDate,
                                        todoList: savedTodoListFromUserDefaults() ?? [])
                entries.append(entry)
            }

            let timeline = Timeline(entries: entries, policy: .atEnd)
            completion(timeline)
        }
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let todoList: [TodoModel]
}

struct danharuWidgetEntryView : View {
    var entry: Provider.Entry
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    let customBlack = Color.colorFromHex(hex: "253138")
    let customLightGray = Color.colorFromHex(hex: "f4f4f4")
    var body: some View {
        
        GeometryReader { geo in
            let widgetWidth = (geo.size.width/2) * 0.9
            let widgetHeight = geo.size.height/CGFloat(entry.todoList.count/2) * 0.8
            ZStack {
                HStack(alignment: .center, spacing: nil) {
                    LazyVGrid(columns: columns, spacing: 5) {
                        ForEach(0..<6, id: \.self) { idx in
                            let todoModel = entry.todoList[idx]
                            if let todoIdx = todoModel.todo_id,
                               let todoTitle = todoModel.title,
                               let todoColor = todoModel.color {
                                Link(destination: URL(string: "danharu://movetododetail?todoidx=\(todoIdx)")!) {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 10)
                                            .frame(width: widgetWidth,
                                                   height: widgetHeight)
                                            .foregroundColor(.colorFromHex(hex: todoColor))
                                        Text(todoTitle.decodeEmoji())
                                            .font(.system(size: 15.0))
                                            .foregroundColor(customBlack)
                                            .frame(width: widgetWidth * 0.8, height: widgetHeight * 0.5)
                                        if let todoChall = todoModel.chaluser_yn, todoChall.lowercased() == "y" {
                                            HStack {
                                                Rectangle().foregroundColor(.clear)
                                                Spacer()
                                                let imageSize = widgetHeight * 0.8
                                                Image(uiImage: UIImage(named: "personFill")!)
                                                    .resizable(capInsets: EdgeInsets(top: 0.0, leading: 0.0, bottom: 0.0, trailing: 0.0))
                                                    .frame(width: imageSize, height: imageSize)
                                                    .opacity(0.1)
                                                Spacer()
                                            }
                                        }
                                    }
                                }
                            } else {
                                RoundedRectangle(cornerRadius: 10)
                                    .frame(width: widgetWidth,
                                           height: widgetHeight)
                                    .foregroundColor(customLightGray)
                            }
                                
                        }
                    }
                    .padding(.horizontal)
                    .frame(width: geo.size.width,
                           height: geo.size.height)
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
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
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
            danharuWidgetEntryView(entry: SimpleEntry(date: Date(),
                                                      todoList: savedTodoListFromUserDefaults() ?? []))
                .previewContext(WidgetPreviewContext(family: .systemMedium))
        }
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

func loadTodoListDataFromServer(completionHandler: @escaping () -> ()) {
    guard let todoListSearchUrl = URL(string: Configs.API.todoList) else { return }
    
    let apiAuthKey = UserDefaults.shared.string(forKey: Configs.UserDefaultsKey.authForWidget)
    
    let userId = UserDefaults.shared.string(forKey: Configs.UserDefaultsKey.userInputID)?.decrypt()
    let date = DateFormatter(format: "yyyy-MM-dd").string(from: Date())
    let param: [String:Any] = ["mem_id":userId ?? "", "fr_date":date]
    
    var todolistRequest = URLRequest(url: todoListSearchUrl)
    todolistRequest.setValue(apiAuthKey, forHTTPHeaderField: "Authorization")
    todolistRequest.httpMethod = "post"
    
    todolistRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
    do { todolistRequest.httpBody = try JSONSerialization.data(withJSONObject: param, options: .prettyPrinted) }
    catch { }
    
    let task = URLSession.shared.dataTask(with: todolistRequest) { data, _, error in
        //error 일경우 종료
        if let err = error { print(err.localizedDescription); return }
        
        //data 가져오기
        if let _data = data {
            
            //메인쓰레드에서 출력하기 위해
            DispatchQueue.main.async {
                do {
                    let jsonRst = try JSONSerialization.jsonObject(with: _data,
                                                                   options: JSONSerialization.ReadingOptions.allowFragments) as? NSDictionary
                    
                    var todoModelList: [TodoModel] = []
                    if let resultDic = jsonRst,
                       let resultArr = resultDic["detail"] as? [NSDictionary] {
                        for todoList in resultArr {
                            let todoModel = try JSONDecoder().decode(TodoModel.self,
                                                                     from: JSONSerialization.data(withJSONObject: todoList))
                            todoModelList.append(todoModel)
                        }
                    }
                    
                    if let encodeData = try? JSONEncoder().encode(todoModelList) {
                        UserDefaults.shared.set(encodeData, forKey: Configs.UserDefaultsKey.listForWidget)
                        completionHandler()
                    }
                }
                catch { print("parsing error : \(error.localizedDescription)") }
                
            }
            
        } else{ print("data nil") }
    }
    task.resume()
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
            opacity: CGFloat(1.0)
        )
    }
}

extension String {
    func decrypt() -> String {
        return RadHelper.AES256Decrypt(WithValue: self, baseKey: Configs.BASE64Key)
    }
}

