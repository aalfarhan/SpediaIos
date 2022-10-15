//
//  LiveNowTCell.swift
//  Spedia
//
//  Created by Viraj Sharma on 23/01/22.
//  Copyright © 2022 Viraj Sharma. All rights reserved.
//

import UIKit
import SwiftyJSON

protocol LiveNowTCellDelegate {
    func didTapOnCollCell(dataModel: JSON)
}

class LiveNowTCell: UITableViewCell {

    @IBOutlet weak var titleLabel: CustomLabel!
    @IBOutlet weak var subTitlelbl: CustomLabel!
    @IBOutlet weak var showAllButton: CustomButton!
    @IBOutlet weak var collView: UICollectionView!
    
    //...
    //Obj..
    var delegateObj : LiveNowTCellDelegate?
     
    //Responsive...
    @IBOutlet weak var leftPeddingConst: NSLayoutConstraint!
    @IBOutlet weak var rightPeddingConst: NSLayoutConstraint!
    
    //...
    var dataJson = JSON()
 
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        //0
        //Responsive...
        self.leftPeddingConst.constant = UIDevice.isPad ? 50.0 : 16.0
        self.rightPeddingConst.constant = UIDevice.isPad ? 50.0 : 16.0
        
        
        //1
        let collNibName = UINib(nibName: "LiveNowCollCell", bundle:nil)
        self.collView.register(collNibName, forCellWithReuseIdentifier: "liveNowCollCell")
        
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

extension LiveNowTCell: UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
 
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.dataJson["HomeDataList"].count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = self.collView.dequeueReusableCell(withReuseIdentifier: "liveNowCollCell", for: indexPath) as? LiveNowCollCell
        
        cell?.tabCellButton.tag = indexPath.row
        cell?.tabCellButton.addTarget(self, action: #selector(tabCellButtonAction(sender:)), for: .touchUpInside)
        
        cell?.configureViewWithData(data: self.dataJson["HomeDataList"][indexPath.row])
        return cell ?? UICollectionViewCell()
      
    }
    
    
    @objc func tabCellButtonAction(sender: UIButton) {
        
        self.delegateObj?.didTapOnCollCell(dataModel: self.dataJson["HomeDataList"][sender.tag])
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let devideValue = UIDevice.isPad ? 2.5 : 1.3
        let witdh = (DeviceSize.screenWidth / devideValue)
        let height = CGFloat(211.0)
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
