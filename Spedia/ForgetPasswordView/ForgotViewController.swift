//
//  ForgotViewController.swift
//  Spedia
//
//  Created by Viraj Sharma on 17/08/2020.
//  Copyright © 2020 Viraj Sharma. All rights reserved.
//

import UIKit

class ForgotViewController: UIViewController {

    @IBOutlet weak var titelLbl: CustomLabel!
    @IBOutlet weak var subTitleLbl: CustomLabel!
    @IBOutlet weak var contactCustomerLbl: CustomLabel!
    @IBOutlet weak var usernameTFT: CustomTFT!
    @IBOutlet weak var submitButton: CustomButton!
    @IBOutlet weak var backButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
     super.viewWillAppear(animated)
     self.setupView()
    }
    
    
    func setupView() {
      
        //1
        self.backButton.imageView?.transform =  L102Language.isCurrentLanguageArabic() ? CGAffineTransform(scaleX: -1.0, y: 1.0) : CGAffineTransform(scaleX: 1.0, y: -1.0)
        //2
        self.titelLbl.text = "forgot_password".localized()
        
        //3
        self.subTitleLbl.text = "valid_username".localized()
        
        //4
        self.contactCustomerLbl.text = "if_dont_rember_contact".localized()
        
        //5
        self.submitButton.setTitle("submitForgot".localized(), for: .normal)
        
        //6
        self.usernameTFT.placeholder = "username".localized()
        
    }
    
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
     
    
    
    @IBAction func submitButtonAction(_ sender: Any) {
        
        let otpStr = usernameTFT.text ?? ""
        
        if !otpStr.isEmpty {
            
        let urlString = forgotPassword
            
        let params = ["username" : usernameTFT.text ?? ""] as [String : Any]
            
            ServiceManager().postRequest(urlString, loader: true, parameters: params) { (status, jsonResponse) in
                 
                if status {
                    
                    self.alertWithAction(withTitle: "forgot_password_reset_sent", yesButton: "login_now", noButton: "", from : "forgotView", fromVc: self)
                    
                  }
                    
                }
        }
           
    }
    
    
    @IBAction func customerSupportAction(sender: UIButton) {
        
        if sender.tag == 1 {
            
            self.tryToOpenAppFirst(urlWhats: SocailLink.whatsappLink, type: "What's App")
        
        } else if sender.tag == 2 {
            
             if let url = NSURL(string: "tel://\(ContactUs.callSupportNumber)"), UIApplication.shared.canOpenURL(url as URL) {
                    UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
             }
            
        } else {
            
        }
        
    }
    
    
    
    //1
    func tryToOpenAppFirst(urlWhats : String, type : String) {
       
        var characterSet = CharacterSet.urlQueryAllowed
        characterSet.insert(charactersIn: "?&")
        if let urlString = urlWhats.addingPercentEncoding(withAllowedCharacters: characterSet) {
               if let whatsappURL = NSURL(string: urlString) {
                
                if UIApplication.shared.canOpenURL(whatsappURL as URL) {
                        UIApplication.shared.open(whatsappURL as URL, options: [:], completionHandler: nil)
                } else {
                    self.openSocialMediaLink(link: urlWhats, title: type)
                 }
            }
        }
        
    }
    

    //2
    func openSocialMediaLink( link : String, title : String) {
        if let vc = TermsAndPolicyViewController.instantiate(fromAppStoryboard: .main) {
          vc.modalPresentationStyle = .fullScreen
          vc.webPageURLStr = link
          vc.titleStr = title
          self.present(vc, animated: true, completion: nil)
        }
    }
    
}
