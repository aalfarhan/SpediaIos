//
//  AppShared.swift
//  Spedia
//
//  Created by Viraj Sharma on 28/11/2020.
//  Copyright © 2020 Viraj Sharma. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class AppShared: NSObject {
    
    
    static let object: AppShared = AppShared()
    
    var docVC: UIDocumentInteractionController!
    
    var isVideoOrZoomViewShowing = false
    
    var pointsCountStringGlobal = ""
    
    var notificationCountGlobal = 0
    
    var answerTotalQuizCountGlobal = 0
    
    var shouldShowQuizButton = false
    
    var quizStatus = "n"
    
    //Timeline Object's
    var timelineSelectedSubjectId = 0
    var timelineSelectedDaysInt = 7
    var timelineSelectedFromDateStr = ""
    var timelineSelectedToDateStr = ""
    var timelineSelectedTypeInt = 0

    
    //General Picking Keyword
    var generalLanguageCode = L102Language.isCurrentLanguageArabic() ? "AR" : "EN"
    
    
    var isFromParentView = false
    
    
    //MARK: For Quiz Time
    
    var quizCurrentTimeInteger = 0
    
    var quizIDGlobal = Int()
    
    var quizStatusGloabl = ""
    
    
    func updateTimeWithAPI(withTime: Int, examId: String) {
        
        let urlString = getUpdateQuizTime
         
        let params = ["ExamAnswerID": examId, "SessionToken": sessionTokenGlobal ?? "", "Time": "\(withTime)", "StudentID": studentIdGlobal ?? ""] as [String : Any]
        
        ServiceManager().postRequest(urlString, loader: false, parameters: params) { (status, jsonResponse) in
             
            if status {
                
                print("\n\n\n Quiz Time Updated Done !!!! \n\n\n")
                
            }
        }
    
    }
    
    
    
    //MARK: Check Expired Subject With API
    func getSubscriptionDataNow(reminderId: Int) {
        
        let urlString = getExpiryReminderData
        
        let params = ["SessionToken" : sessionTokenGlobal ?? "",
                      "StudentID" : studentIdGlobal ?? 0,
                      "ReminderID": reminderId] as [String : Any]
        
        ServiceManager().postRequest(urlString, loader: false, parameters: params) { (status, jsonResponse) in
             
            if status {
                
                let dataRes = JSON.init(jsonResponse ?? "NO DTA")
                
                if dataRes["ShowPopup"].boolValue {
                    if let topController = UIApplication.topViewController() {
                        if let vc = SubscriptionPopUpViewController.instantiate(fromAppStoryboard: .main) {
                            vc.modalPresentationStyle = .overFullScreen
                            vc.reminderIdObje = reminderId
                            vc.dataJson = dataRes
                            topController.present(vc, animated: true, completion: nil)
                            //topController.navigationController?.pushViewController(vc, animated: true)
                        }
                    }
                }
                
            }
        }
        
    }
    
    /*
    func setEnglisnLangNew(didSetRoot: Bool) {
        
        L102Language.setAppleLAnguageTo(lang: "en")
        UIView.appearance().semanticContentAttribute = .forceLeftToRight
        
        
        if didSetRoot {
            if startWithPage == StartWithPageType.universityHome {
                setUniversityRootView(tabBarIndex: 0)
            } else {
                
                if startWithPage == StartWithPageType.liveClass {
                    setRootView(tabBarIndex: 2)
                } else {
                    setRootView(tabBarIndex: 0)
                }
                
            }
            
        }
        
        let mainwindow = (UIApplication.shared.delegate?.window!)!
        mainwindow.backgroundColor = UIColor(hue: 0.6477, saturation: 0.6314, brightness: 0.6077, alpha: 0.8)
        UIView.transition(with: mainwindow, duration: 0.55001, options: .transitionFlipFromLeft, animations: { () -> Void in
        }) { (finished) -> Void in
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
        }
        
    }
    */
    
    func updateLangNow(didSetRoot: Bool, isStaticSetEnAr: String) {
        
        if !isStaticSetEnAr.isEmpty {
            L102Language.setAppleLAnguageTo(lang: isStaticSetEnAr)
            UIView.appearance().semanticContentAttribute = isStaticSetEnAr == "ar" ? .forceRightToLeft : .forceLeftToRight
        } else {
            L102Language.setAppleLAnguageTo(lang: L102Language.isCurrentLanguageArabic() ? "en" : "ar")
            UIView.appearance().semanticContentAttribute = L102Language.isCurrentLanguageArabic() ? .forceRightToLeft : .forceLeftToRight
        }
        
        if didSetRoot {
            if startWithPage == StartWithPageType.universityHome {
                setUniversityRootView(tabBarIndex: 0)
            } else {
                
                if startWithPage == StartWithPageType.liveClass {
                    setRootView(tabBarIndex: 2)
                } else {
                    setRootView(tabBarIndex: 0)
                }
                
            }
            
            //FIXME: LATER CRASHING THE APP
            //UI TAB BAR...
            /*let size = CGFloat(UIDevice.isPad ? 15.0 : 13.0)
            let appearance = UITabBarItem.appearance()
            let attributes = [NSAttributedString.Key.font:UIFont(name: "SEMIBOLD".localized(), size: size)]
            appearance.setTitleTextAttributes(attributes as [NSAttributedString.Key : Any], for: .normal)*/
        }
        
    }
    
}
