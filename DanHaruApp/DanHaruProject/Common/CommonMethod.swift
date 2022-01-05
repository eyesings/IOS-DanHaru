//
//  CommonMethod.swift
//  DanHaruProject
//
//  Created by RadCns_SON_JIYOUNG on 2021/10/25.
//

import Foundation
import UIKit
import FirebaseDynamicLinks
import AVFAudio

/// 개발전용 로그
/// - Parameters:
///   - obj: 출력 값
///   - function: 해당 함수명
/// - Returns: 출력로그
func Dprint(_ obj: Any..., function: String = #function) -> () {
    #if DEBUG
    print("\(function) : \(obj)")
    #endif
}

// MARK: - RadHelper
extension RadHelper {
    
    /// 하단 SafeArea Indicator 영역
    static var bottomSafeAreaHeight: CGFloat = {
        let window = UIApplication.shared.keyWindow
        let bottomPadding = window?.safeAreaInsets.bottom ?? 0.0
        return bottomPadding
    }()
    
    /// HomeSB에서 UIViewController 받아오는 함수
    /// - Returns: VC
    static func getVCFromHomeSB() -> UIViewController {
        return UIStoryboard(name: "HomeSB", bundle: nil).instantiateViewController(withIdentifier: StoryBoardRef.homeVC)
    }
    
    /// MainViewController에서 UIViewController 받아오는 함수
    /// - Returns: VC
    static func getVCFromMainSB() -> UIViewController {
        return UIStoryboard(name: "MainViewController", bundle: nil).instantiateViewController(withIdentifier: StoryBoardRef.mainNavVC)
    }
    
    /// UserJoinSB에서 UIViewController 받아오는 함수
    /// - Parameter withID: 스토리보드 ID (StoryBoardRef 타입)
    /// - Returns: VC
    static func getVCFromUserJoinSB(withID: String) -> UIViewController {
        return UIStoryboard(name: "UserJoinSB", bundle: nil).instantiateViewController(withIdentifier: withID)
    }
    
    /// MyPageSB에서 UIViewController 받아오는 함수
    /// - Parameter withID: 스토리보드 ID (StoryBoardRef 타입)
    /// - Returns: VC
    static func getVCFromMyPageSB(withID: String) -> UIViewController {
        return UIStoryboard(name: "MyPageSB", bundle: nil).instantiateViewController(withIdentifier: withID)
    }
    
    /// RootVC를 MainVC로 변경하는 함수
    static func rootVcChangeToMain() {
        if let appdelegate = UIApplication.shared.delegate as? AppDelegate {
            appdelegate.switchToMain()
        }
    }
    
    /// UserModel 프로필 이미지 주소 값으로 부터 이미지 받아오는 함수
    /// - Returns: 프로필 이미지
    static func getProfileImage(completeHandler: @escaping (UIImage?)->Void) {
        
        let profileImg = UIImage(named: "profileNon")
        guard let profileImgUrl = UserModel.profileImgUrl else { completeHandler(profileImg); return }
        
        RadServerNetwork.getDataFromServerNeedAuth(url: Configs.API.getUsrImg + "/" + profileImgUrl, type: .IMAGE) { dic in
            if let dic = dic {
                let img = dic["image"] as? UIImage
                completeHandler(img)
            } else {
                completeHandler(profileImg)
            }
        } errorHandler: { err in
            Dprint("error with \(err.localizedDescription)")
            completeHandler(profileImg)
        }
    }
    
