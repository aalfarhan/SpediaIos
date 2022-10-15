
//
//  L012Localizer.swift
//  LanguageChanger
//
//  Created by Xpertcube on 01/11/16.
//  Copyright © 2016 Xpertcube. All rights reserved.
//

import Foundation
import UIKit
extension UIApplication {
    class func isRTL() -> Bool{
        return UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft
    }
}

class L102Localizer: NSObject {
    class func DoTheMagic() {
        
        MethodSwizzleGivenClassName(cls: Bundle.self, originalSelector: #selector(Bundle.localizedString(forKey:value:table:)), overrideSelector: #selector(Bundle.specialLocalizedStringForKey(_:value:table:)))
        
        MethodSwizzleGivenClassName(cls: UIApplication.self, originalSelector: #selector(getter: UIApplication.userInterfaceLayoutDirection), overrideSelector: #selector(getter: UIApplication.cstm_userInterfaceLayoutDirection))
    }
}




var numberoftimes = 0
extension UIApplication {
    @objc var cstm_userInterfaceLayoutDirection : UIUserInterfaceLayoutDirection {
        get {
            var direction = UIUserInterfaceLayoutDirection.leftToRight
            if L102Language.currentAppleLanguage() == "ar" {
                direction = .rightToLeft
            }
            return direction
        }
    }
}
extension Bundle {
    @objc func specialLocalizedStringForKey(_ key: String, value: String?, table tableName: String?) -> String {
        if self == Bundle.main {
            let currentLanguage = L102Language.currentAppleLanguage()
            var bundle = Bundle();
            if let _path = Bundle.main.path(forResource: L102Language.currentAppleLanguageFull(), ofType: "lproj") {
                bundle = Bundle(path: _path)!
            }else
            if let _path = Bundle.main.path(forResource: currentLanguage, ofType: "lproj") {
                bundle = Bundle(path: _path)!
            } else {
                let _path = Bundle.main.path(forResource: "Base", ofType: "lproj")!
                bundle = Bundle(path: _path)!
            }
            return (bundle.specialLocalizedStringForKey(key, value: value, table: tableName))
        } else {
            return (self.specialLocalizedStringForKey(key, value: value, table: tableName))
        }
    }
}

func disableMethodSwizzling() {
    
}


/// Exchange the implementation of two methods of the same Class
func MethodSwizzleGivenClassName(cls: AnyClass, originalSelector: Selector, overrideSelector: Selector) {
    guard let origMethod: Method = class_getInstanceMethod(cls, originalSelector),
        let overrideMethod: Method = class_getInstanceMethod(cls, overrideSelector) else {
        return
    }
    if (class_addMethod(cls, originalSelector, method_getImplementation(overrideMethod), method_getTypeEncoding(overrideMethod))) {
        class_replaceMethod(cls, overrideSelector, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
    } else {
        method_exchangeImplementations(origMethod, overrideMethod);
    }
}

/*
import Foundation

class L012Localizer: NSObject {
    
    class func DoTheSwizzling() {
        
        // 1
        MethodSwizzleGivenClassName(cls: Bundle.self, originalSelector: #selector(Bundle.localizedString(forKey:value:table:)), overrideSelector: #selector(Bundle.specialLocalizedStringForKey(key:value:table:)))
        
    }
    
    
}

extension Bundle {
    
    
    @objc func specialLocalizedStringForKey(key: String, value: String?, table tableName: String?) -> String {
        
        /*2*/let currentLanguage = L102Language.currentAppleLanguage()
        //print("key for localization :\(key)")
        
        
        var bundle = Bundle();
        
        /*3*/if let _path = Bundle.main.path(forResource: currentLanguage, ofType: "lproj") {
            
            bundle = Bundle(path: _path)!
            
        } else {
            
            let _path = Bundle.main.path(forResource: "Base", ofType: "lproj")!
            
            bundle = Bundle(path: _path)!
            
        }
        
        //system keys
        switch key {
            case "API_CANCEL_TITLE" : return "Cancel"
            case "USE_PHOTO" : return "Use Photo"
            case "RETAKE": return "Retake"
            default:break
        }
        
        let string = (bundle.specialLocalizedStringForKey(key: key, value: value, table: tableName))
        return string == "localized string not found" ? key : string
    }
    
}

/// Exchange the implementation of two methods for the same Class

func MethodSwizzleGivenClassName(cls: AnyClass, originalSelector: Selector, overrideSelector: Selector) {
    
    let origMethod: Method = class_getInstanceMethod(cls, originalSelector)!;
    
    if let overrideMethod: Method = class_getInstanceMethod(cls, overrideSelector) {
        
        if (class_addMethod(cls, originalSelector, method_getImplementation(overrideMethod), method_getTypeEncoding(overrideMethod))) {
            
            class_replaceMethod(cls, overrideSelector, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
            
        } else {
            
            method_exchangeImplementations(origMethod, overrideMethod);
            
        }
    }
}
*/
