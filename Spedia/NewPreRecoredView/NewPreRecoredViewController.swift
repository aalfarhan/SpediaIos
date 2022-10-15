//
//  NewPreRecoredViewController.swift
//  Spedia
//
//  Created by Viraj Sharma on 09/08/22.
//  Copyright © 2022 Viraj Sharma. All rights reserved.
//

import UIKit
import SwiftyJSON

class NewPreRecoredViewController: UIViewController, TopFourButtonViewDelegate {
    
    //MARK: 1). Outlet's, Object's And Data Model
    //1.1
    let topGadientViewObj = TopFourButtonView()
    @IBOutlet weak var listView: UITableView!
    @IBOutlet weak var childsViewContainer: UIView!
    var mainDataJson = JSON()
    var subjectIdObj = 0
    var whereFrom = ""
    
    
    //For Live Class Call
    var classIdObjectOnlyLiveClassAPI = 0 //Becoz Global Live Class ID Can't use for this
    var isPackageBool = false
    
    
    //MARK: Subscription Pop-Up View
    var subscribtionPopUpObj = SubscribtionPopUpView()
    
    // Responsive...
    @IBOutlet weak var tableTopConst: NSLayoutConstraint!
    
    //Only For Testing
    /*let featuresDummyData : JSON = JSON.init([["TitleEn":"30 hours of detailed explanations","TitleAr":"Ar 30 hours of detailed explanations", "IconImage":""],
                                              ["TitleEn":"Smart diary", "TitleAr":"Ar 30 hours of detailed explanations", "IconImage":""],
                                              ["TitleEn":"Ask the teacher","TitleAr":"Ar 30 hours of detailed explanations", "IconImage":""],
                                              ["TitleEn":"Review free LIVE quizzes compatible with the Ministry's plan","TitleAr":"Ar 30 hours of detailed explanations", "IconImage":""],
                                              ["TitleEn":"Book solutions and past exams","TitleAr":"Ar 30 hours of detailed explanations", "IconImage":""],
                                              ["TitleEn":"Login using mobile devices and computers","TitleAr":"Ar 30 hours of detailed explanations", "IconImage":""]])*/
    
    //2.1
    override func viewDidLoad() {
        super.viewDidLoad()
        //MARK:Adjust Event Set 106 Subscribed Video Page : New
        GlobalFunctions.object.setAdjustEvent(eventName: "4787ju")
        
        self.listView.isHidden = true
        self.topGadientViewObj.isHidden = true
        
        DispatchQueue.main.async {
         self.callApiNow()
        }
    }
    
    
    //2.2
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.registerTableViewCell()
        self.setUpHeaderView()
    }
    
    
    //2.3
    private func setUpHeaderView() {
        //Top Gradient View Setup
        //self.tableTopConst.constant = UIDevice.isPad ? 110 : 90
        self.topGadientViewObj.frame = self.view.frame
        self.view.addSubview(self.topGadientViewObj)
        self.view.sendSubviewToBack(self.topGadientViewObj)
        self.topGadientViewObj.navigationType = NavigationType.presnetType
        self.topGadientViewObj.delegateObj = self
        if self.whereFrom == WhereFromAmIKeys.fromLiveClassPage {
            self.topGadientViewObj.fourButtonCollViewHeight.constant = 0.0
            self.topGadientViewObj.buttonCollectionView.isHidden = true
            //self.tableTopConst.constant = UIDevice.isPad ? 110 : 80
            //self.topGadientViewObj.layoutIfNeeded()
            //self.view.layoutIfNeeded()
            self.topGadientViewObj.navigationType = NavigationType.navigationType
        }
    }
    
    //2.3.1
    func fourButtonsTappedWithTag(tagValue: Int) {
        print("fourButtonsTappedWithTag---> \(tagValue)")
        self.whichButtonIndexActive(tag: tagValue+1)
    }
    
}



