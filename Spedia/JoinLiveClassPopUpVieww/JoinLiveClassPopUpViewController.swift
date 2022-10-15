//
//  JoinLiveClassPopUpViewController.swift
//  Spedia
//
//  Created by Viraj Sharma on 08/07/2021.
//  Copyright © 2021 Viraj Sharma. All rights reserved.
//

import UIKit
import SwiftyJSON

class JoinLiveClassPopUpViewController: UIViewController {

    //1 Outlets.......
    @IBOutlet weak var classBkgImageView: UIImageView!
    @IBOutlet weak var crossButon: UIButton!
    @IBOutlet weak var joinButton: CustomButton!
    @IBOutlet weak var titleLbl: CustomLabel!
    @IBOutlet weak var subTitleLbl: CustomLabel!
    @IBOutlet weak var dateAndTimeLbl: CustomLabel!
    
    
    //2 Data.........
    var dataJson = JSON()
    var meetingId = 0
    
    
    //1
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.isHidden = true
        self.joinButton.isHidden = true
        self.setUpView()
        
        //DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
         self.getClassMeetingDetailNow()
        //}
    }
    
    
    //2
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
   
    
    //3
    func setUpView() {
        self.joinButton.setTitle("join".localized(), for: .normal)
    }
    
    
    
    @IBAction func backButtonAction(_ sender: Any) {
       self.dismiss(animated: true, completion: nil)
       //self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func joinButtonAction(_ sender: Any) {
    
        self.backButtonAction(self)
        
        //Zoom SDK : 4
        ZoomGlobalMeetingClass.object.isFromLiveClass = true
        ZoomGlobalMeetingClass.object.liveClassIdObj = self.meetingId
        ZoomGlobalMeetingClass.object.joinMeetingWithData(model: self.dataJson)
          
    }
    
    
    //4 Call API.....
    
    func getClassMeetingDetailNow() {
        
        let urlString = getMeetingJoinData
        
        let params = ["SessionToken" : sessionTokenGlobal ?? "",
                      "StudentID" : studentIdGlobal ?? 0,
                      "MeetingID": self.meetingId] as [String : Any]
        
        ServiceManager().postRequest(urlString, loader: true, parameters: params) { (status, jsonResponse) in
             
            if status {
                
                let dataRes = JSON.init(jsonResponse ?? "NO DTA")
                
                //0
                self.dataJson = dataRes
                
                self.titleLbl.text = self.dataJson["Title" + Lang.code()].stringValue
                
                self.subTitleLbl.text = self.dataJson["SubTitle" + Lang.code()].stringValue
                
                self.dateAndTimeLbl.text = self.dataJson["MeetingTime" + Lang.code()].stringValue
                
                self.joinButton.isHidden = false
                
            }
            
            self.view.isHidden = false
        }
        
    }

}
