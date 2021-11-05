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
    
    static var isLogin: Bool = {
        return UserModel.userIdx != nil
    }()
}
