//
//  UniversityViewController.swift
//  Spedia
//
//  Created by Viraj Sharma on 10/06/2021.
//  Copyright © 2021 Viraj Sharma. All rights reserved.
//

import UIKit
import SwiftyJSON
import Kingfisher
import SVProgressHUD
import FirebaseMessaging

class UniversityViewController: UIViewController {
    
    
    //MARK: 1 Check Resume Payment (Object)
    var paymentPopViewObj = PaymentPopUp()

    
    //1 Outlets.......
    
    //1.1 HeaderView
    @IBOutlet weak var headerTitleLbl: CustomLabel!
    @IBOutlet weak var headerSubTitleLbl: CustomLabel!
    @IBOutlet weak var headerUniversityIcon: UIImageView!
    
    //@IBOutlet weak var supportIconButton: SupportButton!
    
    
    //1.2 SearchBox View
    @IBOutlet weak var searchBoxViewHeightConst: NSLayoutConstraint!
    @IBOutlet weak var selectedFacultyLabel: CustomLabel!
    @IBOutlet weak var searchHistoryCollViewHeightConst: NSLayoutConstraint!
    @IBOutlet weak var searchHistoryCollView: UICollectionView!
    @IBOutlet weak var selectFacultyButton: UIButton!
    
    
    //1.3 Subject View
    @IBOutlet weak var subjectsCollView: UICollectionView!
    
    
    //1.4 Faculty Picker
    @IBOutlet weak var facultyContainerVieww: UIView!
    @IBOutlet weak var facultyPicker: SearchCountryView!
    var facultyListData = JSON()
    var selectedFacultyIdInt = 0
    
    
    //@IBOutlet weak var topThreeCollView: UICollectionView!
    //@IBOutlet weak var collView: UICollectionView!
    
    
    //No Data
    //@IBOutlet weak var noDataLbl: CustomLabel!
    
    
    //1.1 Constratins For Responsive
    //@IBOutlet weak var collViewHeightConts: NSLayoutConstraint!
    
    
    //2 Data.........
    var mainJson = JSON()
    var dataJson = JSON()
    var names:[String] = UserDefaults.standard.object(forKey: "myKey") as? [String] ?? []
    
    
   
        
    
    //1
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //1 History CollView
        let historyCellNib = UINib(nibName: "SearchHistoryCollCell", bundle:nil)
        self.searchHistoryCollView.register(historyCellNib, forCellWithReuseIdentifier: "searchHistoryCollCell")
        self.searchHistoryCollView.dataSource = self
        self.searchHistoryCollView.delegate = self
        
        
        //2 Subject CollView
        let subjectCellNib = UINib(nibName: "UniversitySubjectCollCell", bundle:nil)
        self.subjectsCollView.register(subjectCellNib, forCellWithReuseIdentifier: "universitySubjectCollCell")
        self.subjectsCollView.dataSource = self
        self.subjectsCollView.delegate = self
        
        
        //3
        self.facultyPicker.delegateObj = self
        self.selectedFacultyLabel.text = "faculty_search_here_ph".localized()
        
        
        
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
    
    
    
    //2
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
            
        self.setUpView()
        
        //let bellButton = BellIconButton()
        //bellButton.setBagesLabel(isShowing: true)
        //self.view.setNeedsLayout()
        
        //let button = BellIconButton()
        
        //self.bellContainerView.addSubview(button)
        
        //self.bellIconButton.setBagesLabel(isShowing: true)
        //self.view.setNeedsLayout()
        
        self.getUniversityDataHomeNow()
        
