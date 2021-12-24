//
//  TodoDetailService.swift
//  DanHaruProject
//
//  Created by RadCns_SON_JIYOUNG on 2021/12/02.
//

import Foundation
import UIKit
import AVFAudio


extension ViewModelService {
    
    /// 상세 페이지 데이터 조회
    static func todoDetailDataService(todoIdx: Int, searchDate: String, completionHandler: @escaping (NSDictionary?) -> Void, errorHandler: @escaping (APIType) -> Void) {
        
        guard let rootVC = RadHelper.getRootViewController() else { Dprint("rootVC 없음"); return }
        rootVC.showLoadingView()
        
        var param: [String:Any] = [:]
        param["todo_id"] = todoIdx
        param["today_dt"] = searchDate
        
        RadServerNetwork.postDicDataFromServerNeedAuth(url: Configs.API.todoDetail, parameters: param) { detailData in
            if let resultCode = detailData?["status_code"] as? String,
               resultCode == APIResultCode.success.rawValue {
                guard let detailDataDic = detailData?["detail"] as? NSDictionary else { return }
                completionHandler(detailDataDic)
            } else {
                print("is error")
                rootVC.hideLoadingView()
            }
            
        } errorHandler: { err in
            Dprint("err \(err)")
            DispatchQueue.main.async {
                rootVC.hideLoadingView()
            }
            errorHandler(.TodoDetail)
        }

    }
    
    /// 데이터 업데이트
    static func todoDetailUpdteService(param: [String:Any], todoIdx: Int, completionHandler: @escaping (Bool) -> Void, errorHandler: @escaping (APIType) -> Void) {
        
        guard let rootVC = RadHelper.getRootViewController() else { Dprint("rootVC 없음"); return }
        rootVC.showLoadingView()
        
        RadServerNetwork.putDataFromServer(url: Configs.API.updateDtl + "/\(todoIdx)", parameters: param, isForUploadImg: false) { resultData in
            
            if let data = resultData?["status_code"] as? String,
               data == APIResultCode.success.rawValue
            {
                completionHandler(true)
            } else {
                completionHandler(false)
            }
            rootVC.hideLoadingView()
        } errorHandler: { error in
            Dprint("error \(error)")
            rootVC.hideLoadingView()
            errorHandler(.TodoUpdate)
        }

    }
    
    /// 챌린지 유저 등록
    static func todoCreateChalengeService(todoIdx: Int, ownerMemId: String, completionHandler: @escaping (Bool) -> Void, errorHandler: @escaping (APIType) -> Void) {
        
        guard let rootVC = RadHelper.getRootViewController() else { Dprint("rootVC 없음"); return }
        rootVC.showLoadingView()
        
        var param: [String:Any] = [:]
        param["todo_id"] = todoIdx
        param["todo_mem_id"] = ownerMemId
        param["chaluser_mem_id"] = UserModel.memberId
        
        RadServerNetwork.postDicDataFromServerNeedAuth(url: Configs.API.createChl, parameters: param) { resultDic in
            if let data = resultDic?["status_code"] as? String,
               data == APIResultCode.success.rawValue
            {
                completionHandler(true)
            } else {
                completionHandler(false)
            }
            rootVC.hideLoadingView()
        } errorHandler: { err in
            print("error \(err)")
            rootVC.hideLoadingView()
            errorHandler(.TodoCreateChallenge)
        }

    }
    
    /// 인증 수단 등록
    //FIXME: 인증 수단 등록 서비스
    static func TodoCreateCertificateService(_ todoIdx: Int,_ memId: String, _ certi_check: String?, _ certi_img_file: [UIImage]?, _ certi_voice_file: AVAudioRecorder?, successHandler: @escaping (Bool) -> Void, errorHandler: @escaping (APIType) -> Void) {
        
        guard let rootVC = RadHelper.getRootViewController() else { Dprint("rootVC 없음"); return }
        rootVC.showLoadingView()
        
    
        var uploadType = ""
        
        var param: [String:Any] = [:]
        
        param["todo_id"] = "\(todoIdx)"
        param["mem_id"] = memId
        
        if certi_img_file?.count != 0 {
            uploadType = "I"
            param["certi_img_file"] = certi_img_file
        } else if certi_voice_file != nil {
            uploadType = "V"
            param["certi_voice_file"] = certi_voice_file?.url
        } else {
            uploadType = "C"
        }
        
        print("파람 확인 :: \(param)")
        
        RadServerNetwork.postDataFromServer(url: Configs.API.createCerti, parameters: param, isUploadType: uploadType) { dic in
            
            print("뭐야 \(dic)")
        
            let detail = dic?["detail"] as? NSDictionary
            
            let msg = dic?["msg"] as? String
            
            print("디테일 :: \(detail)")
            print("메시지 :: \(msg)")
            
            successHandler(true)
            
            rootVC.hideLoadingView()
        } errorHandler: { error in
            print("error \(error)")
            rootVC.hideLoadingView()
            errorHandler(.TodoCreateCertification)
        }

        
        
        
    }
    
}
