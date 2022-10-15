//
//  Keys.swift
//  Spedia
//
//  Created by Viraj Sharma on 17/06/2020.
//  Copyright © 2020 Viraj Sharma. All rights reserved.
//

import Foundation

//1
struct UserDefaultKeys {
      static let userPersonalDataKey = "USER_PERSONAL_DATA_KEY"
}


struct StudentKeys {
    static let CLASS_ID = "ClassID"
    static let MOBILE_VERIFIED = "MobileVerified"
    static let PROFILE_PICTURE = "ProfilePicture"
    static let REDIRECT_URL = "RedirectURL"
    static let SEMESTER = "Semester"
    static let VC = "VC"
    static let TOKEN = "SessionToken"
    static let SUBSCRIPTION_STATUS = "SubscriptionStatus"
    static let USER_ID = "UserID"
    static let PARENT_ID = "ParentID"
    static let USER_NAME = "UserName"
    static let FIRST_NAME = "FirstName"
    static let LAST_NAME = "LastName"
    static let USER_TYPE = "UserType"
    static let SUBJECT_ID = "SubjectID"
    static let SUBJECT_NAME = "Subject"
    static let SELECTED_SUB_ID = "selectedSubjectID"
    static let SELECTED_SUB_NAME = "selectedSubjectName"
    static let SELECTED_SUB_SEM = "selectedSubjectSemester"
    static let EMAIL_ID = "Email"
    static let CLASS_NAME = "ClassName"
    static let MIDDLE_NAME = "MiddleName"
    static let PARENT_MOBILE = "ParentMobile"
    static let ADDRESS = "Address"
    static let GENDER = "Sex"
    static let STUDENT_PHONE = "MobileNo"
    static let CIVIL_ID = "CivilID"
    static let COLOR_CODE = "ColourCode"
    static let SUBJECT_IMAGE = "SubjectImage"
    static let RANKING = "Ranking"
    static let IS_TEACHER_SELECTED = "IsTeacherSelected"
    static let START_WITH_PAGE = "StartPage"
    static let IS_GUEST_LOGIN = "IsGuestUser"
    static let GUEST_USER_MSG = "NonSubscriberMsg"

}







// MARK: - Subject
struct HomeKey {
    
    static let MessageAr = "MessageAr"
    static let Status = "Status"
    static let AcademicPoints = "AcademicPoints"
    static let MessageEn = "MessageEn"
    static let StudentRank = "StudentRank" //Class 10th, 9th, 8th
    static let LevelAr = "LevelAr"
    static let LevelEn = "LevelEn"
    static let Subjects = "Subjects" // CONTENT BELOW UNIT KEYS:
    static let ActiveClassCount = "ActiveClassCount"
    static let Advertisements = "Advertisements"
}



struct SubjectsKey {
    static let SubjectMasterID = "SubjectMasterID"
    static let BackgroundImagePath = "BackgroundImagePath"
    static let SubjectNameAr = "SubjectNameAr"
    static let SubscriptionTypeID = "SubscriptionTypeID"
    static let SubjectPriceID = "SubjectPriceID"
    static let ShowAddToCartButton = "ShowAddToCartButton"
    static let IconPath = "IconPath"
    static let SubjectNameEn = "SubjectNameEn"
    static let SubjectID = "SubjectID"
    static let ColourCode = "ColourCode"
    static let OrderNo = "ColourCode"
    static let UnitID = "UnitID"
    static let SubUnitID = "SubUnitID"
    static let SubSkillID = "SubSkillID"
    static let SubskillVideoID = "SubskillVideoID"
}



struct UnitDetailKey {
    static let UnitsArray = "Units"
    static let SubtUnitsArray = "SubUnits"
    static let CoursesCountEn = "CoursesCountEn"
    static let ChaptersCountEn = "ChaptersCountEn"
    static let SubUnitID = "SubUnitID"
    static let SubUnits = "SubUnits"
    static let NameEn = "NameEn"
    static let SlNo = "SlNo"
    static let Image = "Image"
    static let NameAr = "NameAr"
    static let ChaptersCountAr = "ChaptersCountAr"
    static let CoursesCountAr = "CoursesCountAr"
    static let HideAddToCart = "HideAddToCart"
}



struct VideoListKey {
    
    //Main
    static let UnitNameEn = "UnitNameEn"
    static let UnitNameAr = "UnitNameAr"
    
