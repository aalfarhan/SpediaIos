//
//  HomeViewController.swift
//  Spedia
//
//  Created by Viraj Sharma on 29/05/2020.
//  Copyright © 2020 Viraj Sharma. All rights reserved.
//

import UIKit
import SwiftyJSON
import SVProgressHUD
import FirebaseMessaging

class HomeViewController: UIViewController {

    @IBOutlet weak var listView: UITableView!
    
    var mainDataJson = JSON()
    var dataJson = JSON()
    var subjectDataJson = JSON()
    var advBannerDataJson = JSON()
    var selectedCategoryNumber = 1
    
    @IBOutlet weak var noDataLbl: UILabel!

    //MARK: 1 Check Resume Payment (Object)
    var paymentPopViewObj = PaymentPopUp()

    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(true, animated: true)
        self.registerTableViewCell()
        //self.loadTableView()
        
        //MARK:--------------------------------------------
        //MARK: 2 Check Resume Payment (SetUp)
        //MARK:--------------------------------------------

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            
            if globalshouldResumePaymentIAP && !isGuestLoginGlobal {
                globalshouldResumePaymentIAP = false
                self.paymentPopViewObj.frame = self.view.frame
                self.paymentPopViewObj.setUpView(withHtmlText: globalResumePaymentMsgIAP)
                self.paymentPopViewObj.isHidden = false
                self.paymentPopViewObj.delegateObj = self
                self.view.addSubview(self.paymentPopViewObj)
            }
        }
        
    }

    
    
    /*
    func isUserRegisterForHomePage() { //Get Method
        
        //Test
        let urlString = "http://livetest.spediaapp.com/WCF/Service.svc/InitializeAp"
        
        let params = ["StudentID" : studentIdGlobal ?? 0] as [String : Any]
        
        ServiceManager().postRequest(urlString, loader: false, parameters: params) { (status, jsonResponse) in
            
            
             if status {
                
                let dataJson = JSON.init(jsonResponse ?? "NO DATA")
                
                AppShared.object. = dataJson[].bool ?? true
                
                //New...
                let baseURL = dataJson["BaseUL"].stringValue
                
                AppShared.object = baseURL
                
                UserDefaults.standard.setValue(AppShared.object, forKey: "BASE_URL_KEY")
                UserDefaults.standard.synchronize()
                
                self.getHomeData()
                 
              } else {
                 
                //show error
                
             }
        }
                
    }
    */
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        if AppShared.object.isFromParentView {
            
            AppShared.object.isFromParentView = false
            if let vc = StatisticsViewController.instantiate(fromAppStoryboard: .main) {
                vc.modalPresentationStyle = .fullScreen
                vc.hidesBottomBarWhenPushed = false
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        } else {
            
            self.listView.isHidden = true
            self.noDataLbl.text = ""
            
            AppShared.object.isVideoOrZoomViewShowing = false
            
            self.getHomeData()
            
        }
        
        
        
        //FIXME: For Debugging with Real Device ONLY
        //DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
        
        //  self.showAlert(alertText: "User Details", alertMessage: "Student ID => \(String(describing: studentIdGlobal)) and Name => \(fullNameGlobal)")
        //}
        
        
        
        //MARK: Only For Test: DND
        //(UIApplication.shared.delegate as! AppDelegate).restrictRotation = .all
        
    }
    
    
    //MARK: Only For Test: DND
    /*
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        super.viewWillTransition(to: size, with: coordinator)
           
        self.view.layoutIfNeeded()
        //self.view.setNeedsUpdateConstraints()
        showRecordingError()
        
    }
    */
    
    
    
    func getHomeData() {
        
        let firebaseToken =  Messaging.messaging().fcmToken ?? ""
        let fcmToken = UserDefaults.standard.value(forKey: "FCM_TOKEN_KEY") as? String ?? firebaseToken
           
        let urlString = getHomeDataApi
        let params = ["SessionToken" : sessionTokenGlobal ?? "",
                      "StudentID" : studentIdGlobal ?? 0,
                      "ClassID" : classIdGlobal ?? 0,
                      "FCMToken" : "\(fcmToken)",
                      "DeviceType" : DeviceType.iPhone] as [String : Any]
         
       
        ServiceManager().postRequest(urlString, loader: true, parameters: params) { (status, jsonResponse) in
             
            if status {
                
                self.mainDataJson = JSON.init(jsonResponse ?? "NO DTA")
                
                self.advBannerDataJson = self.mainDataJson["\(HomeKey.Advertisements)"]
                
                self.dataJson = self.mainDataJson["Category\(self.selectedCategoryNumber)"]
                self.subjectDataJson = self.dataJson["\(HomeKey.Subjects)"]
            
                self.checkForEmptyData()
                
                //self.listView.reloadData()
                
                //MARK: For App Instruction Pop-Up
                //showCustomInstructionBox(imageJson: self.mainDataJson["InstructionImages"])
                
                if !UserDefaults.standard.bool(forKey: "isInstructionOnHomeFirstTimeKey") {
                    
                    UserDefaults.standard.setValue(true, forKey: "isInstructionOnHomeFirstTimeKey")
                    showCustomInstructionBox(imageJson: self.mainDataJson["InstructionImages"])
                }
                
                self.listView.reloadData()
                
                
            
            }
        }
        
        
    }
    
        
    func registerTableViewCell() {
        
        self.listView.register(UINib(nibName : "AdBannerTableCell", bundle: nil), forCellReuseIdentifier: "adBannerTableCell")
        //self.listView.sectionHeaderHeight = UITableView.automaticDimension
        //self.listView.estimatedSectionHeaderHeight = 25;
        
    }
    
    
    /*func loadTableView() {
        self.listView.dataSource = self
        self.listView.delegate = self
    }*/
    
}




