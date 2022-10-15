//
//  ParentChildsViewController.swift
//  Spedia
//  
//  Created by Viraj Sharma on 06/11/2020.
//  Copyright © 2020 Viraj Sharma. All rights reserved.
//

import UIKit

//...
import SwiftyJSON
import Kingfisher


class ParentChildsViewController: UIViewController {
    
    //header object...
    @IBOutlet weak var containerVieww: UIView!
    @IBOutlet weak var headerTitleLbl: CustomLabel!
    @IBOutlet weak var headerSubTitleLbl: CustomLabel!
    @IBOutlet weak var addButton: CustomButton!
    @IBOutlet weak var backButton: UIButton!
    
    //No DATA View...
    @IBOutlet weak var noDataView: UIView!
    @IBOutlet weak var noDataLbl: CustomLabel!

    //...
    @IBOutlet weak var collView: UICollectionView!
    

    //Data Objects....
    var dataJson = JSON()
    var studentJson = JSON()
    var sortJson = JSON()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.registerCells()
        
        //self.isUserRegisterForParentView()
    }
    
    
    /*
    private func isUserRegisterForParentView() { //Get Method
    
        let urlString = "http://livetest.spediaapp.com/WCF/Service.svc/InitializeAp"
        
        let params = ["StudentID" : studentIdGlobal ?? 0] as [String : Any]
        
        ServiceManager().postRequest(urlString, loader: false, parameters: params) { (status, jsonResponse) in
            
            
             if status {
                
                let dataJson = JSON.init(jsonResponse ?? "NO DATA")
                
                AppShared.object. = dataJson[red].bool ?? true
                
                //New...
                let baseURL = dataJson["BaseUL"].stringValue
                
                AppShared.object = "http://livetest.spediaapp.com/WCF/Service.svc/" //baseURL
               
                AppShared.object.notificationCountGlobal = dataJson["NotificationCount"].intValue
               
                UserDefaults.standard.setValue(AppShared.object, forKey: "BASE_URL_KEY")
                UserDefaults.standard.synchronize()
                
                
              } else {
                 
                //show error
                
             }
        }
                
    }
    */
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        self.setUpViews()
        self.getStudentOfParent(sortBy: 1)
        
    }
    
    
    @IBAction func backButtonAction(_ sender: Any) {
        logoutNow()
    }
    
    @IBAction func addStudentButtonAction(_ sender: Any) {
        if let vc = ScanQrViewController.instantiate(fromAppStoryboard: .main) {
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    
    //MARK: UI & View SETUP
    private func setUpViews() {
        
        //1
        self.containerVieww.isHidden = true
        self.noDataView.isHidden = true
        
        //2 back button
        self.backButton.imageView?.transform =  L102Language.isCurrentLanguageArabic() ? CGAffineTransform(scaleX: 1.0, y: -1.0) : CGAffineTransform(scaleX: -1.0, y: 1.0)
        
        //3
        self.headerTitleLbl.text = "class_placeholder".localized()
        self.headerSubTitleLbl.text = "which_class_you_are".localized()
        self.noDataLbl.text = "no_student_added".localized()
        self.addButton.setTitle("add".localized(), for: .normal)
    
    }
    
    
    //MARK: Register Cells
    func registerCells() {
        
        let nibName = UINib(nibName: "ParentChildsCollCell", bundle:nil)
        self.collView.register(nibName, forCellWithReuseIdentifier: "parentChildsCollCell")
    
    }
    
    
    
    func getStudentOfParent(sortBy : Int) {
        
        let urlString = getStudentsOfParent
        
        
        let params = ["SessionToken": sessionTokenGlobal ?? "",
                      "ParentID": parentIdGlobal,
                      "SortBy": sortBy] as [String : Any]
        
        ServiceManager().postRequest(urlString, loader: true, parameters: params) { (status, jsonResponse) in
            
            if status {
                
                self.dataJson = JSON.init(jsonResponse ?? "NO DTA")
                self.studentJson = self.dataJson["ListItems"]
                
                //For TableView-Pop-up View
                //self.sortJson = self.dataJson["SortOptions"]
                //let selectTitle = L102Language.isCurrentLanguageArabic() ? self.sortJson[self.selectedIndex]["TextAr"].stringValue : self.sortJson[self.selectedIndex]["TextEn"].stringValue
                //self.tableViewController.tableView.reloadData()
                
                if self.studentJson.count > 0 {
                    
                    self.containerVieww.isHidden = false
                    self.noDataView.isHidden = true
                    self.collView.reloadData()
                    
                } else { // No data there
                    
                    self.containerVieww.isHidden = true
                    self.noDataView.isHidden = false
                    
                }
                
                
                
            }
        }
    }
    
}








//MARK:================================================
//MARK: CollectionView
//MARK:================================================

extension ParentChildsViewController: UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
 
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.studentJson.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        

        let cell = self.collView.dequeueReusableCell(withReuseIdentifier: "parentChildsCollCell", for: indexPath) as? ParentChildsCollCell
            
        //cell?.tapCellButton.addTarget(self, action: #selector(startButtonAction), for: .touchUpInside)
      
        //cell?.dataJson = self.advBannerDataJson
        //cell.delegateObj = self
        //cell?.reloadCellUI()
        
        
        //1
        cell?.childNameLbl.text = self.studentJson[indexPath.row]["FullName"].stringValue
        cell?.gradeLbl.text = self.studentJson[indexPath.row]["UserName"].stringValue
        
        
        //2
        let url = URL(string: self.studentJson[indexPath.row]["ProfilePicPath"].stringValue)
        cell?.childImage.kf.setImage(with: url, placeholder: nil)
        
        return cell ?? UICollectionViewCell()
        
    }
    


    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let witdh = self.collView.frame.width - 50
        let ratioHeight = (self.collView.frame.width / 261) * 175
        
        return CGSize(width: witdh, height: ratioHeight)
        
    }
    
        
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        /*if let vc = ChildDetailViewController.instantiate(fromAppStoryboard: .main) {
            vc.modalPresentationStyle = .fullScreen
            vc.studentSelectedId = self.studentJson[indexPath.row]["StudentID"].intValue
            //studentIdGlobal = self.studentJson[indexPath.row]["ClassID"].stringValue
            //classIdGlobal = self.studentJson[indexPath.row]["StudentID"].stringValue
            self.present(vc, animated: true, completion: nil)
        }*/
        
        studentIdGlobal = self.studentJson[indexPath.row]["StudentID"].stringValue
        classIdGlobal = self.studentJson[indexPath.row]["ClassID"].stringValue
        startWithPage = self.studentJson[indexPath.row]["StartPage"].stringValue
        
        
        AppShared.object.isFromParentView = true
        
        if startWithPage == StartWithPageType.universityHome {
            setUniversityRootView(tabBarIndex: 0)
        } else {
           setRootView(tabBarIndex: 0)
        }

    }
    
}





