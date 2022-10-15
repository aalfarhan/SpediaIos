//
//  NewLiveClassViewController.swift
//  Spedia
//
//  Created by Viraj Sharma on 11/02/22.
//  Copyright © 2022 Viraj Sharma. All rights reserved.
//

import UIKit
import SwiftyJSON

class NewLiveClassViewController: UIViewController, TopGadientViewDelegate {
    
    //0
    func leftRightButtonDidTapped(tagValue: Int) {
        print("leftRightButtonDidTapped---> \(tagValue)")
        
        if isFirstTimeLoad == false {
            if tagValue == 1 {
                
                whichLiveClassPageIndexGlobal = 1
                self.dataJson = self.mainDataJson["LiveclassCategorys"]
                
            } else {
                
                whichLiveClassPageIndexGlobal = 2
                self.dataJson = self.mainDataJson["ReserveList"]
                
            }
            
            self.reloadTableNow()
            
        }
    }

    
    
    //MARK: 1). Outlet's, Object's And Data Model
    //1.1
    @IBOutlet weak var listView: UITableView!

    var topGadientViewObj = TopGadientView()
    var mainDataJson = JSON()
    var dataJson = JSON()
    var whereFrom = ""
    var isFirstTimeLoad = true
    
    
    //MARK: 2). ViewLifeCycles
    
    //2.1
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerTableViewCell()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.callApiFromNotificaitonMethod(notification:)), name: Notification.Name("liveClassNotificationIdentifier"), object: nil)
        
        //MARK:Adjust Event Set 104 Live Class :NEW
        GlobalFunctions.object.setAdjustEvent(eventName: "p7t7d0")
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: Notification.Name("liveClassNotificationIdentifier"), object: nil)
    
    }
    
    @objc func callApiFromNotificaitonMethod(notification: Notification) {
        self.isFirstTimeLoad = true
        self.callApiNow()
    }
    
    
    //2.2
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setUpViewWillAppear()
    }
    
    
    //2.3
    private func setUpViewWillAppear() {
        
        //0
        //self.isFirstTimeLoad = true
        
        //1
        self.listView.isHidden = true
        
        //3
        self.callApiNow()
        
        //2 Header View Set
        //DispatchQueue.main.asyncAfter(deadline: .now() + 0.33) {
            
        //}
        
        
    }

    
    func topHeaderViewSetup() {
        self.topGadientViewObj.frame = self.view.frame
        self.view.addSubview(self.topGadientViewObj)
        self.view.sendSubviewToBack(self.topGadientViewObj)
        self.topGadientViewObj.delegateObj = self
        self.topGadientViewObj.isForLiveClassHeader()
        self.topGadientViewObj.noDataView.isHidden = true
        self.topGadientViewObj.refreshButtonHeight.constant = 40.0
    }
    
    
    //2.4
    func registerTableViewCell() {
        
        //1
        //Left Side Table View
        self.listView.register(UINib(nibName : "IntroVideoTCell", bundle: nil), forCellReuseIdentifier: "introVideoTCell")
        
        self.listView.register(UINib(nibName : "NewActiveClassTCell", bundle: nil), forCellReuseIdentifier: "newActiveClassTCell")
        
        //2
        //Right Side Table View
        
        //Section View
        self.listView.register(UINib(nibName : "NewReservedClassesTCell", bundle: nil), forCellReuseIdentifier: "newReservedClassesTCell")
        
        //Table Row View
        self.listView.register(UINib(nibName : "ReservedSubListTCell", bundle: nil), forCellReuseIdentifier: "reservedSubListTCell")
        
        //Section Footer View
        self.listView.register(UINib(nibName : "ReadMoreFooterTCell", bundle: nil), forCellReuseIdentifier: "readMoreFooterTCell")

        
        self.listView.dataSource = self
        self.listView.delegate = self
        
        self.listView.tableFooterView = nil
        self.listView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: DeviceSize.screenWidth, height: CGFloat.leastNormalMagnitude))
        
    }
    
    
    //2.5
    private func callApiNow() {
        
        let urlString = getLiveClassApi
        let params = ["SessionToken" : sessionTokenGlobal ?? "",
                      "StudentID" : studentIdGlobal ?? 0,
                      "DeviceType" : DeviceType.iPhone] as [String : Any]
        
        ServiceManager().postRequest(urlString, loader: true, parameters: params) { (status, jsonResponse) in
             
            if status {
                
                self.mainDataJson = JSON.init(jsonResponse ?? "NO DTA")
                
                DispatchQueue.main.async {
                    
                    self.topGadientViewObj.headerTitle.text = self.mainDataJson["Heading" + Lang.code()].stringValue
                    
                    self.dataJson = self.mainDataJson["LiveclassCategorys"]
                    
                    //DispatchQueue.main.asyncAfter(deadline: .now() + 0.33) {
                        self.isFirstTimeLoad = false
                        self.reloadTableNow()
                        self.topHeaderViewSetup()
                    //}
                    
                }
                
            }
        }
    
    }

}







