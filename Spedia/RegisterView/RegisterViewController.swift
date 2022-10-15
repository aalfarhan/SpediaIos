//
//  RegisterViewController.swift
//  Spedia
//
//  Created by Viraj Sharma on 04/07/2020.
//  Copyright © 2020 Viraj Sharma. All rights reserved.
//

import UIKit
import SwiftyJSON
import SVProgressHUD
import CoreLocation


class RegisterViewController: UIViewController, UITextFieldDelegate {

    //1 Placeholders
    @IBOutlet weak var registerPHLabel: CustomLabel!
    @IBOutlet weak var userNameLbl: CustomLabel!
    @IBOutlet weak var emailLbl: CustomLabel!
    @IBOutlet weak var phoneLbl: CustomLabel!
    @IBOutlet weak var createPassLbl: CustomLabel!
    @IBOutlet weak var confirmPassLbl: CustomLabel!
    @IBOutlet weak var connectWithLbl: CustomLabel!
    @IBOutlet weak var alreadyAccountLbl: CustomLabel!
    @IBOutlet weak var createVisibilityButton: UIButton!
    @IBOutlet weak var confirmVisibilityButton: UIButton!
    
    //2 TFT's
    @IBOutlet weak var userNameTFT: CustomTFT!
    @IBOutlet weak var emailTFT: CustomTFT!
    @IBOutlet weak var phoneNumberTFT: CustomTFT!
    @IBOutlet weak var createPassTFT: CustomTFT!
    @IBOutlet weak var confirmPassTFT: CustomTFT!
    
    
    //3 Button's
    @IBOutlet weak var nextButton: CustomButton!
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var googleButton: UIButton!
    @IBOutlet weak var loginButton: CustomButton!
    @IBOutlet weak var backButton: UIButton!
    
    
    //4 Constratins
    @IBOutlet weak var alreadyAccountCenterConst: NSLayoutConstraint!
    
    
    //5 Other's

    //5.1 Country Picker
    @IBOutlet weak var countryContainerVieww: UIView!
    @IBOutlet weak var countryPicker: SearchCountryView!
    
    
    //6 County Selection
    @IBOutlet weak var selectCountryButton: UIButton!
    @IBOutlet weak var codeTFT: CustomTFT!
    @IBOutlet weak var flagImageView: UILabel!
    @IBOutlet weak var selectedCodeLbl: CustomLabel!
    
    
    //7 Email or Phone Buttons
    @IBOutlet weak var buttonContStackView: UIStackView!
    //@IBOutlet weak var emailContainerVieww: UIView!
    @IBOutlet weak var phoneContainerVieww: UIView!
    @IBOutlet weak var usernameContainerVieww: UIView!
    @IBOutlet weak var createPasswordContainerVieww: UIView!
    @IBOutlet weak var confirmPasswordContainerVieww: UIView!
    
    @IBOutlet weak var phoneNoAndCountryCodeStackView: UIStackView!
    
    
    @IBOutlet weak var emailButton: CustomButton!
    @IBOutlet weak var phoneButton: CustomButton!
    var isEmailFieldActivated = true
    var isPhoneFieldActivated = true
    
    
    //7.1 Country Data Or Selection
    var countryListData = JSON()
    var coutnryISOCode = ""
    var isAutoPickDone = false
    var currentAutoPickCountryISOCode = ""
    var seletedPhoneCountryISOCode = ""
    
    //8 Location
    let locationManager = CLLocationManager()
    let geoCoder = CLGeocoder()
 
    
    //9 Socail Media (facebook, google, apple)
    var socailMediaType = ""
    var socailMediaId = ""
    var isFromSocailMedia = false
    @IBOutlet weak var topButtonTopConst: NSLayoutConstraint!
    @IBOutlet weak var topButtonHeightConst: NSLayoutConstraint!
     
    
    //T&C Check
    @IBOutlet weak var byClickingLbl: CustomLabel!
    @IBOutlet weak var termsConditionButton: CustomButton!
    var isTermsChecked = false
    @IBOutlet weak var termsIconIV: UIImageView!
    
    func stopTracking() {
        locationManager.stopUpdatingHeading()
        locationManager.stopUpdatingLocation()
    }
    
    func startTracking() {
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()
    }
    
    
    //MVC
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //0 Auto Pick Locaiton
        //if isFromSocailMedia == false {
        
        //}
        
