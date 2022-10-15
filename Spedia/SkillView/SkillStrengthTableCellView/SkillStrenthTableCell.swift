//
//  SkillStrenthTableCell.swift
//  Spedia
//
//  Created by Viraj Sharma on 01/01/2021.
//  Copyright © 2021 Viraj Sharma. All rights reserved.
//

import UIKit
import SwiftyJSON

class SkillStrenthTableCell: UITableViewCell {

    //1 Outlets.......
    @IBOutlet weak var collView: UICollectionView!
    @IBOutlet weak var titleLabel: CustomLabel!
    @IBOutlet weak var subTileLabel: CustomLabel!
    @IBOutlet weak var leanMoreButton: CustomButton!
    @IBOutlet weak var collViewHeightConst: NSLayoutConstraint!
    
    //2 Data....
    var progressSkillData = JSON()
    
    var isQuizType = false
    
    @IBOutlet weak var titleHeightConst: NSLayoutConstraint!
    @IBOutlet weak var subTitleHeightConst: NSLayoutConstraint!
    @IBOutlet weak var subTitleBottomConst: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.titleLabel.text = "skill_strength".localized()
        self.subTileLabel.text = "based_on_your".localized()
        
        self.leanMoreButton.setTitle("learn_more".localized(), for: .normal)
        
        
        //CollView
        let catNib = UINib(nibName: "ProgressCircleCollCell", bundle:nil)
        self.collView.register(catNib, forCellWithReuseIdentifier: "progressCircleCollCell")
        
        //...
        self.collView.delegate = self
        self.collView.dataSource = self
    
    }

    
    func reloadColletionsView() {
        
        
        //self.titleHeightConst.constant = isQuizType ? 0 : 22
        //self.subTitleHeightConst.constant = isQuizType ? 0 : 20
        //self.subTitleBottomConst.constant = isQuizType ? 0 : 21
        
        self.titleLabel.text = isQuizType ? "quiz_skill_strength".localized() : "skill_strength".localized()
        
        self.subTileLabel.text = isQuizType ? "quiz_based_on_your".localized() : "based_on_your".localized()
        
        
        self.collView.reloadData()
        //DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
        //self.collViewHeightConst.constant = self.collView.contentSize.height
        //self.layoutIfNeeded()
        //}
        
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    
    
}




//MARK:================================================
//MARK: CollectionView (Bottom Progress Coll View)
//MARK:================================================

extension SkillStrenthTableCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
        return self.progressSkillData.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "progressCircleCollCell", for: indexPath) as? ProgressCircleCollCell
        
        //cell?.tapButton.tag = indexPath.row
        //cell?.tapButton.addTarget(self, action: #selector(subjectTapButtonAction(sender:)), for: .touchUpInside)
        
        cell?.nameLabel.text = L102Language.isCurrentLanguageArabic() ? progressSkillData[indexPath.row]["NameAr"].stringValue : progressSkillData[indexPath.row]["NameEn"].stringValue
        
        cell?.circularProgressView.value = CGFloat(progressSkillData[indexPath.row]["WatchedVideosPerc"].floatValue)
        
        return cell ?? UICollectionViewCell()
        
        
    }
    
     
    
    /*@objc func subCategoryTabButtonAciton(sender: UIButton) {
        
        self.subCategorySelectedIndex = sender.tag
        self.subcategoryCollView.reloadData()
        
    }*/
    
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: (self.collView.frame.width / 3) - 10 , height: 135)
        
    }
    
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 10 //Top-Bottom Space
        
    }
      
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 10 //Left-Right Space
    }
    

}
