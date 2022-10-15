//
//  GlobalVariable.swift
//  Spedia
//
//  Created by Viraj Sharma on 18/06/2020.
//  Copyright © 2020 Viraj Sharma. All rights reserved.
//

import Foundation
import SwiftyJSON


var isLoginGlobal: Bool?
var sessionTokenGlobal : String?
var studentIdGlobal : String?

var classIdGlobal : String?
var usernameGlobal : String?
var userFullNameGlobal : String?
var userIdGlobal = String()

//var hideAddToCartKey = ""


var whichLiveClassPageIndexGlobal = 1
var whichRPCPageIndexGlobal = 1
var preRecodredSelectedIndexGlobal = 1
var isFromSeeAllButtonBoolGlobal = false

var traningTabBarBadgeCount = ""
var myCartTabBarBadgeCount = ""
var globalCouponCode = ""
var isPdfLoadingGlobal = false
var isPdfDownloadedSuccessGlobal = false
var downloadFilePathURLGlobal: URL?

var homePageSubjectViewHeight = 0.0

//var Lang.code() = L102Language.currentAppleLanguage().capitalized

//MARK: Global Product Id For IAP
// IAP 5
var globalProductIdStrIAP = ""
var globalSubjectPriceIdIAP = 0
var globalIsPrivateClassTypeIAP = false
var globalshouldResumePaymentIAP = false
var globalResumePaymentMsgIAP = ""



open class Lang {
    class func code() -> String {
        return L102Language.currentAppleLanguage().capitalized
    }
}





//App Instruction Object For Check First Time Load:-
//var isInstructionOnHomeFirstTime: Bool = UserDefaults.standard.bool(forKey: "isInstructionOnHomeFirstTimeKey")



//For Parent
var userTypeGlobal:Int = 0
var isParentGlobal: Bool = false
var startWithPage: String = ""
var parentIdGlobal:Int = 0
var emailIdGlobal = String()
var mobileNoGlobal = String()
var fullNameGlobal = String()

var isGuestLoginGlobal: Bool = false
var guestUserMsgGlobal = String()


//For Skill Analytics



func loadUserData() {
    
    if let savedObject = UserDefaults.standard.value(forKey: UserDefaultKeys.userPersonalDataKey) {
         
        let data = JSON.init(savedObject)
        
        userIdGlobal = data["\(StudentKeys.USER_ID)"].string ?? ""
     
        if !userIdGlobal.isEmpty {
            
             isLoginGlobal = true
             sessionTokenGlobal = data["\(StudentKeys.TOKEN)"].stringValue
             studentIdGlobal = data["\(StudentKeys.USER_ID)"].stringValue
             classIdGlobal = data["\(StudentKeys.CLASS_ID)"].stringValue
             usernameGlobal = data["\(StudentKeys.USER_NAME)"].stringValue
             userFullNameGlobal = data["\(StudentKeys.FIRST_NAME)"].stringValue + " " + data["\(StudentKeys.MIDDLE_NAME)"].stringValue + " " + data["\(StudentKeys.LAST_NAME)"].stringValue
             
            //For Parent
            parentIdGlobal = data["\(StudentKeys.PARENT_ID)"].intValue
            userTypeGlobal = data["\(StudentKeys.PARENT_ID)"].intValue
            emailIdGlobal = data["\(StudentKeys.EMAIL_ID)"].stringValue
            mobileNoGlobal = data["\(StudentKeys.STUDENT_PHONE)"].stringValue
            fullNameGlobal = data["\(StudentKeys.FIRST_NAME)"].stringValue
            
            //For University
            startWithPage = data["\(StudentKeys.START_WITH_PAGE)"].stringValue
            
            //For Guest
            isGuestLoginGlobal = data["\(StudentKeys.IS_GUEST_LOGIN)"].boolValue
            guestUserMsgGlobal = data["\(StudentKeys.GUEST_USER_MSG)" + Lang.code()].stringValue
            
            //print("\n\n\n KEY IS ----------> \(StudentKeys.GUEST_USER_MSG + Lang.code()) \n\n")
             
            
            if parentIdGlobal != 0 && userTypeGlobal != 4 {
               isParentGlobal = true
            }
            
        
        } else {
            isLoginGlobal = false
        }
    
        
    } else {
        
        guestUserMsgGlobal = "ARE_YOU_SURE_GUEST".localized()
        isGuestLoginGlobal = false
        isLoginGlobal = false
        sessionTokenGlobal = ""
        studentIdGlobal = ""
        classIdGlobal = ""
        usernameGlobal = ""
        userFullNameGlobal = ""
        userIdGlobal = ""
        //isRegisteredChe = true
        //KeychainItem.deleteUserIdentifierFromKeychain()
        traningTabBarBadgeCount = ""
        myCartTabBarBadgeCount = ""
        globalCouponCode = ""

        //For Parent
        userTypeGlobal = 0
        isParentGlobal = false
        startWithPage = ""
        parentIdGlobal = 0
        emailIdGlobal = ""
        mobileNoGlobal = ""
        
        UserDefaults.standard.set([], forKey: "myKey")
        UserDefaults.standard.synchronize()
        
    }
    
    
}