//MARK: ======================================================
//MARK: ======================================================
//MARK: UITableView (List View)- Both Left-Right
//MARK: ======================================================
//MARK: ======================================================

extension NewLiveClassViewController : UITableViewDelegate, UITableViewDataSource, NewActiveClassTCellDelegate {
    
    //MARK: ==========================================
    //MARK: 1). Table Section Footer View
    //MARK: ==========================================
    
    //MARK: 1.1
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        if whichLiveClassPageIndexGlobal == 1 {
            return UITableViewCell()
        } else {
            
            let cell = self.listView.dequeueReusableCell(withIdentifier: "readMoreFooterTCell") as? ReadMoreFooterTCell
            
            cell?.selectionStyle = .none
            
            let index = section
            
            let isExpandedBool = self.dataJson[index]["isExpanded"].boolValue
            let isReadMoreBool = self.dataJson[index]["hasMoreButton"].boolValue
            let subListCountValue = self.dataJson[index]["SubList"].count
            
            cell?.configureFooterViewWithData(isExpanded: isExpandedBool, isReadMore: isReadMoreBool, subListCount: subListCountValue)
            
            cell?.readMoreButton.tag = index
            cell?.readMoreButton.addTarget(self, action: #selector(readMoreCellButtonAction(sender:)), for: .touchUpInside)
            
            return cell ?? UITableViewCell()
        }
        
    }

