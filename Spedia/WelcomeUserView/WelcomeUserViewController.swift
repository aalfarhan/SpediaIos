//
//  WelcomeUserViewController.swift
//  Spedia
//
//  Created by Viraj Sharma on 16/08/2021.
//  Copyright © 2021 Viraj Sharma. All rights reserved.
//

import UIKit
import SwiftyJSON

class WelcomeUserViewController: UIViewController {
    
    //1 Outlets.......
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var backButton: UIButton!
    
    //1.0
    @IBOutlet weak var headerTitleLbl: CustomLabel!
    @IBOutlet weak var headerSubTitleLbl: CustomLabel!
    
    //1.1
    @IBOutlet weak var fullnamePHLbl: CustomLabel!
    @IBOutlet weak var fullNameTFT: CustomTFT!
    
    //1.2
    @IBOutlet weak var schoolTypeContainerView: UIView!
    @IBOutlet weak var schoolTypePHLbl: CustomLabel!
    @IBOutlet weak var schoolTypeTFT: DataPickerTextField!
    
    //1.3
    @IBOutlet weak var selectGradeContainerView: UIView!
    @IBOutlet weak var selectGradePHLbl: CustomLabel!
    @IBOutlet weak var gradeTFT: DataPickerTextField!
    
    
    //1.4
    @IBOutlet weak var maleImageView: UIImageView!
    @IBOutlet weak var maleView: UIView!
    
    //1.5
    @IBOutlet weak var femaleImageView: UIImageView!
    @IBOutlet weak var famaleView: UIView!
    
    //1.6
    @IBOutlet weak var nextButton: CustomButton!
    
    
    //2 Data.........
    var dataJson = JSON()
    var currentIndex = 0
    
    var selectedClassId = 0
    var selectedAvatarStr = "female"
    var tempId = 0
    var countryISOCodeWelcomeObject = ""
    
    //By Passing
    var isByPassed = false
    var isGuestLocalObj = false
    
    //For Guest Login
    
    @IBOutlet weak var usernameContainerView: UIView!
    @IBOutlet weak var avatatViewHieghtConst: NSLayoutConstraint!
    
    
    
    
    //1
    override func viewDidLoad() {
        
        super.viewDidLoad()
        

        self.schoolTypeTFT.pickerAction = { [unowned self] row in
        
            self.gradeTFT.text = ""
            self.currentIndex = row
            
            self.gradeTFT.items = self.dataJson[row]["ClassList"].arrayValue
            
            //self.schoolTypeTFT.resignFirstResponder()
        }
        
        
        self.gradeTFT.pickerAction = { [unowned self] row in
    
            self.selectedClassId = self.dataJson[self.currentIndex]["ClassList"][row]["ID"].intValue
        
            //self.gradeTFT.resignFirstResponder()
        }

    }
    
    
    