extension NewPreRecoredViewController {
    
    
    func registerTableViewCell() {
        
        self.listView.register(UINib(nibName : "UnitTCell", bundle: nil), forCellReuseIdentifier: "unitTCell")
        
        self.listView.register(UINib(nibName : "DetailDescriptionTCell", bundle: nil), forCellReuseIdentifier: "detailDescriptionTCell")
        
        self.listView.register(UINib(nibName : "FooterDetailTCell", bundle: nil), forCellReuseIdentifier: "footerDetailTCell")
        
        self.listView.dataSource = self
        self.listView.delegate = self
        
        self.listView.estimatedRowHeight = 300
        self.listView.rowHeight = UITableView.automaticDimension
        
    }
    

    func whichButtonIndexActive(tag: Int) {
        
        if tag == 1 { //Video Button
            
            self.childsViewContainer.isHidden = true
            self.listView.isHidden = false
            
        } else if tag == 2 { //Notes
            
            self.childsViewContainer.isHidden = false
            self.listView.isHidden = true
            
            if let vc = BooksAndTestViewController.instantiate(fromAppStoryboard: .main) {
                vc.modalPresentationStyle = .fullScreen
                vc.isBooks = true
                vc.subjectID = self.subjectIdObj
                vc.apiName = getSelectSubjectGuideLine
                self.addChildViewNow(vc, inView: self.childsViewContainer)
              
            }
        
        } else if tag == 4 { //Previous Exam
            
            self.childsViewContainer.isHidden = false
            self.listView.isHidden = true
            
            if let vc = BooksAndTestViewController.instantiate(fromAppStoryboard: .main) {
                vc.modalPresentationStyle = .fullScreen
                vc.isBooks = false
                vc.subjectID = self.subjectIdObj
                vc.apiName = getSelectQuestionPaperArchive
                self.addChildViewNow(vc, inView: self.childsViewContainer)
            }
            
        } else if tag == 3 { //Answer Key
            
            self.childsViewContainer.isHidden = false
            self.listView.isHidden = true
            
            if let vc = BooksAndTestViewController.instantiate(fromAppStoryboard: .main) {
                vc.modalPresentationStyle = .fullScreen
                vc.isBooks = true
                vc.subjectID = self.subjectIdObj
                vc.apiName = getSelectWorkBook
                self.addChildViewNow(vc, inView: self.childsViewContainer)
                
            }
            
        } else {
            
            self.childsViewContainer.isHidden = true
            self.listView.isHidden = true
             
        }
        
    }
    
    
    //2.5
    private func callApiNow() {
        
        var urlString = ""
        var params = [String : Any]()
        
        if self.whereFrom == WhereFromAmIKeys.alreadySubscribedSubject {
            
            urlString = getUnitsAndSubUnitsApi
            params = ["SessionToken" : sessionTokenGlobal ?? "",
                      "StudentID" : studentIdGlobal ?? 0,
                      "SubjectID" : self.subjectIdObj,
                      "ClassID" : classIdGlobal ?? ""] as [String : Any]
            
        } else if self.whereFrom == WhereFromAmIKeys.fromLiveClassPage {
            
            urlString = getLiveClassDetailApi
            params = ["SessionToken" : sessionTokenGlobal ?? "",
                      "StudentID" : studentIdGlobal ?? 0,
                      "LiveClassID" : self.classIdObjectOnlyLiveClassAPI,
                      "DeviceType" : DeviceType.iPhone,
                      "IsPackage" : self.isPackageBool] as [String : Any]
            
        } else {
            urlString = getPreRecordedDescriptionApi
            params = ["SessionToken" : sessionTokenGlobal ?? "",
                      "StudentID" : studentIdGlobal ?? 0,
                      "SubjectID" : self.subjectIdObj,
                      "ClassID" : classIdGlobal ?? ""] as [String : Any]
        }
        
        
        ServiceManager().postRequest(urlString, loader: true, parameters: params) { (status, jsonResponse) in
            
            if status {
                
                self.mainDataJson = JSON.init(jsonResponse ?? "NO DTA")
                
                DispatchQueue.main.async {
                    
                    self.topGadientViewObj.headerTitle.text = self.mainDataJson["Title" + Lang.code()].stringValue
                    self.topGadientViewObj.isHidden = false
                    
                    
                    let noDataBool = self.mainDataJson["ShowNoData"].boolValue
                    DispatchQueue.main.async {
                        self.checkNoDataNow(showNoData: noDataBool)
                    }
                    
                    // set up buttons
                    //let videoButtonStr = self.mainDataJson["VideosButtonName" + Lang.code()].stringValue
                    //let priviousButtonStr = self.mainDataJson["PreviousExamsButtonName" + Lang.code()].stringValue
                    //let answerKeyButtonStr = self.mainDataJson["AnswerKeyButtonName" + Lang.code()].stringValue
                    
                }
                
            }
        }
        
    }
    
    
    func checkNoDataNow(showNoData: Bool) {
        
        if showNoData {
            self.listView.isHidden = true
            self.topGadientViewObj.noDataView.isHidden = false
        } else {
            self.topGadientViewObj.noDataView.isHidden = true
            self.listView.reloadData()
        }
    }
    
    
    private func scrollToTop() {
        let topRow = IndexPath(row: 0,section: 0)
        self.listView.scrollToRow(at: topRow,at: .top,animated: true)
    }
    
}