extension HomeViewController : UITableViewDelegate, UITableViewDataSource, SubjectTableCellDelegate, HomeHeaderTCellDelegate {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            
            let cell = self.listView.dequeueReusableCell(withIdentifier: "homeHeaderTCell") as? HomeHeaderTCell
            
            cell?.selectionStyle = .none
            
            //let imageUrlStr = self.mainDataJson["ProfilePic"].stringValue
            //cell?.loadProfileImage(imageUrl: imageUrlStr)
            
            //cell?.profileTopButton.setImage(self.profilePic.image, for: .normal)
            
            cell?.delegateObj = self
            
            //cell?.profileButton.addTarget(self, action: #selector(profileButtonAction(sender:)), for: .touchUpInside)
            
            //cell?.lblLevel.text = (L102Language.isCurrentLanguageArabic() ? self.dataJson[HomeKey.LevelAr].stringValue : self.dataJson[HomeKey.LevelEn].stringValue).uppercased()
            
            //Only EN
            //cell?.lblClass.text = self.dataJson[HomeKey.StudentRank].stringValue //only EN
            
            let cateOneStr = L102Language.isCurrentLanguageArabic() ? self.mainDataJson["Category1NameAr"].stringValue : self.mainDataJson["Category1NameEn"].stringValue
            
            let cateTwoStr = L102Language.isCurrentLanguageArabic() ?  self.mainDataJson["Category2NameAr"].stringValue : self.mainDataJson["Category2NameEn"].stringValue
            
            cell?.categoryButtonOne.setTitle(cateOneStr, for: .normal)
            cell?.categoryButtonTwo.setTitle(cateTwoStr, for: .normal)
            
            //cell.delegateObj = self
            
            cell?.reloadBellIcon()
            
