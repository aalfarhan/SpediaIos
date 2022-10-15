//
//  LeaderViewController.swift
//  Spedia
//
//  Created by Viraj Sharma on 23/12/2020.
//  Copyright © 2020 Viraj Sharma. All rights reserved.
//

import UIKit
import SwiftyJSON

class LeaderViewController: UIViewController {
    
    //1 Outlets.......
    @IBOutlet weak var topThreeCollView: UICollectionView!
    @IBOutlet weak var collView: UICollectionView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var headerTitleLbl: CustomLabel!
    @IBOutlet weak var headerSubTitleLbl: CustomLabel!
    @IBOutlet weak var noDataLbl: CustomLabel!
    
    //1.1 Constratins For Responsive
    @IBOutlet weak var collViewHeightConts: NSLayoutConstraint!
    
    
    //2 Data.........
    var dataJson = JSON()
    
    
    //1
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cellNib = UINib(nibName: "LeaderCollCell", bundle:nil)
        self.collView.register(cellNib, forCellWithReuseIdentifier: "leaderCollCell")
        
        
        let topNib = UINib(nibName: "TopThreeCollCell", bundle:nil)
        self.topThreeCollView.register(topNib, forCellWithReuseIdentifier: "topThreeCollCell")
        
        
    }
    
    
    //2
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setUpView()
        self.getLeaderboardDateNow()
    }
   
    
    //3
    func setUpView() {
        
        //0
        self.collView.isHidden = true
        self.topThreeCollView.isHidden = true
        self.noDataLbl.text = ""
        
        //1
        self.headerTitleLbl.text = "leaderboards".localized()
        self.headerSubTitleLbl.text = "ranks_based".localized()
        
        //2
        self.backButton.imageView?.transform =  L102Language.isCurrentLanguageArabic() ? CGAffineTransform(scaleX: -1.0, y: 1.0) : CGAffineTransform(scaleX: 1.0, y: -1.0)
        
        
        self.collViewHeightConts.constant = L102Language.isCurrentLanguageArabic() ? 210 : 190
        
    }
    
    
    
    
    
    @IBAction func backButtonAction(_ sender: Any) {
        //self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    
    //4 Call API.....
    
    func getLeaderboardDateNow() {
        
        let urlString = getLeaderBoard
        let params = ["SessionToken" : sessionTokenGlobal ?? "",
                      "StudentID" : studentIdGlobal ?? 0] as [String : Any]
        
        ServiceManager().postRequest(urlString, loader: true, parameters: params) { (status, jsonResponse) in
             
            if status {
                
                let dataRes = JSON.init(jsonResponse ?? "NO DTA")
                self.dataJson = dataRes
                
                if self.dataJson["Top3List"].count == 0 && self.dataJson["RankList"].count == 0 {
                    
                    //no data here... hide ALL
                    self.collView.isHidden = true
                    self.topThreeCollView.isHidden = true
                    self.noDataLbl.text = "no_data_found".localized()
                }
                
                
                if self.dataJson["Top3List"].count > 0 {
                    
                    self.topThreeCollView.isHidden = false
                    self.topThreeCollView.reloadData()
                    
                }
                
                if self.dataJson["RankList"].count > 0 {
                    
                    self.collView.isHidden = false
                    self.collView.reloadData()
                    
                }
                
                
            }
        }
        
    }
    

}




//MARK:================================================
//MARK: CollectionView (Leader Coll View)
//MARK:================================================

extension LeaderViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if topThreeCollView == collectionView {
            return self.dataJson["Top3List"].count
        }
        
        return self.dataJson["RankList"].count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if topThreeCollView == collectionView {
            
            let cell = self.topThreeCollView.dequeueReusableCell(withReuseIdentifier: "topThreeCollCell", for: indexPath) as? TopThreeCollCell

            if indexPath.row == 1 { // 1st View (Top First Student)
                
                cell?.imgViewHeightConst.constant = 90
                cell?.crownImageIcon.isHidden = false
                cell?.circleImageView.image = #imageLiteral(resourceName: "yellowDashCircle.png")
                cell?.rankLabel.textColor = Colors.APP_LIME_GREEN
                cell?.configureCellWithData(data: self.dataJson["Top3List"][0])
            
            } else { // Runner Up's
                
                cell?.crownImageIcon.isHidden = true
                cell?.imgViewHeightConst.constant = 70
                cell?.rankLabel.textColor = Colors.APP_PLACEHOLDER_GRAY25
                
                cell?.circleImageView.image = #imageLiteral(resourceName: "grayDashCircle.png")
                
                if indexPath.row == 0 {
                    cell?.configureCellWithData(data: self.dataJson["Top3List"][1])
                }
                
                if indexPath.row == 2 {
                    cell?.configureCellWithData(data: self.dataJson["Top3List"][2])
                }
            
            }
            

            cell?.reloadCellNow()
            
            return cell ?? UICollectionViewCell()
        
            
        } else {
        
        let cell = self.collView.dequeueReusableCell(withReuseIdentifier: "leaderCollCell", for: indexPath) as? LeaderCollCell
        
        let index = indexPath.row
        
        cell?.configureCellWithData(data: self.dataJson["RankList"][index])
            
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
        
        
        if topThreeCollView == collectionView {
            return CGSize(width: (self.topThreeCollView.frame.width/3) , height: self.collViewHeightConts.constant)
        }
        
        return CGSize(width: self.collView.frame.width, height: 80)
        
    }
    
    

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        if topThreeCollView == collectionView {
            return 0
        }
        
        return 0 //Left-Right Space
        
    }
      
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        if topThreeCollView == collectionView {
            return 0
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
        
    }*/
    
   
    
    /*
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
