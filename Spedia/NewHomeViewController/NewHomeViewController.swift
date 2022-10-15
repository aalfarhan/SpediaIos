//
//  NewHomeViewController.swift
//  Spedia
//
//  Created by Rahul Sharma on 22/01/22.
//  Copyright © 2022 Viraj Sharma. All rights reserved.
//

import UIKit
import SwiftyJSON
import FirebaseMessaging

class NewHomeViewController: UIViewController {

    //MARK: 1). Outlet's, Object's And Data Model
    @IBOutlet weak var listView: UITableView!
    
    //1.1
    let topHeaderLogoViewObj = TopHeaderLogoView()
    var mainDataJson = JSON()
    
    
    //MARK: 2). ViewLifeCycles
    
    //2.1
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpViewDidLoad()
        self.registerTableViewCell()
    }
    
    //2.2
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setUpViewWillAppear()
    }

    //2.3
    private func setUpViewDidLoad() {
        
    }
    
    
    func registerTableViewCell() {
        
        self.listView.register(UINib(nibName : "AdBannerTableCell", bundle: nil), forCellReuseIdentifier: "adBannerTableCell")
        
        self.listView.register(UINib(nibName : "RequestClassBannerTCell", bundle: nil), forCellReuseIdentifier: "requestClassBannerTCell")
        
        self.listView.register(UINib(nibName : "LiveNowTCell", bundle: nil), forCellReuseIdentifier: "liveNowTCell")
        
        self.listView.register(UINib(nibName : "SubjectNewHomeTCell", bundle: nil), forCellReuseIdentifier: "subjectNewHomeTCell")
        
        self.listView.dataSource = self
        self.listView.delegate = self
        
    }
    
    
    
    //2.4
    private func setUpViewWillAppear() {
        
        if AppShared.object.isFromParentView {
            
            AppShared.object.isFromParentView = false
            if let vc = StatisticsViewController.instantiate(fromAppStoryboard: .main) {
                vc.modalPresentationStyle = .fullScreen
                vc.hidesBottomBarWhenPushed = false
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        } else {
        
            //0
            self.listView.isHidden = true
            
            //1...
            self.topHeaderLogoViewObj.frame = self.view.frame
            self.view.addSubview(self.topHeaderLogoViewObj)
            self.view.sendSubviewToBack(self.topHeaderLogoViewObj)
            self.topHeaderLogoViewObj.noDataView.isHidden = true
            
            //2
            AppShared.object.isVideoOrZoomViewShowing = false
            
            //3
            self.callApiForData()
            
        }
        
    }
 
    
    
    func callApiForData() {
        
        let firebaseToken =  Messaging.messaging().fcmToken ?? ""
        let fcmToken = UserDefaults.standard.value(forKey: "FCM_TOKEN_KEY") as? String ?? firebaseToken
           
        let urlString = getHomeNewDataApi
        let params = ["SessionToken" : sessionTokenGlobal ?? "",
                      "StudentID" : studentIdGlobal ?? 0,
                      "ClassID" : classIdGlobal ?? 0,
                      "FCMToken" : "\(fcmToken)",
                      "DeviceType" : DeviceType.iPhone] as [String : Any]
         
        
        ServiceManager().postRequest(urlString, loader: true, parameters: params) { (status, jsonResponse) in
             
            if status {
                
                self.mainDataJson = JSON.init(jsonResponse ?? "NO DTA")
                
                //MARK: For App Instruction Pop-Up
                if !UserDefaults.standard.bool(forKey: "isInstructionOnHomeFirstTimeKey") {
                    
                    UserDefaults.standard.setValue(true, forKey: "isInstructionOnHomeFirstTimeKey")
                    showCustomInstructionBox(imageJson: self.mainDataJson["InstructionImages"])
                }
                
                
                DispatchQueue.main.async {
                    self.listView.isHidden = false
                    self.listView.reloadData()
                    
                    self.topHeaderLogoViewObj.setupProfileViewNow(imageUrl: self.mainDataJson["ProfilePic"].stringValue, pointsObj: self.mainDataJson["Points"].stringValue)
                }
                
            }
        }
        
        
    }

    func checkForEmptyData() {
        //if self.subjectDataJson.count == 0 {
            //self.listView.isHidden = true
            //self.noDataLbl.text = "no_data_found".localized()
        //} else {
            //self.listView.isHidden = false
          //  self.noDataLbl.text = ""
        //}
        
        //self.listView.isHidden = false
    }
    
}



//===========================
//MARK: LIST VIEW
//===========================

extension NewHomeViewController : UITableViewDelegate, UITableViewDataSource, LiveNowTCellDelegate, SubjectNewHomeTCellDelegate {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.mainDataJson["Items"].count + 2
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            
            let cell = self.listView.dequeueReusableCell(withIdentifier: "adBannerTableCell") as? AdBannerTableCell
            