    static let VideosAvailableEn = "VideosAvailableEn"
    static let VideosAvailableAr = "VideosAvailableAr"
    
    static let UnitDescriptionEn = "UnitDescriptionEn"
    static let UnitDescriptionAr = "UnitDescriptionAr"
    
    static let HideAddToCart = "HideAddToCart"
    static let QuizStatus = "QuizStatus"
    static let QuizID = "QuizID"
    
    
    static let VideoList = "VideoList"
    //List Sub Array
    static let IsIntroductoryVideo = "IsIntroductoryVideo"
    static let IntroductoryVideo = "IntroductoryVideo"
    static let isLock = "isLock"
    static let UnitID = "UnitID"
    static let WatchedLength = "WatchedLength"
    static let SubSkillID = "SubSkillID"
    static let AvgRating = "AvgRating"
    static let StudentID = "StudentID"
    static let Title = "Title"
    static let IsCompleted = "IsCompleted"
    static let sRating = "sRating"
    static let SubskillVideoID = "SubskillVideoID"
    static let Thumbnail = "Thumbnail"
    static let WatchedCount = "WatchedCount"
    static let VideoPathWithoutMediaPlayer = "VideoPathWithoutMediaPlayer"
    static let videoMinAr = "videoMinAr"
    static let videoMinEn = "videoMinEn"
}




struct QuestionAnswerKey {

 //Main
 static let ListItems = "ListItems"
 
 static let Title = "Title"
 static let SubTitle = "SubTitle"
 static let ImagePath = "ImagePath"
    
 static let WorkBookAnswerPathShow = "WorkBookAnswerPathShow"
 static let showAB = "showAB"
 static let WorkBookAnswerNameEn = "WorkBookAnswerNameEn"
 static let WorkBookAnswerNameAr = "WorkBookAnswerNameAr"
 static let WorkBookAnswerPath = "WorkBookAnswerPath"
 static let WorkBookQ1Path = "WorkBookQ1Path"
 static let WorkBookQ2Path = "WorkBookQ2Path"
 static let isLock = "isLock"
    
}



struct MyCartKeys {
    
      static let CouponDescription = "CouponDescription"
      static let TotalActualPrice = "TotalActualPrice"
      static let Status = "Status"
      static let CouponApplied = "CouponApplied"
      static let MessageEn = "MessageEn"
      static let MessageAr = "MessageAr"
      static let TotalPriceAfterDiscount = "TotalPriceAfterDiscount"
    
      //List
      static let CartItemList = "CartItemList"
          //{
          static let SubjectNameAr = "SubjectNameAr"
          static let SubjectPriceID = "SubjectPriceID"
          static let AfterDiscountPrice = "AfterDiscountPrice"
          static let ActualPrice = "ActualPrice"
          static let SubjectImage = "SubjectImage"
          static let SubjectNameEn = "SubjectNameEn"
          //}
    
    
    static let Advertisements = "Advertisements"
    
}
 




//Profile Keys...
struct ProfileKeys {
    
    static let MessageAr = "MessageAr"
    static let MessageEn = "MessageEn"
    static let Status = "Status"
    static let AcademicPoints = "AcademicPoints"
    static let ClassNameAr = "ClassNameAr"
    static let ClassNameEn = "ClassNameEn"
    static let Email = "Email"
    static let FullName = "FullName"
    static let JoinedDateAr = "JoinedDateAr"
    static let JoinedDateEn = "JoinedDateEn"
    static let LevelAr = "LevelAr"
    static let LevelEn = "LevelEn"
    static let Phone = "Phone"
    static let MembershipNo = "MembershipNo"
    static let Username = "Username"
    //Array..
    static let SubscribedSubjectList = "SubscribedSubjectList"
    static let PrivateclassRequestsList = "PrivateclassRequestsList"
    //...
    static let ChaptersCountAr = "ChaptersCountAr"
    static let ChaptersCountEn = "ChaptersCountEn"
    static let CoursesCountAr = "CoursesCountAr"
    static let CoursesCountEn = "CoursesCountEn"
    static let SubjectImage = "SubjectImage"
    static let SubjectNameAr = "SubjectNameAr"
    static let SubjectNameEn = "SubjectNameEn"
    
    static let ProfilePic = "ProfilePic"
}
