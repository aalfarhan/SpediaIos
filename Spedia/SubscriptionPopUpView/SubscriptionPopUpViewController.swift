//
//  SubscriptionPopUpViewController.swift
//  Spedia
//
//  Created by Viraj Sharma on 20/08/2021.
//  Copyright © 2021 Viraj Sharma. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON


class SubscriptionPopUpViewController: UIViewController {

    //1 Outlets.......
    @IBOutlet weak var subscribeBkgImageView: UIImageView!
    @IBOutlet weak var crossButon: UIButton!
    @IBOutlet weak var subscribeButton: CustomButton!
    @IBOutlet weak var titleLbl: CustomLabel!
    @IBOutlet weak var subTitleLbl: CustomLabel!
    @IBOutlet weak var commentsLbl: CustomLabel!
    
    
    //2 Data.........
    var dataJson = JSON()
    var reminderIdObje = 1
    
    
    //1
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    //2
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.subscribeButton.isHidden = true
        self.setUpView()
        self.fillDataNow()
    }
   
    
    func fillDataNow() {
        
        self.titleLbl.text = self.dataJson["Title" + Lang.code()].stringValue
        
        self.subTitleLbl.text = self.dataJson["SubTitle" + Lang.code()].stringValue
        
        self.commentsLbl.text = self.dataJson["Comment" + Lang.code()].stringValue
        
        self.subscribeButton.isHidden = false
    }
    
    
    //3
    func setUpView() {
        
        self.subscribeButton.setTitle("subscribe_ph".localized(), for: .normal)

    }
    
    
    
    @IBAction func backButtonAction(_ sender: Any) {
       self.dismiss(animated: true, completion: nil)
       //self.navigationController?.popViewController(animated: true)
    }
    
    
    
    @IBAction func subscribeButtonAction(_ sender: Any) {
        
        self.addToCartExpirySubjectNow()
        
    }
    
    
    
    
    
    
    
    //MARK: ADD TO CART (Note: Diffrenct API Calling Here
    
    func addToCartExpirySubjectNow() {
        
        let urlString = expiryReminderAddToCart
        
        let params = ["SessionToken" : sessionTokenGlobal ?? "",
                      "StudentID" : studentIdGlobal ?? 0,
                      "ReminderID": self.reminderIdObje] as [String : Any]
        
        ServiceManager().postRequest(urlString, loader: true, parameters: params) { (status, jsonResponse) in
             
            if status {
                
                //let dataRes = JSON.init(jsonResponse ?? "NO DTA")
                
                self.backButtonAction(self)
                
            }
        }
        
    }
}