//===========================
//MARK: LIST VIEW
//===========================

extension NewPreRecoredViewController : UITableViewDelegate, UITableViewDataSource, UnitTCellDelegate, DetailDescriptionTCellDelegate {
    
    func didInnerTableViewReloadDone() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { //DispatchQueue.main.async {
            self.listView.isHidden = false
            self.listView.reloadData()
            //self.listView.layoutIfNeeded()
            //self.view.layoutIfNeeded()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.mainDataJson["complexskill"].count + 2
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //0 Last Cell Footer View
        let lastSectionIndex = tableView.numberOfSections - 1
        // last row
        let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
        
        
        if indexPath.row == 0 {
            
            let cell = self.listView.dequeueReusableCell(withIdentifier: "detailDescriptionTCell") as? DetailDescriptionTCell
            
            cell?.selectionStyle = .none
            cell?.delegateObj = self
            
            cell?.freeHeightConst.constant = 0.0
            
            //1
            let bannerUrl = self.mainDataJson["BannerImage"].stringValue
            cell?.configureBannerViewWithString(imageUrl: bannerUrl)
            
            //2
            cell?.configureFeaturesListWithData(featuresDataModel: self.mainDataJson["NewDescription"])
            
            //3
            cell?.configureViewWithData(data: self.mainDataJson)
            
            cell?.subscribeButton.addTarget(self, action: #selector(subscribeCellButtonAction(sender:)), for: .touchUpInside)
            cell?.freeTrailButton.addTarget(self, action: #selector(freeTrailCellButtonAction(sender:)), for: .touchUpInside)
            
            return cell ?? UITableViewCell()
        
        } else if indexPath.row == lastRowIndex && self.mainDataJson["FacultyDetails"].count == 1 {
    
            let cell = self.listView.dequeueReusableCell(withIdentifier: "footerDetailTCell") as? FooterDetailTCell
            
            cell?.selectionStyle = .none
            
            //let index = indexPath.row - 1
            
            cell?.configureViewWithData(data: self.mainDataJson["FacultyDetails"][0])
            
            cell?.expandTabButton.tag = 0
            cell?.expandTabButton.addTarget(self, action: #selector(footerExpandCellButtonAction(sender:)), for: .touchUpInside)
            
            return cell ?? UITableViewCell()
        
        } else {
            let cell = self.listView.dequeueReusableCell(withIdentifier: "unitTCell") as? UnitTCell
            
            cell?.selectionStyle = .none
            
            cell?.delegateObj = self
            
            let index = indexPath.row - 1
            
            cell?.dataJson = self.mainDataJson["complexskill"][index]
            cell?.configureViewWithData(data: self.mainDataJson["complexskill"][index], atIndex: index)
            
            cell?.articleTitleLbl.text = self.mainDataJson["ArticleContent" + Lang.code()].stringValue
            
            cell?.expandTabButton.tag = index
            cell?.expandTabButton.addTarget(self, action: #selector(expandCellButtonAction(sender:)), for: .touchUpInside)
            
            //cell?.readMoreButton.tag = index
            //cell?.readMoreButton.addTarget(self, action: #selector(readMoreCellButtonAction(sender:)), for: .touchUpInside)
            
            return cell ?? UITableViewCell()
        }
        
        
    }
    
    
    @objc func subscribeCellButtonAction(sender: UIButton) {
        
        // IAP 6
        self.subscribtionPopUpObj.frame = self.view.frame
        self.view.addSubview(self.subscribtionPopUpObj)
        self.view.bringSubviewToFront(self.subscribtionPopUpObj)
        
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
    
    @objc func expandCellButtonAction(sender: UIButton) {
        
        //Data Update...
        if self.mainDataJson["complexskill"][sender.tag]["Expand"].boolValue == false {
            self.mainDataJson["complexskill"][sender.tag]["Expand"].boolValue = true
        } else {
            self.mainDataJson["complexskill"][sender.tag]["Expand"].boolValue = false
        }
        
        self.listView.reloadData()
    }
    
    
    @objc func footerExpandCellButtonAction(sender: UIButton) {
        if self.mainDataJson["FacultyDetails"].count == 1 {
        //Data Update...
        if self.mainDataJson["FacultyDetails"][0]["Expand"].boolValue == false {
            self.mainDataJson["FacultyDetails"][0]["Expand"].boolValue = true
        } else {
            self.mainDataJson["FacultyDetails"][0]["Expand"].boolValue = false
        }
        self.listView.reloadData()
        }
    }
    
    /*@objc func readMoreCellButtonAction(sender: UIButton) {
        
        //...
        if self.mainDataJson["complexskill"][sender.tag]["ReadMore"].boolValue == false {
            self.mainDataJson["complexskill"][sender.tag]["ReadMore"].boolValue = true
        } else {
            self.mainDataJson["complexskill"][sender.tag]["ReadMore"].boolValue = false
        }
        self.listView.reloadData()
        //listView.beginUpdates()
       //listView.endUpdates()
    }*/
    
    /*
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if self.whereFrom == WhereFromAmIKeys.alreadySubscribedSubject {
            if indexPath.row == 0 {
                return 0
            } else {
                return UITableView.automaticDimension
            }
        } else {
           return UITableView.automaticDimension
        }
        
    }*/
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        //0 Last Cell Footer View
        let lastSectionIndex = tableView.numberOfSections - 1
        // last row
        let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
        
        
        if indexPath.row == 0 {
            if self.whereFrom == WhereFromAmIKeys.alreadySubscribedSubject {
                return 0
            } else {
                return UITableView.automaticDimension
            }
        } else if indexPath.row == lastRowIndex {
            if self.mainDataJson["FacultyDetails"].count == 1 {
                if self.mainDataJson["FacultyDetails"][0]["Expand"].boolValue == false {
                    return 60
                } else {
                   return UITableView.automaticDimension
                }
                
            } else {
                return 0
            }
            
        } else {
        
        let index = indexPath.row - 1
        
        let isExpandBool = self.mainDataJson["complexskill"][index]["Expand"].boolValue
        
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
            /*
            if isReadMore {
                return index == 0 ? skillViewHeight + 40 : skillViewHeight
            } else {
                
                return index == 0 ? totalRowsHeight + 170 : totalRowsHeight + 130
            }
            */
            
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

extension NewPreRecoredViewController: SubscribtionPopUpViewDelegate {
    
    func crossButtonClick() {
        self.subscribtionPopUpObj.removeFromSuperview()
    }

}