    //2
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        if isGuestLocalObj {
            
            self.avatatViewHieghtConst.constant = 0.0
            self.usernameContainerView.isHidden = true
            self.headerSubTitleLbl.isHidden = true

        } else {
            self.avatatViewHieghtConst.constant = 80.0
            self.usernameContainerView.isHidden = false
            self.headerSubTitleLbl.isHidden = false

        }

        
        self.setUpView()
        self.getWelcomePageDataNow()
        
    }
   
    
    //3
    func setUpView() {

        self.fullnamePHLbl.text = "fullname_top_ph".localized()
        self.schoolTypePHLbl.text = "school_type_ph".localized()
        self.selectGradePHLbl.text = "select_grade_ph".localized()
        
        self.fullNameTFT.placeholder = "fullname_top_ph".localized()
        self.schoolTypeTFT.placeholder = "school_type_ph".localized()
        self.gradeTFT.placeholder = "select_grade_ph".localized()
        
        
        self.nextButton.setTitle("next".localized(), for: .normal)
        
        
        self.backButton.imageView?.transform =  L102Language.isCurrentLanguageArabic() ? CGAffineTransform(scaleX: -1.0, y: 1.0) : CGAffineTransform(scaleX: 1.0, y: -1.0)
        
        
        self.famaleView.layer.borderColor = Colors.APP_LIGHT_GREEN?.cgColor
        self.maleView.layer.borderColor = UIColor.clear.cgColor
        
        self.famaleView.layer.borderWidth = 1.0
        self.maleView.layer.borderWidth = 1.0
        
        self.famaleView.layer.cornerRadius = 10
        self.maleView.layer.cornerRadius = 10
        
        
        //BY PASSING
        self.schoolTypeContainerView.isHidden = self.isByPassed
        self.selectGradeContainerView.isHidden = self.isByPassed
        self.schoolTypeTFT.text = self.isByPassed ? "By Passed" : ""
        self.gradeTFT.text = self.isByPassed ? "By Passed" : ""
        
    }
    
    
    @IBAction func maleButtonAction(_ sender: Any) {
        
        self.selectedAvatarStr = "male" // Male
        self.maleView.layer.borderColor = Colors.APP_LIGHT_GREEN?.cgColor
        self.famaleView.layer.borderColor = UIColor.clear.cgColor
    }
    
    @IBAction func femaleButtonAction(_ sender: Any) {
        self.selectedAvatarStr = "female"
        self.famaleView.layer.borderColor = Colors.APP_LIGHT_GREEN?.cgColor
        self.maleView.layer.borderColor = UIColor.clear.cgColor
    }
    
    
    @IBAction func backButtonAction(_ sender: Any) {
       self.dismiss(animated: true, completion: nil)
       //self.navigationController?.popViewController(animated: true)
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
    
    
    @IBAction func nextButtonAction(_ sender: Any) {
        
        if validateFields() {
                        
            if isGuestLocalObj {
                self.loginAsGuestNow()
            } else {
               self.signUpUserNow()
            }
        }
        
    }
    
    
    
    //4 Call API.....
    
    func getWelcomePageDataNow() {
        
        let urlString = getClasses
        let params = ["CountryCode":  self.countryISOCodeWelcomeObject] as [String : String]
        ServiceManager().getRequest(urlString, loader: true, parameters: params) { (status, jsonResponse) in
            
            if status {
                
                let dataRes = JSON.init(jsonResponse ?? "NO DTA")
                
                //0
                self.dataJson = dataRes["Categories"]
                
                self.headerTitleLbl.text = dataRes["Title" + Lang.code()].stringValue
                
                self.headerSubTitleLbl.text = dataRes["SubTitle" + Lang.code()].stringValue
                
                
                self.schoolTypeTFT.items = self.dataJson.arrayValue
                
                
                //1 Male Avatar Image
                let maleUrl = URL(string: dataRes["AvatarMale"].stringValue)
                self.maleImageView.kf.setImage(with: maleUrl, placeholder: UIImage.init(named: "male"))
                
                //2 Female Avatar Image
                let femaleUrl = URL(string: dataRes["AvatarFemale"].stringValue)
                self.femaleImageView.kf.setImage(with: femaleUrl, placeholder: UIImage.init(named: "female"))
                 
            }
            
        }
        
    }
    
    
    
    func signUpUserNow() {
        
        let fullNameStr = self.fullNameTFT.text ?? ""
        
        let urlString = signupStudent
        
        
        let params = ["tempID" : self.tempId,
                      "Avatar" : self.selectedAvatarStr,
                      "Name": fullNameStr,
                      "ClassID" : self.selectedClassId] as [String : Any]
        
        
        ServiceManager().postRequest(urlString, loader: true, parameters: params) { (status, jsonResponse) in
            
            if status {
                
                //MARK:Adjust Event Set 101 Register:New
                GlobalFunctions.object.setAdjustEvent(eventName: "msnqs0")
                
                let welcomeResponse = JSON.init(jsonResponse ?? "NO DTA")
                
                UserDefaults.standard.set(welcomeResponse.object, forKey: UserDefaultKeys.userPersonalDataKey)

                loadUserData()
                
        
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
    
    
    func parseDataNow(dataModel: JSON) {
        
        UserDefaults.standard.set(dataModel.object, forKey: UserDefaultKeys.userPersonalDataKey)

        loadUserData()
        

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
    
    
    
    func loginAsGuestNow() {
        
        let urlString = guestLoginApi
        
        let params = ["ClassID" : self.selectedClassId] as [String : Any]
        
        
        ServiceManager().postRequest(urlString, loader: true, parameters: params) { (status, jsonResponse) in
            
            if status {
                
                //MARK:Adjust Event Set 102 Guest Login:NEW
                GlobalFunctions.object.setAdjustEvent(eventName: "9gxt1u")
                
                var dataResponse = JSON.init(jsonResponse ?? "NO DTA")
                for item in dataResponse {
                    if item.1.type == .null {
                        print("key-->", item.0, "value--->",item.1)
                        dataResponse[item.0] = ""
                    }
                }
                
                DispatchQueue.main.async {
                    self.parseDataNow(dataModel: dataResponse)
                }
                
            }
        }
        
    }
    
    
    private func validateFields()->Bool {
        
        var validateFields = true
        
        //1
        
        if isGuestLocalObj == false {
            
            let fullNameStr = fullNameTFT.text ?? ""
            if fullNameStr.isEmpty {
                showAlert(alertText: "please_enter_fullname".localized(), alertMessage: "")
                validateFields = false
            }
        }
        
        //2
        let schoolTypeStr = schoolTypeTFT.text ?? ""
        if schoolTypeStr.isEmpty {
            showAlert(alertText: "please_select_school_type".localized(), alertMessage: "")
            validateFields = false
        }
        
        //3
        let gradeStr = gradeTFT.text ?? ""
        if gradeStr.isEmpty {
            showAlert(alertText: "please_select_grade".localized(), alertMessage: "")
            validateFields = false
        }
        
        return validateFields
    }
    
}
