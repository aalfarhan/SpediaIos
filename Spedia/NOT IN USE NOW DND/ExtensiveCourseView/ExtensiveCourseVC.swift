//
//  ExtensiveCourseVC.swift
//  Spedia
//
//  Created by Viraj Sharma on 25/12/2020.
//  Copyright © 2020 Viraj Sharma. All rights reserved.
//

import UIKit
import SwiftyJSON

class ExtensiveCourseVC: UIViewController {
    
    //1 Outlets.......
    @IBOutlet weak var categoryCollView: UICollectionView!
    @IBOutlet weak var gridCollView: UICollectionView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var headerTitleLbl: CustomLabel!
    //@IBOutlet weak var noDataLbl: CustomLabel!
    
    
    //2 Data.........
    //var dataJson = JSON()
    
    
    //1
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cellNib = UINib(nibName: "ExtensiveCollCell", bundle:nil)
        self.gridCollView.register(cellNib, forCellWithReuseIdentifier: "extensiveCollCell")
        
        let topNib = UINib(nibName: "ExtensiveCategoryCollCell", bundle:nil)
        self.categoryCollView.register(topNib, forCellWithReuseIdentifier: "extensiveCategoryCollCell")
        
        
    }
    
    
    //2
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setUpView()
    }
   
    
    //3
    func setUpView() {
        
        //1
        self.headerTitleLbl.text = "extensive_courses".localized()
        
        //2
        self.backButton.imageView?.transform =  L102Language.isCurrentLanguageArabic() ? CGAffineTransform(scaleX: -1.0, y: 1.0) : CGAffineTransform(scaleX: 1.0, y: -1.0)
        
    }
    
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    /*
    func getTimelineData() {
        
        let urlString = AppShared.object.+getUnitsAndSubUn
        let params = ["SessionToken" : sessionTokenGlobal ?? "",
                      "SubjectID" : self.selectedModel[SubjectsKey.SubjectID].intValue] as [String : Any]
        
    
        ServiceManager().postRequest(urlString, loader: true, parameters: params) { (status, jsonResponse) in
             
            if status {
                
                let dataRes = JSON.init(jsonResponse ?? "NO DTA")
                self.dataJson = dataRes
                self.dataJson = self.dataJson["\(UnitDetailKey.UnitsArray)"]
                self.collView.reloadData()
                
                self.addToCartButton.isHidden = AppShared.object. //dataRes[UnitDetailKey.HideAddToCart].boolValue
                
                //if self.dataJson[UnitDetailKey.UnitsArray].count == 0 {
                    //self.collView.isHidden = true
                    //self.noDataLbl.text = "no_data_found".localized()
                //} else {
                    //self.noDataLbl.text = ""
                //}
                 
            }
        }
        
    }
    */
    
    
}



//MARK:================================================
//MARK: CollectionView (Grid and Top Category Cells)
//MARK:================================================

extension ExtensiveCourseVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if categoryCollView == collectionView {
            return 3
        }
        
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if categoryCollView == collectionView {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "extensiveCategoryCollCell", for: indexPath) as? ExtensiveCategoryCollCell

            if indexPath.row == 1 { // 1st View (Top First Student)
                
                
            
            } else { // Runner Up's
                
                
                
            }
            
            //cell?.expandDownButton.tag = indexPath.row - 1 //Down Animation
            //cell?.expandDownButton.addTarget(self, action: #selector(expondButtonsAction(sender:)), for: .touchUpInside)
                    
            //cell?.configureCellWithData(data: self.dataJson[indexPath.row-1])
            
            //cell?.reloadCellNow()
            
            return cell ?? UICollectionViewCell()
        
        } else {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "extensiveCollCell", for: indexPath) as? ExtensiveCollCell
            
        //cell?.expandDownButton.tag = indexPath.row - 1 //Down Animation
        //cell?.expandDownButton.addTarget(self, action: #selector(expondButtonsAction(sender:)), for: .touchUpInside)
                
        //cell?.configureCellWithData(data: self.dataJson[indexPath.row-1])
        
        return cell ?? UICollectionViewCell()
        
       }
    }
    
    
    /*
    func didTapOnExpandedCell (model : JSON) {
        
        print("didTapOnExpandedCell ====> \(model)")
        
        if let vc = VideoViewController.instantiate(fromAppStoryboard: .main) {
           vc.modalPresentationStyle = .fullScreen
           vc.subjectId = self.selectedModel[SubjectsKey.SubjectID].intValue
           vc.subjectPriceId = self.selectedModel[SubjectsKey.SubjectPriceID].intValue
           vc.selectedModel = model
           //vc.videoURL = model["VideoPathWithoutMediaPlayer"].stringValue
           vc.hidesBottomBarWhenPushed = true
           self.navigationController?.pushViewController(vc, animated: true)
           
           //self.present(vc, animated: true, completion: nil)
           
        }
    }
    */
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        if categoryCollView == collectionView {
           return CGSize(width: 110, height: 37)
        }
        
        return CGSize(width: (self.gridCollView.frame.width/2) - 10, height: 203)
        
    }
    
    
    
 
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        if categoryCollView == collectionView {
            return 0
        }
        
        return 20 //Left-Right Space
        
    }
      
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        if categoryCollView == collectionView {
            return 20
        }
        
        return 20 //Top-Bottom Space
    }
    
    
    //func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)  {
    //}
    
    
    
    /*
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

        if topThreeCollView == collectionView {
            let cellWitdh = Int ((self.topThreeCollView.frame.width / 3) + 10)
            
            let totalCellWidth = cellWitdh * collectionView.numberOfItems(inSection: 0)
            let totalSpacingWidth = 0 * (collectionView.numberOfItems(inSection: 0) - 1)
            
            let leftInset = (collectionView.layer.frame.size.width - CGFloat(totalCellWidth + totalSpacingWidth)) / 2
            let rightInset = leftInset
            
            return UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: rightInset)
        }
        
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
    }
    

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
        return CGSize(width: (self.topThreeCollView.frame.width / 4) - 5 , height: self.topThreeCollView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 42
    }*/
    
    
    
}
