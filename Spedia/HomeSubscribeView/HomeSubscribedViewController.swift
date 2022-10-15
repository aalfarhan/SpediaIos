//
//  HomeSubscribedViewController.swift
//  Spedia
//
//  Created by Viraj Sharma on 05/02/22.
//  Copyright © 2022 Viraj Sharma. All rights reserved.
//

import UIKit
import SwiftyJSON

class HomeSubscribedViewController: UIViewController {

    //MARK: 1). Outlet's, Object's And Data Model
    //1.1
    @IBOutlet weak var listView: UITableView!
    var topHeaderLogoViewObj = TopHeaderLogoView()
    var mainDataJson = JSON()
    var whereFrom = ""
    
    //MARK: 2). ViewLifeCycles
    
    //2.1
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpViewDidLoad()
    }
    
    //2.2
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setUpViewWillAppear()
        self.callApiNow()
    }

    //2.3
    private func setUpViewDidLoad() {
        self.registerTableViewCell()
    }
    
    //2.4
    private func setUpViewWillAppear() {
        self.listView.isHidden = true
        self.topHeaderLogoViewObj.frame = self.view.frame
        self.view.addSubview(self.topHeaderLogoViewObj)
        self.view.sendSubviewToBack(self.topHeaderLogoViewObj)
        self.topHeaderLogoViewObj.noDataView.isHidden = true
    }

    //2.41
    func registerTableViewCell() {
        
        self.listView.register(UINib(nibName : "SubscribeSubjectTCell", bundle: nil), forCellReuseIdentifier: "subscribeSubjectTCell")
        
        self.listView.register(UINib(nibName : "MyLiveClassesTCell", bundle: nil), forCellReuseIdentifier: "myLiveClassesTCell")
        
        self.listView.register(UINib(nibName : "PrivateClassTCell", bundle: nil), forCellReuseIdentifier: "privateClassTCell")
        
        self.listView.dataSource = self
        self.listView.delegate = self
        
    }
    
    
    //2.5
    private func callApiNow() {
        
        let urlString = getHomeSubscribedDataApi
        let params = ["SessionToken" : sessionTokenGlobal ?? "",
                      "StudentID" : studentIdGlobal ?? 0,
                      "ClassID" : classIdGlobal ?? "" ,
                      "DeviceType" : DeviceType.iPhone] as [String : Any]
         
        ServiceManager().postRequest(urlString, loader: true, parameters: params) { (status, jsonResponse) in
             
            if status {
                
                self.mainDataJson = JSON.init(jsonResponse ?? "NO DTA")
                let showLiveClass = self.mainDataJson["ShowLiveClasses"].boolValue
                let showPrivateClass = self.mainDataJson["ShowPrivateClasses"].boolValue
                let showSubsSubjects = self.mainDataJson["ShowSubscribedSubjects"].boolValue
                
                DispatchQueue.main.async {
    
                    if !showLiveClass && !showPrivateClass && !showSubsSubjects {
                        
                        self.listView.isHidden = true
                        self.topHeaderLogoViewObj.noDataView.isHidden = false
                        
                    } else {
                        
                        self.listView.isHidden = false
                        self.topHeaderLogoViewObj.noDataView.isHidden = true
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

extension HomeSubscribedViewController : UITableViewDelegate, UITableViewDataSource, SubscribeSubjectTCellDelegate, MyLiveClassesTCellDelegate, PrivateClassTCellDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //var count = 0
        
        //count = self.mainDataJson["SubscribedSubjects"].count > 0 ? count + 1 : count + 0
        
        //count = self.mainDataJson["MyLiveClasses"].count > 0 ? count + 1 : count + 0
        
        return 3
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            
            let cell = self.listView.dequeueReusableCell(withIdentifier: "subscribeSubjectTCell") as? SubscribeSubjectTCell
            cell?.selectionStyle = .none
            
            cell?.delegateObj = self
            cell?.dataJson = self.mainDataJson["SubscribedSubjects"]
            cell?.reloadCellUI()
            
            return cell ?? UITableViewCell()
            
        } else if indexPath.row == 1 {
            
            let cell = self.listView.dequeueReusableCell(withIdentifier: "myLiveClassesTCell") as? MyLiveClassesTCell
            
            cell?.selectionStyle = .none
            cell?.delegateObj = self
            cell?.dataJson = self.mainDataJson["MyLiveClasses"]
            cell?.reloadCellUI()
            
            cell?.showAllButton.addTarget(self, action: #selector(showAllLiveClassButtonAction(sender:)), for: .touchUpInside)
            
            
            return cell ?? UITableViewCell()
            
        } else {
            
            let cell = self.listView.dequeueReusableCell(withIdentifier: "privateClassTCell") as? PrivateClassTCell
            cell?.selectionStyle = .none
            
            cell?.delegateObj = self
            cell?.dataJson = self.mainDataJson["MyPrivateClasses"]
            cell?.reloadCellUI()
            
            cell?.showAllButton.addTarget(self, action: #selector(showAllPrivateClassButtonAction(sender:)), for: .touchUpInside)
            
            
            return cell ?? UITableViewCell()
            
            //return UITableViewCell()
            
        }
        
    }
 
    
    @objc func showAllPrivateClassButtonAction(sender: UIButton) {
    
        whichRPCPageIndexGlobal = 1
        //self.tabBarController?.selectedIndex = 3
        setRootView(tabBarIndex: 3)
    }
    
    
    
    @objc func showAllLiveClassButtonAction(sender: UIButton) {
    
        whichLiveClassPageIndexGlobal = 2
        self.tabBarController?.selectedIndex = 2
    
    }
    
    
    
    //MY PRIVATE CELL ACTION
    func didTapOnJoinButtonPrivateClass(dataModel: JSON) {
        print("\n\nJOIN MEETING FROM PRIVATE CLASS: \(dataModel)\n\n")
        
        let urlString = studentJoined
        let params = ["SessionToken" : sessionTokenGlobal ?? "",
                      "StudentID" : studentIdGlobal ?? 0,
                      "LiveClassDetailID" : dataModel["LiveClassDetailID"].intValue] as [String : Any]
        
        ServiceManager().postRequest(urlString, loader: true, parameters: params) { (status, jsonResponse) in
            
            if status {
                
                //Zoom SDK : 5
                ZoomGlobalMeetingClass.object.isFromLiveClass = true
                ZoomGlobalMeetingClass.object.liveClassIdObj = dataModel["LiveClassDetailID"].intValue
                ZoomGlobalMeetingClass.object.joinMeetingWithData(model: dataModel)
                
            }
        }
        
    }
    
    
    //MY CLASS CELL ACTION
    func didTapOnJoinButton(dataModel: JSON) {
        print("\n\nJOIN MEETING FROM MY CLASS: \(dataModel)\n\n")
        
        let urlString = studentJoined
        let params = ["SessionToken" : sessionTokenGlobal ?? "",
                      "StudentID" : studentIdGlobal ?? 0,
                      "LiveClassDetailID" : dataModel["LiveClassDetailID"].intValue] as [String : Any]
        
        ServiceManager().postRequest(urlString, loader: true, parameters: params) { (status, jsonResponse) in
            
            if status {
                //Zoom SDK : 5
                ZoomGlobalMeetingClass.object.isFromLiveClass = true
                ZoomGlobalMeetingClass.object.liveClassIdObj = dataModel["LiveClassDetailID"].intValue
                ZoomGlobalMeetingClass.object.joinMeetingWithData(model: dataModel)
            } 
        }
    }
    
    
    //MY SUBJECT CELL ACTION
    func didTapOnSubjectCollCell(dataModel: JSON) {
        print("\n\nSubject Select : \(dataModel)\n\n")
        
        if let vc = SubscribedUserViewController.instantiate(fromAppStoryboard: .main) {
            vc.modalPresentationStyle = .fullScreen
            vc.subjectIdObj = dataModel["SubjectID"].intValue
            self.present(vc, animated: true, completion: nil)
        }
        
    }
     
    
    
    @objc func readMoreCellButtonAction(sender: UIButton) {
        
    
    }
    

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let showLiveClass = self.mainDataJson["ShowLiveClasses"].boolValue
        let showPrivateClass = self.mainDataJson["ShowPrivateClasses"].boolValue
        let showSubsSubjects = self.mainDataJson["ShowSubscribedSubjects"].boolValue
        
        if indexPath.row == 0 {
            
            return showSubsSubjects ? UITableView.automaticDimension : 0
            
        } else if indexPath.row == 1 {
            
            return showLiveClass ? UITableView.automaticDimension : 0
            
        } else {
            
            return showPrivateClass ? UITableView.automaticDimension : 0
        }
        
    }

}