            cell?.selectionStyle = .none
            
            cell?.dataJson = self.mainDataJson["Advertisements"]
            
            cell?.leftPadding.constant = UIDevice.isPad ? 50.0 : 16.0
            
            cell?.rightPadding.constant = UIDevice.isPad ? 50.0 : 16.0
            
            cell?.reloadCellUI()
            
            
            return cell ?? UITableViewCell()
        
        } else if indexPath.row == 1 {
             
            let cell = self.listView.dequeueReusableCell(withIdentifier: "requestClassBannerTCell") as? RequestClassBannerTCell
            
            cell?.selectionStyle = .none
            
            if self.mainDataJson["PrivateRequest"].count == 1 {
              cell?.configureViewWithData(data: self.mainDataJson["PrivateRequest"][0])
            }
    
            cell?.titleLbl.text = self.mainDataJson["PrivateClassTitle" + Lang.code()].stringValue
            
            cell?.classButton.addTarget(self, action: #selector(requestCellButtonAction(sender:)), for: .touchUpInside)
            
            return cell ?? UITableViewCell()
        
        }  else {
         
            let index = indexPath.row - 2
            
            let type = self.mainDataJson["Items"][index]["Type"].stringValue
            
            if type == "LiveClass" {
                
                let cell = self.listView.dequeueReusableCell(withIdentifier: "liveNowTCell") as? LiveNowTCell
                 
                cell?.selectionStyle = .none
                
                cell?.dataJson = self.mainDataJson["Items"][index]
                cell?.reloadCellUI()
                
                cell?.delegateObj = self
                
                cell?.showAllButton.addTarget(self, action: #selector(liveClassSeeAllButtonAction(sender:)), for: .touchUpInside)
                
                
                return cell ?? UITableViewCell()
           
            } else { //"PreRecorded"
                
                let cell = self.listView.dequeueReusableCell(withIdentifier: "subjectNewHomeTCell") as? SubjectNewHomeTCell
                 
                cell?.selectionStyle = .none
                
                cell?.delegateObj = self
                
                cell?.dataJson = self.mainDataJson["Items"][index]
                cell?.reloadCellUI()
                
                
                cell?.showAllButton.addTarget(self, action: #selector(seeAllCellButtonAction(sender:)), for: .touchUpInside)
                
                
                return cell ?? UITableViewCell()
            }
        }
    
    }
 
    @objc func liveClassSeeAllButtonAction(sender: UIButton) {
    
        whichLiveClassPageIndexGlobal = 1
        self.tabBarController?.selectedIndex = 2
    
    }
    
    @objc func seeAllCellButtonAction(sender: UIButton) {
    
        if let vc = VideoLibraryViewController.instantiate(fromAppStoryboard: .main) {
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
    
    }

    
    @objc func requestCellButtonAction(sender: UIButton) {
        whichRPCPageIndexGlobal =  2
        self.tabBarController?.selectedIndex = 3
    }
    
    
    //Here Live Class Call 323Here
    func didTapOnCollCell(dataModel: JSON) {
    
        if let vc = LiveClassDetailViewController.instantiate(fromAppStoryboard: .main) {
            //vc.modalPresentationStyle = .overFullScreen
            vc.modalPresentationStyle = .fullScreen
            vc.hidesBottomBarWhenPushed = false
            //vc.whereFrom = WhereFromAmIKeys.navigationBottomBar
            vc.classIdObject = dataModel["ID"].intValue
            vc.isPackageBool = dataModel["IsPackage"].boolValue
            vc.whereFrom = WhereFromAmIKeys.navigationBottomBar
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    
    func didTapOnSubjectCollCell(dataModel: JSON) {
    
        if let vc = NewPreRecoredViewController.instantiate(fromAppStoryboard: .main) {
            vc.modalPresentationStyle = .fullScreen
            vc.whereFrom = WhereFromAmIKeys.homeSubscribePage
            //vc.subjectBannerImageUrl = dataModel["CourseImage"].stringValue
            vc.subjectIdObj = dataModel["ID"].intValue
            self.present(vc, animated: true, completion: nil)
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
            
            if self.mainDataJson["Advertisements"].count == 0 {
                
                return 0
                
            } else {
                
                let height = (self.listView.frame.width / 344) * 79
                return height + 30
                
            }
            
        } else if indexPath.row == 1 {
            
            if self.mainDataJson["PrivateRequest"].count == 0 {
                return 0
            } else {
                return UITableView.automaticDimension
            }
            
        } else {
            return UITableView.automaticDimension
        }
        
    }
    

}
