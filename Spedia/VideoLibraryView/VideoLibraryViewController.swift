//
//  VideoLibraryViewController.swift
//  Spedia
//
//  Created by Viraj Sharma on 16/02/22.
//  Copyright © 2022 Viraj Sharma. All rights reserved.
//

import UIKit
import SwiftyJSON

class VideoLibraryViewController: UIViewController {

    //MARK: 1). Outlet's, Object's And Data Model
    //1.1
    @IBOutlet weak var listView: UITableView!
    var topGadientViewObj = TopGadientView()
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
        self.topGadientViewObj.frame = self.view.frame
        self.view.addSubview(self.topGadientViewObj)
        self.view.sendSubviewToBack(self.topGadientViewObj)
    }

    
    //2.41
    func registerTableViewCell() {
        
        self.listView.register(UINib(nibName : "IntroVideoTCell", bundle: nil), forCellReuseIdentifier: "introVideoTCell")
        
        self.listView.register(UINib(nibName : "LiveNowTCell", bundle: nil), forCellReuseIdentifier: "liveNowTCell")
        
        self.listView.register(UINib(nibName : "SubjectNewHomeTCell", bundle: nil), forCellReuseIdentifier: "subjectNewHomeTCell")
        
        self.listView.dataSource = self
        self.listView.delegate = self
        
    }
    
    
    //2.5
    private func callApiNow() {
        
        let urlString = getVideoLibraryApi
        let params = ["SessionToken" : sessionTokenGlobal ?? "",
                      "StudentID" : studentIdGlobal ?? 0,
                      "ClassID" : classIdGlobal ?? "",
                      "DeviceType" : DeviceType.iPhone] as [String : Any]
         
        ServiceManager().postRequest(urlString, loader: true, parameters: params) { (status, jsonResponse) in
             
            if status {
                
                self.mainDataJson = JSON.init(jsonResponse ?? "NO DTA")
                
                DispatchQueue.main.async {
    
                    self.topGadientViewObj.headerTitle.text = self.mainDataJson["Title" + Lang.code()].stringValue
                    
                    let noDataBool = self.mainDataJson["ShowNoData"].boolValue
                    self.checkNoDataNow(showNoData: noDataBool)
                    
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

extension VideoLibraryViewController : UITableViewDelegate, UITableViewDataSource, LiveNowTCellDelegate, SubjectNewHomeTCellDelegate {
    
    func didTapOnCollCell(dataModel: JSON) {
    
        if let vc = NewPreRecoredViewController.instantiate(fromAppStoryboard: .main) {
            //vc.modalPresentationStyle = .overFullScreen
            vc.modalPresentationStyle = .fullScreen
            vc.hidesBottomBarWhenPushed = false
            //vc.whereFrom = WhereFromAmIKeys.navigationBottomBar
            vc.classIdObjectOnlyLiveClassAPI = dataModel["ID"].intValue
            vc.isPackageBool = dataModel["IsPackage"].boolValue
            vc.whereFrom = WhereFromAmIKeys.fromLiveClassPage
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
    

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.mainDataJson["Items"].count + 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            
            let cell = self.listView.dequeueReusableCell(withIdentifier: "introVideoTCell") as? IntroVideoTCell
            
            cell?.selectionStyle = .none
            let imageUrlObj = self.mainDataJson["HighlightedData"].stringValue
            
            cell?.configureViewWithData(imageUrl: imageUrlObj)
            
            return cell ?? UITableViewCell()
            
        } else {
            
            let index = indexPath.row - 1
            
            let type = self.mainDataJson["Items"][index]["Type"].stringValue
            
            if type == "LiveClass" {
                
                let cell = self.listView.dequeueReusableCell(withIdentifier: "liveNowTCell") as? LiveNowTCell
                 
                cell?.selectionStyle = .none
                
                cell?.dataJson = self.mainDataJson["Items"][index]
                cell?.reloadCellUI()
                
                cell?.delegateObj = self
                cell?.showAllButton.isHidden = true
                //cell?.showAllButton.addTarget(self, action: #selector(liveClassSeeAllButtonAction(sender:)), for: .touchUpInside)
                
                
                return cell ?? UITableViewCell()
           
            } else { //"PreRecorded"
                
                let cell = self.listView.dequeueReusableCell(withIdentifier: "subjectNewHomeTCell") as? SubjectNewHomeTCell
                 
                cell?.selectionStyle = .none
                
                cell?.delegateObj = self
                
                cell?.dataJson = self.mainDataJson["Items"][index]
                cell?.reloadCellUI()
                
                cell?.showAllButton.isHidden = true
                //cell?.showAllButton.addTarget(self, action: #selector(seeAllCellButtonAction(sender:)), for: .touchUpInside)
                
                
                return cell ?? UITableViewCell()
            }
        }
        
    }
    
    
    func didTapOnLibrarySubjectCollCell(dataModel: JSON) {
        
        if let vc = RecordedDetailViewController.instantiate(fromAppStoryboard: .main) {
            //vc.modalPresentationStyle = .overFullScreen
            vc.modalPresentationStyle = .fullScreen
            //vc.hidesBottomBarWhenPushed = false
            //vc.whereFrom = WhereFromAmIKeys.navigationBottomBar
            vc.subjectIdObj = dataModel["SubjectID"].intValue
            self.present(vc, animated: true, completion: nil)
        }
        
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
        
    }

}