        //1 Delegates
        self.phoneNumberTFT.delegate = self
        self.userNameTFT.delegate = self
        self.emailTFT.delegate = self
        self.createPassTFT.delegate = self
        self.confirmPassTFT.delegate = self
        self.countryPicker.delegateObj = self
    
        //2
        self.setupView()
        
        
        //For .
        /*self.phoneNumberTFT.text = ""
        self.emailTFT.text = "luke@gmail.com"
        self.userNameTFT.text = "luke323"
        self.createPassTFT.text = "12345"
        self.confirmPassTFT.text = "12345"*/
    
        self.whichButtonActive(tag: 1)
        
        phoneNumberTFT.addTarget(self, action: #selector(didChangeText(field:)), for: .editingChanged)

        self.phoneLbl.textAlignment = .left
    }
    
    
    @objc func didChangeText(field: UITextField) {
        if ((field.text?.containsNonEnglishNumbers) != nil) {
            field.text = field.text?.english
        }
    }
    
    
    @IBAction func emailButtonAction(_ sender: Any) {
        self.whichButtonActive(tag: 0)
    }
    
    
    @IBAction func phoneButtonAction(_ sender: Any) {
        self.whichButtonActive(tag: 1)
    }
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        createVisibilityButton.isSelected = true
        confirmVisibilityButton.isSelected = true
        
        if L102Language.isCurrentLanguageArabic() {
         self.phoneNoAndCountryCodeStackView.semanticContentAttribute =  .forceLeftToRight
         self.phoneLbl.textAlignment = .right
         //self.phoneLblLeftConst.constant = 100
            
         self.phoneNoAndCountryCodeStackView.setNeedsLayout()
         self.phoneNoAndCountryCodeStackView.layoutIfNeeded()
        }
        
        if isFromSocailMedia {
        
            self.topButtonTopConst.constant = 0
            self.topButtonHeightConst.constant = 0
            
            self.emailTFT.text = emailGlobal
            
            if SocailMediaType.google == self.socailMediaType {
               self.emailTFT.isUserInteractionEnabled = false
            }
            
            
            if SocailMediaType.apple == self.socailMediaType {
                if !emailGlobal.isEmpty {
                    self.emailTFT.isUserInteractionEnabled = false
                }
            }
            
            
            self.usernameContainerVieww.isHidden = true
            self.createPasswordContainerVieww.isHidden = true
            self.confirmPasswordContainerVieww.isHidden = true
             
            
        } else {
            
            
        }
        
