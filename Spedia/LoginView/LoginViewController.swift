//
//  LoginViewController.swift
//  Spedia
//
//  Created by Viraj Sharma on 21/05/2020.
//  Copyright © 2020 Viraj Sharma. All rights reserved.
//

import UIKit
import SwiftyJSON
import SVProgressHUD
import GoogleSignIn
import AVKit
import Photos

class LoginViewController: UIViewController {

    //Placeholders...
    @IBOutlet weak var usernameLbl: CustomLabel!
    @IBOutlet weak var passwordLbl: UILabel!
    
    //UI OBJECT's
    @IBOutlet weak var emailTFT: CustomTFT!
    @IBOutlet weak var passwordTFT: CustomTFT!
    @IBOutlet weak var visibilityButton: UIButton!
    @IBOutlet weak var loginButton: CustomButton!
    //@IBOutlet weak var doYouHaveAccountLbl: CustomLabel!
    @IBOutlet weak var registerButton: CustomButton!
    @IBOutlet weak var forgotButton: CustomButton!
    @IBOutlet weak var guestLoginButton: CustomButton!
    @IBOutlet weak var changeLangButton: CustomButton!
    
    
    //LoginWith
    @IBOutlet weak var loginWithContianerVieww: UIView!
    @IBOutlet weak var loginWithLbl: CustomLabel!
    @IBOutlet weak var facebookLbl: CustomLabel!
    @IBOutlet weak var googleLbl: CustomLabel!
    @IBOutlet weak var appleLbl: CustomLabel!
    
    @IBOutlet weak var facebookButtonView: UIView!
    @IBOutlet weak var googleButtonView: UIView!
    @IBOutlet weak var appleButtonView: UIView!
    
    
    //Const...
    @IBOutlet weak var centerAlignFacebooConts: NSLayoutConstraint!
    @IBOutlet weak var centerAlignGoogleConts: NSLayoutConstraint!
    @IBOutlet weak var centerAlignAppleConts: NSLayoutConstraint!
    
    //Responsive
    @IBOutlet weak var leftPaddingForMainView: NSLayoutConstraint!
    @IBOutlet weak var rightPaddingForMainView: NSLayoutConstraint!
    
    //For Crash Test
    //@IBOutlet weak var crashButton: UIButton!
    
    //MVC....
    override func viewDidLoad() {
        super.viewDidLoad()
        //navigationController?.setNavigationBarHidden(true, animated: true)
      
        
        //Alignment
        
        //1 Facebook Button
        //let facebookValue = self.centerAlignFacebooConts.constant
        //self.centerAlignFacebooConts.constant = L102Language.isCurrentLanguageArabic() ? -(facebookValue) : facebookValue
        
        //2 Google Button
        let googleValue = self.centerAlignGoogleConts.constant
        self.centerAlignGoogleConts.constant = L102Language.isCurrentLanguageArabic() ? -(googleValue) : googleValue
        
        //3 Apple Button
        let appleValue = self.centerAlignAppleConts.constant
        self.centerAlignAppleConts.constant = L102Language.isCurrentLanguageArabic() ? -(appleValue) : appleValue
        
        
        //Camera
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { response in
            if response {
                //access granted
            } else {

            }
        }

        //Photos
        let photos = PHPhotoLibrary.authorizationStatus()
        if photos == .notDetermined {
            PHPhotoLibrary.requestAuthorization({status in
                if status == .authorized {
                    
                } else {
                    
                }
            })
        }
         
        
    }
    
    
    
    
    private func getDataFromInitializeApp() {
        
        /*
        let urlString = initializeAppApi
    
        ServiceManager().getRequest(urlString, loader: false, parameters: [:]) { (status, jsonResponse) in
            
             if status {
                
                let dataJson = JSON.init(jsonResponse ?? "NO DATA")
                
                let socailButtonShow = dataJson["ShowSocialMedia"].bool ?? false
                
                let baseURL = dataJson["BaseURL"].stringValue
            
                UserDefaults.standard.setValue(baseURL, forKey: "BASE_URL_KEY")
                UserDefaults.standard.synchronize()
                
                self.loginWithContianerVieww.isHidden = !socailButtonShow
                
              } else {
                 
                //show error
                
             }
        }
        */
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        //isGuestLoginGlobal = false

        self.setupView()
        
        //MARK: Cache User ID Removed
        //For Remove From Cache... Save Side
        //self.saveUserInKeychain("")
        
        //FIXME: For 
        //self.emailTFT.text = "Linea" //"idc.farook@gmail.com "
        //self.passwordTFT.text = "1234"  //"123456789"
    
        //self.leftPaddingForMainView.constant = 212
        //self.rightPaddingForMainView.constant = 212
        
        self.registerButton.isHidden = false
        self.loginWithContianerVieww.isHidden = true
        visibilityButton.isSelected = true
        
        self.getDataFromInitializeApp()
        
    }
    

    
    func setupView() {
        
        //1
        self.usernameLbl.text =  "username".localized()
        emailTFT.placeholder = "username".localized()
        

        self.passwordLbl.text =  L102Language.isCurrentLanguageArabic() ? "كلمة السر" : "Password"
        
        passwordTFT.placeholder = passwordLbl.text
        
        
        //self.doYouHaveAccountLbl.text =  L102Language.isCurrentLanguageArabic() ? "ليس لديك حساب ؟" : "Don't have an account?"
        
        
        //2
        let loginTitle = L102Language.isCurrentLanguageArabic() ? "الدخول" : "LOGIN"
        let registerTitle = "register".localized().uppercased()
        
        self.loginButton.setTitle(loginTitle, for: .normal)
        self.registerButton.setTitle(registerTitle, for: .normal)
        
        
        //3
        //self.centerAlignValueConts.constant = L102Language.isCurrentLanguageArabic() ? 35 : -35
        
        //4
        self.forgotButton.setTitle("forgot_password".localized(), for: .normal)
        
        //4
        //self.contactUsButton.setTitle("guest_login_ph".localized(), for: .normal)
        
        
        let changeLangButtonStr = "select_language".localized()
        self.changeLangButton.setTitle(changeLangButtonStr, for: .normal)
        
        
        
        //5 Login With
        let loginWithStr = "login_with".localized()
        self.loginWithLbl.text = loginWithStr
        
        
        //6 Facebook, Google and Apple Views
        self.facebookButtonView.layer.cornerRadius = 10.0
        //self.facebookButtonView.frame.height / 2
        self.facebookButtonView.clipsToBounds = true
        self.facebookButtonView.layer.borderWidth = 1.0
        self.facebookButtonView.layer.borderColor = UIColor.gray.cgColor
        
        
        self.googleButtonView.layer.cornerRadius = 10.0
        self.googleButtonView.clipsToBounds = true
        self.googleButtonView.layer.borderWidth = 1.0
        self.googleButtonView.layer.borderColor = UIColor.gray.cgColor
        
        self.appleButtonView.layer.cornerRadius = 10.0
        self.appleButtonView.clipsToBounds = true
        self.appleButtonView.layer.borderWidth = 1.0
        self.appleButtonView.layer.borderColor = UIColor.gray.cgColor
        
        
        //6 Guest Login
        self.guestLoginButton.setTitle("guest_login_ph".localized().uppercased(), for: .normal)

    }
    
    
    