        self.searchBoxViewHeightConst.constant = names.count == 0 ? 90 : 142
        
        }
        
    }
   
    
    //3
    func setUpView() {
        
        //0
        //self.collView.isHidden = true
        //self.topThreeCollView.isHidden = true
        //self.noDataLbl.text = ""
        
        //1
        //self.headerTitleLbl.text = "Harvard Univ."
        //self.headerSubTitleLbl.text = "Master of Information Technology"
        
        //self.collViewHeightConts.constant = L102Language.isCurrentLanguageArabic() ? 210 : 190
        
        //Bell ICON
        //self.bellIconButton.updateBellCount(color: Colors.TAB_TINT_ORANGE ?? .cyan)
   
    }
    
    
    //4 Call API.....
    
    func getUniversityDataHomeNow() {
        
        let firebaseToken =  Messaging.messaging().fcmToken ?? ""
        let fcmToken = UserDefaults.standard.value(forKey: "FCM_TOKEN_KEY") as? String ?? firebaseToken
        
        let urlString = getUniversityHome
        let params = ["SessionToken" : sessionTokenGlobal ?? "",
                      "StudentID" : studentIdGlobal ?? 0,
                      "ClassID": classIdGlobal ?? "",
                      "DeviceType": DeviceType.iPhone,
                      "FCMToken": fcmToken,
                      "FacultyID": self.selectedFacultyIdInt] as [String : Any]
        
        
        ServiceManager().postRequest(urlString, loader: true, parameters: params) { (status, jsonResponse) in
             
            
            if status {
                
                let dataRes = JSON.init(jsonResponse ?? "NO DTA")
                self.mainJson = dataRes
                
                
                //Fill Header Now
                self.headerTitleLbl.text = dataRes["Title" + Lang.code()].stringValue
                self.headerSubTitleLbl.text = dataRes["SubTitle" + Lang.code()].stringValue
                
                let url = URL(string: dataRes["ClassIcon"].stringValue)
                self.headerUniversityIcon.kf.setImage(with: url, placeholder: UIImage(named: "collBkg"))
             
                
                //Init...
                self.dataJson = self.mainJson["Subjects"]
                self.facultyListData = self.mainJson["FacultyList"]
                self.subjectsCollView.reloadData()
                
                
                
            }
        }
        
    }
    
    
    
    
    
    //MARK: Show Select Faculty Pop-Up (Button Action)
    
    @IBAction func selectFacultyButtonAction(_ sender: Any) {
            self.facultyPicker.searchTFT.text = ""
            self.facultyPicker.isFacultyType = true
            self.facultyPicker.topTitleLbl.text = "pick_faculty".localized()
            self.facultyPicker.dataJson = self.facultyListData
            self.facultyPicker.dataJsonCopy = self.facultyListData
            self.facultyPicker.listView.reloadData()
            self.facultyContainerVieww.isHidden = false
    }
    
    
}




//MARK:================================================
//MARK: CollectionView (Coll View)
//MARK:================================================

