//
//  EditProfileViewController.swift
//  Spedia
//
//  Created by Viraj Sharma on 23/08/2020.
//  Copyright © 2020 Viraj Sharma. All rights reserved.
//

import UIKit
import SwiftyJSON
import SVProgressHUD

class EditProfileViewController: UIViewController, UITextFieldDelegate {
    
    //1 Placeholders
    @IBOutlet weak var headerTitleLbl: CustomLabel!
    @IBOutlet weak var fullNameLbl: CustomLabel!
    @IBOutlet weak var emailLbl: CustomLabel!
    @IBOutlet weak var phoneLbl: CustomLabel!
    @IBOutlet weak var createPassLbl: CustomLabel!
    @IBOutlet weak var confirmPassLbl: CustomLabel!
    @IBOutlet weak var deleteAccountLabelPH: CustomLabel!
    
    //2 TFT's
    @IBOutlet weak var fullNameTFT: CustomTFT!
    @IBOutlet weak var emailTFT: CustomTFT!
    @IBOutlet weak var phoneNumberTFT: CustomTFT!
    @IBOutlet weak var createPassTFT: CustomTFT!
    @IBOutlet weak var confirmPassTFT: CustomTFT!

    //3 Button's
    @IBOutlet weak var submitButton: CustomButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var createVisibilityButton: UIButton!
    @IBOutlet weak var confirmVisibilityButton: UIButton!
    
    //4 Constratins
    
    //5 Other's
    var isPhoneNoVerified = true
    var isPhoneEmpty = false
    
    //6 Delete Account POP View:
    let deleteAccountViewObj = DeleteAccountView()
    var msgString = ""
    var titleString = ""
     
    
    //MARK: Change Grade
    //7.1
    @IBOutlet weak var schoolTypeContainerView: UIView!
    @IBOutlet weak var schoolTypePHLbl: CustomLabel!
    @IBOutlet weak var schoolTypeTFT: DataPickerTextField!
    //7.2
    @IBOutlet weak var selectGradeContainerView: UIView!
    @IBOutlet weak var selectGradePHLbl: CustomLabel!
    @IBOutlet weak var gradeTFT: DataPickerTextField!
    var selectedClassId = 0
    var currentIndex = 0
    var dataJson = JSON()
    
    //Responsive
    @IBOutlet weak var leftPedding: NSLayoutConstraint!
    @IBOutlet weak var rightPedding: NSLayoutConstraint!
    @IBOutlet weak var checkBoxImageView: UIImageView!
    
    
    //MVC
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.phoneNumberTFT.delegate = self
        self.fullNameTFT.delegate = self
        self.emailTFT.delegate = self
        self.createPassTFT.delegate = self
        self.confirmPassTFT.delegate = self
        
        //
        self.phoneNumberTFT.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        
        
        //MARK: Change Grade
        self.schoolTypeTFT.items = self.dataJson["Categories"].arrayValue
        
        //1
        self.schoolTypeTFT.pickerAction = { [unowned self] row in
            self.gradeTFT.text = ""
            self.currentIndex = row
            self.gradeTFT.items = self.dataJson["Categories"][row]["ClassList"].arrayValue
        }
        
