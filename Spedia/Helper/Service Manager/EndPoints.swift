//
//  EndPoints.swift
//  Spedia
//
//  Created by Viraj Sharma on 17/06/2020.
//  Copyright © 2020 Viraj Sharma. All rights reserved.
//


import Foundation

//#if DEBUG
//let BaseURL = baseURLGloabal
//#else
//let BaseURL = baseURLGloabal
//#endif


//=================================================================================
//=================================================================================
//MARK: Dynamic URL & API's
//=================================================================================
//=================================================================================


//LIVE
//let baseURL = "https://live.spediaapp.com/wcf/Service.svc/" OLD LIVE
let baseURL = "https://NewAdmin.spediaapp.com/api/SpediaMobile/" //NEW LIVE

//Beta
//let baseURL = "https://beta.spediaapp.com/api/SpediaMobile/"


let getSpediaOnBoarding = baseURL + "GetSpediaOnBoarding"

let loginApi = baseURL + "LoginUserNew"

let tempRegisterStudent = baseURL + "TempRegisterStudent"

let getClasses = baseURL + "GetClasses"

let requestOTP = baseURL + "RequestOTP"

let verifyOTP = baseURL + "VerifyOTP"

let getHomeDataApi = baseURL + "GetHome"

let getUnits = baseURL + "GetUnits"

let getSelectWorkBook = baseURL + "SelectWorkBook"

let getSelectQuestionPaperArchive = baseURL + "SelectQuestionPaperArchive"

let getSelectQuestions = baseURL + "SelectQuestions"

let getUpdateQuizTime = baseURL + "UpdateQuizTime"

let getSaveQuizAnswer = baseURL + "SaveQuizAnswer"

let getUpdateExamAnswerMark = baseURL + "UpdateExamAnswerMark"

let getExamResultApi = baseURL + "ExamResult"

let getCartItems = baseURL + "GetCartItems"

let addToCartApi = baseURL + "AddToCart_Apple" //"AddToCart"

let testingAddToCart = baseURL + "Test_iOS"

let removeFromCartApi = baseURL + "RemoveFromCart"

let saveSubscriptionBeforePayment = baseURL + "SaveSubscriptionBeforePayment"

let saveSubscriptionStatusAfterPayment = baseURL + "SaveSubscriptionStatusAfterPayment"

let getLiveCourses = baseURL + "GetLiveCourses"

let getProfileData = baseURL + "GetProfileData"

let uploadFile = baseURL + "UploadFile"

let getAskSpediaReplies = baseURL + "GetAskSpediaReplies"

let askSpedia = baseURL + "AskSpedia"

let getAskSpediaHistory = baseURL + "GetAskSpediaHistory"

let getStudentNotificationHistory = baseURL + "GetStudentNotificationHistory"

let videoEvents = baseURL + "VideoEvents"

let forgotPassword = baseURL + "ForgotPassword"

let updateStudentProfile = baseURL + "UpdateStudentProfile"

let getLiveClassRequestData = baseURL + "GetLiveClassRequestData"

let requestLiveClass = baseURL + "RequestLiveClass_ToCart"

let initiatePaymentForLiveClass = baseURL + "InitiatePaymentForLiveClass"

let verifyLiveClassPayment = baseURL + "VerifyLiveClassPayment"

let studentJoined = baseURL + "StudentJoined"

let getStatistics = baseURL + "GetStatistics"

let skillAnalysisData = baseURL + "SkillAnalysisData"

let getLeaderBoard = baseURL + "GetLeaderBoard"

let getTimeline = baseURL + "GetTimeline"

let getCountry = baseURL + "GetCountry"

let getBookmark = baseURL + "GetVideoBookMark"

let getHomeWork = baseURL + "GetHomeWork"

let downloadedHomeWork = baseURL + "DownloadedHomeWork"

let uploadHomeWorkAnswer = baseURL + "UploadHomeWorkAnswer"

let getMeetingJoinData = baseURL + "GetMeetingJoinData"

let signupStudent = baseURL + "SignupStudent"

let getExpiryReminderData = baseURL + "GetExpiryReminderData"

let expiryReminderAddToCart = baseURL + "ExpiryReminder_AddToCart"

let saveLiveClassRating = baseURL + "SaveLiveClassRating"

let socialMediaLogin = baseURL + "SocialMediaLogin"

let getStudentsOfParent = baseURL + "GetStudentsOfParent"

let getStudentProgressSummary = baseURL + "GetStudentProgressSummary"

let updateParentProfile = baseURL + "UpdateParentProfile"

let addStudentUnderParentQRCode = baseURL + "AddStudentUnderParent_QR"

let getQRCodeForStudent = baseURL + "GetQRCodeForStudent"

let getUniversityHome = baseURL + "GetUniversityHome"

let getUniversityUnits = baseURL + "GetUniversityUnits"

let applePaymentDoneDirect = baseURL + "ApplePaymentDone_Direct"

let guestLoginApi = baseURL + "GuestLogin"

//new
let getHomeNewDataApi = baseURL + "GetHomeNew"
let getLiveClassDetailApi = baseURL + "GetLiveClassDetails"
let getPreRecordedDescriptionApi = baseURL + "GetPreRecordedDescription"
let getHomeSubscribedDataApi = baseURL + "GetMyCourses"
let getSubSkillVideo = baseURL + "GetSubSkillVideo"
let getLiveClassApi = baseURL + "GetLiveClass"
let getVideoLibraryApi = baseURL + "GetVideoLibrary"
let getUnitsAndSubUnitsApi = baseURL + "GetUnitsAndSubUnits"
let deleteStudentPermenantlyApi = baseURL + "DeleteStudentPermenantly"
let getSelectSubjectGuideLine = baseURL + "SelectSubjectGuideLine"
let getNotificaitonActionApi = baseURL + "StudentNotificationActions"
let getOneTimeQuizApi = baseURL + "GetOneTimeQuizForMenu"

