//
//  OTPViewController.swift
//  Spedia
//
//  Created by Viraj Sharma on 08/07/2020.
//  Copyright © 2020 Viraj Sharma. All rights reserved.
//

import UIKit
import SwiftyJSON

class OTPViewController: UIViewController {
    
    var tempUserID = 0
    var classID = 0
    var isByPassed = false
    
    var dataJsonObj = JSON()
    
    var whereFromI = ""
    var mobileNo = ""
    var countryISOCodeOTPObj = ""
    
    @IBOutlet weak var willSendYourNoLbl: CustomLabel!
    @IBOutlet weak var otpTFT: CustomTFT!
    @IBOutlet weak var finishButton: CustomButton!
    @IBOutlet weak var resendButton: CustomButton!
    @IBOutlet weak var backButton: UIButton!
    
    
    //OTP Timer Set Objects...
    @IBOutlet var countDownLabel: UILabel!
    var count = 60 //sec
    var countdownTimer = Timer()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setupResendButtonNow()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        self.setupView()
        //self.sendReuqstForOTP()
        
    }
    
    
    func setupView() {
        
        self.backButton.imageView?.transform =  L102Language.isCurrentLanguageArabic() ? CGAffineTransform(scaleX: -1.0, y: 1.0) : CGAffineTransform(scaleX: 1.0, y: -1.0)
    
        self.resendButton.setTitle("resend_code".localized(), for: .normal)
        self.finishButton.setTitle("submit_ph".localized(), for: .normal)
        
        self.fillDataWith(dataModel: self.dataJsonObj)
        
    }
    
    
    
    func fillDataWith(dataModel: JSON) {
        
        //1
        let willSendYourNoLblStr = dataModel["Title" + Lang.code()].stringValue
        //2
        let otpTFTPlaceholder = dataModel["OTPPlaceholder" + Lang.code()].stringValue
        
        //Fill
        self.willSendYourNoLbl.text = willSendYourNoLblStr
        self.otpTFT.placeholder = otpTFTPlaceholder
        
    }
    
    
    
    
    /*
     
     
     
     func configureViewForKuwaitOrNot(isNonKuwait : Bool) {
     
     
     if isNonKuwait == false { //Means user from kuwait country
     
     //1
     let willSendYourNoLblStr = L102Language.isCurrentLanguageArabic() ? "تم إرسال رمز التأكيد إلى رقم الموبايل" : "An OTP has been send to your registered mobile number"
     //2
     let resendButtonStr = L102Language.isCurrentLanguageArabic() ? "إعادة إرسال رمز التأكيد" : "Resend code"
     
     //3
     let otpTFTStr = L102Language.isCurrentLanguageArabic() ? "إدخال رمز التأكيد" : "Enter OTP"
     
     //4 Fill
     self.willSendYourNoLbl.text = willSendYourNoLblStr
     self.resendButton.setTitle(resendButtonStr, for: .normal)
     self.otpTFT.placeholder = otpTFTStr
     
     
     } else { //Means user from outsider country
     
     let willSendYourNoLblStr = L102Language.isCurrentLanguageArabic() ? "تم ارسال رمز التأكيد الى بريدك الإلكتروني" : "An code has been send to your registered email"
     
     let resendButtonStr = L102Language.isCurrentLanguageArabic() ? "إعادة إرسال رمز التأكيد" : "Resend code"
     
     let otpTFTStr = L102Language.isCurrentLanguageArabic() ? "إدخال رمز التأكيد" : "Enter code"
     
     //4 Fill
     self.willSendYourNoLbl.text = willSendYourNoLblStr
     self.resendButton.setTitle(resendButtonStr, for: .normal)
     self.otpTFT.placeholder = otpTFTStr
     }
     
     
     }
     */
    
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func finishButtonAction(_ sender: Any) {
        
        let otpStr = otpTFT.text ?? ""
        
        if !otpStr.isEmpty {
            
            let urlString = verifyOTP
            
            var params = [String : Any]()
            
            if whereFromI == "editprofile" {
                
                params = ["OTP" : otpTFT.text ?? "",
                          "tempID" : tempUserID,
                          "StudentID" : studentIdGlobal ?? 0,
                          "Action" : whereFromI] as [String : Any]
                
            } else {
                
                params = ["OTP" : otpTFT.text ?? "",
                          "tempID" : tempUserID] as [String : Any]
            }
            
            
            
            ServiceManager().postRequest(urlString, loader: true, parameters: params) { (status, jsonResponse) in
                
                if status {
                    
                    if self.whereFromI == "editprofile" {
                        
                        phoneNoGlobal = self.mobileNo
                        self.backButtonAction(self)
                        
                    } else {
                        
                        //let otpResponse = JSON.init(jsonResponse ?? "NO DTA")
                        
                        if let vc = WelcomeUserViewController.instantiate(fromAppStoryboard: .main) {
                            vc.modalPresentationStyle = .fullScreen
                            
                            vc.tempId = self.tempUserID
                            vc.selectedClassId = self.classID
                            vc.isByPassed = self.isByPassed
                            vc.countryISOCodeWelcomeObject = self.countryISOCodeOTPObj
                            self.present(vc, animated: true, completion: nil)
                        }
                        
                        
                        
                    }
                    
                }
                
            }
        }
        
    }
    
    
    @IBAction func resendButtonAction(_ sender: Any) {
        
        self.didResendOTPRefillNow()
        self.sendReuqstForOTP()
    }
    
    
    
    func sendReuqstForOTP() {
        
        let urlString = requestOTP
        
        var params = [String : Any]()
        
        if whereFromI == "editprofile" {
            
            params = ["ClassID" : classID,
                      "tempID" : tempUserID,
                      "StudentID" : studentIdGlobal ?? 0,
                      "MobileNo" : mobileNo,
                      "Action" : whereFromI]
            
        } else {
            
            params = ["ClassID" : classID,
                      "tempID" : tempUserID]
        }
        
        ServiceManager().postRequest(urlString, loader: true, parameters: params) { (status, jsonResponse) in
            
            if status {
                
                //let dataRes = JSON.init(jsonResponse!)
                
                //self.configureViewForKuwaitOrNot(isNonKuwait: dataRes["IsNonKuwait"].boolValue)
                
            }
            
        }
    }
    
}





//MARK:==========================================
//MARK: RESEND OTP SET UP
//MARK:==========================================

extension OTPViewController {
    
    // Timer Method...
     @objc func updateTime() {
        if(count > 0) {
            //let minutes = String(count / 60)
            let seconds = String(count % 60)
            countDownLabel.text = seconds
            count = count - 1
            //print("Timer Alived")
        } else {
            countdownTimer.invalidate()
            countDownLabel.text = ""
            print("Timer Killed")
            self.resendButton.isEnabled = true
            self.resendButton.alpha = 1.0
        }
     }
    
    
    func setupResendButtonNow() {
        //Call Timer on screen apprearing....for 60 sec
        self.countDownLabel.text = ""
        self.countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateTime), userInfo: nil, repeats: true)
        self.resendButton.isEnabled = false
        self.resendButton.alpha = 0.4
    }
    
    func didResendOTPRefillNow() {
        //Call Timer on screen apprearing....for 60 sec
        self.countDownLabel.text = ""
        count = 60
        self.countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateTime), userInfo: nil, repeats: true)
        self.resendButton.isEnabled = false
        self.resendButton.alpha = 0.4
    }
}


