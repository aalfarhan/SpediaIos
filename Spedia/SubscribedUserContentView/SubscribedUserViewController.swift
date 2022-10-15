//
//  SubscribedUserViewController.swift
//  Spedia
//
//  Created by Viraj Sharma on 20/02/22.
//  Copyright © 2022 Viraj Sharma. All rights reserved.
//

import UIKit
import SwiftyJSON

class SubscribedUserViewController: UIViewController {
    
    //MARK: 1). Outlet's, Object's And Data Model
    //1.1
    @IBOutlet weak var listView: UITableView!
    let topGadientViewObj = TopGadientView()
    var mainDataJson = JSON()
    var subjectIdObj = 0
    var whereFrom = ""
    
    
    //Four Button...
    @IBOutlet weak var videoButton: CustomButton!
    @IBOutlet weak var previousExamButton: CustomButton!
    @IBOutlet weak var answerKeyButton: CustomButton!
    @IBOutlet weak var dairyButton: CustomButton!
    @IBOutlet weak var childsViewContainer: UIView!
    @IBOutlet weak var fourButtonStackView: UIStackView!
    
    //MARK: 2). ViewLifeCycles
    
    //2.1
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK:Adjust Event Set 106 Subscribed Video Page : New
        GlobalFunctions.object.setAdjustEvent(eventName: "4787ju")
        
        
        self.setUpViewDidLoad()
        self.callApiNow()
    }
    
    
    //2.2
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setUpViewWillAppear()
    }
    
    
    //2.3
    private func setUpViewDidLoad() {
        self.registerTableViewCell()
        
        self.listView.isHidden = true
        self.topGadientViewObj.isHidden = true
        self.fourButtonStackView.isHidden = true
        
        //Top Gradient View Setup
        self.topGadientViewObj.frame = self.view.frame
        self.view.addSubview(self.topGadientViewObj)
        self.view.sendSubviewToBack(self.topGadientViewObj)
        self.topGadientViewObj.heightConst.constant = 110
    }
    
    
    //2.4
    private func setUpViewWillAppear() {
        
    }
    
    
    func registerTableViewCell() {
        
        self.listView.register(UINib(nibName : "UnitTCell", bundle: nil), forCellReuseIdentifier: "unitTCell")
        
        self.listView.dataSource = self
        self.listView.delegate = self
        
    }
    
    
    
    //MARK: Four Button Action Colllection: With Tag 1,2,3 & 4
    @IBAction func fourButtonsActionWithTag(_ sender: UIButton) {
        
        //1
        self.videoButton.backgroundColor = .clear
        self.previousExamButton.backgroundColor = .clear
        self.answerKeyButton.backgroundColor = .clear
        self.dairyButton.backgroundColor = .clear
        
        //2
        self.videoButton.setTitleColor(UIColor.white.withAlphaComponent(0.60), for: .normal)
        self.previousExamButton.setTitleColor(UIColor.white.withAlphaComponent(0.60), for: .normal)
        self.answerKeyButton.setTitleColor(UIColor.white.withAlphaComponent(0.60), for: .normal)
        self.dairyButton.setTitleColor(UIColor.white.withAlphaComponent(0.60), for: .normal)
        
        if sender.tag == 1 {
            self.videoButton.backgroundColor = .white
            self.videoButton.setTitleColor(Colors.APP_LIGHT_GREEN, for: .normal)
        } else if sender.tag == 2 {
            self.previousExamButton.backgroundColor = .white
            self.previousExamButton.setTitleColor(Colors.APP_LIGHT_GREEN, for: .normal)
        } else if sender.tag == 3 {
            self.answerKeyButton.backgroundColor = .white
            self.answerKeyButton.setTitleColor(Colors.APP_LIGHT_GREEN, for: .normal)
        } else if sender.tag == 4 {
            self.dairyButton.backgroundColor = .white
            self.dairyButton.setTitleColor(Colors.APP_LIGHT_GREEN, for: .normal)
        }
        
        //3
        self.whichButtonIndexActive(tag: sender.tag)
        
    }
    
    func whichButtonIndexActive(tag: Int) {
        
        if tag == 1 { //Video Button Active
            
            self.childsViewContainer.isHidden = true
            self.listView.isHidden = false
            
        } else if tag == 2 { //Previous Exam
            
            self.childsViewContainer.isHidden = false
            self.listView.isHidden = true
            
            if let vc = BooksAndTestViewController.instantiate(fromAppStoryboard: .main) {
                vc.modalPresentationStyle = .fullScreen
                vc.isBooks = false
                vc.subjectID = self.subjectIdObj
                self.addChildViewNow(vc, inView: self.childsViewContainer)
            }
            
        } else if tag == 3 { //Answer Key
            
            self.childsViewContainer.isHidden = false
            self.listView.isHidden = true
            
            if let vc = BooksAndTestViewController.instantiate(fromAppStoryboard: .main) {
                vc.modalPresentationStyle = .fullScreen
                vc.isBooks = true
                vc.subjectID = self.subjectIdObj
                self.addChildViewNow(vc, inView: self.childsViewContainer)
              
            }
            
        } else {
            
            self.childsViewContainer.isHidden = true
            self.listView.isHidden = true
             
        }
        
    }
    
    
    //2.5
    private func callApiNow() {
        
        let urlString = getUnitsAndSubUnitsApi
        let params = ["SessionToken" : sessionTokenGlobal ?? "",
                      "StudentID" : studentIdGlobal ?? 0,
                      "SubjectID" : self.subjectIdObj,
                      "ClassID" : classIdGlobal ?? ""] as [String : Any]
        
        ServiceManager().postRequest(urlString, loader: true, parameters: params) { (status, jsonResponse) in
            
            if status {
                
                self.mainDataJson = JSON.init(jsonResponse ?? "NO DTA")
                
                DispatchQueue.main.async {
                    
                    self.topGadientViewObj.headerTitle.text = self.mainDataJson["Title" + Lang.code()].stringValue
                    self.topGadientViewObj.isHidden = false
                    self.fourButtonStackView.isHidden = false
                    
                    let noDataBool = self.mainDataJson["ShowNoData"].boolValue
                    DispatchQueue.main.async {
                     self.checkNoDataNow(showNoData: noDataBool)
                    }
                    
                    // set up buttons
                    let videoButtonStr = self.mainDataJson["VideosButtonName" + Lang.code()].stringValue
                    let priviousButtonStr = self.mainDataJson["PreviousExamsButtonName" + Lang.code()].stringValue
                    let answerKeyButtonStr = self.mainDataJson["AnswerKeyButtonName" + Lang.code()].stringValue
                    
                    self.videoButton.setTitle(videoButtonStr, for: .normal)
                    self.previousExamButton.setTitle(priviousButtonStr, for: .normal)
                    self.answerKeyButton.setTitle(answerKeyButtonStr, for: .normal)
                                        
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
            self.listView.isHidden = false
            self.listView.reloadData()
            
        }
    }
    
}


//===========================
//MARK: LIST VIEW
//===========================

extension SubscribedUserViewController : UITableViewDelegate, UITableViewDataSource, UnitTCellDelegate {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.mainDataJson["complexskill"].count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.listView.dequeueReusableCell(withIdentifier: "unitTCell") as? UnitTCell
        
        cell?.selectionStyle = .none
        
        cell?.delegateObj = self
        
        let index = indexPath.row
        
        cell?.dataJson = self.mainDataJson["complexskill"][index]
        cell?.configureViewWithData(data: self.mainDataJson["complexskill"][index], atIndex: index)
        
        cell?.articleTitleLbl.text = self.mainDataJson["ArticleContent" + Lang.code()].stringValue
        
        cell?.expandTabButton.tag = index
        cell?.expandTabButton.addTarget(self, action: #selector(expandCellButtonAction(sender:)), for: .touchUpInside)
        
        //cell?.readMoreButton.tag = index
        //cell?.readMoreButton.addTarget(self, action: #selector(readMoreCellButtonAction(sender:)), for: .touchUpInside)
        
        return cell ?? UITableViewCell()
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
            self.mainDataJson["complexskill"][sender.tag]["ReadMore"].boolValue = false
        }
        
        self.listView.reloadData()
    }
    
    
    @objc func readMoreCellButtonAction(sender: UIButton) {
        
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
        
        let index = indexPath.row
        
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
