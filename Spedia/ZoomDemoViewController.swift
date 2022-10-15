//
//  ZoomDemoViewController.swift
//  Spedia
//
//  Created by Viraj Sharma on 25/10/2020.
//  Copyright © 2020 Viraj Sharma. All rights reserved.
//


import UIKit
//import MobileRTC, MobileRTCMeetingServiceDelegate


class ZoomDemoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    /*
    
    @IBAction func joinButtonAction(_ sender: Any) {
        
        
        
        
        if let setting = MobileRTC.shared().getMeetingSettings() {
            setting.topBarHidden = true
            setting.meetingInviteHidden = true
            setting.meetingPasswordHidden = true
            setting.meetingTitleHidden = true
            setting.thumbnailInShare = false
            setting.meetingMoreHidden = true
            setting.meetingShareHidden = true
            setting.meetingLeaveHidden = false
        }
        
        
        if let meetingService = MobileRTC.shared().getMeetingService() {
            
            meetingService.delegate = self
            meetingService.joinMeeting(with: [
                kMeetingParam_Username: "USER ONE",
                kMeetingParam_MeetingNumber: "75936578122",
                kMeetingParam_MeetingPassword: "L1VPdC9RSHBEU3hjLzN3MFNiRFFBUT09",
                //kMeetingParam_WebinarToken: "\(webnarToken)"
                
               
            ])
            
            
            L102Language.setAppleLAnguageTo(lang: "en")
                           L012Localizer.DoTheSwizzling()
                           
                           L102Language.setAppleLAnguageTo(lang: "en")
                           UIView.appearance().semanticContentAttribute = L102Language.isCurrentLanguageArabic() ? .forceRightToLeft : .forceLeftToRight
                           
                           L012Localizer.DoTheSwizzling()
                           
                           UIView.appearance().semanticContentAttribute = L102Language.isCurrentLanguageArabic() ? .forceRightToLeft : .forceLeftToRight
                           
            
        
        }
        
        
    }

        
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
      func onMeetingReady() {
        
        
       
       }
       
    
       func onMeetingEndedReason(_ reason: MobileRTCMeetingEndReason) {
           
        L102Language.setAppleLAnguageTo(lang: "en")
        
        UIView.appearance().semanticContentAttribute = L102Language.isCurrentLanguageArabic() ? .forceRightToLeft : .forceLeftToRight
        
        L012Localizer.DoTheSwizzling()
        
       }*/

}

