//
//  MyLiveClassesTCell.swift
//  Spedia
//
//  Created by Viraj Sharma on 07/02/22.
//  Copyright © 2022 Viraj Sharma. All rights reserved.
//

import UIKit
import SwiftyJSON

protocol MyLiveClassesTCellDelegate {
    func didTapOnJoinButton(dataModel: JSON)
}


class MyLiveClassesTCell: UITableViewCell {

    @IBOutlet weak var titleLabel: CustomLabel!
    @IBOutlet weak var collView: UICollectionView!
    @IBOutlet weak var showAllButton: CustomButton!
    
    //...
    //Obj..
    var delegateObj : MyLiveClassesTCellDelegate?
     
    var dataJson = JSON()
    
    //Responsive...
    @IBOutlet weak var collViewHeightConst: NSLayoutConstraint!
    @IBOutlet weak var leftPeddingConst: NSLayoutConstraint!
    @IBOutlet weak var rightPeddingConst: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //0
        //Responsive...
        self.leftPeddingConst.constant = UIDevice.isPad ? 50.0 : 16.0
        self.rightPeddingConst.constant = UIDevice.isPad ? 50.0 : 16.0
        
        self.collViewHeightConst.constant = L102Language.isCurrentLanguageArabic() ? 160 : 123
        
        //1
        let collNibName = UINib(nibName: "MyClassCollCell", bundle:nil)
        self.collView.register(collNibName, forCellWithReuseIdentifier: "myClassCollCell")
        
        //2
        self.collView.delegate = self
        self.collView.dataSource = self
        
    }

    func reloadCellUI() {
        
        self.titleLabel.text = self.dataJson["MyLiveClassesTitle" + Lang.code()].stringValue
        let showAllStr = self.dataJson["LiveClassShowAllTitle" + Lang.code()].stringValue
        self.showAllButton.setTitle(showAllStr, for: .normal)
        
        DispatchQueue.main.async {
         self.collView.reloadData()
        }
    }
    
}



//MARK:================================================
//MARK: UICollectionView (Adv. Banner Silder Coll View)
//MARK:================================================

extension MyLiveClassesTCell: UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
 
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return self.dataJson["MyLiveClassList"].count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = self.collView.dequeueReusableCell(withReuseIdentifier: "myClassCollCell", for: indexPath) as? MyClassCollCell
        
        let index = indexPath.row
        cell?.configureViewWithData(data: self.dataJson["MyLiveClassList"][index])
        
        cell?.joinButton.tag = index
        cell?.joinButton.addTarget(self, action: #selector(joinButtonAction(sender:)), for: .touchUpInside)
        
        return cell ?? UICollectionViewCell()
      
    }
    
    
    @objc func joinButtonAction(sender: UIButton) {
         self.delegateObj?.didTapOnJoinButton(dataModel: self.dataJson["MyLiveClassList"][sender.tag])
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if UIDevice.isPad {
            return CGSize(width: 270, height: self.collViewHeightConst.constant)
        } else {
            return CGSize(width: 270, height: self.collViewHeightConst.constant)
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

