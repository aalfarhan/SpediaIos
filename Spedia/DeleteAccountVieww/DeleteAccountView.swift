//
//  DeleteAccountView.swift
//  Spedia
//
//  Created by Viraj Sharma on 13/09/22.
//  Copyright © 2022 Viraj Sharma. All rights reserved.
//

import UIKit

class DeleteAccountView: UIView {

    //1 Objects...
    @IBOutlet var containerVieww: UIView!
    @IBOutlet var whiteBoxView: UIView!
    @IBOutlet var titleLbl: CustomLabel!
    @IBOutlet var subTitleLbl: CustomLabel!
    @IBOutlet var termsConditionButton: CustomButton!
    @IBOutlet var yesButton: CustomButton!
    @IBOutlet var noButton: CustomButton!
    
    //Responsive..
    @IBOutlet weak var heightConst: NSLayoutConstraint!
    
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
                
        Bundle.main.loadNibNamed("DeleteAccountView", owner: self, options: nil)
        addSubview(containerVieww)
        
        self.layer.cornerRadius = 0
        self.clipsToBounds = true
        
        self.containerVieww.frame = self.bounds
        self.containerVieww.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.containerVieww.layer.cornerRadius = 0
        self.containerVieww.clipsToBounds = true
    
        self.whiteBoxView.clipsToBounds = true
        self.whiteBoxView.layer.cornerRadius = 15.0
        
        //Set Up Done
        self.setUpView()
        
    }
    
    func setUpView() {
        self.termsConditionButton.setTitle("terms_and_condition".localized(), for: .normal)
        self.yesButton.setTitle("YES".localized(), for: .normal)
        self.noButton.setTitle("NO".localized(), for: .normal)
    }
    
    
    @IBAction func yesButtonAction(_ sender: Any) {
        print("yesButtonAction")
        self.callDeleteAccountApi()
    }
    
    @IBAction func noButtonAction(_ sender: Any) {
        print("noButtonAction")
        self.isHidden = true
    }
    
    @IBAction func termsButtonAction(_ sender: Any) {
        if let topController = UIApplication.topViewController() {
            if let vc = TermsAndPolicyViewController.instantiate(fromAppStoryboard: .main) {
                vc.modalPresentationStyle = .fullScreen
                topController.present(vc, animated: true, completion: nil)
            }
        }
    }
    
    func callDeleteAccountApi() {
        
        let urlString = deleteStudentPermenantlyApi
        
        let params = ["SessionToken" : sessionTokenGlobal ?? "",
                      "StudentID" : studentIdGlobal ?? 0] as [String : Any]
        ServiceManager().postRequest(urlString, loader: true, parameters: params) { (status, jsonResponse) in
             
            if status {
                logoutNow()
            }
        }
    }
}
