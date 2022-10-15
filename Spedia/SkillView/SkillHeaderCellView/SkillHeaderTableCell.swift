//
//  SkillHeaderTableCell.swift
//  Spedia
//
//  Created by Viraj Sharma on 31/12/2020.
//  Copyright © 2020 Viraj Sharma. All rights reserved.
//

import UIKit
import SwiftyJSON
import UICircularProgressRing

protocol SkillHeaderTableCellDelegate {
    func didTapOnTopSubjectCollView (atIndex : Int)
}


class SkillHeaderTableCell: UITableViewCell {
    
    
    var delegateObj : SkillHeaderTableCellDelegate?
    
    @IBOutlet var subjectProgressVieww: UICircularProgressRing!
    
    //1 Outlets.......
    @IBOutlet weak var subjectCollView: UICollectionView!
    @IBOutlet weak var subcategoryCollView: UICollectionView!
    @IBOutlet weak var selectedSubjectNameLbl: CustomLabel!
    @IBOutlet weak var overallStatsLabel: CustomLabel!
    
    //1.1 Points View
    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var LevelVieww: UIView!
    @IBOutlet weak var lblLevel: CustomLabel!
    @IBOutlet weak var lblPoints: CustomLabel!
    @IBOutlet weak var levelViewWitdhConst: NSLayoutConstraint!
    
    @IBOutlet weak var showSkillButton: UIButton!
    @IBOutlet weak var showLeaderBord: UIButton!
    
    //1.2 Data
    var overviewDataJson = JSON()
    var subjectsDataJson = JSON()
    var selectedSubjectIndex = 0 //For Top Coll View Selection
    var subCategorySelectedIndex = 0 // For Middle Coll View
    
    
    //History View
    @IBOutlet weak var progressViewHeightConst: NSLayoutConstraint!
    @IBOutlet weak var progressViewTopConst: NSLayoutConstraint!
    @IBOutlet weak var progressViewBottomConst: NSLayoutConstraint!
    
    @IBOutlet weak var watchVideoLabel: CustomLabel!
    @IBOutlet weak var percentageLabel: CustomLabel!
    
    var isQuizType = false

    
    //Dummy Data collCellImage0  
    //let dummyData : JSON = JSON.init([["title":"Questions Correct", "subTitle":"52 Correct", "image":"collCellImage0"], ["title":"Test Attempted", "subTitle":"5 Practices", "image":"collCellImage1"], ["title":"Academic Hours", "subTitle":"09:15 hr", "image":"collCellImage2"]])
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        //CollView
        let cellNib = UINib(nibName: "SkillSubjectCollView", bundle:nil)
        self.subjectCollView.register(cellNib, forCellWithReuseIdentifier: "skillSubjectCollView")
        
        //CollView
        let catNib = UINib(nibName: "SkillSubCategoryCollCell", bundle:nil)
        self.subcategoryCollView.register(catNib, forCellWithReuseIdentifier: "skillSubCategoryCollCell")
        
        
        //self.levelViewWitdhConst.constant = (self.borderView.bounds.width / 2) + 30
        borderView.layer.cornerRadius = 20
        borderView.layer.borderWidth = 1
        borderView.layer.borderColor = Colors.APP_LIGHT_GREEN?.cgColor
        borderView.backgroundColor = UIColor.clear
        
        
        //LevelVieww.layer.cornerRadius = 20
        //LevelVieww.layer.borderWidth = 0
        //LevelVieww.layer.borderColor = UIColor.clear.cgColor
        //LevelVieww.backgroundColor = Colors.APP_LIGHT_GREEN
        
        
        //...
        self.subcategoryCollView.delegate = self
        self.subcategoryCollView.dataSource = self
        
        self.subjectCollView.delegate = self
        self.subjectCollView.dataSource = self
        
        
        self.subjectProgressVieww.font = UIFont(name: "BOLD".localized(), size: 26) ?? UIFont.systemFont(ofSize: 26)
        
        self.subjectProgressVieww.shouldShowValueText = false
        
        self.watchVideoLabel.text = self.isQuizType ? "quiz_watched".localized() : "video_watched".localized()
        
