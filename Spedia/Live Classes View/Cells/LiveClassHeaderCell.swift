//
//  LiveClassHeaderCell.swift
//  Spedia
//
//  Created by Viraj Sharma on 09/09/2020.
//  Copyright © 2020 Viraj Sharma. All rights reserved.
//

import UIKit
import SwiftyJSON
import Kingfisher

protocol LiveClassHeaderCellDelegate {
    func didTapOnCollCell(id : String, type : String)
}

class LiveClassHeaderCell: UICollectionViewCell {
     
    //1 Outlets...
    @IBOutlet weak var requestTitleLbl: CustomLabel!
    @IBOutlet weak var startButton: CustomButton!
    @IBOutlet weak var tapCellButton: UIButton!
    
    
    //...
    //Obj..
    var delegateObj : AdBannerTableCellDelegate?
     
    @IBOutlet weak var collView: UICollectionView!
    @IBOutlet weak var pageController: UIPageControl!
    
    //Responsive
    @IBOutlet weak var leftPadding: NSLayoutConstraint!
    @IBOutlet weak var rightPadding: NSLayoutConstraint!
    @IBOutlet weak var topPadding: NSLayoutConstraint!
    @IBOutlet weak var bottomPadding: NSLayoutConstraint!
    
    
    var dataJson = JSON()
    
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        self.requestTitleLbl.text = "request_private".localized()
        self.startButton.setTitle("start".localized(), for: .normal)
    
        //1
        let collNibName = UINib(nibName: "AdBannerCollCell", bundle:nil)
        self.collView.register(collNibName, forCellWithReuseIdentifier: "adBannerCollCell")
        
        //2
        self.collView.delegate = self
        self.collView.dataSource = self
        
        //Responsive
        //let peddingValue = 16.0 //Int(DeviceSize.screenWidth / 15.36)
        //self.leftPadding.constant = UIDevice.isPad ? CGFloat(peddingValue) : 16
        //self.rightPadding.constant = UIDevice.isPad ? CGFloat(peddingValue) : 16
        
        self.pageController.transform = CGAffineTransform(scaleX: 1.5, y: 1.5);
        
    }
    
    
    func reloadCellUI() {
        
        if dataJson.count == 0 {
            self.collView.isHidden = true
            //self.pageController.isHidden = true
        } else {
            self.collView.isHidden = false
            //self.pageController.isHidden = false
        }
        
        self.pageController.numberOfPages = self.dataJson.count
        self.pageController.hidesForSinglePage = true
        

        self.collView.reloadData()
        
    }
    
}


//MARK:================================================
//MARK: UICollectionView (Adv. Banner Silder Coll View)
//MARK:================================================

extension LiveClassHeaderCell: UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
 
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.dataJson.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = self.collView.dequeueReusableCell(withReuseIdentifier: "adBannerCollCell", for: indexPath) as? AdBannerCollCell
        
        //1
        //cell?.nameButtonLbl.setTitle(self.dataJson[indexPath.row][nameKey].stringValue, for: .normal)
        
        //2
        
         let url = URL(string: self.dataJson[indexPath.row]["AdvImage"].stringValue)
        
        cell?.imageV.kf.setImage(with: url, placeholder: nil)
        
        //3
        //cell?.nameLbl.text = self.dataJson[indexPath.row]["name"].stringValue
        
        //cell?.downloadWithOutAns.tag = indexPath.row
        //cell?.downloadWithOutAns.addTarget(self, action: #selector(withOutAnsAction), for: .touchUpInside)
                          
        
        return cell ?? UICollectionViewCell()
     
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let witdh = self.collView.frame.width
        let height = (witdh / 344) * 60
        
        return CGSize(width: witdh, height: height)
    
    }
    
    
 
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
        
    }
      
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
          
        return 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //let id = self.dataJson[indexPath.row]["_id"].stringValue
        
        //print("Tap Coll Cell----->", id)
        
        //self.delegateObj?.didTapOnCollCell(id: id, type: self.type)
         
    }
    
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        
        self.pageController.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
        
        /*
           //set callback...
           //delegate?.cellDidScroll(contentOffset: scrollView.contentOffset)
           //call the current index in the main stack..first
           if self.dataJson.count != 0 {
               var visibleRect = CGRect()
               visibleRect.origin = self.collView!.contentOffset
               visibleRect.size = self.collView!.bounds.size
               let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
               let visibleIndexPath = self.collView!.indexPathForItem(at: visiblePoint)
            
               let pageIndex = ((visibleIndexPath as NSIndexPath?)?.row)! % (self.dataJson.count)
            
               self.pageController.currentPage = pageIndex
           }
        */
    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        //self.pageController.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
    
    
}
