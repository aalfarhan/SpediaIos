//
//  SubscribeSubjectTCell.swift
//  Spedia
//
//  Created by Viraj Sharma on 07/02/22.
//  Copyright © 2022 Viraj Sharma. All rights reserved.
//

import UIKit
import SwiftyJSON

protocol SubscribeSubjectTCellDelegate {
    func didTapOnSubjectCollCell(dataModel: JSON)
}


class SubscribeSubjectTCell: UITableViewCell {

    @IBOutlet weak var titleLabel: CustomLabel!
    @IBOutlet weak var collView: UICollectionView!
    
    //...
    //Obj..
    var delegateObj : SubscribeSubjectTCellDelegate?
     
    var dataJson = JSON()
    
    //Responsive...
    @IBOutlet weak var leftPeddingConst: NSLayoutConstraint!
    //@IBOutlet weak var rightPeddingConst: NSLayoutConstraint!
    @IBOutlet weak var collViewHeightConst: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //0
        //Responsive...
        self.leftPeddingConst.constant = UIDevice.isPad ? 50.0 : 16.0
        //self.rightPeddingConst.constant = UIDevice.isPad ? 50.0 : 16.0
        
        //1
        let collNibName = UINib(nibName: "SubjectNewCollCell", bundle:nil)
        self.collView.register(collNibName, forCellWithReuseIdentifier: "subjectNewCollCell")
        
        //2
        self.collView.delegate = self
        self.collView.dataSource = self
        
    }

    func reloadCellUI() {
        
        self.titleLabel.text = self.dataJson["SubscribedSubjectTitle" + Lang.code()].stringValue
         
        DispatchQueue.main.async {
            self.collView.reloadData()
            self.layoutIfNeeded()
        }
    }

}



//MARK:================================================
//MARK: UICollectionView (Adv. Banner Silder Coll View)
//MARK:================================================

extension SubscribeSubjectTCell: UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
 
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return self.dataJson["SubscribedSubjectList"].count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = self.collView.dequeueReusableCell(withReuseIdentifier: "subjectNewCollCell", for: indexPath) as? SubjectNewCollCell
        cell?.configureViewWithData(data: self.dataJson["SubscribedSubjectList"][indexPath.row])
        
        cell?.tabCellButton.tag = indexPath.row
        cell?.tabCellButton.addTarget(self, action: #selector(tabCellButtonAction(sender:)), for: .touchUpInside)
        
        return cell ?? UICollectionViewCell()
      
    }
    
    
    @objc func tabCellButtonAction(sender: UIButton) {
         
        self.delegateObj?.didTapOnSubjectCollCell(dataModel: self.dataJson["SubscribedSubjectList"][sender.tag])
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let devideValue = UIDevice.isPad ? 3.0 : 2.0
        let witdh = (DeviceSize.screenWidth / devideValue)
        let minus = UIDevice.isPad ? 44.0 : 22.0
        let calcutedWitdh = witdh - minus
        return CGSize(width: calcutedWitdh, height: 150)
        
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
