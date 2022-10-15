//
//  NewActiveClassTCell.swift
//  Spedia
//
//  Created by Viraj Sharma on 11/02/22.
//  Copyright © 2022 Viraj Sharma. All rights reserved.
//

import UIKit
import SwiftyJSON

protocol NewActiveClassTCellDelegate {
    func didTapOnCollCell(dataModel: JSON)
}

class NewActiveClassTCell: UITableViewCell {

    @IBOutlet weak var titleLabel: CustomLabel!
    @IBOutlet weak var subTitlelbl: CustomLabel!
    //@IBOutlet weak var showAllLbl: CustomLabel!
    @IBOutlet weak var collView: UICollectionView!
    
    //...
    //Obj..
    var delegateObj : NewActiveClassTCellDelegate?
     
    //Responsive...
    @IBOutlet weak var leftPeddingConst: NSLayoutConstraint!
    @IBOutlet weak var collViewHeightConst: NSLayoutConstraint!
    var isOnlyClassNameAndTimeBoolValue = false
    
    //...
    var dataJson = JSON()
 
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        //0
        //Responsive...
        self.leftPeddingConst.constant = UIDevice.isPad ? 50.0 : 16.0
        
        
        //1
        let collNibName = UINib(nibName: "ClassesCollCell", bundle:nil)
        self.collView.register(collNibName, forCellWithReuseIdentifier: "classesCollCell")
        
        //2
        self.collView.delegate = self
        self.collView.dataSource = self
        
    }

    func reloadCellUI() {
        
        self.collViewHeightConst.constant = self.isOnlyClassNameAndTimeBoolValue ? 241 : 288
        
        self.titleLabel.text = self.dataJson["CategoryName" + Lang.code()].stringValue
        self.subTitlelbl.text = self.dataJson["Description" + Lang.code()].stringValue
        //self.showAllLbl.text = self.dataJson["ShowAll" + Lang.code()].stringValue
        
        DispatchQueue.main.async {
         self.collView.reloadData()
        }
        
        self.layoutIfNeeded()
    }
    
    
}



//MARK:================================================
//MARK: UICollectionView
//MARK:================================================

extension NewActiveClassTCell: UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
 
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.dataJson["ActiveList"].count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = self.collView.dequeueReusableCell(withReuseIdentifier: "classesCollCell", for: indexPath) as? ClassesCollCell
        
        cell?.isOnlyClassNameAndTimeBool = self.isOnlyClassNameAndTimeBoolValue
        
        let indexValue = indexPath.row
        cell?.tabCellButton.tag = indexValue
        cell?.tabCellButton.addTarget(self, action: #selector(tabCellButtonAction(sender:)), for: .touchUpInside)
    
        cell?.configureViewWithData(data: self.dataJson["ActiveList"][indexValue])
    
        cell?.reloadCollCellUI()
        
        return cell ?? UICollectionViewCell()
      
    }
    
    
    @objc func tabCellButtonAction(sender: UIButton) {
        self.delegateObj?.didTapOnCollCell(dataModel: self.dataJson["ActiveList"][sender.tag])
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let devideValue = UIDevice.isPad ? 2.5 : 1.3
        let witdh = (DeviceSize.screenWidth / devideValue)
        let height = CGFloat(self.collViewHeightConst.constant)
        return CGSize(width: witdh, height: height)
    
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
