//
//  PaymentPopUp.swift
//  Kuwait Padel
//
//  Created by Viraj Sharma on 29/09/21.
//


import UIKit
import SwiftyJSON

protocol PaymentPopUpDelegate {
    func crossButtonClick()
}


class PaymentPopUp: UIView, UITextFieldDelegate {
    
    //0 Delegates...
    var delegateObj : PaymentPopUpDelegate?
    
    //1 Objects...
    @IBOutlet var containerVieww: UIView!
    
    @IBOutlet var whiteBoxVieww: UIView!

    @IBOutlet var infoLabel: UILabel!
    
    @IBOutlet var termsButton: CustomButton!
    @IBOutlet var policyButton: CustomButton!
    @IBOutlet var buyNowButton: CustomButton!
    
    @IBOutlet var crossButton: UIButton!
    
    var isRPCPage = false
    
    //1
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    //2
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    
    //2.1
    @IBAction func crossButtonButtonAction(_ sender: Any) {
        
        self.delegateObj?.crossButtonClick()
    }
    
    //2.2
    @IBAction func termsButtonAction(_ sender: Any) {
        if let topController = UIApplication.topViewController() {
            
        if let vc = TermsAndPolicyViewController.instantiate(fromAppStoryboard: .main) {
            vc.modalPresentationStyle = .fullScreen
            vc.webPageURLStr = isRPCPage ? ContactUs.liveClassTermsLink : ContactUs.subscriptionsTermsLink
            topController.present(vc, animated: true, completion: nil)
        }
            
        }
    }
    
    
    //2.3
    @IBAction func policyButtonAction(_ sender: Any) {
        
        if let topController = UIApplication.topViewController() {
            
        if let vc = TermsAndPolicyViewController.instantiate(fromAppStoryboard: .main) {
            vc.modalPresentationStyle = .fullScreen
            vc.webPageURLStr = ContactUs.privacyPolicyCommonLink
            vc.type = "policy"
            topController.present(vc, animated: true, completion: nil)
        }
            
        }
        
    }

    
    //2.4
    @IBAction func buyNowButtonAction(_ sender: Any) {
        
        if isGuestLoginGlobal {
            globalshouldResumePaymentIAP = true
            GlobalFunctions.object.guestCheckPopUp()
        } else {
            globalshouldResumePaymentIAP = false
            GlobalFunctions.object.makeIAPNonAtomicPaymentNow(productIdStr: globalProductIdStrIAP)
        }
        
        self.delegateObj?.crossButtonClick()
        
    }
    
    //3
    private func commonInit() {
                
        Bundle.main.loadNibNamed("PaymentPopUp", owner: self, options: nil)
        addSubview(containerVieww)
        
        self.layer.cornerRadius = 0
        self.clipsToBounds = true
        
        self.containerVieww.frame = self.bounds
        self.containerVieww.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.containerVieww.layer.cornerRadius = 0
        self.containerVieww.clipsToBounds = true
        
        self.whiteBoxVieww.backgroundColor = UIColor.white
        self.whiteBoxVieww.layer.cornerRadius = 20.0
        
        self.termsButton.setTitle("terms_and_condition".localized(), for: .normal)
        self.policyButton.setTitle("privacy_policy".localized(), for: .normal)

        self.buyNowButton.setTitle("buy_now_ph".localized(), for: .normal)
        //terms_and_condition
    }
    
    
    
    func setUpView(withHtmlText: String) {
        
        self.infoLabel.attributedText = withHtmlText.htmlToAttributedString
    }
    

}