    //MARK: 1.2
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if whichLiveClassPageIndexGlobal == 1 {
            return 0.0
        } else {
            
            let index = section
            let isExpanded = self.dataJson[index]["isExpanded"].boolValue
            //let isReadMore = self.dataJson[index]["hasMoreButton"].boolValue
            let subListCountValue = self.dataJson[index]["SubList"].count
            
            if isExpanded {
                
                if subListCountValue <= 2 {
                    return 20.0
                } else {
                    return 50.0
                }
                
            } else {
                return 0.0
            }
            
        }
    }
    
    
    
    //MARK: ==========================================
    //MARK: 2). Table Section View
    //MARK: ==========================================
    
    //MARK: 2.1
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if whichLiveClassPageIndexGlobal == 1 {
            return 1
        } else {
            return self.dataJson.count
        }
        
    }
    
    //MARK: 2.2
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if whichLiveClassPageIndexGlobal == 1 {
            return 0.0
        } else {
            return 120.0
        }
    }
    
    
    //MARK: 2.3
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if whichLiveClassPageIndexGlobal == 1 {
            return UITableViewCell()
        } else {
            
            let cell = self.listView.dequeueReusableCell(withIdentifier: "newReservedClassesTCell") as? NewReservedClassesTCell
            
            cell?.selectionStyle = .none
            
            let index = section
            
            cell?.configureViewWithData(data: self.dataJson[index])
            
            cell?.expandTCellButton.tag = index
            cell?.expandTCellButton.addTarget(self, action: #selector(expandCellButtonAction(sender:)), for: .touchUpInside)
            
            cell?.notesButton.tag = index
            cell?.notesButton.addTarget(self, action: #selector(downloadButtonAction(sender:)), for: .touchUpInside)
            
            
            return cell ?? UITableViewCell()
        }
    }
    
    
    
    //MARK: ==========================================
    //MARK: 3). Table Row View
    //MARK: ==========================================
    
    //MARK: 3.1
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //Active Classes: 1
        if whichLiveClassPageIndexGlobal == 1 {
           
            return 1 + self.dataJson.count
        
        //Reserved Classes: 2
        } else {
            
            let index = section
            let isExpanded = self.dataJson[index]["isExpanded"].boolValue
            let isReadMore = self.dataJson[index]["hasMoreButton"].boolValue
            let subListCountValue = self.dataJson[index]["SubList"].count
            
            if isExpanded {
                if isReadMore {
                    return subListCountValue
                } else {
                    if subListCountValue <= 2 {
                        return self.dataJson[index]["SubList"].count
                    } else {
                        return 2
                    }
                }
            } else {
                return 2
            }
            
        }
    
    }
    
    
    //MARK: 3.2
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //MARK: Active Classes: 1
        if whichLiveClassPageIndexGlobal == 1 {
            
            if indexPath.row == 0 {
                
                let cell = self.listView.dequeueReusableCell(withIdentifier: "introVideoTCell") as? IntroVideoTCell
                
                cell?.selectionStyle = .none
                let imageUrlObj = self.mainDataJson["HighlightedData"].stringValue
                
                cell?.configureViewWithData(imageUrl: imageUrlObj)
                
                return cell ?? UITableViewCell()
                
            } else {
                
                let cell = self.listView.dequeueReusableCell(withIdentifier: "newActiveClassTCell") as? NewActiveClassTCell
                
                cell?.selectionStyle = .none
                cell?.isOnlyClassNameAndTimeBoolValue = false
                
                let index = indexPath.row - 1
                cell?.dataJson = self.dataJson[index]
                cell?.reloadCellUI()
                
                cell?.delegateObj = self
                
                return cell ?? UITableViewCell()
                
            }
            
            
        //MARK: Reserved Classes: 2
        } else {
            
            let cell = self.listView.dequeueReusableCell(withIdentifier: "reservedSubListTCell") as? ReservedSubListTCell
            
            cell?.selectionStyle = .none
        
            let index = indexPath.section
           
            //0 Last Cell Footer View
            let lastCount = self.dataJson[index]["SubList"].count
            
            //For Read More
            
            if self.dataJson[index]["isExpanded"].boolValue {
                
            }
            
            cell?.configureViewWithData(data: self.dataJson[index]["SubList"][indexPath.row], isLastRow: lastCount == indexPath.row + 1, showReadMore: true)
            
            
            cell?.joinButton.layer.shadowOffset.width = CGFloat(indexPath.section)
            cell?.joinButton.tag = indexPath.row
            cell?.joinButton.addTarget(self, action: #selector(didTapOnJoinButton(sender:)), for: .touchUpInside)
            
            
            return cell ?? UITableViewCell()
        
        }
        
    }
     
    //MARK: 3.3
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if whichLiveClassPageIndexGlobal == 1 {
            return UITableView.automaticDimension
        } else {
            
            let isExpanded = self.dataJson[indexPath.section]["isExpanded"].boolValue
            let isReadMore = self.dataJson[indexPath.section]["hasMoreButton"].boolValue
            
            print("Selection Bool----> \(isExpanded), \(isReadMore)")
            
            if isExpanded {
                if isReadMore {
                    
                    return 70.0
                    
                } else {
                    
                    //let lastCount = self.dataJson[indexPath.section]["SubList"].count
                    //return lastCount == indexPath.row+1 ? 120.0 : 90
                    
                    return 70.0
                    
                }
                
            } else {
                return 0.0
            }
           
        }
        
    }

    
    
    //MARK: ==========================================
    //MARK: 4). Button Action & Delegate's
    //MARK: ==========================================
    
    //MARK: 4.0 Join Button API...
    @objc func didTapOnJoinButton(sender: UIButton) {
    
        let sectionInt = Int(sender.layer.shadowOffset.width)
        let rowInt = sender.tag
        
        let model = self.dataJson[sectionInt]["SubList"][rowInt]
        
        print("\n\nYour Tag is: \(sectionInt)")
        print("\nYour Tag is: \(rowInt)")
        
        let urlString = studentJoined
        let params = ["SessionToken" : sessionTokenGlobal ?? "",
                      "StudentID" : studentIdGlobal ?? 0,
                      "LiveClassDetailID" : model["LiveClassDetailID"].intValue] as [String : Any]
        
        ServiceManager().postRequest(urlString, loader: true, parameters: params) { (status, jsonResponse) in
            
            if status {
                
                //Zoom SDK : 5
                ZoomGlobalMeetingClass.object.isFromLiveClass = true
                ZoomGlobalMeetingClass.object.liveClassIdObj = model["LiveClassDetailID"].intValue
                ZoomGlobalMeetingClass.object.joinMeetingWithData(model: model)
                
            }
        }
    }
    
    
    
    //MARK: 4.0
    //0 Did Tap On Note's Button PDF file View
    @objc func downloadButtonAction(sender: UIButton) {
        if let vc = DocumentViewController.instantiate(fromAppStoryboard: .main) {
          vc.modalPresentationStyle = .fullScreen
          //vc.isCommingFromQuizzWithPdf = isBooks
          vc.pdfString = self.dataJson[sender.tag]["FilePath"].stringValue
          self.present(vc, animated: true, completion: nil)
        }
    }
    
    
    //MARK: 4.1
    //1 Did Tap On Activ Class Cell (Delegate Action)
    func didTapOnCollCell(dataModel: JSON) {
        print("data is-----> \(dataModel)")
        if let vc = LiveClassDetailViewController.instantiate(fromAppStoryboard: .main) {
            //vc.modalPresentationStyle = .overFullScreen
            vc.modalPresentationStyle = .fullScreen
            vc.hidesBottomBarWhenPushed = false
            vc.whereFrom = WhereFromAmIKeys.navigationBottomBar
            vc.classIdObject = dataModel["LiveClassID"].intValue
            vc.isPackageBool = dataModel["IsPackage"].boolValue
            //vc.whereFrom = WhereFromAmIKeys.fromLiveClassPage
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    //MARK: 4.2
    //2 Expand Button Action
    @objc func expandCellButtonAction(sender: UIButton) {
        
        if self.dataJson[sender.tag]["isExpanded"].boolValue == false {
            self.dataJson[sender.tag]["isExpanded"].boolValue = true
        } else {
            self.dataJson[sender.tag]["isExpanded"].boolValue = false
        }
        
        self.reloadTableNow()
    }
    
    
    //MARK: 4.3
    //3 Read More Button Action
    @objc func readMoreCellButtonAction(sender: UIButton) {
        
        if self.dataJson[sender.tag]["hasMoreButton"].boolValue == false {
            self.dataJson[sender.tag]["hasMoreButton"].boolValue = true
        } else {
            self.dataJson[sender.tag]["hasMoreButton"].boolValue = false
        }
        
        self.reloadTableNow()
    }
    
    
    func reloadTableNow() {
        DispatchQueue.main.async {
        if self.dataJson.count == 0 {
            self.listView.isHidden = true
            
            if whichLiveClassPageIndexGlobal == 1 {
                self.topGadientViewObj.noDataLbl.text =  "no_active_data".localized()
            } else {
                self.topGadientViewObj.noDataLbl.text =  "no_reserved_data".localized()
            }
            
            self.topGadientViewObj.noDataView.isHidden = false
            
        } else {
            
            self.listView.isHidden = false
            self.topGadientViewObj.noDataLbl.text = ""
            self.topGadientViewObj.noDataView.isHidden = true
            
        }
        
            DispatchQueue.main.async {
                self.listView.reloadData()
            }
        }
    }

    
}