    @IBAction func visibilityAction(_ sender: Any) {
         
        self.passwordTFT.isSecureTextEntry = self.passwordTFT.isSecureTextEntry ? false : true
        self.visibilityButton.isSelected = self.passwordTFT.isSecureTextEntry ? true : false
        
        
     }
    
    
    @IBAction func changeLanguageButtonAction(_ sender: Any) {
        
        self.showChangeLanguagePopUP()
    }
    
    
    func showChangeLanguagePopUP() {
        // Create the alert controller
        
        let alertController = UIAlertController(title: "select_lang".localized(), message: "", preferredStyle: .alert)
        
        // Create the actions
        let okAction = UIAlertAction(title: "lang_yes_pop".localized(), style: UIAlertAction.Style.default) {
            UIAlertAction in
            NSLog("OK Pressed")
            
            let changeLangButtonStr = "select_language".localized()
            if changeLangButtonStr == "English" {
                
                self.onLoginClickEnglish()
            } else {
                self.onLoginClickAr()
            }
            
            self.viewWillAppear(false)
        
        }
        
        
        let cancelAction = UIAlertAction(title: "lang_no_pop".localized(), style: UIAlertAction.Style.cancel) {
            UIAlertAction in
            NSLog("Cancel Pressed")
        }
        
        // Add the actions
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        // Present the controller
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    
    @IBAction func loginButtonAction(_ sender: Any) {
        
        //let deviceToken = Messaging.messaging().apnsToken?.hexString ?? "NO_DEVICE_TOKEN"
        
        if validateFields() {
            
            let username = emailTFT.text?.lowercased() ?? ""
            let password = passwordTFT.text ?? ""
            
            let urlString = loginApi
            let params = ["UserName" : username,
                "Password" : password]
            
            
            ServiceManager().postRequest(urlString, loader: true, parameters: params) { (status, jsonResponse) in
                
                
                if status {
                    
                    //MARK:Adjust Event Set 103 User Login :NEW
                    GlobalFunctions.object.setAdjustEvent(eventName: "an2crf")
                                   
                    let loginResponse = JSON.init(jsonResponse ?? "NO DATA")
                    
                    UserDefaults.standard.set(loginResponse.object, forKey: UserDefaultKeys.userPersonalDataKey)
                    
                    loadUserData()
                
                    //Parent Check
                    if isParentGlobal {
                      setParentRootView()
                    } else {
                        
                     if startWithPage == StartWithPageType.universityHome {
                        setUniversityRootView(tabBarIndex: 0)
                     } else {
                        
                        if startWithPage == StartWithPageType.liveClass {
                            setRootView(tabBarIndex: 2)
                        } else {
                            setRootView(tabBarIndex: 0)
                        }
                        
                     }
                      
                    }
                    
                    
                }
                
            }
            
        }
        
        
        //For Crash Test
        //self.crashButton.isHidden = true
    
    }
    
    
    /*private func saveUserInKeychain(_ userIdentifier: String) {
        do {
            try KeychainItem(service: "com.mutawar.www.Spedia", account: "userIdentifier").saveItem(userIdentifier)
        } catch {
            print("Unable to save userIdentifier to keychain.")
        }
    }*/
    
    
    
    @IBAction func registerButtonAction(_ sender: Any) {
        if let vc = RegisterViewController.instantiate(fromAppStoryboard: .main) {
           vc.modalPresentationStyle = .fullScreen
           self.present(vc, animated: true, completion: nil)
        }
    }
     
    
    
    @IBAction func forgotButtonAction(_ sender: Any) {
        if let vc = ForgotViewController.instantiate(fromAppStoryboard: .main) {
           vc.modalPresentationStyle = .fullScreen
           self.present(vc, animated: true, completion: nil)
        }
    }
     
    
    
    private func validateFields()->Bool {
    
        var validateFields = true
        
        //1
        let emailStr = emailTFT.text ?? "" //|| !isValidEmail(emailStr)
        let passStr = passwordTFT.text ?? ""
    
        if emailStr.isEmpty {
            SVProgressHUD.showInfo(withStatus: "valid_username".localized())
            validateFields = false
    
        } else if passStr.isEmpty {
            SVProgressHUD.showInfo(withStatus: "valid_password".localized())

            validateFields = false
        }
        
        return validateFields
    }
    
    
    
    @IBAction func guestLoginButtonAction(_ sender: Any) {
        
        if let vc = WelcomeUserViewController.instantiate(fromAppStoryboard: .main) {
           vc.modalPresentationStyle = .fullScreen
            
           vc.isGuestLocalObj = true
            
           self.present(vc, animated: true, completion: nil)
        }
        
        //self.setRandomGuestAutoRegister()
    }
     
    
    
    func setRandomGuestAutoRegister() {
        
        /*let urlString = AppShared.object.+tempRegisterStudent
        
        let randomPhoneNumber = Int.random(in: 0...9999999)
        
        let params = ["FullName":  "iOS Guest",
                      "Email": "iOSGuest\(randomPhoneNumber)@gmail.com",
                      "MobileNo": "9\(randomPhoneNumber)",
                      "DeviceID": UIDevice.current.identifierForVendor!.uuidString,
                      "Password": "12345678",
                      "CountryID" : "0"] as [String : Any]
        
        ServiceManager().postRequest(urlString, loader: true, parameters: params) { (status, jsonResponse) in
            
            if status {
                
                let dataResponse = JSON.init(jsonResponse!)
                */
        
                if let vc = SelectSchoolViewController.instantiate(fromAppStoryboard: .main) {
                    
                    vc.modalPresentationStyle = .fullScreen
                    //vc.tempUserID = dataResponse["tempID"].intValue
                    
                    self.present(vc, animated: true, completion: nil)
                    
                }
                
           // }
            
        //}
    }
             
        
    
    
    
    private func onLoginClickEnglish() {
        
        L102Language.setAppleLAnguageTo(lang: "en")
        UIView.appearance().semanticContentAttribute = .forceLeftToRight
        setLoginAsRootView()
        
        /*
        L102Language.setAppleLAnguageTo(lang: "en")
        UIView.appearance().semanticContentAttribute = .forceLeftToRight

        let mainwindow = (UIApplication.shared.delegate?.window!)!
        mainwindow.backgroundColor = UIColor(hue: 0.6477, saturation: 0.6314, brightness: 0.6077, alpha: 0.8)
        UIView.transition(with: mainwindow, duration: 0.55001, options: .transitionFlipFromLeft, animations: { () -> Void in
        }) { (finished) -> Void in
            setLoginAsRootView()
        }
        
        L102Language.setAppleLAnguageTo(lang: "en")
        UIView.appearance().semanticContentAttribute = .forceLeftToRight
        
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
        */
    }
     
    
    
   private func onLoginClickAr() {
        
    
        L102Language.setAppleLAnguageTo(lang: "ar")
        UIView.appearance().semanticContentAttribute = .forceRightToLeft
        setLoginAsRootView()
    
    
        /*
        UIView.appearance().semanticContentAttribute = .forceRightToLeft

        let mainwindow = (UIApplication.shared.delegate?.window!)!
        mainwindow.backgroundColor = UIColor(hue: 0.6477, saturation: 0.6314, brightness: 0.6077, alpha: 0.8)
        UIView.transition(with: mainwindow, duration: 0.55001, options: .transitionFlipFromLeft, animations: { () -> Void in
        }) { (finished) -> Void in
            
        }
        
        L102Language.setAppleLAnguageTo(lang: "ar")
        UIView.appearance().semanticContentAttribute = .forceRightToLeft
        
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
        */
    }
    
    
    
    
    @IBAction func facebookButtonAction(_ sender: Any) {
    
    }
    
    
    @IBAction func googleButtonAction(_ sender: Any) {
       GlobalFunctions.object.clickOnGoogleButton()
    }
    
    
    @IBAction func appleButtonAction(_ sender: Any) {
        GlobalFunctions.object.clickOnAppleSingInButton()
    }
    
}






