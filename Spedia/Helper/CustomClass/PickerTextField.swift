//
//  PickerTextField.swift
//  Spedia
//
//  Created by Viraj Sharma on 07/11/2020.
//  Copyright © 2020 Viraj Sharma. All rights reserved.
//

import UIKit
import SwiftyJSON

class PickerCustomerTextField: UITextField, UITextFieldDelegate {
    
    @IBInspectable var isSearchType: Bool = false
    var titleLabel:UILabel!
    @IBInspectable var maxChars:Int = 0
    @IBInspectable var editable:Bool = true
    @IBInspectable var isClearText: Bool = false
    
    
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
    
    //2.1
    override func awakeFromNib() {
        super.awakeFromNib()
        delegate = self
        self.isUserInteractionEnabled = editable
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if string == "" {
            return true
        }
        
        if maxChars != 0 {
            if textField.text!.count >= maxChars {
                return false
            }
        }
        
        return true
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField)  {
        
        //titleLabel.isHidden = false
        //return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        //titleLabel.isHidden = textField.text == ""
        //        return true
    }
    
    
    override public func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(copy(_:)) || action == #selector(paste(_:)) {
            return false
        }

        return true
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
            self.textColor = isClearText ? .clear : Colors.APP_TEXT_BLACK
            
        } else {
            self.layer.borderWidth = 1.0
            self.layer.borderColor = UIColor.white.cgColor
            
            self.layer.cornerRadius = 10
            self.alpha = 1.0
            self.backgroundColor = Colors.APP_TFT_BKG
            self.clipsToBounds = true
            self.textColor = isClearText ? .clear : Colors.APP_TEXT_BLACK
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



//MARK:===========================
//MARK: DATE PICKER 111
//MARK:===========================

class DateTimePickerTextField: PickerCustomerTextField {
    
    var returnedDate:String {
        
        set{
            returned = newValue
        }
        
        get {
            var myDate = ""
            let digits = ["١":"1","٢":"2","٣":"3","٤":"4","٥":"5","٦":"6","٧":"7","٨":"8","٩":"9","٠":"0"]
            for c in returned {
                
                if let mD = digits["\(c)"]{
                    myDate += mD
                }else{
                    myDate += "\(c)"
                }
            }
            return myDate
        }
    }
    
    var returned = ""
    
    let datePickerView = UIDatePicker()
    var pickerMode:UIDatePicker.Mode = .date
    var minimuDate = Date()
    var setMinimumdate:((_ date:Date)->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        datePickerView.datePickerMode = pickerMode
        
        if #available(iOS 13.4, *) {
            datePickerView.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
            
        }
        
        if pickerMode == .date {
            datePickerView.minimumDate = Calendar.current.date(byAdding: .year, value: -1, to: Date()) ?? Date()
            datePickerView.maximumDate = Date()
        }
        
        self.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
    }
    
    @objc func handleDatePicker(sender: UIDatePicker) {
     
        if pickerMode == .date {
            
            let myDateFormat = DateFormatter()
            myDateFormat.dateFormat = "d-M-yyyy"
            self.returnedDate = myDateFormat.string(from: sender.date)
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMM yyyy"
            self.text = dateFormatter.string(from: sender.date)
            
        } else if pickerMode == .time {
            
            let date24Format = DateFormatter()
            date24Format.dateFormat = "HH:mm"
            self.returnedDate = date24Format.string(from: sender.date)
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "hh:mm a"
            self.text = dateFormatter.string(from: sender.date)
        }
        
        self.setMinimumdate?(sender.date)
    }
     
    
    //MY Login... goku..
    override func textFieldDidBeginEditing(_ textField: UITextField) {
        super.textFieldDidBeginEditing(textField)
        
       if self.text!.isEmpty && pickerMode == .date {
       
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        self.text = dateFormatter.string(from:  Date())
        
        let returnDateFormate = DateFormatter()
        returnDateFormate.dateFormat = "d-M-yyyy"
        self.returnedDate = returnDateFormate.string(from:  Date())
       
       }
        
        if self.text!.isEmpty && pickerMode == .time {
         
         let dateFormatter = DateFormatter()
         dateFormatter.dateFormat = "hh:mm a"
         self.text = dateFormatter.string(from:  Date())
        
        }
    
    }
    
    
}



//MARK:===========================
//MARK: DATA PICKER 222
//MARK:===========================


class DataPickerTextField: PickerCustomerTextField, UIPickerViewDelegate, UIPickerViewDataSource {
    
    private let pickerView = UIPickerView()
    
    var items = [JSON]()
    var index:Int?
    var nameKey = "Name" + Lang.code()
    var pickerAction:((_ item:Int)->())?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        pickerView.delegate = self
        pickerView.dataSource = self
        
        self.inputView = pickerView
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) ->Int{
    
         return items.count
    
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return items[row][nameKey].stringValue
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if items.count > 0 {
            self.text = items[row][nameKey].stringValue
            self.index = row
            self.pickerAction?(row)
            
        }
    }
    
    
    override func textFieldDidBeginEditing(_ textField: UITextField) {
        super.textFieldDidBeginEditing(textField)
        if items.count > 0 {
            self.text = items[0][nameKey].stringValue
        }
        self.index = 0
    }
}