//MARK:================================================
//MARK: TableView Extension (For Pop-up / Drop Down
//MARK:================================================
/*
extension ParentChildsViewController : UITableViewDelegate, UITableViewDataSource {
    
   var tableViewController = UITableViewController()
   var selectedIndex = Int()
    
   func registerPopUpTableView() {
        self.tableViewController.tableView.backgroundColor = .clear
        self.tableViewController.tableView.showsVerticalScrollIndicator = false
        
        self.tableViewController.tableView.delegate = self
        self.tableViewController.tableView.dataSource = self
        
        let nibName2 = UINib(nibName: "GradeTableCell", bundle:nil)
        self.tableViewController.tableView.register(nibName2, forCellReuseIdentifier: "gradeTableCell")
    }
    
    @IBAction func selectGradeButtonAction(_ sender: Any) {
        
        guard let button = sender as? UIView else {
            return
        }
        
        let alertController = UIAlertController(title: nil,
                                                message: nil,
                                                preferredStyle: .alert)
        
        
        let cancelAction = UIAlertAction(title: "Select", style: .cancel) { (action) in
            
            let id = self.sortJson[self.selectedIndex]["ID"].intValue
            
            print("Selected ID is---> \(id)")
            
            self.getStudentOfParent(sortBy: id)
            
        }
        
        
        alertController.addAction(cancelAction)
        
        
        let hieghtValue = self.view.frame.height - 250
        let witdhValue  = self.view.frame.width - 50
        
        self.tableViewController.preferredContentSize = CGSize(width: witdhValue, height: hieghtValue)
        
        alertController.setValue(tableViewController, forKey: "contentViewController")
        
        if let presenter = alertController.popoverPresentationController {
            presenter.sourceView = button
            presenter.sourceRect = button.bounds
        }
        
        self.tableViewController.tableView.reloadData()
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sortJson.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "gradeTableCell") as? GradeTableCell
        
        cell?.selectionStyle = .none
        cell?.backgroundColor = .clear
        cell?.containerVieww.backgroundColor = .clear
        cell?.checkImageView.isHidden = true
        cell?.roundImageView.isHidden = false
        
        if self.selectedIndex == indexPath.row {
            cell?.checkImageView.isHidden = false
            cell?.roundImageView.isHidden = true
        }
        
        cell?.nameLbl.text = L102Language.isCurrentLanguageArabic() ? self.sortJson[indexPath.row]["TextAr"].stringValue : self.sortJson[indexPath.row]["TextEn"].stringValue
        
        return cell ?? UITableViewCell()
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print("did select at index---> \(indexPath.row)")
        
        self.selectedIndex = indexPath.row
        self.tableViewController.tableView.reloadData()
    }
    
}

*/
