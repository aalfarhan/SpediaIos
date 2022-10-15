//
//  PrivateClassTCell.swift
//  Spedia
//
//  Created by Viraj Sharma on 08/02/22.
//  Copyright © 2022 Viraj Sharma. All rights reserved.
//

import UIKit
import SwiftyJSON

protocol PrivateClassTCellDelegate {
    func didTapOnJoinButtonPrivateClass(dataModel: JSON)
}

class PrivateClassTCell: UITableViewCell {

    @IBOutlet weak var titleLabel: CustomLabel!
    @IBOutlet weak var collView: UICollectionView!
    @IBOutlet weak var showAllButton: CustomButton!
    
    
    //...
    //Obj..
    var delegateObj : PrivateClassTCellDelegate?
    var dataJson = JSON()
    
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
        let collNibName = UINib(nibName: "ClassCollCell", bundle:nil)
        self.collView.register(collNibName, forCellWithReuseIdentifier: "classCollCell")
        
        //2
        self.collView.delegate = self
        self.collView.dataSource = self
        
        //self.listViewHeightConst.constant = self.dataJson["PrivateClassList"].count > 2 ? 450.0 : 200.00
        
    }

    
    func reloadCellUI() {
        
        //self.listViewHeightConst.constant = CGFloat(self.dataJson.count * 93) + 60.0
        //self.layoutIfNeeded()
        
        self.titleLabel.text = self.dataJson["MyPrivateClassTitle" + Lang.code()].stringValue
        let showAllStr = self.dataJson["PrivateClassShowAllTitle" + Lang.code()].stringValue
        
        self.showAllButton.setTitle(showAllStr, for: .normal)
        
        DispatchQueue.main.async {
          self.collView.reloadData()
        }
    }
    
}


//MARK:================================================
//MARK: UICollectionView (Adv. Banner Silder Coll View)
//MARK:================================================

extension PrivateClassTCell: UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
 
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataJson["PrivateClassList"].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = self.collView.dequeueReusableCell(withReuseIdentifier: "classCollCell", for: indexPath) as? ClassCollCell
        let index = indexPath.row
        
        cell?.configureViewWithData(data: self.dataJson["PrivateClassList"][index])
        
        cell?.joinButton.tag = index
        cell?.joinButton.addTarget(self, action: #selector(joinButtonTapped(sender:)), for: .touchUpInside)
        
        cell?.downloadButton.tag = index
        cell?.downloadButton.addTarget(self, action: #selector(attachmentButtonAction(sender:)), for: .touchUpInside)
       
        let checkPdf = self.dataJson["PrivateClassList"][index]["FilePath"].stringValue
        cell?.downloadButton.isHidden = checkPdf.isEmpty ? true : false
        cell?.imageDownloadButton.isHidden = checkPdf.isEmpty ? true : false
        return cell ?? UICollectionViewCell()
    }
    
    
    @objc func attachmentButtonAction(sender: UIButton) {
        print("attachmentButtonAction")
        if let topController = UIApplication.topViewController() {
            if let vc = DocumentViewController.instantiate(fromAppStoryboard: .main) {
                vc.modalPresentationStyle = .fullScreen
                //vc.isCommingFromQuizzWithPdf = isBooks
                vc.pdfString = self.dataJson["PrivateClassList"][sender.tag]["FilePath"].stringValue
                topController.present(vc, animated: true, completion: nil)
            }
        }
    }
    
    //XLR8 - Status Change Action...
    @objc func joinButtonTapped(sender: UIButton) {
        
        self.delegateObj?.didTapOnJoinButtonPrivateClass(dataModel: self.dataJson["PrivateClassList"][sender.tag])
    
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let devideValue = UIDevice.isPad ? 2.5 : 1.3
        let witdh = (DeviceSize.screenWidth / devideValue)
        return CGSize(width: witdh, height: 85)
        
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
