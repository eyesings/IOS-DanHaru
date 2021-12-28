//
//  MainViewContoller+Push.swift
//  DanHaruProject
//
//  Created by RadCns_SON_JIYOUNG on 2021/12/28.
//

import Foundation
import UIKit

extension MainViewController: RadPushViewModelProtocol {
    
    func pushReceivedWithPushModel(pushModel: RadPushViewModel) {
        
        guard let pushModelWebLink = pushModel.pushModel.webLink,
              let moveUrl = URL(string: pushModelWebLink) else { return }
        
        if pushModelWebLink.contains(Configs.URL.UniversalLink.moveToTodoDetail) {
            if let query = moveUrl.query, let todoidxStr = query.components(separatedBy: "=").last {
                self.openDetailTotoIdx = (todoidxStr as NSString).integerValue
            }
        }
        
        let status = UIApplication.shared.applicationState
        Dprint("app status \(status.rawValue)")
        
        if status == .active {
            
            if let navi = RadHelper.getRootViewController() as? UINavigationController,
               !(navi.visibleViewController is MainViewController) {
                navi.popToMainViewController()
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                
            }
        }
    }
}
