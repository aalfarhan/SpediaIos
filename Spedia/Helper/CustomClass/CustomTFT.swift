//
//  CustomTFT.swift
//  Spedia
//
//  Created by Viraj Sharma on 20/05/2020.
//  Copyright © 2020 Viraj Sharma. All rights reserved.
//

import Foundation
import UIKit


class CustomTFT: UITextField {
    
    @IBInspectable var isSearchType: Bool = false
    
    //1
    required init?(coder aDecoder:NSCoder) {
        super.init(coder:aDecoder)
        self.layoutSubviews()
    }
    
    //2
    override init(frame:CGRect) {
        super.init(frame:frame)
        self.layoutSubviews()
        
    }
    
    //3
    override func layoutSubviews() {
        
        super.layoutSubviews()
        //new add on
        textAlignment = L102Language.isCurrentLanguageArabic() ? .right : .left
        
        if isSearchType {
            
            self.layer.borderWidth = 0.0
            self.layer.borderColor = UIColor.clear.cgColor
            self.layer.cornerRadius = 0
            self.alpha = 1.0
            self.backgroundColor = .clear
            self.clipsToBounds = true
            self.textColor = Colors.APP_TEXT_BLACK
            
        } else {
            self.layer.borderWidth = 1.0
            self.layer.borderColor = UIColor.white.cgColor
            
            self.layer.cornerRadius = 10
            self.alpha = 1.0
            self.backgroundColor = Colors.APP_TFT_BKG
            self.clipsToBounds = true
            self.textColor = Colors.APP_TEXT_BLACK
        }
    }
    
    
    
    //4
    var fntSz = CGFloat()
    
    @IBInspectable var fontTypeName: String {
        
        get { return "" }
        
        set {
            
            //new add on
            //textAlignment = L102Language.isCurrentLanguageArabic() ? .right : .left
            
            if UIDevice.current.userInterfaceIdiom == .pad {
                fntSz = self.font?.pointSize ?? 15  + DeviceSize.screenWidth / 160
            } else {
                fntSz = self.font?.pointSize ?? 15
            }
            
            switch newValue {
            
            case AppFontRegular:
                self.font = UIFont(name: "REGULAR".localized(), size: self.fntSz)
                
            case AppFontBold:
                self.font = UIFont(name: "BOLD".localized(), size: self.fntSz)
                
            case AppFontLight:
                self.font = UIFont(name: "LIGHT".localized(), size: self.fntSz)
                
                
            case AppFontExBold:
                self.font = UIFont(name: "XTRABOLD".localized(), size: self.fntSz)
                
            default:
                print("set as defual custom label")
                
            }
            
        }
    }
    
    
    let padding = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
    
    let paddingWithout = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: isSearchType ? paddingWithout : padding)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: isSearchType ? paddingWithout : padding)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: isSearchType ? paddingWithout : padding)
    }
    
}



//MARK: Placeholder For UITextView
extension UITextView {

    private class PlaceholderLabel: UILabel { }

    private var placeholderLabel: PlaceholderLabel {
        if let label = subviews.compactMap( { $0 as? PlaceholderLabel }).first {
            return label
        } else {
            let label = PlaceholderLabel(frame: .zero)
            label.font = UIFont(name: "REGULAR".localized(), size: 15)
            if #available(iOS 13.0, *) {
                label.textColor = UIColor.placeholderText
            } else {
                // Fallback on earlier versions
            }
            
            //new add on
            textAlignment = L102Language.isCurrentLanguageArabic() ? .right : .left
            label.textAlignment = L102Language.isCurrentLanguageArabic() ? .right : .left
            addSubview(label)
            return label
        }
    }
   
    open override func layoutSubviews() {
        
        super.layoutSubviews()
        
    }
    
    
    @IBInspectable
    var placeholder: String {
        
        get {
            return subviews.compactMap( { $0 as? PlaceholderLabel }).first?.text ?? ""
        }
        set {
            
            let placeholderLabel = self.placeholderLabel
            placeholderLabel.text = newValue
            placeholderLabel.numberOfLines = 0
            let width = frame.width - textContainer.lineFragmentPadding * 2
            let size = placeholderLabel.sizeThatFits(CGSize(width: width, height: .greatestFiniteMagnitude))
            placeholderLabel.frame.size.height = size.height
            placeholderLabel.frame.size.width = width
            placeholderLabel.frame.origin = CGPoint(x: textContainer.lineFragmentPadding, y: textContainerInset.top)

            textStorage.delegate = self
             
            
        }
    }

}


extension UITextView: NSTextStorageDelegate {

    public func textStorage(_ textStorage: NSTextStorage, didProcessEditing editedMask: NSTextStorage.EditActions, range editedRange: NSRange, changeInLength delta: Int) {
        if editedMask.contains(.editedCharacters) {
            placeholderLabel.isHidden = !text.isEmpty
        }
    }

}
