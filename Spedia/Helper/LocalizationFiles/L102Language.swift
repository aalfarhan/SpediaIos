//
//  L102Language.swift
//  LanguageChanger
//
//  Created by Xpertcube on 01/11/16.
//  Copyright © 2016 Xpertcube. All rights reserved.
//


import Foundation

// constants

let APPLE_LANGUAGE_KEY = "AppleLanguages"

/// L102Language.isCurrentLanguageArabic()

open class L102Language {
    
    /// get current Apple language
    
    class func currentAppleLanguage() -> String {
        
        let userdef = UserDefaults.standard
        
        let langArray = userdef.object(forKey: APPLE_LANGUAGE_KEY) as! NSArray
        
        let current = langArray.firstObject as! String
        
        return current
        
    }
    
    /// set @lang to be the first in Applelanguages list
    
    class func setAppleLAnguageTo(lang: String) {
        
        //old
        let userdef = UserDefaults.standard
        userdef.removeObject(forKey: APPLE_LANGUAGE_KEY)
        //sleep(1)
        userdef.set([lang], forKey: APPLE_LANGUAGE_KEY)
        userdef.set(lang, forKey: "NEW_LANG_CODE_SET_IS_KEY")
        userdef.synchronize()
    
    }
    
    class func isCurrentLanguageArabic() -> Bool {
        let langCodeSet = UserDefaults.standard.string(forKey: "NEW_LANG_CODE_SET_IS_KEY") ?? "ar"
        return langCodeSet == "ar"
    }
    
    class func currentAppleLanguageFull() -> String{
        let userdef = UserDefaults.standard
        let langArray = userdef.object(forKey: APPLE_LANGUAGE_KEY) as! NSArray
        let current = langArray.firstObject as! String
        return current
    }
}
