//
//  CustomLabel.swift
//  Spedia
//
//  Created by Viraj Sharma on 17/05/2020.
//  Copyright © 2020 Viraj Sharma. All rights reserved.
//

import UIKit

class CustomLabel: UILabel {
    
    var fntSz = CGFloat()
    
    
    @IBInspectable var fontTypeName: String {
        
        get { return "" }
        
        set {
            
            if UIDevice.isPad {
                fntSz = self.font.pointSize //+ DeviceSize.screenWidth / 200
            } else {
                fntSz = self.font.pointSize
            }
            
            switch newValue {
                
            case AppFontRegular:
                self.font = UIFont(name: "REGULAR".localized(), size: self.fntSz)
                
            case AppFontSemiBold:
                self.font = UIFont(name: "SEMIBOLD".localized(), size: self.fntSz)
                
            case AppFontLight:
                self.font = UIFont(name: "LIGHT".localized(), size: self.fntSz)
                
            case AppFontBold:
                self.font = UIFont(name: "BOLD".localized(), size: self.fntSz)
                
            case AppFontExBold:
                self.font = UIFont(name: "XTRABOLD".localized(), size: self.fntSz)
                
            default:
                print("set as defual custom label")
                
            }
            
        }
        
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    func setup() {
        if self.textAlignment == .center {
            
        } else {
            self.textAlignment = L102Language.isCurrentLanguageArabic() ? .right : .left
        }
    }
    
}




public extension UILabel {
    /// SwifterSwift: Initialize a UILabel with text
    convenience init(text: String?) {
        self.init()
        self.text = text
    }

    /// SwifterSwift: Initialize a UILabel with a text and font style.
    ///
    /// - Parameters:
    ///   - text: the label's text.
    ///   - style: the text style of the label, used to determine which font should be used.
    convenience init(text: String, style: UIFont.TextStyle) {
        self.init()
        font = UIFont.preferredFont(forTextStyle: style)
        self.text = text
    }

    /// SwifterSwift: Required height for a label
    var requiredHeight: CGFloat {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: frame.width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        label.attributedText = attributedText
        label.sizeToFit()
        return label.frame.height
    }
}