    static func keyboardAnimation(_ noti: Notification, _ moveLayout: NSLayoutConstraint, forCustom: Bool = false, isUpdateToHihger: Bool = false, completionHandler: @escaping () -> Void) {
        if let keyboardFrame: NSValue = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            
            keyboardH = keyboardH > keyboardHeight ? keyboardH : keyboardHeight
            if forCustom { completionHandler(); return }
            
            moveLayout.constant = noti.name == UIResponder.keyboardWillShowNotification ? -(isUpdateToHihger ? keyboardH : keyboardHeight - RadHelper.bottomSafeAreaHeight) : 0
            if noti.name == UIResponder.keyboardWillHideNotification { keyboardH = 0.0 }
            completionHandler()
        }
    }
    
    static var tempraryID: String = {
        return "DHR" + "\(Date().timestamp)"
    }()
    
    static var isIphoneSE1st: Bool = {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        return identifier == "iPhone8,4"
    }()
    
    static func AES256Encrypt(WithValue value: String?) -> String {
        return RadHelper.AES256Encrypt(WithValue: value, baseKey: Configs.BASE64Key)
    }
    
    static func AES256Decrypt(WithValue value: String?) -> String {
        return RadHelper.AES256Decrypt(WithValue: value, baseKey: Configs.BASE64Key)
    }
    
    static func convertNSTimeInterval12String(_ time:TimeInterval) -> String {
        let min = Int(time/60)
        let sec = Int(time.truncatingRemainder(dividingBy: 60))
        let strTime = String(format: "%02d:%02d", min, sec)
        return strTime
    }
    
    static func isLogin() -> Bool {
        guard let memID = UserModel.memberId else { return false }
        return !memID.contains("DHR")
    }
    
    static func createDynamicLink(with url: String, completionHandler: @escaping (_ url: URL?)->Void) {
        guard let linkUrl = URL(string: "\(Configs.dynamicPrefix)?link=\(url)&isi=\(Configs.appstoreID)&ibi=kr.co.radcns.DanHaruProject&efr=1") else { return }
    
        DynamicLinkComponents.shortenURL(linkUrl, options: nil) { url, warnings, err in
            completionHandler(url)
        }
    }
}

extension RadServerNetwork {
    
