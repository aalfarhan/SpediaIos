//
//  LiveClassDetailViewController.swift
//  Spedia
//
//  Created by Viraj Sharma on 27/01/22.
//  Copyright © 2022 Viraj Sharma. All rights reserved.
//

import UIKit
import SwiftyJSON
import Kingfisher

class LiveClassDetailViewController: UIViewController {
    
    //MARK: 1). Outlet's, Object's And Data Model
    //1.1
    @IBOutlet weak var listView: UITableView!
    let topGradientViewObj = TopGadientView()
    var mainDataJson = JSON()
    var whereFrom = ""
    var classIdObject = 0
    var isPackageBool = false
    
    @IBOutlet weak var noDataLbl: CustomLabel!
    
    
    //MARK: Subscription Pop-Up View
    var subscribtionPopUpObj = SubscribtionPopUpView()
    
    
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
        self.callApiNow()
        
        
        //Responsive...
        //self.leftPeddingConst.constant = UIDevice.isPad ? 50.0 : 16.0
        //self.rightPeddingConst.constant = UIDevice.isPad ? 50.0 : 16.0
        
    }

    //2.3
    private func setUpViewDidLoad() {
        
    }
    
    
    //2.4
    private func setUpViewWillAppear() {
        
        self.listView.isHidden = true
        
        //Top Gradient View Setup
        self.topGradientViewObj.frame = self.view.frame
        self.view.addSubview(self.topGradientViewObj)
        self.view.sendSubviewToBack(self.topGradientViewObj)
        self.topGradientViewObj.whereFrom = self.whereFrom
        
    }

    func registerTableViewCell() {
        
        self.listView.register(UINib(nibName : "ImageAndVideoBannerTCell", bundle: nil), forCellReuseIdentifier: "imageAndVideoBannerTCell")
        
        self.listView.register(UINib(nibName : "DetailDescriptionTCell", bundle: nil), forCellReuseIdentifier: "detailDescriptionTCell")
        
        self.listView.register(UINib(nibName : "ContentDetailTCell", bundle: nil), forCellReuseIdentifier: "contentDetailTCell")
        
        self.listView.dataSource = self
        self.listView.delegate = self
        
    }
    
    //2.5
    private func callApiNow() {
        
        let urlString = getLiveClassDetailApi
        let params = ["SessionToken" : sessionTokenGlobal ?? "",
                      "StudentID" : studentIdGlobal ?? 0,
                      "LiveClassID" : self.classIdObject,
                      "DeviceType" : DeviceType.iPhone,
                      "IsPackage" : self.isPackageBool] as [String : Any]
         
       
        ServiceManager().postRequest(urlString, loader: true, parameters: params) { (status, jsonResponse) in
             
            if status {
                
                self.mainDataJson = JSON.init(jsonResponse ?? "NO DTA")
                
                if self.mainDataJson["ShowNoData"].boolValue {
                    
                    self.listView.isHidden = true
                    self.noDataLbl.text = "no_data_found".localized()
                    
                } else {
                    
                    self.topGradientViewObj.headerTitle.text = self.mainDataJson["Title"+Lang.code()].stringValue
                    
                    self.noDataLbl.text = ""
                    DispatchQueue.main.async {
                        self.listView.isHidden = false
                        self.listView.reloadData()
                    }
                }
                
            }
        }
        
        
    }

}


//===========================
//MARK: LIST VIEW
//===========================

extension LiveClassDetailViewController : UITableViewDelegate, UITableViewDataSource {
   
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.mainDataJson["Details"].count + 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
             
            let cell = self.listView.dequeueReusableCell(withIdentifier: "detailDescriptionTCell") as? DetailDescriptionTCell
            
            cell?.selectionStyle = .none
            
            cell?.freeHeightConst.constant = 0.0
            
            cell?.configureViewWithData(data: self.mainDataJson)
            