        //2
        self.gradeTFT.pickerAction = { [unowned self] row in
            self.selectedClassId = self.dataJson["Categories"][self.currentIndex]["ClassList"][row]["ID"].intValue
        }
        
        
    }
    
    @IBAction func selectGradeButtonAction(_ sender: Any) {
        
        let schoolTypeStr = self.schoolTypeTFT.text ?? ""
        
        if schoolTypeStr.isEmpty {
            showAlert(alertText: "please_select_school_type".localized(), alertMessage: "")
        } else {
            self.gradeTFT.becomeFirstResponder()
            self.schoolTypeTFT.resignFirstResponder()
        }
        
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        if !isPhoneEmpty {
        if textField == phoneNumberTFT {
            print(textField.text ?? "")
            
            let verifiedPhoneNo = phoneNoGlobal.replacingOccurrences(of: "+", with: "")
            let typePhoneNo = textField.text ?? ""
            
            if verifiedPhoneNo == typePhoneNo {
                
                UIView.transition(with: self.checkBoxImageView,
                                  duration: 0.5,
                                  options: .transitionCrossDissolve,
                                  animations: {
                                    self.submitButton.setTitle("submitEditProfile".localized(), for: .normal)
                                    self.isPhoneNoVerified = true
                                    self.checkBoxImageView.image = UIImage.init(named: "icon_checked_grayGreen")
                },
                                  completion: nil)
                
                
            } else {
                
                UIView.transition(with: self.checkBoxImageView,
                                  duration: 0.5,
                                  options: .transitionCrossDissolve,
                                  animations: {
                                    self.submitButton.setTitle("verify".localized(), for: .normal)
                                    self.isPhoneNoVerified = false
                                    self.checkBoxImageView.image = UIImage.init(named: "icon_cross_red_24pt")
                },
                                  completion: nil)
                
            }
        
        }
            
        } else {
        
            let phoneStr = self.phoneNumberTFT.text ?? ""
            self.isPhoneEmpty = phoneStr.isEmpty ? true : false
        
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //1
        self.setupView()
        
        self.phoneNumberTFT.text = phoneNoGlobal.replacingOccurrences(of: "+", with: "")
        self.fullNameTFT.text = nameGlobal
        self.emailTFT.text = emailGlobal
        self.createPassTFT.placeholder = "••••••••"
        self.confirmPassTFT.placeholder = "••••••••"
        
        
        let emailStr = self.emailTFT.text ?? ""
        self.emailTFT.isUserInteractionEnabled = emailStr.isEmpty ? true : false
        
        let phoneStr = self.phoneNumberTFT.text ?? ""
        self.isPhoneEmpty = phoneStr.isEmpty ? true : false
        self.checkBoxImageView.isHidden = phoneStr.isEmpty ? true : false
        
        
        //MARK: Delete Account Button Set Up
        self.deleteAccountLabelPH.text = "delete_ph".localized()
        self.deleteAccountViewObj.frame = self.view.frame
        self.view.addSubview(self.deleteAccountViewObj)
        self.deleteAccountViewObj.isHidden = true
        self.deleteAccountViewObj.titleLbl.text = self.titleString
        self.deleteAccountViewObj.subTitleLbl.text = self.msgString
        
        
        //MARK: Change Grade
        self.schoolTypePHLbl.text = "school_type_ph".localized()
        self.selectGradePHLbl.text = "select_grade_ph".localized()
        
        self.schoolTypeTFT.placeholder = self.dataJson["Category" + Lang.code()].stringValue
        self.gradeTFT.placeholder = self.dataJson["Grade" + Lang.code()].stringValue
        self.selectedClassId = self.dataJson["ClassID"].intValue
        
        createVisibilityButton.isSelected = true
        confirmVisibilityButton.isSelected = true
        
    }
    
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func deleteAccountButtonAction(_ sender: Any) {
        print("deleteAccountButtonAction")
        self.deleteAccountViewObj.isHidden = false
    }
    
    
    @IBAction func visibilyButtonAction(_ sender: UIButton) {
        
        if sender.tag == 1 {
            self.createPassTFT.isSecureTextEntry = self.createPassTFT.isSecureTextEntry ? false : true
            self.createVisibilityButton.isSelected = self.createPassTFT.isSecureTextEntry ? true : false
        }
        
        if sender.tag == 2 {
            self.confirmPassTFT.isSecureTextEntry = self.confirmPassTFT.isSecureTextEntry ? false : true
            self.confirmVisibilityButton.isSelected = self.confirmPassTFT.isSecureTextEntry ? true : false
        }
        
    }
    
    
    @IBAction func undoPhoneNoButtonAction(_ sender: Any) {
        
        self.phoneNumberTFT.text = phoneNoGlobal.replacingOccurrences(of: "+", with: "")
        self.submitButton.setTitle("submitEditProfile".localized(), for: .normal)
        self.isPhoneNoVerified = true
        self.checkBoxImageView.image = UIImage.init(named: "icon_checked_grayGreen")
        
    }
    
    
    
    //1 Setup View...
    func setupView() {
        
        //1
        fullNameLbl.text = "fullname_ph".localized()
        fullNameTFT.placeholder = "valid_fullname".localized()
        
        //2
        emailLbl.text = "email_ph".localized()
        emailTFT.placeholder = "email_ph".localized()
        
        //3
        phoneLbl.text = "phone_number".localized()
        phoneNumberTFT.placeholder = "valid_phone".localized()
        
        //4
        createPassLbl.text = "new_password".localized()
        createPassTFT.placeholder = "new_password".localized()
        
        //5
        confirmPassLbl.text = "confirm_new_password".localized()
        confirmPassTFT.placeholder = "confirm_new_password".localized()
        
        //6
        headerTitleLbl.text = "edit_profile".localized()
        
        //7
        self.submitButton.setTitle("submitEditProfile".localized(), for: .normal)
        
        //8
        self.backButton.imageView?.transform =  L102Language.isCurrentLanguageArabic() ? CGAffineTransform(scaleX: -1.0, y: 1.0) : CGAffineTransform(scaleX: 1.0, y: -1.0)
        
        self.submitButton.setTitle("submitEditProfile".localized(), for: .normal)
        self.isPhoneNoVerified = true
        self.checkBoxImageView.image = UIImage.init(named: "icon_checked_grayGreen")
        

    }
    
    
    //===============================================
    //MARK: VALIDATION'S
    //===============================================
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == phoneNumberTFT {
            let maxLength = 30
            let currentString: NSString = textField.text as NSString? ?? ""
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
            
        } else {
            return true
        }
        
    }
    
    
    
    private func validateFields()->Bool {
        
        var validateFields = true
        
        //1
        //let emailStr = emailTFT.text ?? "" //|| !isValidEmail(emailStr)
        //if emailStr.isEmpty {
            //SVProgressHUD.showInfo(withStatus: "valid_username".localized())
            //validateFields = false
        //}
        
        //2
        //let phoneStr = phoneNumberTFT.text ?? ""
        //if phoneStr.isEmpty {
           //SVProgressHUD.showInfo(withStatus: "valid_phone".localized())
           //validateFields = false
        //}
        
        //3
        let nameStr = fullNameTFT.text ?? ""
        if nameStr.isEmpty {
            SVProgressHUD.showInfo(withStatus: "valid_fullname".localized())
            validateFields = false
        }
        
        //4 & 5
        
        //let checkStr = createPassTFT.placeholder ?? ""
        let passStr = createPassTFT.text ?? ""
        let confirmPassStr = confirmPassTFT.text ?? ""
        
        if passStr != confirmPassStr  {
            SVProgressHUD.showInfo(withStatus: "password_mismatch".localized())
            validateFields = false
        }
        
        return validateFields
        
    }
    
    
    
    
    
    
    @IBAction func nextButtonAction(_ sender: Any) {
        
        //Verify First Now...
        if self.isPhoneNoVerified == false {
            
            let mobileNo = phoneNumberTFT.text ?? ""
            
            if mobileNo.count > 5 {
                
                if let vc = OTPViewController.instantiate(fromAppStoryboard: .main) {
                    vc.modalPresentationStyle = .fullScreen
                    vc.whereFromI = "editprofile"
                    vc.mobileNo = mobileNo
                    self.present(vc, animated: true, completion: nil)
                }
                
            } else {
                SVProgressHUD.showInfo(withStatus: "valid_phone".localized())
            }
            
            
            
            // GO FOR NOW...
        } else {
            
            if validateFields() {
                
                let saveClassId = Int(classIdGlobal ?? "0")
                
                if saveClassId == self.selectedClassId {
                    self.callEditProfileAPi(isClassChange: false)
                } else {
                    self.showChangeIdPopUp()
                }
                 
            }
            
        }
        
    }
    
    
    func callEditProfileAPi(isClassChange: Bool) {
        let urlString = updateStudentProfile
        
        let params = ["SessionToken": sessionTokenGlobal ?? "",
                      "StudentID": studentIdGlobal ?? 0,
                      "Name":  fullNameTFT.text ?? "",
                      "Email": emailTFT.text ?? "",
                      "MobileNo": phoneNumberTFT.text ?? "",
                      "Password": confirmPassTFT.text ?? "",
                      "ClassID": self.selectedClassId] as [String : Any]
        
        ServiceManager().postRequest(urlString, loader: true, parameters: params) { (status, jsonResponse) in
            
            if status {
                if isClassChange {
                    if isParentGlobal {
                        setParentRootView()
                    } else {
                     logoutNow()
                    }
                } else {
                    self.backButtonAction(self)
                }
                
            }
        }
    }
    
    
    func showChangeIdPopUp() {
        // Create the alert controller
        let alertController = UIAlertController(title: "", message: "ARE_YOU_SURE_CHANGE_CLASS".localized(), preferredStyle: .alert)
        
        // Create the actions
        let okAction = UIAlertAction(title: "YES".localized(), style: UIAlertAction.Style.default) {
            UIAlertAction in
            NSLog("OK Pressed")
            self.callEditProfileAPi(isClassChange: true)
        }
        let cancelAction = UIAlertAction(title: "NO".localized(), style: UIAlertAction.Style.cancel) {
            UIAlertAction in
            NSLog("Cancel Pressed")
        }
        
        // Add the actions
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        // Present the controller
        self.present(alertController, animated: true, completion: nil)
    }
}