    static public func getDataFromServerNeedAuth(url: String, type: RadEnum.DataType, successHandler: @escaping (_ resultData: NSDictionary?)-> Void, errorHandler: @escaping (_ error: Error)-> Void) -> Void {
        let session = URLSession.shared;
        if let reqUrl = URL(string: url) {
            print("reqUrl \(url)")
            var request = URLRequest(url: reqUrl)
            
            request.setValue(UserModel.authForAPI, forHTTPHeaderField: "Authorization")
            request.httpMethod = "get"
            
            session.dataTask(with: request) { (data, response, error) in
                
                if error != nil {
                    Dprint("error\(String(describing: error))")
                    errorHandler(error!);
                }else {
                    
                    guard let rstData = data else {
                        Dprint("data is nil!!!!????????.");
                        //nil에 대한 대비를 해야하는가?!!??
                        successHandler(nil);
                        return;
                    }
                    
                    do {
                        
                        if type == .JSON {
                            let jsonRst  = try JSONSerialization.jsonObject(with: rstData, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary;
                            successHandler(jsonRst);
                        }else {
                            
                            if let image = UIImage(data: rstData) {
                                let dic = NSDictionary(dictionary: ["image":image]);
                                successHandler(dic);
                            }else {
                                successHandler(nil);
                            }
                        }
                    }
                    catch {
                        errorHandler(error);
                        Dprint("parsing error : \(error.localizedDescription)")
                    }
                }
            }.resume();
        }else {
            Dprint("url is nil or empty")
        }
    }
    
    static public func postDicDataFromServerNeedAuth(url: String, parameters:[String:Any], successHandler: @escaping (_ resultDic: NSDictionary?)-> Void, errorHandler: @escaping (_ error: Error) -> Void) -> Void {
        
        if let reqUrl = URL(string: url) {
            
            var request = URLRequest(url: reqUrl)
            
            request.setValue(UserModel.authForAPI, forHTTPHeaderField: "Authorization")
            request.httpMethod = "post"
            
            if parameters.count > 0 {
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                do {
                    request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
                } catch {
                    successHandler(nil)
                }
            }
            
            let session = URLSession.shared
            
            let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) in
                
                //error 일경우 종료
                guard error == nil && data != nil else {
                    
                    if let err = error {
                        errorHandler(err)
                        Dprint(err.localizedDescription) }
                    return
                }
                
                
                
                //data 가져오기
                if let _data = data {
                    
                    //메인쓰레드에서 출력하기 위해
                    
                    DispatchQueue.main.async {
                        do {
                            let jsonRst  = try JSONSerialization.jsonObject(with: _data, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary;
                            successHandler(jsonRst);
                        }
                        catch {
                            errorHandler(error);
                            Dprint("parsing error : \(error.localizedDescription)")
                        }
                        
                    }
                    
                }else{
                    Dprint("data nil")
                }
            })
            
            task.resume()
        } else {
            Dprint("url is nil or empty")
        }
    }
    
    //FIXME: 이미지 로드 API 수정중
    static public func getFromServerNeedAuth(url: String, successHandler: @escaping (_ resultDic: NSDictionary?)-> Void, errorHandler: @escaping (_ error: Error) -> Void) -> Void {
        
        if let reqUrl = URL(string: url) {
            
            var request = URLRequest(url: reqUrl)
            
            request.setValue(UserModel.authForAPI, forHTTPHeaderField: "Authorization")
            
            request.httpMethod = "get"
            
            let session = URLSession.shared
            
            let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) in
                
                //error 일경우 종료
                guard error == nil && data != nil else {
                    if let err = error { Dprint(err.localizedDescription) }
                    return
                }
               
                //data 가져오기
                if let _data = data {
                    
                    if let image = UIImage(data: _data) {
                        let dic = NSDictionary(dictionary: ["image":image])
                        successHandler(dic)
                    } else {
                        let dic = NSDictionary(dictionary: ["data":_data])
                        successHandler(dic)
                    }
                    
                } else {
                    Dprint("data nil")
                    successHandler(nil)
                }
            })
            
            task.resume()
        } else {
            Dprint("url is nil or empty")
        }
        
        
    }
    
    static func postArrDataFromServerNeedAuth(url: String, parameters:[String:Any], successHandler: @escaping (_ resultData: NSArray?)-> Void, errorHandler: @escaping (_ error: Error)-> Void) {
        
        guard let reqUrl = URL(string: url) else { return }
        
        var request = URLRequest(url: reqUrl)
        
        request.setValue(UserModel.authForAPI, forHTTPHeaderField: "Authorization")
        request.httpMethod = "post" //get : Get 방식, post : Post 방식
        
        if parameters.count > 0 {
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            } catch {
                successHandler(nil)
            }
        }
        
        let task = URLSession.shared.dataTask(with: request,
                                              completionHandler: { (data: Data?, response: URLResponse?, error: Error?) in
            
            //error 일경우 종료
            guard error == nil && data != nil else {
                
                if let err = error { errorHandler(err) }
                return
            }
            
            
            //data 가져오기
            if let _data = data, let _ = NSString(data: _data, encoding: String.Encoding.utf8.rawValue) {
                //메인쓰레드에서 출력하기 위해
                DispatchQueue.main.async {
                    do {
                        let jsonRst  = try JSONSerialization.jsonObject(with: _data, options: JSONSerialization.ReadingOptions.allowFragments) as? NSArray
                        successHandler(jsonRst);
                    }
                    catch {
                        errorHandler(error);
                    }
                    
                }
            }
        })
        
        task.resume()
    }
    
    static func putDataFromServer(url: String, parameters:[String:Any], isForUploadImg: Bool, successHandler: @escaping (_ resultData: NSDictionary?)-> Void, errorHandler: @escaping (_ error: Error)-> Void) {
        
        guard let reqUrl = URL(string: url) else { return }
        
        let boundary = "Boundary-\(UUID().uuidString)"
        var request = URLRequest(url: reqUrl)
        request.setValue(UserModel.authForAPI, forHTTPHeaderField: "Authorization")
        request.httpMethod = "PUT"
        if isForUploadImg { request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type") }
        
        if parameters.count > 0 {
            if isForUploadImg {
                let body = NSMutableData()
                let boundaryPrefix = "--\(boundary)\r\n"
                
                for (key, value) in parameters {
                    body.appendString(boundaryPrefix)
                    body.appendString("Content-Disposition: form-data; name=\"\(key)\"")
                    if key == "uploaded_file" {
                        if let fileContent = (value as? UIImage)?.jpegData(compressionQuality: 0.9),
                           let urlStr = (value as? UIImage)?.getImageInfo(type: .url),
                            let url = URL(string: urlStr)
                        {
                            do { try fileContent.write(to: url) }
                            catch { print("error combined to file type") }
                            
                            body.appendString("; filename=\"\(url)\"\r\n" + "Content-Type: image/jpeg\"\r\n\r\n")
                            body.append(fileContent)
                            body.appendString("\r\n")
                        }
                        
                    } else {
                        if let valueStr = value as? String { body.appendString("\r\n\r\n\(valueStr)\r\n") }
                    }
                }
                
                body.appendString("--\(boundary)--\r\n")
                
                request.httpBody = body as Data
            } else {
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                do {
                    request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
                } catch {
                    successHandler(nil)
                }
            }
        }
        
        let task = URLSession.shared.dataTask(with: request,
                                              completionHandler: { (data: Data?, response: URLResponse?, error: Error?) in
            
            //error 일경우 종료
            guard error == nil && data != nil else {
                
                if let err = error { errorHandler(err) }
                return
            }
            
            
            //data 가져오기
            if let _data = data, let _ = NSString(data: _data, encoding: String.Encoding.utf8.rawValue) {
                //메인쓰레드에서 출력하기 위해
                DispatchQueue.main.async {
                    do {
                        let jsonRst  = try JSONSerialization.jsonObject(with: _data, options: JSONSerialization.ReadingOptions.allowFragments) as? NSDictionary
                        successHandler(jsonRst);
                    }
                    catch {
                        errorHandler(error);
                    }
                    
                }
            }
        })
        
        task.resume()
    }
    
    //FIXME: 인증 수단 API 호출 함수 수정중
    static func postMultipartDataFromServer(url: String, parameters:[String:Any], isUploadType: String, successHandler: @escaping (_ resultData: NSDictionary?)-> Void, errorHandler: @escaping (_ error: Error)-> Void) {
        
        guard let reqUrl = URL(string: url) else { return }
        
        let boundary = "Boundary-\(UUID().uuidString)"
        var request = URLRequest(url: reqUrl)
        request.setValue(UserModel.authForAPI, forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        
        //if isUploadType == "I" { request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type") }
        
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let body = NSMutableData()
        let boundaryPrefix = "--\(boundary)\r\n"
        
        // 이미지 등록
        if isUploadType == "I" {
            
            
            for (key, value) in parameters {
                
                if key == "certi_img_file" {
                    
                    for imageValue in value as! [Any] {
                        body.appendString(boundaryPrefix)
                        body.appendString("Content-Disposition: form-data; name=\"\(key)\"")
                        if let fileContent = (imageValue as? UIImage)?.jpegData(compressionQuality: 0.9),
                           let urlStr = (imageValue as? UIImage)?.getImageInfo(type: .url),
                            let url = URL(string: urlStr)
                        {
                            do { try fileContent.write(to: url) }
                            catch { print("error combined to file type") }
                            
                            body.appendString("; filename=\"\(url)\"\r\n" + "Content-Type: image/jpeg\"\r\n\r\n")
                            body.append(fileContent)
                            body.appendString("\r\n")
                        }
                        
                    }
                    
                } else {
                    body.appendString(boundaryPrefix)
                    body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                    if let valueStr = value as? String {
                        body.appendString("\(valueStr)\r\n")
                    }
                    
                }
                
            }
            
            body.appendString("--\(boundary)--\r\n")
            request.httpBody = body as Data
            
        } else if isUploadType == "V" {
            // 오디오
            //FIXME: 오디오 업로드 수정중
            for (key, value) in parameters {
                body.appendString(boundaryPrefix)
                body.appendString("Content-Disposition: form-data; name=\"\(key)\"")
                if key == "certi_voice_file" {
                    do {
                        let audioData = try Data(contentsOf: value as! URL)
                        
                        body.appendString("; filename=\"\(UUID()).m4a\"\r\n" + "Content-Type: audio/x-m4a\"\r\n\r\n")
                        body.append(audioData)
                        body.appendString("\r\n")
                    } catch {
                        Dprint("audio Data create failed")
                    }
                
                } else {
                    
                    body.appendString(boundaryPrefix)
                    body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                    if let valueStr = value as? String {
                        body.appendString("\(valueStr)\r\n")
                    }
                }
            }
            
            body.appendString("--\(boundary)--\r\n")
            request.httpBody = body as Data
            
        } else {
            // 단순체크
            for (key, value) in parameters {
                body.appendString(boundaryPrefix)
                body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                if let valueStr = value as? String {
                    body.appendString("\(valueStr)\r\n")
                }
                
            }
            
            body.appendString("--\(boundary)--\r\n")
            request.httpBody = body as Data
        }
        
        let task = URLSession.shared.dataTask(with: request,
                                              completionHandler: { (data: Data?, response: URLResponse?, error: Error?) in
            
            //error 일경우 종료
            guard error == nil && data != nil else {
        
                if let err = error { errorHandler(err) }
                return
            }
            
            //data 가져오기
            if let _data = data, let _ = NSString(data: _data, encoding: String.Encoding.utf8.rawValue) {
                //메인쓰레드에서 출력하기 위해
                DispatchQueue.main.async {
                    do {
                        let jsonRst  = try JSONSerialization.jsonObject(with: _data, options: JSONSerialization.ReadingOptions.allowFragments) as? NSDictionary
                        successHandler(jsonRst);
                    }
                    catch {
                        errorHandler(error);
                    }
                    
                }
            }
        })
        
        task.resume()
    }
    
    
    
    
}
