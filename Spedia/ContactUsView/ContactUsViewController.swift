//
//  ContactUsViewController.swift
//  Spedia
//
//  Created by Viraj Sharma on 17/07/2020.
//  Copyright © 2020 Viraj Sharma. All rights reserved.
//

import UIKit

class ContactUsViewController: UIViewController {

    
    //Header Objects....
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerTitle: CustomLabel!
    @IBOutlet weak var backButton: UIButton!
    
    
    //Placeholders....
    @IBOutlet weak var placeholderOfficeLbl: CustomLabel!
    @IBOutlet weak var placeholderEmailLbl: CustomLabel!
    @IBOutlet weak var placeholderPhoneLbl: CustomLabel!
    
    
    //Contact Object's...
    @IBOutlet weak var officeAddresLbl: CustomLabel!
    @IBOutlet weak var emailLbl: CustomLabel!
    @IBOutlet weak var phoneLbl: CustomLabel!
    @IBOutlet weak var weAreSocailLbl: CustomLabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func backButtonAction(_ sender: Any) {
      //self.dismiss(animated: true, completion: nil)
      self.navigationController?.popViewController(animated: true)

    }
         
       
    override func viewWillAppear(_ animated: Bool) {
        
        //1
        self.backButton.imageView?.transform =  L102Language.isCurrentLanguageArabic() ? CGAffineTransform(scaleX: -1.0, y: 1.0) : CGAffineTransform(scaleX: 1.0, y: -1.0)
        
        //2
        self.headerTitle.text = "contact_us".localized()
        
        //3
        self.placeholderOfficeLbl.text = L102Language.isCurrentLanguageArabic() ? "العنوان" : "Office"
        
        //4
        self.placeholderEmailLbl.text = "email_ph".localized()
        
        //5
        self.placeholderPhoneLbl.text = "phone_ph".localized()
        
        //6
        self.officeAddresLbl.text = L102Language.isCurrentLanguageArabic() ? "خيطان , شارع المطار , مجمع سما , الدور الخامس" : "Khaitan , B9 , St 22 , Sama Mall, Floor No - 5"
        
        //7
        self.weAreSocailLbl.text = "we_are_social".localized()
        
        //8
        self.emailLbl.textAlignment = L102Language.isCurrentLanguageArabic() ? .right : .left
        self.phoneLbl.textAlignment = L102Language.isCurrentLanguageArabic() ? .right : .left
    
    }
    
    
    @IBAction func emailButtonAction(_ sender: Any) {
        
        if let url = NSURL(string: "mailto:\(ContactUs.emailSupprtId)"), UIApplication.shared.canOpenURL(url as URL) {
         UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
        }
    }
    
    
    @IBAction func callButtonAction(_ sender: Any) {
        if let url = NSURL(string: "tel://\(ContactUs.callSupportNumber)"), UIApplication.shared.canOpenURL(url as URL) {
         UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
        }
    }
    
    
    @IBAction func socailMediaLinkButtonsAciton(_ sender: UIButton) {
        
        switch sender.tag {
            
            case 1: //Instagram
              self.tryToOpenAppFirst(urlWhats: SocailLink.instagramLink, type: "Instagram")
            
            case 2: //Twitter
               self.tryToOpenAppFirst(urlWhats: SocailLink.twitterLink, type: "Twitter")
            
            case 3: //YouTube
               self.tryToOpenAppFirst(urlWhats: SocailLink.youtubeLink, type: "YouTube")
                
            case 4: //Snap Chat
               self.tryToOpenAppFirst(urlWhats: SocailLink.snapchatLink, type: "Snap Chat")
            
            case 5: //What's App
                //"whatsapp://send?phone=\(ContactUs.whatsAppNumber)&text="
                self.tryToOpenAppFirst(urlWhats: SocailLink.whatsappLink, type: "What's App")
            
           case 6: //Google Maps
            
            self.tryToOpenAppFirst(urlWhats: SocailLink.googleMapLink, type: "Google Map")
                
            default:
                print("do nothing now!")
               
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
