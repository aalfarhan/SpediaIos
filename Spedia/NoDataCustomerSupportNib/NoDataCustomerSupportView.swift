//
//  NoDataCustomerSupportView.swift
//  Spedia
//
//  Created by Viraj Sharma on 13/08/2021.
//  Copyright © 2021 Viraj Sharma. All rights reserved.
//

import UIKit
import SwiftyJSON

//protocol NoDataCustomerSupportViewDelegate {
    //func didTapOnCallingButton()
//}


class NoDataCustomerSupportView: UIView {
    
    //0 Delegates...
    //var delegateObj : NoDataCustomerSupportViewDelegate?
    
    //1 Objects...
    @IBOutlet var containerVieww: UIView!
    @IBOutlet var grayColorView: UIView!
    @IBOutlet var topTitleLbl: CustomLabel!
    @IBOutlet var middleSubTitleLbl: CustomLabel!
    @IBOutlet var orLbl: CustomLabel!
    
    @IBOutlet var supportFirstNumberButton: CustomButton!
    @IBOutlet var supportSecondNumberButton: CustomButton!
    
    
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
    
    
    //3
    private func commonInit() {
        
        Bundle.main.loadNibNamed("NoDataCustomerSupportView", owner: self, options: nil)
        addSubview(containerVieww)
        
        self.layer.cornerRadius = 0
        self.clipsToBounds = true
        
        self.containerVieww.frame = self.bounds
        self.containerVieww.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.containerVieww.layer.cornerRadius = 0
        self.containerVieww.clipsToBounds = true
      
        self.grayColorView.clipsToBounds = true
        self.grayColorView.layer.cornerRadius = 10
        self.grayColorView.layer.borderWidth = 1.0
        self.grayColorView.layer.borderColor = Colors.APP_BORDER_GRAY?.cgColor
        
        self.setUpView()
        
    }
    
    
    
    private func setUpView() {
        
        self.topTitleLbl.text = "you_are_not_subs".localized()
        
        self.middleSubTitleLbl.text = "if_you_want_to_subs".localized()
        
        self.orLbl.text = "or_ph".localized()
        
    }
    
    
    @IBAction func firstNumberButtonAction(_ sender: Any) {
        print("firstNumberButtonAction")
        
        if let url = NSURL(string: "tel://\(ContactUs.callSupportNumber)"), UIApplication.shared.canOpenURL(url as URL) {
         UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
        }
        
    }
    
    
    @IBAction func secondNumberButtonAction(_ sender: Any) {
        print("secondNumberButtonAction")
        if let url = NSURL(string: "tel://\(ContactUs.callSupportPhoneNumber)"), UIApplication.shared.canOpenURL(url as URL) {
         UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
        }
    }
    
}



