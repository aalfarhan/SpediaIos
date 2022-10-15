//
//  LibrarySubjectsTCell.swift
//  Spedia
//
//  Created by Viraj Sharma on 18/02/22.
//  Copyright © 2022 Viraj Sharma. All rights reserved.
//

import UIKit
import SwiftyJSON

protocol LibrarySubjectsTCellDelegate {
    func didTapOnLibrarySubjectCollCell(dataModel: JSON)
}


class LibrarySubjectsTCell: UITableViewCell {

    @IBOutlet weak var titleLabel: CustomLabel!
    @IBOutlet weak var subTitlelbl: CustomLabel!
    @IBOutlet weak var collView: UICollectionView!
    
    //...
    //Obj..
    var delegateObj : LibrarySubjectsTCellDelegate?
     
    var dataJson = JSON()
    var whereFromI = ""
    var dataKeyName = "Subjects"
    
    //Responsive...
    @IBOutlet weak var leftPeddingConst: NSLayoutConstraint!
    @IBOutlet weak var rightPeddingConst: NSLayoutConstraint!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
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

    
    func reloadCellUIWith(titleStr: String, subTitleStr: String) {
        
        //1
        self.titleLabel.text = titleStr
        self.subTitlelbl.text = subTitleStr
        
        //2
        DispatchQueue.main.async {
         self.collView.reloadData()
        }
        
    }
    
}



//MARK:================================================
//MARK: UICollectionView
//MARK:================================================

extension LibrarySubjectsTCell: UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
 
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return self.dataJson[self.dataKeyName].count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = self.collView.dequeueReusableCell(withReuseIdentifier: "subjectNewCollCell", for: indexPath) as? SubjectNewCollCell
        
        cell?.whereFrom = WhereFromAmIKeys.videoLibraryPage
        
        
        cell?.tabCellButton.tag = indexPath.row
        cell?.tabCellButton.addTarget(self, action: #selector(tabCellButtonAction(sender:)), for: .touchUpInside)
        
        
        cell?.configureViewWithData(data: self.dataJson[self.dataKeyName][indexPath.row])
        
        
        return cell ?? UICollectionViewCell()
      
    }
    
    
    @objc func tabCellButtonAction(sender: UIButton) {
         
        self.delegateObj?.didTapOnLibrarySubjectCollCell(dataModel: self.dataJson[self.dataKeyName][sender.tag])
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if UIDevice.isPad {
            return CGSize(width: 180, height: 165)
        } else {
            return CGSize(width: 150, height: 165)
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
