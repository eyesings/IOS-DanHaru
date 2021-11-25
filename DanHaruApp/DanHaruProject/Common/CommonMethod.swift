//
//  CommonMethod.swift
//  DanHaruProject
//
//  Created by RadCns_SON_JIYOUNG on 2021/10/25.
//

import Foundation
import UIKit

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
    static func getProfileImage() -> UIImage? {
        var image: UIImage?
        RadServerNetwork.getDataFromServer(url: UserModel.profileImgUrl ?? "", type: .IMAGE) { dic in
            if let dic = dic {
                let img = dic["image"] as? UIImage
                image = img
            }
        } errorHandler: { err in
            Dprint("error with \(err.localizedDescription)")
        }

        return image
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
    
    static var isLogin: Bool = {
        return UserModel.memberId != nil
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
    
}

extension RadServerNetwork {
    static func postDataFromServer(url: String, parameters:[String:Any], successHandler: @escaping (_ resultData: NSArray?)-> Void, errorHandler: @escaping (_ error: Error)-> Void) {
        
        if let reqUrl = URL(string: url) {
            
            var request = URLRequest(url: reqUrl)
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
                    
                    if let err = error {
                        errorHandler(err)
                    }
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
    }
}