        //goku here OFF //DND
        self.checkLocationServices()
        self.startTracking()
        
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
       self.stopTracking()
       
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        
         self.stopTracking()
        
    }
    
    
    func setDateAccodingAutoPickCountry(countryCode : String)  {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            
            let searchPredicate = NSPredicate(format: "(CountryIsoCode contains[c] %@) OR (CountryIsoCode contains[c] %@)", countryCode, countryCode)
            
            if let array = self.countryListData.arrayObject {
                
                let foundItems = JSON(array.filter { searchPredicate.evaluate(with: $0) })
                
                if foundItems.count == 1 {
                    
                    print("\n\n\n foundItems---->\n\n\n", foundItems)
                    
                    self.selectedCodeLbl.text = foundItems[0]["CountryCode"].stringValue
                    
                    self.coutnryISOCode = foundItems[0]["CountryIsoCode"].stringValue
                    self.flagImageView.text = "".countryFlag(countryCode: self.coutnryISOCode)
                
                }
                
            }
        }
        
        
    }
    
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
      
    
    @IBAction func eyeButtonAction(_ sender: UIButton) {
        
        if sender.tag == 1 {
            self.createPassTFT.isSecureTextEntry = self.createPassTFT.isSecureTextEntry ? false : true
            self.createVisibilityButton.isSelected = self.createPassTFT.isSecureTextEntry ? true : false
        }
        
        if sender.tag == 2 {
            self.confirmPassTFT.isSecureTextEntry = self.confirmPassTFT.isSecureTextEntry ? false : true
            self.confirmVisibilityButton.isSelected = self.confirmPassTFT.isSecureTextEntry ? true : false
        }
        
    }
    
    
    @IBAction func termsButtonAction(_ sender: Any) {
     
      if let vc = TermsAndPolicyViewController.instantiate(fromAppStoryboard: .main) {
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
      }
        
    }
    
    
    
    func whichButtonActive(tag : Int) {
        
        //UIView.animate(withDuration: 0.50) {
            
        if tag == 0 { //Email Button
            
            self.emailButton.backgroundColor = Colors.APP_LIGHT_GREEN
            self.emailButton.setTitleColor(.white, for: .normal)
            
            self.phoneButton.backgroundColor = .white
            self.phoneButton.setTitleColor(.black, for: .normal)
            
            self.isEmailFieldActivated = true
            self.isPhoneFieldActivated = false
            
            //self.emailContainerVieww.isHidden = false
            self.phoneContainerVieww.isHidden = false
            
            self.coutnryISOCode = self.currentAutoPickCountryISOCode
            
        } else { //Phone Button
            
            
            self.phoneButton.backgroundColor = Colors.APP_LIGHT_GREEN
            self.phoneButton.setTitleColor(.white, for: .normal)
            
            self.emailButton.backgroundColor = .white
            self.emailButton.setTitleColor(.black, for: .normal)
        
            self.isEmailFieldActivated = false
            self.isPhoneFieldActivated = true
            
            //self.emailContainerVieww.isHidden = true
            self.phoneContainerVieww.isHidden = false
            
            self.coutnryISOCode = self.seletedPhoneCountryISOCode
        }
        //self.layoutIfNeeded() //}
    
    }
    
    
    
    /*
    func whichButtonActive(tag : Int) {
        
        //UIView.animate(withDuration: 0.50) {
            
            if tag == 1 { //From Kuwait User
                
                //self.selectCountryTFT.isEnabled = false
                self.selectCountryTFT.text = "kuwait".localized()
                self.selectCountryPHLabel.text = "kuwait_placeholder".localized()
                emailLbl.text = "username".localized()
                emailTFT.placeholder = "username".localized()
                //self.codeTFT.text = "+965"
                //self.selectCountryButton.isEnabled = false
                //self.selectedCountryIdInt = 0
                self.phoneNumberTFT.text = ""
                AppShared.object.isNonKuwaitGlobal = false
                //self.searchButton.isHidden = true
                
            } else { //Out side from Kuwait User
                
                //self.selectCountryTFT.isEnabled = true
                //self.selectCountryTFT.text = ""
                //self.codeTFT.text = ""
                //self.selectCountryButton.isEnabled = true
                self.selectCountryPHLabel.text = "please_select_country".localized()
                
                emailLbl.text = "email_ph".localized()
                emailTFT.placeholder = "email_ph".localized()
                
                AppShared.object.isNonKuwaitGlobal = true
                
                //self.searchButton.isHidden = false
                self.phoneNumberTFT.text = ""
            }
        
           // self.view.layoutIfNeeded()
        //}
        
    }

     */
 
    
    @IBAction func checkBoxButtonAction(_ sender: Any) {
      /*    if isTermsChecked {
            isTermsChecked = true
            checkBoxImageView.image = #imageLiteral(resourceName: "terms_icon_nill")
        } else {
            isTermsChecked = true
            checkBoxImageView.image = #imageLiteral(resourceName: "terms_icon_fill")
        }*/
    }
    
    
    
    @IBAction func selectCountryButtonAction(_ sender: Any) {
        
        //goku here OFF
        //DND
        
        self.countryPicker.searchTFT.text = ""
        self.countryPicker.isFacultyType = false
        self.countryPicker.topTitleLbl.text = "pick_country".localized()
        self.countryPicker.dataJson = self.countryListData
        self.countryPicker.dataJsonCopy = self.countryListData
        self.countryPicker.listView.reloadData()
        self.countryContainerVieww.isHidden = false
        
    }
    
    
    //4 Call API.....
    func getCountryListData() {
    
        let urlString = getCountry
       
        let params = ["CountryCode" : self.coutnryISOCode]
        
        ServiceManager().postRequest(urlString, loader: true, parameters: params) { (status, jsonResponse) in
             
            if status {
                
                let data = JSON.init(jsonResponse ?? "NO DTA")
                self.countryListData = data["Countries"]
                
                //Check For Hide
                let shouldShowEmailBox = data["IsByEmail"].boolValue
                let shouldShowPhoneBox = data["IsByPhone"].boolValue
                
                if shouldShowPhoneBox && !shouldShowEmailBox {
                    self.whichButtonActive(tag: 1)
                }
                
                if !shouldShowPhoneBox && shouldShowEmailBox {
                    self.whichButtonActive(tag: 0)
                }
                
                self.emailButton.isHidden = !shouldShowEmailBox
                self.phoneButton.isHidden = !shouldShowPhoneBox
                
                self.setDateAccodingAutoPickCountry(countryCode: self.coutnryISOCode)
                
            }
        }
        
    }
    
    
    
    
    //1 Setup View...
    func setupView() {
        
        //0
        self.registerPHLabel.text = "register".localized()
        self.backButton.imageView?.transform =  L102Language.isCurrentLanguageArabic() ? CGAffineTransform(scaleX: -1.0, y: 1.0) : CGAffineTransform(scaleX: 1.0, y: -1.0)
        
        
        if L102Language.isCurrentLanguageArabic() {
            //self.buttonContStackView.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            self.emailButton.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            self.phoneButton.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            
        }
    
        
        
        //1
        userNameLbl.text = "username".localized()
        userNameTFT.placeholder = "username".localized()
        
        //2
        emailLbl.text = "email_ph".localized()
        emailTFT.placeholder = "email_ph".localized()
        
        //3
        phoneLbl.text = L102Language.isCurrentLanguageArabic() ? "رقم الموبايل" : "Phone Number"
        phoneNumberTFT.placeholder = "phone_ph".localized()
        
        //4
        createPassLbl.text = L102Language.isCurrentLanguageArabic() ? "أدخل كلمة السر" : "Create Password"
        createPassTFT.placeholder = createPassLbl.text
        
        //5
        confirmPassLbl.text = L102Language.isCurrentLanguageArabic() ? "تأكيد كلمة السر" : "Confirm Password"
        confirmPassTFT.placeholder = confirmPassLbl.text
        
        //6
        connectWithLbl.text = L102Language.isCurrentLanguageArabic() ? "تسجيل الدخول بواسطة" : "Connect with"
        alreadyAccountLbl.text = L102Language.isCurrentLanguageArabic() ? "لديك حساب بالفعل ؟" : "Already have an account?"
        //7
        self.nextButton.setTitle(L102Language.isCurrentLanguageArabic() ? "التالي" : "NEXT", for: .normal)
        self.loginButton.setTitle(L102Language.isCurrentLanguageArabic() ? "الدخول" : "Login", for: .normal)
        //8
        self.alreadyAccountCenterConst.constant = L102Language.isCurrentLanguageArabic() ? 35 : -25
        
        //9
        self.codeTFT.placeholder = "" //"code".localized()
        
        //self.selectCountryPHLabel.text = "select_country".localized()
        //self.selectCountryTFT.placeholder = "select_country".localized()
        
        
        //9 Phone and Email View
        self.emailButton.setTitle("email_ph".localized(), for: .normal)
        self.phoneButton.setTitle("phone_ph".localized(), for: .normal)
        
        self.emailButton.layer.cornerRadius = self.emailButton.frame.height / 2
        self.emailButton.clipsToBounds = true
        
        self.phoneButton.layer.cornerRadius = self.phoneButton.frame.height / 2
        self.phoneButton.clipsToBounds = true
        
        
        
        //10 Terms
        self.byClickingLbl.text = "by_clicking".localized()
        self.termsConditionButton.setTitle("terms_and_condition".localized(), for: .normal)
        isTermsChecked = false
        termsIconIV.image = #imageLiteral(resourceName: "terms_icon_nill")
        
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
       
        let passStr = createPassTFT.text ?? ""
        let confirmPassStr = confirmPassTFT.text ?? ""
        
        if isPhoneFieldActivated {
            
            let phoneStr = phoneNumberTFT.text ?? ""
            if phoneStr.isEmpty {
                SVProgressHUD.showInfo(withStatus: "valid_phone".localized())
                return false
            }
            
        }
        
        if passStr.isEmpty && isFromSocailMedia == false {
            SVProgressHUD.showInfo(withStatus: "valid_password".localized())
            return false
        }
        
        if confirmPassStr.isEmpty && isFromSocailMedia == false {
            SVProgressHUD.showInfo(withStatus: "valid_confirm_password".localized())
            return false
        }
        
        if passStr != confirmPassStr && isFromSocailMedia == false {
            SVProgressHUD.showInfo(withStatus: "password_mismatch".localized())
            return false
        }
           
        if isTermsChecked == false {
            SVProgressHUD.showInfo(withStatus: "iagreedTC".localized())
            return false
        }
        
        return true
    
    }
    
    
    //5
    @IBAction func checkBoxAction(_ sender: Any) {
        
        if isTermsChecked {
            
            isTermsChecked = false
            termsIconIV.image = #imageLiteral(resourceName: "terms_icon_nill")
        
        } else {
            isTermsChecked = true
            termsIconIV.image = #imageLiteral(resourceName: "terms_icon_fill")
        }
        
    }
    
    
    
    @IBAction func nextButtonAction(_ sender: Any) {
     
    //let deviceToken = Messaging.messaging().apnsToken?.hexString ?? "NO_DEVICE_TOKEN"
    DispatchQueue.main.async {
        if self.validateFields() {
            
     let urlString = tempRegisterStudent
        
            let params = ["UserName":  self.userNameTFT.text ?? "",
                          "Email": self.emailTFT.text ?? "",
                          "MobileNo": self.phoneNumberTFT.text ?? "",
                   "DeviceID": UIDevice.current.identifierForVendor!.uuidString,
                          "Password": self.confirmPassTFT.text ?? "",
                   "CountryCode" : self.coutnryISOCode,
                   "IsPhone": self.isPhoneFieldActivated,
                   "SocialMediaType" : self.socailMediaType,
                   "SocialMediaID" : self.socailMediaId] as [String : Any]
   
     ServiceManager().postRequest(urlString, loader: true, parameters: params) { (status, jsonResponse) in
          
         if status {
             
             let dataResponse = JSON.init(jsonResponse!)
         
              if let vc = OTPViewController.instantiate(fromAppStoryboard: .main) {
                
                vc.modalPresentationStyle = .fullScreen
                vc.tempUserID = dataResponse["tempID"].intValue
                vc.classID = dataResponse["ClassID"].intValue
                vc.isByPassed = dataResponse["ByPassClassSelection"].boolValue
                vc.dataJsonObj = dataResponse
                vc.countryISOCodeOTPObj = self.coutnryISOCode
                self.present(vc, animated: true, completion: nil)
                 
               }
             
             }
            
          }
        }
    }
    }
    

    
    @IBAction func loginButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}