extension UniversityViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if self.searchHistoryCollView == collectionView {
            return names.count
        } else {
            return self.dataJson.count
        }
        
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if self.searchHistoryCollView == collectionView {
            
            let cell = self.searchHistoryCollView.dequeueReusableCell(withReuseIdentifier: "searchHistoryCollCell", for: indexPath) as? SearchHistoryCollCell

            //cell?.configureCellWithData(data: self.dataJson["Top3List"][0])
            //cell?.reloadCellNow()
            cell?.historyLabel.text = names[indexPath.row]
            cell?.crossButton.tag = indexPath.row //Delete Button Action
            cell?.crossButton.addTarget(self, action: #selector(didTapOnCrossButton(sender:)), for: .touchUpInside)
            
            return cell ?? UICollectionViewCell()
        
            
        } else {
        
            let cell = self.subjectsCollView.dequeueReusableCell(withReuseIdentifier: "universitySubjectCollCell", for: indexPath) as? UniversitySubjectCollCell

            cell?.configureCellWithData(data: self.dataJson[indexPath.row])
            
            cell?.tabButton.tag = indexPath.row
            cell?.tabButton.addTarget(self, action: #selector(didTapOnSubjectUnitCell(sender:)), for: .touchUpInside)
            
            return cell ?? UICollectionViewCell()
        
        }
        
    }
    
    
    @objc func didTapOnCrossButton(sender: UIButton) {
    
        names.remove(at: sender.tag)
        UserDefaults.standard.set(names, forKey: "myKey")
        UserDefaults.standard.synchronize()
        
        self.searchHistoryCollView.reloadData()
        
        self.searchBoxViewHeightConst.constant = names.count == 0 ? 90 : 142
        
        print("didTapOnCrossButton ====> \(sender.tag)")
        
    }
    
    
    @objc func didTapOnSubjectUnitCell(sender: UIButton) {
    
        
        let model = self.dataJson[sender.tag]
        
        print("\n\n DidTapOnSubjectUnitCell \n\n", model)
        
        if let vc = UniversityUnitViewController.instantiate(fromAppStoryboard: .main) {
            vc.modalPresentationStyle = .fullScreen
            vc.selectedModel = model
            vc.hidesBottomBarWhenPushed = false
            self.navigationController?.pushViewController(vc, animated: true)
            //self.present(vc, animated: true, completion: nil)
            
        }
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if self.searchHistoryCollView == collectionView {
            return CGSize(width: 90, height: 40)
        } else {
            let gridPart = CGFloat(UIDevice.isPad ? 3 : 2)
            let spaceBtw = CGFloat(UIDevice.isPad ? 80 : 52)
            
            var witdh = self.subjectsCollView.frame.width - spaceBtw
            witdh = witdh / gridPart
            let height = round(witdh / 1.11)
            
            print("-------->",self.subjectsCollView.frame.width,witdh, height)
            return CGSize(width: witdh, height: height)
        }
    }
    
    

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        if self.searchHistoryCollView == collectionView {
            return 5
        }
        
        return 20 //Top Side
        
    }
      
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        if self.searchHistoryCollView == collectionView {
            return 5
        }
        
        return 14 //Left Side
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if self.searchHistoryCollView == collectionView {
           
            let string = names[indexPath.row]
            //let indexof = self.facultyListData.arrayValue.index(of: string)
            
            let valueKey = "NameEn"
            
            let searchPredicate = NSPredicate(format: "(\(valueKey) contains[c] %@) OR (NameEn contains[c] %@)", string, string)
            
            if let array = self.facultyListData.arrayObject {
                
                var foundItems = JSON(array.filter { searchPredicate.evaluate(with: $0) })
                
                if foundItems.count > 0 {
                    
                    foundItems = foundItems[0]
                    self.selectedFacultyIdInt = foundItems["FacultyID"].intValue
                    
                    let valueKey = L102Language.isCurrentLanguageArabic() ? "NameAr" : "NameEn"
                    
                    self.selectedFacultyLabel.text = foundItems["\(valueKey)"].stringValue
                    
                    self.getUniversityDataHomeNow()
                    
                    print(foundItems)
                }
                
                
            }
            
            //print(string, indexof)
        }
        
    }
    
}



//MARK:================================================
//MARK: Faculty Selection Extension
//MARK:================================================

extension UniversityViewController : SearchCountryViewDelegate {

    func didCountrySelect(countryData : JSON) {
        
        self.selectedFacultyIdInt = countryData["FacultyID"].intValue
        
        let valueKey = L102Language.isCurrentLanguageArabic() ? "NameAr" : "NameEn"
        
        self.selectedFacultyLabel.text = countryData["\(valueKey)"].stringValue
        
        self.facultyContainerVieww.isHidden = true
        
        self.getUniversityDataHomeNow()
       
        
    
        names.append(countryData["\(valueKey)"].stringValue)
        
        names = names.removingDuplicates()
        UserDefaults.standard.set(names, forKey: "myKey")
        
        UserDefaults.standard.synchronize()
        
        print("OLD DATA----->",names)
        
        self.searchHistoryCollView.reloadData()
        
        //AppShared.object.getSetFulcultyDataLocally()
        
        self.searchBoxViewHeightConst.constant = names.count == 0 ? 90 : 142
        
    }

    @IBAction func crossButtonAction(_ sender: Any) {
        self.facultyContainerVieww.isHidden = true
    }

    
    @IBAction func resetButtonAction(_ sender: Any) {
        self.facultyContainerVieww.isHidden = true
        self.selectedFacultyIdInt = 0
        self.selectedFacultyLabel.text = "faculty_search_here_ph".localized()
        self.getUniversityDataHomeNow()
    }
}





extension Array where Element: Hashable {
    func removingDuplicates() -> [Element] {
        var addedDict = [Element: Bool]()

        return filter {
            addedDict.updateValue(true, forKey: $0) == nil
        }
    }

    mutating func removeDuplicates() {
        self = self.removingDuplicates()
    }
}



//MARK:--------------------------------------------
//MARK: 3 Check Resume Payment (Delegate or Actions)
//MARK:--------------------------------------------

extension UniversityViewController: PaymentPopUpDelegate {
    func crossButtonClick() {
        self.paymentPopViewObj.removeFromSuperview()
    }

}