            cell?.subscribeButton.addTarget(self, action: #selector(subscribeCellButtonAction(sender:)), for: .touchUpInside)
            cell?.freeTrailButton.addTarget(self, action: #selector(freeTrailCellButtonAction(sender:)), for: .touchUpInside)
            
            //Only For Testing...
            cell?.featureTableContView.isHidden = true
            
            let imageUrlObj = self.mainDataJson["BannerImage"].stringValue
            cell?.configureBannerViewWithString(imageUrl: imageUrlObj)
            
            return cell ?? UITableViewCell()
        
        }  else {
            
            let cell = self.listView.dequeueReusableCell(withIdentifier: "contentDetailTCell") as? ContentDetailTCell
            
            cell?.selectionStyle = .none
            
            let index = indexPath.row - 1
            
            cell?.isForFacultyMembersView = self.mainDataJson["Details"][index]["isFacultyType"].boolValue
            
            cell?.configureViewWithData(data: self.mainDataJson["Details"][index])
            
            cell?.expandTabButton.tag = index
            cell?.expandTabButton.addTarget(self, action: #selector(expandCellButtonAction(sender:)), for: .touchUpInside)
            
            return cell ?? UITableViewCell()
        }
    
    }
 
    
    @objc func subscribeCellButtonAction(sender: UIButton) {
        
        // IAP 6
        self.subscribtionPopUpObj.frame = self.tabBarController?.view.frame ?? self.view.frame
        self.tabBarController?.view.addSubview(self.subscribtionPopUpObj)
        self.tabBarController?.view.bringSubviewToFront(self.subscribtionPopUpObj)
        
        self.subscribtionPopUpObj.delegateObj = self
        self.subscribtionPopUpObj.dataJson = self.mainDataJson["PriceDetail"]
        self.subscribtionPopUpObj.reloadDataNow()
    
    }
    
    

    @objc func freeTrailCellButtonAction(sender: UIButton) {
     
        /*if let vc = VideoViewController.instantiate(fromAppStoryboard: .main) {
            vc.modalPresentationStyle = .fullScreen
            vc.subjectId = self.mainDataJson["SubjectID"].intValue
            
            //For Load Player Logic and don't pick first video on top "-1" is false/stop
            vc.subSkillVideoIdStr = "0"
            
            vc.unitId = self.mainDataJson["UnitID"].intValue
            
            //For Call new api and back button action
            vc.whereFromAmI = WhereFromAmIKeys.answerDetail
            
            self.present(vc, animated: true, completion: nil)
            
        }*/
        
    }
    
    
    @objc func expandCellButtonAction(sender: UIButton) {
        
        //Data Update...
        if self.mainDataJson["Details"][sender.tag]["Expand"].boolValue == false {
            self.mainDataJson["Details"][sender.tag]["Expand"].boolValue = true
        } else {
            self.mainDataJson["Details"][sender.tag]["Expand"].boolValue = false
        }
        
        DispatchQueue.main.async {
         self.listView.reloadData()
        }
    }
    
    /*
    @objc func readMoreCellButtonAction(sender: UIButton) {
        
        if self.mainDataJson["Details"][sender.tag]["ReadMore"].boolValue == false {
            self.mainDataJson["Details"][sender.tag]["ReadMore"].boolValue = true
        } else {
            self.mainDataJson["Details"][sender.tag]["ReadMore"].boolValue = false
        }
       
        DispatchQueue.main.async {
         self.listView.reloadData()
        }
    }
    */

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
            
            return UITableView.automaticDimension
            
        } else {
            
            let index = indexPath.row - 1
            let isExpandBool = self.mainDataJson["Details"][index]["Expand"].boolValue
            if isExpandBool {
                return UITableView.automaticDimension
            } else {
                return 85
            }
        }
        
    }

}



//MARK:================================================
//MARK: Subscribtion Pop Deletegate
//MARK:================================================

extension LiveClassDetailViewController: SubscribtionPopUpViewDelegate {
    
    func crossButtonClick() {
        self.subscribtionPopUpObj.removeFromSuperview()
    }

}
