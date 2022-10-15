//
//  SubjectNewHomeTCell.swift
//  Spedia
//
//  Created by Viraj Sharma on 23/01/22.
//  Copyright © 2022 Viraj Sharma. All rights reserved.
//

import UIKit
import SwiftyJSON

protocol SubjectNewHomeTCellDelegate {
    func didTapOnSubjectCollCell(dataModel: JSON)
}


class SubjectNewHomeTCell: UITableViewCell {

    @IBOutlet weak var titleLabel: CustomLabel!
    @IBOutlet weak var subTitlelbl: CustomLabel!
    @IBOutlet weak var showAllButton: CustomButton!
    @IBOutlet weak var collView: UICollectionView!
    
    //...
    //Obj..
    var delegateObj : SubjectNewHomeTCellDelegate?
     
    var dataJson = JSON()
    var whereFromI = ""
    var dataKeyName = "HomeDataList"
    //Responsive...
    @IBOutlet weak var leftPeddingConst: NSLayoutConstraint!
    @IBOutlet weak var rightPeddingConst: NSLayoutConstraint!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        if whereFromI == WhereFromAmIKeys.homeSubscribePage {
            
        }
        
        //0
        //Responsive...
        self.leftPeddingConst.constant = UIDevice.isPad ? 50.0 : 16.0
        self.rightPeddingConst.constant = UIDevice.isPad ? 50.0 : 16.0
        
        
        //1
        let collNibName = UINib(nibName: "SubjectNewCollCell", bundle:nil)
        self.collView.register(collNibName, forCellWithReuseIdentifier: "subjectNewCollCell")
        
        //2
        self.collView.delegate = self
        self.collView.dataSource = self
        
    }

    func reloadCellUI() {
        
        self.titleLabel.text = self.dataJson["CategoryName" + Lang.code()].stringValue
        self.subTitlelbl.text = self.dataJson["Description" + Lang.code()].stringValue
        let seeAllStr = self.dataJson["ShowAll" + Lang.code()].stringValue
        
        self.showAllButton.setTitle(seeAllStr, for: .normal)
        
        DispatchQueue.main.async {
         self.collView.reloadData()
        }
    }
    
}



//MARK:================================================
//MARK: UICollectionView (Adv. Banner Silder Coll View)
//MARK:================================================

extension SubjectNewHomeTCell: UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
 
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return self.dataJson[self.dataKeyName].count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = self.collView.dequeueReusableCell(withReuseIdentifier: "subjectNewCollCell", for: indexPath) as? SubjectNewCollCell
        cell?.configureViewWithData(data: self.dataJson[self.dataKeyName][indexPath.row])
        
        cell?.tabCellButton.tag = indexPath.row
        cell?.tabCellButton.addTarget(self, action: #selector(tabCellButtonAction(sender:)), for: .touchUpInside)
        
        return cell ?? UICollectionViewCell()
      
    }
    
    
    @objc func tabCellButtonAction(sender: UIButton) {
         
        self.delegateObj?.didTapOnSubjectCollCell(dataModel: self.dataJson[self.dataKeyName][sender.tag])
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if UIDevice.isPad {
            return CGSize(width: 180, height: 150)
        } else {
            return CGSize(width: 150, height: 150)
        }
        
    
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
        
    }
      
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
          
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if UIDevice.isPad {
            return UIEdgeInsets (top: 0, left: 50, bottom: 0, right: 50)
        } else {
            return UIEdgeInsets (top: 0, left: 16, bottom: 0, right: 16)
        }
    }
    

}
