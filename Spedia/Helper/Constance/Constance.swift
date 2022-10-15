//
//  Constance.swift
//  Spedia
//
//  Created by Viraj Sharma on 17/05/2020.
//  Copyright © 2020 Viraj Sharma. All rights reserved.
//

import Foundation

//Fonts Name
let AppFontRegular = "Regular"
let AppFontSemiBold = "SemiBold"
let AppFontBold = "Bold"
let AppFontLight = "Light"
let AppFontExBold = "ExBold"

//Text Color Name
let AppTextLightGreen = "AppTextGreen"
let AppTextBlack = "AppTextBlack"
let AppTextDarkGreen = "AppTextDarkGreen"
let AppTextLimeGreen = "AppTextLimeGreen"


let spaceofFiveString = "     "

let mainStoryboadName = UIDevice.isPad ? "Main_iPad" : "Main" //Main_iPad

let universityStoryboard = UIDevice.isPad ? "University" : "University"

//=======================================================
//=======================================================


import UIKit

struct DeviceSize {
    private static let screenSize = UIScreen.main.bounds
    static let screenWidth = screenSize.width
    static let screenHeight = screenSize.height
    static let statusBarHeight = getStatusBarHeight()
    
}

struct DeviceType {
    static let iPhone = 2 // 1 = Android and 2 = iPhone
}


public extension UIDevice {

    class var isPhone: Bool {
        return UIDevice.current.userInterfaceIdiom == .phone
    }

    class var isPad: Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
}


func getStatusBarHeight() -> CGFloat {
    var statusBarHeight: CGFloat = 0
    if #available(iOS 13.0, *) {
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        statusBarHeight = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
    } else {
        statusBarHeight = UIApplication.shared.statusBarFrame.height
    }
    return statusBarHeight
}


//Contact US:

struct ContactUs {
    static let callSupportNumber = "+9651881880"
    static let emailSupprtId = "info@spediaapp.com"
    static let callSupportPhoneNumber = "+96555005500"
    static let callSupportForStudents = "1800000088"
    
    static let termsConditionCommonLink = "https://live.spediaapp.com/28feb2021.pdf"
    static let privacyPolicyCommonLink = "http://live.spediaapp.com/Spedia_PrivacyPolicy.html?v=1"
    
    static let subscriptionsTermsLink = "https://live.spediaapp.com/TaC_Videos.html?v=1"
    static let liveClassTermsLink = "http://live.spediaapp.com/tac_Private.html?v=1"

}

//Profile Data:
var nameGlobal = ""
var phoneNoGlobal = ""
var emailGlobal = ""


//Socail Links :
struct SocailLink {
    static let instagramLink = "https://www.instagram.com/spediaapp/"
    static let twitterLink = "https://twitter.com/spediaapp"
    static let youtubeLink = "https://www.youtube.com/channel/UCgkBDHIhE1ECUJ3l09JbPBg"
    static let snapchatLink = "https://www.snapchat.com/add/spediaapp"
    static let whatsappLink = "https://api.whatsapp.com/send?phone=9651881880&text=&source=&data=&app_absent="
    static let googleMapLink = "https://goo.gl/maps/i5wDFKVNoUh1tQ6i6"
    
}

//JWPlayer :
struct JWPlayerConstance {
    static let videoBaseURL = "https://cdn.jwplayer.com/manifests/"
    static let videoExtension = ".m3u8"
}


//Zoom SDK : 3
struct ZoomConts {
    static let clientKey = "ZkOuqxHZtu93EZhUCBo6Zkl353kCDwku4b6e"
    static let clientSecret = "Yh9Ywrf9TWS6ProkoTmvsdGUhMhNMFusx2fM"
    static let webDomain = ""
    static let appTitle = ""
}



//Socail Media Type
struct SocailMediaType {
    static let facebook = "facebook"
    static let google = "google"
    static let apple = "apple"
}



//Animation Type:
struct AnimationTypeValue {
    static let shake = "shake"
    static let pop = "pop"
    static let morph = "shake"
    static let squeeze = "shake"
    static let wobble = "shake"
    static let swing = "shake"
    static let flipX = "shake"
    static let flipY = "shake"
    static let fall = "fall"
    static let squeezeLeft = "shake"
    static let squeezeRight = "shake"
    static let squeezeDown = "shake"
    static let squeezeUp = "squeezeUp"
    static let slideLeft = "shake"
    static let slideRight = "shake"
    static let slideDown = "shake"
    static let slideUp = "slideUp"
    static let fadeIn = "fadeIn"
    static let fadeOut = "shake"
    static let fadeInLeft = "shake"
    static let fadeInRight = "shake"
    static let fadeInDown = "shake"
    static let fadeInUp = "fadeInUp"
    static let zoomIn = "shake"
    static let zoomOut = "shake"
    static let flash = "shake"
}


var guestDummyData = [
    "UserID" : "-1",
    "ProfilePic" : "",
    "ClassID" : "17",
    "ProfilePicture" : "",
    "MiddleName" : "",
    "MobileVerified" : "1",
    "MobileNo" : "62345678",
    "Student_QR" : "EAAAAG2PFhY7WOdXi9aXvQU0LiMUo1Ibn4NEfAh68YjAwKfu",
    "SessionToken" : "c536a6cb-9d24-4671-8f8d-4396211f6aa4",
    "RedirectToLiveCourse" : false,
    "LastName" : "Guest",
    "Status" : "True",
    "Semester" : "1",
    "UserName" : "GuestiOS@12.com",
    "Email" : "GuestiOS@12.com",
    "IsParent" : "0",
    "ParentID" : "0",
    "FirstName" : "Guest  iOS",
    "UserType" : "4"
] as [String : Any]



//WhereFromAmI Type:
struct WhereFromAmIKeys {
    static let bookmark = "fromBookmarkView"
    static let bellIcon = "fromBellIconAction"
    static let answerDetail = "fromAnswerDetailView"
    static let navigationBottomBar = "fromNavigationBottomBar"
    static let homeSubscribePage = "fromHomeSubscribePage"
    static let preRecoredPage = "fromPreRecordedPage"
    static let videoLibraryPage = "forVideoLibraryPage"
    //New
    static let alreadySubscribedSubject = "alreadySubscribedSubject"
    static let fromLiveClassPage = "fromLiveClassPage"
    static let fromHomePageShowPrice = "fromHomePageShowPrice"
}

struct NavigationType {
    static let presnetType = "presentView"
    static let navigationType = "navigationView"
}

//WhereFromAmI Type:
struct IndexNames {
    static let activeClasses = "activeClassesIsActiveNow"
    static let reservedClasses = "reservedClassesIsActiveNow"
}
