//
//  Colors.swift
//  Spedia
//
//  Created by Viraj Sharma on 17/05/2020.
//  Copyright © 2020 Viraj Sharma. All rights reserved.
//

import UIKit

class Colors {

    //Tab Bar....
    static var TAB_TINT_ORANGE = UIColor(named: "TabBarTintOrange") //Orange color
    
    //Mains
    static var APP_LIGHT_GREEN = UIColor(named: "AppLightGreen") //Light Green
    static var APP_BlACK = UIColor(named: "AppBlack") //Black
    static var APP_DARK_GREEN = UIColor(named: "AppDarkGreen") //Dark Green
    static var APP_LIME_GREEN = UIColor(named: "AppLimeGreen") // Lime Green
    
    //TFT's
    static var APP_TFT_BKG = UIColor(named: "AppTFTBkg")
    static var APP_PLACEHOLDER_GRAY25 = UIColor(named: "AppPlaceholderGray25")
    
    //Text & Label's
    static var APP_TEXT_BLACK = UIColor(named: "AppTextBlack")
    static var APP_TEXT_GREEN = UIColor(named: "AppTextGreen")
    static var APP_TEXT_RED = UIColor(named: "AppTextRed")
    
    //Border's
    static var APP_BORDER_GRAY = UIColor(named: "AppBorderGray")
    
    static var APP_RED = UIColor(named: "AppRed")
    static var APP_RED_WITH5 = UIColor(named: "AppRedWith5")
    
    
    //Testing only
    static var Cell_Bkg_Blue = UIColor(named: "CellBkgTest")
    
    

}



extension UIColor {
    convenience init?(hexaRGB: String, alpha: CGFloat = 1) {
        var chars = Array(hexaRGB.hasPrefix("#") ? hexaRGB.dropFirst() : hexaRGB[...])
        switch chars.count {
        case 3: chars = chars.flatMap { [$0, $0] }
        case 6: break
        default: return nil
        }
        self.init(red: .init(strtoul(String(chars[0...1]), nil, 16)) / 255,
                green: .init(strtoul(String(chars[2...3]), nil, 16)) / 255,
                 blue: .init(strtoul(String(chars[4...5]), nil, 16)) / 255,
                alpha: alpha)
    }

    convenience init?(hexaRGBA: String) {
        var chars = Array(hexaRGBA.hasPrefix("#") ? hexaRGBA.dropFirst() : hexaRGBA[...])
        switch chars.count {
        case 3: chars = chars.flatMap { [$0, $0] }; fallthrough
        case 6: chars.append(contentsOf: ["F","F"])
        case 8: break
        default: return nil
        }
        self.init(red: .init(strtoul(String(chars[0...1]), nil, 16)) / 255,
                green: .init(strtoul(String(chars[2...3]), nil, 16)) / 255,
                 blue: .init(strtoul(String(chars[4...5]), nil, 16)) / 255,
                alpha: .init(strtoul(String(chars[6...7]), nil, 16)) / 255)
    }

    convenience init?(hexaARGB: String) {
        var chars = Array(hexaARGB.hasPrefix("#") ? hexaARGB.dropFirst() : hexaARGB[...])
        switch chars.count {
        case 3: chars = chars.flatMap { [$0, $0] }; fallthrough
        case 6: chars.append(contentsOf: ["F","F"])
        case 8: break
        default: return nil
        }
        self.init(red: .init(strtoul(String(chars[2...3]), nil, 16)) / 255,
                green: .init(strtoul(String(chars[4...5]), nil, 16)) / 255,
                 blue: .init(strtoul(String(chars[6...7]), nil, 16)) / 255,
                alpha: .init(strtoul(String(chars[0...1]), nil, 16)) / 255)
    }
}




/*
extension UIColor {

  convenience init(hex: String, alpha: CGFloat = 1.0) {
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

    if (cString.hasPrefix("#")) { cString.removeFirst() }

    if ((cString.count) != 6) {
      self.init(hex: "ff0000") // return red color for wrong hex input
      return
    }

    var rgbValue: UInt64 = 0
    Scanner(string: cString).scanHexInt64(&rgbValue)

    self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
              green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
              blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
              alpha: alpha)
  }

}
*/
