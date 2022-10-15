//
//  ZoomGlobalMeetingClass.swift
//  Spedia
//
//  Created by Viraj Sharma on 24/08/2021.
//  Copyright © 2021 Viraj Sharma. All rights reserved.
//


import Foundation
import MobileRTC
import SwiftyJSON
import UIKit

//Zoom SDK : 7 Last
class ZoomGlobalMeetingClass: NSObject, MobileRTCMeetingServiceDelegate {

    //1 Object Variables
    static let object: ZoomGlobalMeetingClass = ZoomGlobalMeetingClass()
    
    var isFromLiveClass = false
    var liveClassIdObj = 0
    
    var previousLang = ""
    var topController = UIViewController()
    
    //2 Methods
    func joinMeetingWithData(model : JSON) {
        
        self.previousLang = L102Language.isCurrentLanguageArabic() ? "WasArabic" : "WasEnglish"
        
        
        
        
        
        
        
        AppShared.object.updateLangNow(didSetRoot: true, isStaticSetEnAr: "en")
        
        //let mobileObj = MobileRTC.shared().mobileRTCRootController()
        //mobileObj?.popToRootViewController(animated: true)

        if let currentOjc = UIApplication.topViewController() {
            self.topController = currentOjc
            self.topController.view.isHidden = true
        }
        
        print("joinMeetingWithData", model)
        let meetingId = model["MeetingID"].stringValue
        let meetingPass = model["MeetingPassword"].stringValue
        let webnarToken = model["MeetingToken"].stringValue
        let userName = userFullNameGlobal ?? ""
        
        
        if let setting = MobileRTC.shared().getMeetingSettings() {
            setting.topBarHidden = false
            setting.meetingInviteHidden = true
            setting.meetingPasswordHidden = true
            setting.meetingTitleHidden = true
            setting.thumbnailInShare = true
            setting.meetingMoreHidden = false
            setting.meetingShareHidden = false
            setting.meetingLeaveHidden = false
            setting.setAutoConnectInternetAudio(true)
            setting.disableDriveMode(true)
        }
        
        
        if let meetingService = MobileRTC.shared().getMeetingService() {
            
            //1
            let meetingParams = MobileRTCMeetingJoinParam()
            meetingParams.userName = userName
            meetingParams.meetingNumber = meetingId
            meetingParams.password = meetingPass
            meetingParams.webinarToken = webnarToken
            
            //2
            meetingService.joinMeeting(with: meetingParams)
            
            //3
            meetingService.delegate = self
        
        }
    }
    
    
    
    //MARK: Meeting Delegate
    
    func onMeetingStateChange(_ state: MobileRTCMeetingState) {
        let meetingStatus = Int(state.rawValue)
        print("\n\n\n\n Meeting End \(meetingStatus) \(state.rawValue) \n\n\n")
        
        /*self.topController.viewDidLoad()
        self.topController.viewWillAppear(true)
        self.topController.view.setNeedsLayout()
        self.topController.view.layoutIfNeeded()*/
    }
    
    func onMeetingReady() {
        (UIApplication.shared.delegate as! AppDelegate).restrictRotation = .all
    }
    
    
    func onMeetingEndedReason(_ reason: MobileRTCMeetingEndReason) {
        
        (UIApplication.shared.delegate as! AppDelegate).restrictRotation = .portrait
        
        //DispatchQueue.main.async {
            if self.previousLang == "WasArabic" {
                self.onClickAr()
                AppShared.object.updateLangNow(didSetRoot: true, isStaticSetEnAr: "ar")
            } else {
                self.onClickEnglish()
                AppShared.object.updateLangNow(didSetRoot: true, isStaticSetEnAr: "en")
            }
        //}
        
    }
    
    
    
    func onClickEnglish() {
        print("\n\n\n\n WAS323 ENGLISH \n\n\n")
        if self.isFromLiveClass {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                if let topController = UIApplication.topViewController() {
                    if let vc = TeacherRattingViewPopUpVC.instantiate(fromAppStoryboard: .main) {
                        vc.modalPresentationStyle = .overFullScreen
                        vc.liveClassId = self.liveClassIdObj
                        topController.present(vc, animated: true, completion: nil)
                        //topController.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            }
            
        }
    }
     
    
    func onClickAr() {
        print("\n\n\n\n WAS323 ARABIC \n\n\n")
        if self.isFromLiveClass {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                if let topController = UIApplication.topViewController() {
                    if let vc = TeacherRattingViewPopUpVC.instantiate(fromAppStoryboard: .main) {
                        vc.modalPresentationStyle = .overFullScreen
                        vc.liveClassId = self.liveClassIdObj
                        topController.present(vc, animated: true, completion: nil)
                        //topController.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            }
            
        }
    }
}