        //4
        self.subjectCollView.semanticContentAttribute = L102Language.isCurrentLanguageArabic() ? .forceRightToLeft : .forceLeftToRight
        
        
    }

    
    func incrementLabel(to endValue: Int) {
        let duration: Double = 1.5 //seconds
        DispatchQueue.global().async {
            for i in 0 ..< (endValue + 1) {
                let sleepTime = UInt32(duration/Double(endValue) * 1000000.0)
                usleep(sleepTime)
                DispatchQueue.main.async {
                    self.percentageLabel.text = "\(i) % "
                }
            }
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    //func loadNowProgressView() {
      //  self.subjectProgressVieww.startProgress(to: 66, duration: 2.0)
    //}
    
    
    func reloadColletionsView() {
        
        //self.layoutIfNeeded()
        
        self.watchVideoLabel.text = self.isQuizType ? "quiz_watched".localized() : "video_watched".localized()
        
        self.subjectCollView.reloadData()
        
        self.subcategoryCollView.reloadData()
    
        if overviewDataJson.count == 0 {
            self.progressViewHeightConst.constant = 270
            self.progressViewTopConst.constant = 0
            self.progressViewBottomConst.constant = 0
        } else {
            self.progressViewHeightConst.constant = 471
            self.progressViewTopConst.constant = 30
            self.progressViewBottomConst.constant = 20
        }
        
        self.layoutIfNeeded()
    
    }
    
    
}




//MARK:================================================
//MARK: CollectionView (Top Subject Coll View)
//MARK:================================================

extension SkillHeaderTableCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
        if collectionView == subcategoryCollView {
            return self.overviewDataJson.count
        }
        return self.subjectsDataJson.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == subcategoryCollView {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "skillSubCategoryCollCell", for: indexPath) as? SkillSubCategoryCollCell
                
            cell?.tapButton.tag = indexPath.row
            cell?.tapButton.addTarget(self, action: #selector(subCategoryTabButtonAciton(sender:)), for: .touchUpInside)
            
            /*if indexPath.row == subCategorySelectedIndex {
            
                cell?.contianerVieww.backgroundColor = Colors.APP_LIME_GREEN?.withAlphaComponent(0.10)
                cell?.contianerVieww.layer.borderColor = Colors.APP_LIME_GREEN?.cgColor
            } else {*/
                
                cell?.contianerVieww.backgroundColor = .clear
                cell?.contianerVieww.layer.borderColor = UIColor.clear.cgColor
            //}
            
            //cell?.categoryimageView.image = UIImage.init(named:"collCellImage\(indexPath.row)")
            
            cell?.configureCellWithData(data: self.overviewDataJson[indexPath.row])
            
            return cell ?? UICollectionViewCell()
            
        } else {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "skillSubjectCollView", for: indexPath) as? SkillSubjectCollView
            
        
            cell?.tapButton.tag = indexPath.row
            cell?.tapButton.addTarget(self, action: #selector(subjectTapButtonAction(sender:)), for: .touchUpInside)
            cell?.isCellSelected = false
            if indexPath.row == selectedSubjectIndex {
                cell?.isCellSelected = true
            }
            
            cell?.configureCellWithData(data: subjectsDataJson[indexPath.row])
            
            self.selectedSubjectNameLbl.text = L102Language.isCurrentLanguageArabic() ? subjectsDataJson[selectedSubjectIndex]["NameAr"].stringValue : subjectsDataJson[selectedSubjectIndex]["NameEn"].stringValue
            
            self.overallStatsLabel.text = L102Language.isCurrentLanguageArabic() ? subjectsDataJson[selectedSubjectIndex]["DescriptionAr"].stringValue : subjectsDataJson[selectedSubjectIndex]["DescriptionEn"].stringValue
            
        
            return cell ?? UICollectionViewCell()
            
        }
    }
    
     
    @objc func subjectTapButtonAction(sender: UIButton) {
        
        let progressValue = subjectsDataJson[selectedSubjectIndex]["DescriptionAr"].floatValue
        self.subjectProgressVieww.startProgress(to: CGFloat(progressValue), duration: 2.0)
        
        selectedSubjectIndex = sender.tag
        self.subjectCollView.reloadData()
        
        self.delegateObj?.didTapOnTopSubjectCollView(atIndex: selectedSubjectIndex)
    }
    
    
    
    @objc func subCategoryTabButtonAciton(sender: UIButton) {
        
        self.subCategorySelectedIndex = sender.tag
        self.subcategoryCollView.reloadData()
        
    }
    
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == subcategoryCollView {
            return CGSize(width: (self.subcategoryCollView.frame.width / 3) - 7, height: 150)
        }
        
        return CGSize(width: (self.subjectCollView.frame.width / 4.5) - 7, height: 120)
        
    }
    
    
    
 
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        if collectionView == subcategoryCollView {
           return 0 //Top-Bottom Space
        }
        return 0 //Top-Bottom Space
        
    }
      
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        if collectionView == subcategoryCollView {
           return 10 //Left-Right Space
        }
        return 10 //Left-Right Space
    }
    
    
    /*
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

        if subcategoryCollView == collectionView {
            let cellWitdh = Int ((self.subcategoryCollView.frame.width / 3)) + 10
            
            let totalCellWidth = cellWitdh * collectionView.numberOfItems(inSection: 0)
            let totalSpacingWidth = 0 * (collectionView.numberOfItems(inSection: 0) - 1)
            
            let leftInset = (collectionView.layer.frame.size.width - CGFloat(totalCellWidth + totalSpacingWidth)) / 2
            let rightInset = leftInset
            
            return UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: rightInset)
        }
        
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
    }
    */
    
  
    
}

