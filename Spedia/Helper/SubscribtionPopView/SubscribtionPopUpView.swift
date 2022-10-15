//
//  SubscribtionPopUpView.swift
//  Spedia
//
//  Created by Viraj Sharma on 04/02/22.
//  Copyright © 2022 Viraj Sharma. All rights reserved.
//

import UIKit
import SwiftyJSON

protocol SubscribtionPopUpViewDelegate {
    func crossButtonClick()
}


class SubscribtionPopUpView: UIView {
    
    //0 Delegates...
    var delegateObj : SubscribtionPopUpViewDelegate?
    
    //1 Objects...
    @IBOutlet var containerVieww: UIView!
    
    @IBOutlet var whiteBoxVieww: UIView!

    @IBOutlet var listView: UITableView!
    @IBOutlet var titleLbl: CustomLabel!
    @IBOutlet var termsButton: CustomButton!
    @IBOutlet var policyButton: CustomButton!
    @IBOutlet var buyNowButton: CustomButton!
    
    @IBOutlet var crossButton: UIButton!
    
    
    var dataJson = JSON()
    
    //Responsive...
    @IBOutlet weak var leftPeddingConst: NSLayoutConstraint!
    @IBOutlet weak var rightPeddingConst: NSLayoutConstraint!
    @IBOutlet weak var listViewHeightConst: NSLayoutConstraint!
    
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
            vc.webPageURLStr = ContactUs.subscriptionsTermsLink
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
                
        Bundle.main.loadNibNamed("SubscribtionPopUpView", owner: self, options: nil)
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

        self.registerTableViewCell()
        
        //Responsive...
        self.leftPeddingConst.constant = UIDevice.isPad ? 200.0 : 20.0
        self.rightPeddingConst.constant = UIDevice.isPad ? 200.0 : 20.0
    
    }
    
    
    func registerTableViewCell() {
        
        self.listView.register(UINib(nibName : "SubscriptionTCell", bundle: nil), forCellReuseIdentifier: "subscriptionTCell")
        self.listView.dataSource = self
        self.listView.delegate = self
    
    }
    
    func reloadDataNow() {
        
        let buttonTitleStr = self.dataJson["SubscribeButton" + Lang.code()].stringValue
        self.buyNowButton.setTitle(buttonTitleStr, for: .normal)
        
        let titleStr = self.dataJson["PricePopupTitle" + Lang.code()].stringValue
        self.titleLbl.text = titleStr
        
        DispatchQueue.main.async {
            self.listView.reloadData()
        }
        
        //
        let rowHeight = L102Language.isCurrentLanguageArabic() ? 130 : 100
        self.listViewHeightConst.constant = CGFloat(rowHeight * self.dataJson["PriceList"].count)
        
    }
    
}




//===========================
//MARK: LIST VIEW
//===========================

extension SubscribtionPopUpView : UITableViewDelegate, UITableViewDataSource {
   
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataJson["PriceList"].count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.listView.dequeueReusableCell(withIdentifier: "subscriptionTCell") as? SubscriptionTCell
        
        cell?.selectionStyle = .none
        
        let index = indexPath.row
        
        cell?.configureViewWithData(dataModel: self.dataJson["PriceList"][index])
        
        cell?.tabCellButton.tag = index
        cell?.tabCellButton.addTarget(self, action: #selector(tabCellButtonAction(sender:)), for: .touchUpInside)
    
        if self.dataJson["PriceList"][index]["IsSelected"].boolValue {
            
            globalProductIdStrIAP = self.dataJson["PriceList"][index]["AppleProductID"].stringValue
            globalSubjectPriceIdIAP = self.dataJson["PriceList"][index]["SubjectPriceID"].intValue
            globalIsPrivateClassTypeIAP = false
            
            print("\n\n\nIAP Data----->\(globalProductIdStrIAP), \(globalSubjectPriceIdIAP) \n\n\n")
        }
        
        return cell ?? UITableViewCell()
        
    }
 
    
    @objc func tabCellButtonAction(sender: UIButton) {
        
        var count = 0
        for _ in self.dataJson["PriceList"] {
            self.dataJson["PriceList"][count]["IsSelected"].boolValue = false
            count = count + 1
        }
        self.dataJson["PriceList"][sender.tag]["IsSelected"].boolValue = true
        
        self.listView.reloadData()
    }
    
   
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return L102Language.isCurrentLanguageArabic() ? 130 : 100
    }

}


