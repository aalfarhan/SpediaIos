//
//  BookmarkViewController.swift
//  Spedia
//
//  Created by Viraj Sharma on 22/06/2021.
//  Copyright © 2021 Viraj Sharma. All rights reserved.
//

import UIKit
import SwiftyJSON

class BookmarkViewController: UIViewController, UITextFieldDelegate {

    //1 Outlets.......
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var collView: UICollectionView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var headerTitleLbl: CustomLabel!
    @IBOutlet weak var headerSubTitleLbl: CustomLabel!
    //@IBOutlet weak var bellIconButton: BellIconButton!
    //@IBOutlet weak var supportIconButton: SupportButton!
    
    @IBOutlet weak var tftContainerView: UIView!
    @IBOutlet weak var subjectTFT: DataPickerTextField!
    
    
    
    //MARK: NoData Customer Support View
    @IBOutlet weak var noSupportDataView: NoDataCustomerSupportView!
    
    
    //2 Data.........
    var dataJson = JSON()
    var selectedSubjectId = 0
    var isFirstTime = true
    
    
    //1
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let nibName = UINib(nibName: "BookmarkCollCell", bundle:nil)
        self.collView.register(nibName, forCellWithReuseIdentifier: "bookmarkCollCell")
        
        self.containerView.isHidden = true
        self.noSupportDataView.isHidden = true
        self.tftContainerView.isHidden = true
        
        self.subjectTFT.placeholder = "select_subject_ph".localized()
    
        //self.subjectTFT.nameKey = L102Language.isCurrentLanguageArabic() ? "NameAr" : "NameEn"
        
        self.subjectTFT.pickerAction = { [unowned self] row in
            print("------->", row)
            
            self.selectedSubjectId = self.dataJson["Subjects"][row]["ID"].intValue
            self.getBookmarkDataNow()
            self.subjectTFT.resignFirstResponder()
        }
        

    }
    
    
    
    //2
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setUpView()
        self.getBookmarkDataNow()
        
        //Bell ICON
        //self.bellIconButton.updateBellCount(color: Colors.APP_LIGHT_GREEN ?? .cyan)
        
    }
   
    
    //3
    func setUpView() {
        
        //self.headerTitleLbl.text = "bookmark".localized()
        //self.headerSubTitleLbl.text = "see_all_bookmarks".localized()
        
        //2
        self.backButton.imageView?.transform =  L102Language.isCurrentLanguageArabic() ? CGAffineTransform(scaleX: -1.0, y: 1.0) : CGAffineTransform(scaleX: 1.0, y: -1.0)
    
    }
    
    
    
    @IBAction func backButtonAction(_ sender: Any) {
       //self.dismiss(animated: true, completion: nil)
       self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func applyFilterButtonAction(_ sender: Any) {
        
    }
    
    
    //4 Call API.....
    
    func getBookmarkDataNow() {
        
        let urlString = getBookmark
        
        let params = ["SessionToken" : sessionTokenGlobal ?? "",
                      "StudentID" : studentIdGlobal ?? 0,
                      "SubjectID": self.selectedSubjectId] as [String : Any]
        
    
        ServiceManager().postRequest(urlString, loader: true, parameters: params) { (status, jsonResponse) in
             
            if status {
                
                let dataRes = JSON.init(jsonResponse ?? "NO DTA")
                
                //0
                self.dataJson = dataRes
                
                self.headerTitleLbl.text = self.dataJson["Title" + Lang.code()].stringValue
                
                self.headerSubTitleLbl.text = self.dataJson["SubTitle" + Lang.code()].stringValue
                
                
                if self.isFirstTime {
                 self.isFirstTime = false
                 self.subjectTFT.items = self.dataJson["Subjects"].arrayValue
                }
                
                
                if self.dataJson["BookMarkList"].count == 0 { //no data here...
                    self.containerView.isHidden = true
                    self.noSupportDataView.isHidden = false
                    self.tftContainerView.isHidden = true
                } else {
                    
                    self.containerView.isHidden = false
                    self.noSupportDataView.isHidden = true
                    self.tftContainerView.isHidden = false
                    self.collView.reloadData()
                }
                
            }
        }
        
    }
    
    
}







//MARK:================================================
//MARK: CollectionView (Timeline Coll View)
//MARK:================================================

extension BookmarkViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.dataJson["BookMarkList"].count
    
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = self.collView.dequeueReusableCell(withReuseIdentifier: "bookmarkCollCell", for: indexPath) as? BookmarkCollCell
        
        cell?.tapBookmarkButton.tag = indexPath.row
        cell?.tapBookmarkButton.addTarget(self, action: #selector(didTapOnBookmarkButton(sender:)), for: .touchUpInside)
                
        cell?.configureCellWithData(data: self.dataJson["BookMarkList"][indexPath.row])
        
        return cell ?? UICollectionViewCell()
            
    }
    
    
    
    
    @objc func didTapOnBookmarkButton(sender: UIButton) {
        
        let selectedModel = self.dataJson["BookMarkList"][sender.tag]
        
        print(selectedModel)
    
        if let vc = VideoViewController.instantiate(fromAppStoryboard: .main) {
           vc.modalPresentationStyle = .fullScreen
           vc.subjectId = selectedModel["SubjectID"].intValue
           //vc.subjectPriceId = selectedModel["SubjectPriceID"].intValue
           vc.subSkillVideoIdStr = selectedModel["SubskillVideoID"].string ?? "0"
           vc.unitId = selectedModel["SubUnitID"].intValue
           vc.whereFromAmI = WhereFromAmIKeys.bookmark
           vc.bookmarkWatchedLength = selectedModel["WatchedLength"].intValue
           //vc.hidesBottomBarWhenPushed = true
           //self.navigationController?.pushViewController(vc, animated: true)
           self.present(vc, animated: true, completion: nil)
        }
        
    }
    

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: self.collView.frame.width, height: 160)
        
    }
    
 
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0 //Left-Right Space
        
    }
      
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
         
        return 20 //Top-Bottom Space
    }
    
    
    //func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)  {
    //}
    
    
}