//MARK:================================================
//MARK: Select Country Extension
//MARK:================================================

extension RegisterViewController : SearchCountryViewDelegate {

    func didCountrySelect(countryData : JSON) {
        
        self.selectedCodeLbl.text = countryData["CountryCode"].stringValue
        self.coutnryISOCode = countryData["CountryIsoCode"].stringValue
        self.seletedPhoneCountryISOCode = self.coutnryISOCode
        self.flagImageView.text = "".countryFlag(countryCode: self.coutnryISOCode)
        
        self.countryContainerVieww.isHidden = true
        
    }

    
    @IBAction func crossButtonAction(_ sender: Any) {
        self.countryContainerVieww.isHidden = true
    }

}




//MARK:================================================
//MARK: Core Location (Get Device Current Location)
//MARK:================================================

extension RegisterViewController : CLLocationManagerDelegate {
    
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            //checkLocationAuthorization()
        } else {
            // Show alert letting the user know they have to turn this on.
        }
    }
    
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.requestWhenInUseAuthorization()
    }
    
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            
            locationManager.startUpdatingLocation()
            break
        case .denied:
            // Show alert instructing them how to turn on permissions
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            // Show an alert letting them know what's up
            break
        case .authorizedAlways:
            break
        @unknown default:
            print("errror")
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        print("\n\n\n locationManager \n\n\n locationManager \n\n\n")
        
        guard let currentLocation = locations.first else { return }
        
        geoCoder.reverseGeocodeLocation(currentLocation) { (placemarks, error) in
            guard let currentLocPlacemark = placemarks?.first else { return }
            print(currentLocPlacemark.country ?? "No country found")
            print(currentLocPlacemark.isoCountryCode ?? "No country code found")
            
            
            self.coutnryISOCode = currentLocPlacemark.isoCountryCode ?? ""
            self.currentAutoPickCountryISOCode = self.coutnryISOCode
            self.seletedPhoneCountryISOCode = self.coutnryISOCode
            self.flagImageView.text = "".countryFlag(countryCode: self.coutnryISOCode)
            
            if !self.coutnryISOCode.isEmpty {
                //self.stopTracking()
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.getCountryListData()
                self.stopTracking()
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
    
}