            return cell ?? UITableViewCell()
        }
            
        else if indexPath.row == 1 {
            
            let cell = self.listView.dequeueReusableCell(withIdentifier: "adBannerTableCell") as? AdBannerTableCell
            
            cell?.selectionStyle = .none
            cell?.dataJson = self.advBannerDataJson
            //cell.delegateObj = self
            cell?.reloadCellUI()
            //cell?.backgroundColor = .lightGray
            return cell ?? UITableViewCell()
        
        }
            
        else if indexPath.row == 2 {
            
            let cell = self.listView.dequeueReusableCell(withIdentifier: "subjectTableCell") as? SubjectTableCell
            
            cell?.selectionStyle = .none
            cell?.delegateObj = self
            //cell?.buttonTempo.addTarget(self, action: #selector(subjectCellClick(sender:)), for: .touchUpInside)
            
            //cell.delegateObj = self
            //cell.featureModel = featuredList[indexPath.section]
            cell?.configureViewWithData(data: self.subjectDataJson)
            return cell ?? UITableViewCell()
        
        } else {
            
            let cell = self.listView.dequeueReusableCell(withIdentifier: "homeCoursesTCell") as? HomeCoursesTCell
            
            cell?.selectionStyle = .none
            //cell?.configureViewWithData(data: indexPath.row - 2)
            
            cell?.titleLabel.text = L102Language.isCurrentLanguageArabic() ? self.mainDataJson["LiveClassTitleAr"].stringValue : self.mainDataJson["LiveClassTitleEn"].stringValue
            
            cell?.subTitleLabel.text = L102Language.isCurrentLanguageArabic() ? self.mainDataJson["LiveClassSubTitleAr"].stringValue : self.mainDataJson["LiveClassSubTitleEn"].stringValue
            
            cell?.cellTabButton.addTarget(self, action: #selector(viewAllButtonAction(sender:)), for: .touchUpInside)
        
            let buttonTitle = L102Language.isCurrentLanguageArabic() ? self.mainDataJson["ActiveClassCountAr"].stringValue : self.mainDataJson["ActiveClassCountEn"].stringValue
            
            //L102Language.isCurrentLanguageArabic() ? self.dataJson[HomeKey.ActiveClassCount].stringValue + "active_course_count".localized() : "active_course_count".localized() + self.dataJson[HomeKey.ActiveClassCount].stringValue
            
            cell?.activeClassButton.setTitle(buttonTitle, for: .normal)
            
            return cell ?? UITableViewCell()
        }
        
    }
    

    func didTapOnCategoryButton(index : Int) {
        self.selectedCategoryNumber = index
        self.dataJson = self.mainDataJson["Category\(index)"]
        self.subjectDataJson = self.dataJson["\(HomeKey.Subjects)"]
    
        self.checkForEmptyData()
        self.listView.reloadData()
        print("didTapOnCategoryButton---->", index)
        
    }
    
    
    func checkForEmptyData() {
        if self.subjectDataJson.count == 0 {
            //self.listView.isHidden = true
            self.noDataLbl.text = "no_data_found".localized()
        } else {
            //self.listView.isHidden = false
            self.noDataLbl.text = ""
        }
        
        self.listView.isHidden = false
    }
    
    
    //XLR8 - Status Change Action...
    @objc func viewAllButtonAction(sender: UIButton) {
        
        /*if let vc = LiveClassViewController.instantiate(fromAppStoryboard: .main) {
                   vc.modalPresentationStyle = .fullScreen
                   self.present(vc, animated: true, completion: nil)
        }*/
        
        // =  1
        //self.tabBarController?.selectedIndex = 3
        
    }
    
    
    //XLR8 - Status Change Action...
    //@objc func subjectCellClick(sender: UIButton) {
        
        //if let vc = SubjectViewController.instantiate(fromAppStoryboard: .main) {
          //     vc.modalPresentationStyle = .fullScreen
          //     self.present(vc, animated: true, completion: nil)
        //}
    
    //}
    
    
    
    /*@objc func profileButtonAction(sender: UIButton) {
     
        if let vc = ProfileViewController.instanti(fromAppStoryboard: .main) {
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            
        }

    }*/
     
    
    @objc func liveClassButtonAction(sender: UIButton) {
     
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        
    }
    
    
    func didTapOnCell(model: JSON) {
        
        print("\n\nSelected model=====>\n\n", model)
        
        if let vc = SubjectViewController.instantiate(fromAppStoryboard: .main) {
            vc.modalPresentationStyle = .fullScreen
            vc.selectedModel = model
            //vc.hidesBottomBarWhenPushed = false
            self.navigationController?.pushViewController(vc, animated: true)
            //self.present(vc, animated: true, completion: nil)
        }
        
    }
    
    

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
             
            return 170 //UITableView.automaticDimension
        
        } else  if indexPath.row == 1 {
          
            if self.advBannerDataJson.count == 0 {
                
                return 0
                
            } else {
                
                let height = (self.listView.frame.width / 344) * 79
                return height + 20
                
            }
            
             
        } else  if indexPath.row == 2 {
             
            return getCollViewHieght()
        
        } else {
            
            if self.mainDataJson["HideActiveClassBanner"].boolValue {
                return 0
            } else {
                return UIDevice.isPad ? (DeviceSize.screenWidth / 100) * 23.4375 : 180
            }
        }
        
       
    }
    
    
    
    func getCollViewHieght() -> CGFloat { //self.subjectDataJson.count
        
        /*if UIDevice.isPhone {
            let gridPart = 2
            
            let value = Float(self.subjectDataJson.count)
            let count = roundf(value / Float(gridPart))
            var width = self.listView.frame.width
            width = width / CGFloat(gridPart)
            width = round((width) - (width / 3.5))
            
            let totalHeight = Int(width) * Int(count)
            let extraSpce = UIDevice.isPad ? 50 : 10
            
            return CGFloat(totalHeight + extraSpce)
        
        } else {*/
            
            //Step 1). Add 30px in bottom space
            let cellHeight = UIDevice.isPad ? 185 + 30 : 115 + 20
            
            //Step 2).get subject count
            let count = Double(self.subjectDataJson.count) / 2.0
        
            //Step 3). calculated and round off value
            let totalCount = count + 0.5
            
            //Step 4). multiply
            let totalHeight = Int(cellHeight) * Int(totalCount)
            
            //Step 5). final return height
            return CGFloat(totalHeight + 20)
            
        //}
    }


}



//MARK:--------------------------------------------
//MARK: 3 Check Resume Payment (Delegate or Actions)
//MARK:--------------------------------------------

extension HomeViewController: PaymentPopUpDelegate {
    func crossButtonClick() {
        self.paymentPopViewObj.removeFromSuperview()
    }

}
