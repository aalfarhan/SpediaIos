//
//  SubscribedSubjectTCell.swift
//  Spedia
//
//  Created by Viraj Sharma on 16/07/2020.
//  Copyright © 2020 Viraj Sharma. All rights reserved.
//

import UIKit
import SwiftyJSON

class SubscribedSubjectTCell: UITableViewCell {

    @IBOutlet weak var privateCollView: UICollectionView!
    @IBOutlet weak var subscribedCollView: UICollectionView!
    
    var selectIndex = 0
    var cellWitdh = CGFloat()
    var privateRequestDataJson = JSON()
    var subscribedSubjectDataJson = JSON()
    
    @IBOutlet weak var privateRequestLbl: CustomLabel!
    @IBOutlet weak var subscribedSubjectLbl: CustomLabel!
    
    //Responsive
    @IBOutlet weak var leftPedding: NSLayoutConstraint!
    @IBOutlet weak var rightPedding: NSLayoutConstraint!
    
    
    //IF No Data
    @IBOutlet weak var privateContainerView: UIView!
    @IBOutlet weak var subscribedContainerView: UIView!
    @IBOutlet weak var stackViewTopConst: NSLayoutConstraint!
    @IBOutlet weak var stackViewBottomConst: NSLayoutConstraint!
     
    
    override func awakeFromNib() {
         
        super.awakeFromNib()
        
        
        let peddingValue = Int(DeviceSize.screenWidth / 15.36)
        print(peddingValue)
        self.leftPedding.constant = UIDevice.isPad ? CGFloat(peddingValue) : 16
        self.rightPedding.constant = UIDevice.isPad ? 0 : 0
        
        //membership_no
        self.privateRequestLbl.text = "private_requests".localized()
        self.subscribedSubjectLbl.text = "subscribed_subjects".localized()
        
     
        
        // Initialization code
        let nibName = UINib(nibName: "SubUnitCollCell", bundle:nil)
        self.subscribedCollView.register(nibName, forCellWithReuseIdentifier: "subUnitCollCell")
        
        self.subscribedCollView.delegate = self
        self.subscribedCollView.dataSource = self
        
        
    
        let nibPrivateName = UINib(nibName: "SubUnitCollCell", bundle:nil)
        self.privateCollView.register(nibPrivateName, forCellWithReuseIdentifier: "subUnitCollCell")
        
        self.privateCollView.delegate = self
        self.privateCollView.dataSource = self
        
        
        
        self.subscribedCollView.semanticContentAttribute = L102Language.isCurrentLanguageArabic() ? .forceRightToLeft : .forceLeftToRight
        
        self.privateCollView.semanticContentAttribute = L102Language.isCurrentLanguageArabic() ? .forceRightToLeft : .forceLeftToRight
        

    }


    func configureViewNow() {
        
        
        self.stackViewTopConst.constant = self.privateRequestDataJson.count == 0 ? 0 : 20
        self.stackViewBottomConst.constant = self.subscribedSubjectDataJson.count == 0 ? 0 : 20
        
        self.privateContainerView.isHidden = self.privateRequestDataJson.count == 0 ? true : false
        self.subscribedContainerView.isHidden = self.subscribedSubjectDataJson.count == 0 ? true : false
        
        
        self.layoutIfNeeded()
        
        self.privateCollView.reloadData()
        self.subscribedCollView.reloadData()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}



//MARK:================================================
//MARK: CollectionView (Custom TabBar View)
//MARK:================================================

extension SubscribedSubjectTCell: UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
 
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == self.privateCollView {
            return self.privateRequestDataJson.count
        }
        return self.subscribedSubjectDataJson.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.privateCollView {
        
        let cell = self.privateCollView.dequeueReusableCell(withReuseIdentifier: "subUnitCollCell", for: indexPath) as? SubUnitCollCell

        cell?.expandDownButton.isHidden = true
    
        let data = self.privateRequestDataJson[indexPath.row]
        
        //1
        let titleStr = L102Language.isCurrentLanguageArabic() ? data["SubjectAr"].stringValue : data["SubjectEn"].stringValue

        cell?.unitNameLbl.text = titleStr
        
        //2
        let counrseCountStr = L102Language.isCurrentLanguageArabic() ? data["DateTimeAr"].stringValue : data["DateTimeEn"].stringValue

        cell?.courseCountLbl.text = counrseCountStr
        
        //3
        
        let chapterCountStr = L102Language.isCurrentLanguageArabic() ? data["RequestedDateTimeEn"].stringValue : data["RequestedDateTimeEn"].stringValue

        cell?.chanpterCountLbl.text = chapterCountStr
         
        
        //4
        
        let url = URL(string: data["Image"].stringValue)
        cell?.bkgImageView.kf.setImage(with: url, placeholder: UIImage(named: "collBkg"))
        
        
        return cell ?? UICollectionViewCell()
        
        
        
        } else {
        
        let cell = self.subscribedCollView.dequeueReusableCell(withReuseIdentifier: "subUnitCollCell", for: indexPath) as? SubUnitCollCell

        cell?.expandDownButton.isHidden = true
    
        let data = self.subscribedSubjectDataJson[indexPath.row]
        
        //1
        let titleStr = L102Language.isCurrentLanguageArabic() ? data[ProfileKeys.SubjectNameAr].stringValue : data[ProfileKeys.SubjectNameAr].stringValue

        cell?.unitNameLbl.text = titleStr
        
        //2
        let counrseCountStr = L102Language.isCurrentLanguageArabic() ? data[ProfileKeys.CoursesCountAr].stringValue : data[ProfileKeys.CoursesCountEn].stringValue

        cell?.courseCountLbl.text = counrseCountStr
        
        //3
        
        let chapterCountStr = L102Language.isCurrentLanguageArabic() ? data[ProfileKeys.ChaptersCountAr].stringValue : data[ProfileKeys.ChaptersCountEn].stringValue

        cell?.chanpterCountLbl.text = chapterCountStr
         
        
        //4
        
        let url = URL(string: data[ProfileKeys.SubjectImage].stringValue)
        cell?.bkgImageView.kf.setImage(with: url, placeholder: UIImage(named: "collBkg"))
        
        
        return cell ?? UICollectionViewCell()
        
        }
        
        
    }
    
    
    /*@objc func tempoBookAction(sender: UIButton) {
     
        if let vc = BooksAndTestViewController.instantiate(fromAppStoryboard: .main) {
               vc.modalPresentationStyle = .fullScreen
               vc.isBooks = true
               self.present(vc, animated: true, completion: nil)
        }

    }*/
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
          var witdh = self.privateCollView.frame.width
        
          witdh = round(witdh / 2.4)
        
          let witdh2 = self.privateCollView.frame.width / 3.5
          
          return CGSize(width: UIDevice.isPad ? witdh2 : witdh , height: 150)
        
    }
     
 
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
        
    }
      
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
          
        return 10
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //did select
     
        /*if let vc = VideoViewController.instantiate(fromAppStoryboard: .main) {
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }*/
        
    }
    
    
}
