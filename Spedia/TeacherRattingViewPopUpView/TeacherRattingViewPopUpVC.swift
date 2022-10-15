//
//  TeacherRattingViewPopUpVC.swift
//  Spedia
//
//  Created by Viraj Sharma on 20/08/2021.
//  Copyright © 2021 Viraj Sharma. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import Cosmos

class TeacherRattingViewPopUpVC: UIViewController {

    //1 Outlets.......
    @IBOutlet weak var whiteBoxView: UIView!
    
    @IBOutlet weak var titleLbl: CustomLabel!
    @IBOutlet weak var subTitleLbl: CustomLabel!
    
    @IBOutlet weak var cancelButton: CustomButton!
    @IBOutlet weak var sendCommentButton: CustomButton!
    
    @IBOutlet weak var rattingView: CosmosView!
    
    
    @IBOutlet weak var commentTextView: UITextView!
    
    var liveClassId = 0
    
    
    //1
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    //2
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setUpView()
        
        //MARK: Ratting View Setup
        rattingView.settings.updateOnTouch = true
        rattingView.settings.fillMode = .full // Other fill modes: .half, .precise
        rattingView.settings.starSize = 25
        rattingView.settings.starMargin = 5
        
   }
   
    
    //3
    func setUpView() {
        
        self.titleLbl.text = "did_you_like_class_ph".localized()
        self.subTitleLbl.text = "let_us_know_what_ph".localized()
    
        self.sendCommentButton.setTitle("send_comment_ph".localized(), for: .normal)
        self.cancelButton.setTitle("cancel_ph".localized(), for: .normal)
 
        
        self.commentTextView.textAlignment = L102Language.isCurrentLanguageArabic() ? .right : .left
        
        
        //self.rattingView.transform = L102Language.isCurrentLanguageArabic() ? CGAffineTransform(scaleX: -1.0, y: 1.0) : CGAffineTransform(scaleX: 1.0, y: -1.0)
        
    }
    
    
    //4
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    
        print("Star Rating changed to---->", rattingView.rating)
    }
    
    
    
    @IBAction func cancelButtonAction(_ sender: Any) {
       self.dismiss(animated: true, completion: nil)
       //self.navigationController?.popViewController(animated: true)
    }
    
    
    
    @IBAction func sendCommentButtonAction(_ sender: Any) {
        
        self.saveLiveClassRatingNow()
        
    }
    
    

    //MARK: Call Rating Api for Give Ended Class Rating Or Teacher Rating
    
    func saveLiveClassRatingNow() {
        
        let urlString = saveLiveClassRating
        
        let params = ["SessionToken" : sessionTokenGlobal ?? "",
                      "StudentID" : studentIdGlobal ?? 0,
                      "LiveClassMeetingID": self.liveClassId,
                      "Rating" : Int(self.rattingView.rating),
                      "Comment" : self.commentTextView.text ?? ""] as [String : Any]
        
    
        ServiceManager().postRequest(urlString, loader: true, parameters: params) { (status, jsonResponse) in
             
            if status {
                
                //let dataRes = JSON.init(jsonResponse ?? "NO DTA")
                
                self.cancelButtonAction(self)
                
            }
        }
        
    }
}

