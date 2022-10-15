//
//  HomeworkHeaderTCell.swift
//  Spedia
//
//  Created by Viraj Sharma on 04/07/2021.
//  Copyright © 2021 Viraj Sharma. All rights reserved.
//

import UIKit
import SwiftyJSON


protocol HomeworkHeaderTCellDelegate {
    func didTapOnTopHomeworkCollView(atIndex : Int)
}


class HomeworkHeaderTCell: UITableViewCell {
        
    var delegateObj : HomeworkHeaderTCellDelegate?
    
    //1 Outlets.......
    @IBOutlet weak var subjectCollView: UICollectionView!
    
    //2 Data....
    var subjectsDataJson = JSON()
    var selectedSubjectIndex = 0

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        //CollView
        let cellNib = UINib(nibName: "SkillSubjectCollView", bundle:nil)
        self.subjectCollView.register(cellNib, forCellWithReuseIdentifier: "skillSubjectCollView")
        
        self.subjectCollView.delegate = self
        self.subjectCollView.dataSource = self
    
        self.subjectCollView.semanticContentAttribute = L102Language.isCurrentLanguageArabic() ? .forceRightToLeft : .forceLeftToRight
        
        
    }

    
    func reloadColletionsView() {
        self.subjectCollView.reloadData()
        self.layoutIfNeeded()
    }
    
}




//MARK:================================================
//MARK: CollectionView (Top Subject Coll View)
//MARK:================================================

extension HomeworkHeaderTCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
        return self.subjectsDataJson.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "skillSubjectCollView", for: indexPath) as? SkillSubjectCollView
        
    
        cell?.isCellSelected = false
        
        if indexPath.row == self.selectedSubjectIndex {
            cell?.isCellSelected = true
        }
        
        cell?.configureCellWithData(data: subjectsDataJson[indexPath.row])
        
        cell?.tapButton.tag = indexPath.row
        cell?.tapButton.addTarget(self, action: #selector(subjectTapButtonAction(sender:)), for: .touchUpInside)
        
        
        return cell ?? UICollectionViewCell()
        
        
    }
    
     
    @objc func subjectTapButtonAction(sender: UIButton) {
        
        self.delegateObj?.didTapOnTopHomeworkCollView(atIndex: sender.tag)
        self.delegateObj?.didTapOnTopHomeworkCollView(atIndex: sender.tag)
        self.delegateObj?.didTapOnTopHomeworkCollView(atIndex: sender.tag)
        self.selectedSubjectIndex = sender.tag
        self.subjectCollView.reloadData()
    }
    

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: (self.subjectCollView.frame.width / 4.5) - 7, height: 120)
        
    }
    
    
    
 
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0 //Top-Bottom Space
        
    }
      
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 10 //Left-Right Space
    }
    
    
}

