//
//  RecordedDetailViewController.swift
//  Spedia
//
//  Created by Viraj Sharma on 31/01/22.
//  Copyright © 2022 Viraj Sharma. All rights reserved.
//

import UIKit
import SwiftyJSON
import Kingfisher

class RecordedDetailViewController: UIViewController {
    
    //MARK: 1). Outlet's, Object's And Data Model
    //1.1
    @IBOutlet weak var listView: UITableView!
    let topGradientViewObj = TopGadientView()
    var mainDataJson = JSON()
    var subjectIdObj = 0
    var whereFrom = ""
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
        
        self.listView.register(UINib(nibName : "UnitTCell", bundle: nil), forCellReuseIdentifier: "unitTCell")
        
        self.listView.register(UINib(nibName : "ContentDetailTCell", bundle: nil), forCellReuseIdentifier: "contentDetailTCell")
        
        self.listView.dataSource = self
        self.listView.delegate = self
        
    }
    
    //2.5
    private func callApiNow() {
        
        let urlString = getPreRecordedDescriptionApi
        let params = ["SessionToken" : sessionTokenGlobal ?? "",
                      "StudentID" : studentIdGlobal ?? 0,
                      "SubjectID" : self.subjectIdObj,
                      "ClassID" : classIdGlobal ?? "",
                      "DeviceType" : DeviceType.iPhone] as [String : Any]
        
        ServiceManager().postRequest(urlString, loader: true, parameters: params) { (status, jsonResponse) in
             
            if status {
                
                self.mainDataJson = JSON.init(jsonResponse ?? "NO DTA")
                
                if self.mainDataJson["complexskill"].count == 0 {
                    
                    self.listView.isHidden = true
                    self.noDataLbl.text = "no_data_found".localized()
                    
                } else {
                    
                    self.topGradientViewObj.headerTitle.text = self.mainDataJson["SubjectName" + Lang.code()].stringValue
                     
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

extension RecordedDetailViewController : UITableViewDelegate, UITableViewDataSource, UnitTCellDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2 + self.mainDataJson["complexskill"].count + self.mainDataJson["FacultyDetails"].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //0 Last Cell Footer View
        let lastSectionIndex = tableView.numberOfSections - 1
        // last row
        let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
        
        
        // ROW's...
        //First Row
        if indexPath.row == 0 {
            
            let cell = self.listView.dequeueReusableCell(withIdentifier: "imageAndVideoBannerTCell") as? ImageAndVideoBannerTCell
            
            cell?.selectionStyle = .none
            let imageUrlObj = self.mainDataJson["BannerImage"].stringValue
            
            cell?.configureViewWithData(imageUrl: imageUrlObj)
            
            return cell ?? UITableViewCell()
        
        //Second Row
        } else if indexPath.row == 1 {
             
            let cell = self.listView.dequeueReusableCell(withIdentifier: "detailDescriptionTCell") as? DetailDescriptionTCell
            
            cell?.selectionStyle = .none
            
            cell?.configureViewWithData(data: self.mainDataJson)
            
            cell?.subscribeButton.addTarget(self, action: #selector(subscribeCellButtonAction(sender:)), for: .touchUpInside)
            cell?.freeTrailButton.addTarget(self, action: #selector(freeTrailCellButtonAction(sender:)), for: .touchUpInside)
            
            return cell ?? UITableViewCell()
        
            
        //Last Row
        } else if indexPath.row == lastRowIndex && self.mainDataJson["FacultyDetails"].count == 1 {
            
            let cell = self.listView.dequeueReusableCell(withIdentifier: "contentDetailTCell") as? ContentDetailTCell
            
            cell?.selectionStyle = .none
            cell?.isForFacultyMembersView = true
            //let index = indexPath.row - 2
            cell?.configureViewWithData(data: self.mainDataJson["FacultyDetails"][0])
            
            cell?.expandTabButton.tag = 0
            cell?.expandTabButton.addTarget(self, action: #selector(expandFacultyCellButtonAction(sender:)), for: .touchUpInside)
            
            //cell?.readMoreButton.tag = 0
            //cell?.readMoreButton.addTarget(self, action: #selector(readMoreFacultyCellButtonAction(sender:)), for: .touchUpInside)
            
            return cell ?? UITableViewCell()
        
            
        // Other's Row
        } else {
            
            let cell = self.listView.dequeueReusableCell(withIdentifier: "unitTCell") as? UnitTCell
            
            cell?.selectionStyle = .none
            
            cell?.delegateObj = self
            
            let index = indexPath.row - 2
            
            cell?.dataJson = self.mainDataJson["complexskill"][index]
            cell?.configureViewWithData(data: self.mainDataJson["complexskill"][index], atIndex: index)
            
            cell?.articleTitleLbl.text = self.mainDataJson["ArticleContent" + Lang.code()].stringValue
            
            cell?.expandTabButton.tag = index
            cell?.expandTabButton.addTarget(self, action: #selector(expandCellButtonAction(sender:)), for: .touchUpInside)
            
           // cell?.readMoreButton.tag = index
            //cell?.readMoreButton.addTarget(self, action: #selector(readMoreCellButtonAction(sender:)), for: .touchUpInside)
            
            
            return cell ?? UITableViewCell()
        }
    
    }
 
    
    //MARK: Unit Cell Delegate : PLAY BUTTON ACTION
    func didTapOnPlayButton(dataModel: JSON) {
        print("123----",dataModel)
        
        //if let topController = UIApplication.topViewController() {
        if let vc = VideoViewController.instantiate(fromAppStoryboard: .main) {
            vc.modalPresentationStyle = .fullScreen
            vc.subjectId = self.subjectIdObj
            vc.whereFromAmI = WhereFromAmIKeys.preRecoredPage
            vc.subSkillVideoIdStr = "0"
            vc.preRecSubSkillId = dataModel["SubSkillID"].intValue
            vc.unitId = dataModel["UnitID"].intValue
            self.present(vc, animated: true, completion: nil)
        }
        //}
        
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
        
        if let vc = VideoViewController.instantiate(fromAppStoryboard: .main) {
            vc.modalPresentationStyle = .fullScreen
            vc.subjectId = self.mainDataJson["SubjectID"].intValue
            
            //For Load Player Logic and don't pick first video on top "-1" is false/stop
            vc.subSkillVideoIdStr = "0"
            
            vc.unitId = self.mainDataJson["UnitID"].intValue
            
            //For Call new api and back button action
            vc.whereFromAmI = WhereFromAmIKeys.answerDetail
            
            self.present(vc, animated: true, completion: nil)
            
        }
        
    }
    
    
    @objc func expandFacultyCellButtonAction(sender: UIButton) {
        
        //Data Update...
        if self.mainDataJson["FacultyDetails"][sender.tag]["Expand"].boolValue == false {
            self.mainDataJson["FacultyDetails"][sender.tag]["Expand"].boolValue = true
        } else {
            self.mainDataJson["FacultyDetails"][sender.tag]["Expand"].boolValue = false
            self.mainDataJson["FacultyDetails"][sender.tag]["ReadMore"].boolValue = false
        }
        
        self.listView.reloadData()
    }
    
    
    @objc func readMoreFacultyCellButtonAction(sender: UIButton) {
        
        if self.mainDataJson["FacultyDetails"][sender.tag]["ReadMore"].boolValue == false {
            self.mainDataJson["FacultyDetails"][sender.tag]["ReadMore"].boolValue = true
        } else {
            self.mainDataJson["FacultyDetails"][sender.tag]["ReadMore"].boolValue = false
        }
        self.listView.reloadData()
        //listView.beginUpdates()
        //listView.endUpdates()
        
    }
    

    @objc func expandCellButtonAction(sender: UIButton) {
        
        //Data Update...
        if self.mainDataJson["complexskill"][sender.tag]["Expand"].boolValue == false {
            self.mainDataJson["complexskill"][sender.tag]["Expand"].boolValue = true
        } else {
            self.mainDataJson["complexskill"][sender.tag]["Expand"].boolValue = false
            self.mainDataJson["complexskill"][sender.tag]["ReadMore"].boolValue = false
        }
        
        self.listView.reloadData()
    }
    
    
    @objc func readMoreCellButtonAction(sender: UIButton) {
        
        //new
        /*var count = 0
        for _ in self.mainDataJson["complexskill"] {
            self.mainDataJson["complexskill"][count]["ReadMore"].boolValue = false
            count = count + 1
        }
        
        self.mainDataJson["complexskill"][sender.tag]["ReadMore"].boolValue = true
        self.listView.reloadData()*/
        
        
        //...
        if self.mainDataJson["complexskill"][sender.tag]["ReadMore"].boolValue == false {
            self.mainDataJson["complexskill"][sender.tag]["ReadMore"].boolValue = true
        } else {
            self.mainDataJson["complexskill"][sender.tag]["ReadMore"].boolValue = false
        }
        self.listView.reloadData()
        //listView.beginUpdates()
        //listView.endUpdates()
        
    }
    

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        //0 Last Cell Footer View
        let lastSectionIndex = tableView.numberOfSections - 1
        // last row
        let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
        
        
        //First Row...
        if indexPath.row == 0 {
            
            return UITableView.automaticDimension
        
        //Second Row...
        } else if indexPath.row == 1 {
    
            return UITableView.automaticDimension
        
        //Last Row..
        } else if indexPath.row == lastRowIndex && self.mainDataJson["FacultyDetails"].count == 1 {
            
            let index = 0
            let isExpandBool = self.mainDataJson["FacultyDetails"][index]["Expand"].boolValue
            if isExpandBool {
                
                let isReadMore = self.mainDataJson["FacultyDetails"][index]["ReadMore"].boolValue
                if isReadMore {
                  return UITableView.automaticDimension
                } else {
                  return 200
                }
                
            } else {
                return 85
            }
            
        } else {
            
            let index = indexPath.row - 2
            
            let isExpandBool = self.mainDataJson["complexskill"][index]["Expand"].boolValue
            let isReadMore = self.mainDataJson["complexskill"][index]["ReadMore"].boolValue
            let skillCount = self.mainDataJson["complexskill"][index]["SkillCount"].intValue
            let subSkillCount = self.mainDataJson["complexskill"][index]["SubSkillCount"].intValue
            
            //1
            if isExpandBool {
                
                //Note: Per Section Hegith is = 50.0
                let totalSectionsHeight = CGFloat(50 * skillCount)
                
                //Note: Per Row (Play Icons) Hegith is = 50.0
                let totalRowsHeight = CGFloat(50 * subSkillCount)
                
                //Note: 40.0 blue header height + 40.0 read more height = 80.0 + 20.0 (Spc)
                let skillViewHeight = CGFloat(totalSectionsHeight + totalRowsHeight + 90)
                
                //Retune Final Value Now
                return index == 0 ? skillViewHeight + 40 : skillViewHeight
                /*if isReadMore {
                    return index == 0 ? skillViewHeight + 40 : skillViewHeight
                } else {
                    return index == 0 ? totalRowsHeight + 170 : totalRowsHeight + 130
                }*/
                
                
            } else {
            
                if index == 0 {
                    return 50 + 40
                } else {
                    return 50
                }
                
            }
        
        }
        
    }

}



//MARK:================================================
//MARK: Subscribtion Pop Deletegate
//MARK:================================================

extension RecordedDetailViewController: SubscribtionPopUpViewDelegate {
    
    func crossButtonClick() {
        self.subscribtionPopUpObj.removeFromSuperview()
    }

}
