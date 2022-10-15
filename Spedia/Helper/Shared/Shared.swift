//
//  Shared.swift
//  Spedia
//
//  Created by Viraj Sharma on 17/06/2020.
//  Copyright © 2020 Viraj Sharma. All rights reserved.
//

import SwiftyJSON


/*
class UserSingleton: NSObject {

    var shared = UserSingleton()
    
    var isLogin: Bool?
    var sessionToken : String?
    var studentID : Int?
    var classID : Int?
    var userId : Int?
    
    
    //Initializer access level change now
    override init() {
        
        isLogin = false
        
        let savedObject = UserDefaults.standard.value(forKey: UserDefaultKeys.)
        
        let data = JSON.init(savedObject ?? "NO DATA")
        
        userId = data["\(StudentKeys.USER_ID)"].int ?? 0
    
        if userId != 0 {
            isLogin = true
            sessionToken = data["\(StudentKeys.TOKEN)"].stringValue
            studentID = data["\(StudentKeys.USER_ID)"].intValue
            classID = data["\(StudentKeys.CLASS_ID)"].intValue
        }
        
    }
    
}
*/


enum QuestionType:String {
    
    case fillInTheBlank = "1"
    case matching = "2"
    case multiChoice = "3"
    case shortAnswer = "4"
    case trueOrFale = "5"
    case multiSelect = "6"
    case shortAnswerWithChoice = "7"
    case fillInBlankWithChoices = "8"
    case underLine = "9"
    case fillSpace = "10"
    case written = "18"
    case comprehension = "20"

    func getQuizzID() -> Int {
        switch self{
        case .fillInTheBlank : return 1
        case .matching : return 2
        case .multiChoice : return 3
        case .shortAnswer : return 4
        case .trueOrFale : return 5
        case .multiSelect :  return 6
        case .shortAnswerWithChoice : return 7
        case .fillInBlankWithChoices : return 8
        case .underLine: return 9
        case .fillSpace : return 10
        case .written : return 18
        case .comprehension : return 20
            
        }
    }
}




