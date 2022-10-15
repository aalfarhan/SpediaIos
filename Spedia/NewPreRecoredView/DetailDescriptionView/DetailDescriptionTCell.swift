//
//  DetailDescriptionTCell.swift
//  Spedia
//
//  Created by Viraj Sharma on 27/01/22.
//  Copyright © 2022 Viraj Sharma. All rights reserved.
//

import UIKit
import SwiftyJSON
import Kingfisher
 
protocol DetailDescriptionTCellDelegate {
    func didInnerTableViewReloadDone()
}

class DetailDescriptionTCell: UITableViewCell {
    
    //MARK: Main Outlets
    //Obj..
    var delegateObj : DetailDescriptionTCellDelegate?
    @IBOutlet weak var containerVieww: UIView!
    
    //1 Banner Image View
    @IBOutlet weak var bannerContView: UIView!
    @IBOutlet weak var bannerImageView: UIImageView!
    
    //2 Features View
    @IBOutlet weak var featureHeaderTitleLbl: CustomLabel!
    @IBOutlet weak var featureTableContView: UIView!
    @IBOutlet weak var featuresListView: UITableView!
    @IBOutlet weak var featuresTableHeightConst: NSLayoutConstraint!
    var listJson = JSON()
    var isFirstTableLoadingDone = false
    
    //3 Price & Buttons View
    @IBOutlet weak var priceAndButtonsContView: UIView!
    @IBOutlet weak var actualPriceLbl: CustomLabel!
    @IBOutlet weak var discountPriceLbl: CustomLabel!
    @IBOutlet weak var discountPriceView: UIView!
    @IBOutlet weak var subscribeButton: CustomButton!
    @IBOutlet weak var freeTrailButton: CustomButton!
    
    //Responsive..
    @IBOutlet weak var freeHeightConst: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setUpForBannerView()
        self.setUpForFeaturesView()
        self.setUpForPriceButtonsView()
    }
    
}



//MARK: 1 BANNER VIEW SETUP EXTENSION
extension DetailDescriptionTCell {
    
    func setUpForBannerView() {
        self.bannerContView.layer.cornerRadius = 10.0
        self.bannerContView.clipsToBounds = true
    }
    
    func configureBannerViewWithString(imageUrl: String) {
        //...
        let imageLink = URL(string: imageUrl)
        self.bannerImageView.kf.setImage(with: imageLink, placeholder: UIImage.init(named: "subscriptionBkg"))
    }
}


//MARK: 2 FEATURE TABLE VIEW SETUP EXTENSION
extension DetailDescriptionTCell: UITableViewDelegate, UITableViewDataSource {
    
    func setUpForFeaturesView() {
        //1
        
        //2
        self.featuresListView.register(UINib(nibName : "FeaturesInnerTCell", bundle: nil), forCellReuseIdentifier: "featuresInnerTCell")
        self.featuresListView.dataSource = self
        self.featuresListView.delegate = self
        
        self.featuresListView.estimatedRowHeight = 40
        self.featuresListView.rowHeight = UITableView.automaticDimension
        
    }
    
    var tableViewHeight: CGFloat {
        self.featuresListView.layoutIfNeeded()
        self.layoutIfNeeded()
        return self.featuresListView.contentSize.height
    }
    
    func configureFeaturesListWithData(featuresDataModel: JSON) {
        
        //0
        self.featureHeaderTitleLbl.text = featuresDataModel["Title"+Lang.code()].stringValue
        
        //1
        self.listJson = featuresDataModel["ObjDescriptionDetails"]
        
        //2
        self.featuresListView.reloadData()
        
        //3
        DispatchQueue.main.async {
            self.featuresListView.scrollToBottom(animated: false)
            self.featuresListView.safeScrollToRow(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
            self.featuresTableHeightConst.constant = self.tableViewHeight
            self.featuresListView.layoutIfNeeded()
            self.layoutIfNeeded()
        }
        
        //4
        if self.isFirstTableLoadingDone == false {
        self.featuresListView.reloadDataWithBlock {
            self.delegateObj?.didInnerTableViewReloadDone()
            self.isFirstTableLoadingDone = true
          }
        }
        
    }
    
    //===========================
    //MARK: LIST VIEW
    //===========================
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listJson.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.featuresListView.dequeueReusableCell(withIdentifier: "featuresInnerTCell") as? FeaturesInnerTCell
        cell?.selectionStyle = .none
        
        cell?.configureIconViewWith(dataModel: self.listJson[indexPath.row])
        
        return cell ?? UITableViewCell()
        
    }
 
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

}



//MARK: 3 PRICE AND BUTTONS VIEW SETUP EXTENSION
extension DetailDescriptionTCell {
    
    func setUpForPriceButtonsView() {
        self.freeTrailButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: L102Language.isCurrentLanguageArabic() ? 10 : 0, bottom: 0, right: L102Language.isCurrentLanguageArabic() ? 0 : 10)
    }
    
    func configureViewWithData(data: JSON) {
        
        let subscribeButtonStr = data["SubscribeButton" + Lang.code()].stringValue
        let freeTrailButtonStr = data["FreeTrialButton" + Lang.code()].stringValue
        
        self.subscribeButton.setTitle(subscribeButtonStr, for: .normal)
        self.freeTrailButton.setTitle(freeTrailButtonStr, for: .normal)
        self.freeTrailButton.isHidden = data["HideFreeTrial"].boolValue
        self.freeHeightConst.constant =  data["HideFreeTrial"].boolValue ? 0.0 : 44.0
        
        //1
        //let descriptionHtmlText = data["Description" + Lang.code()].stringValue
        //self.descriptionLbl.attributedText = descriptionHtmlText.htmlToAttributedString
        
        //2
        let discountPriceText = data["PreviousPriceText"].stringValue
        self.discountPriceLbl.attributedText = discountPriceText.strikeThrough(showOrNot: true)
        
        //3
        let acutalPriceText = data["ActualPriceText"].stringValue
        self.actualPriceLbl.text = acutalPriceText
        
        //4 PreviousPrice ActualPrice
        self.discountPriceView.isHidden = true
        self.actualPriceLbl.textAlignment = .center
        let discountPriceDouble = data["PreviousPrice"].floatValue
        let actualPriceDouble = data["ActualPrice"].floatValue
        
        if discountPriceDouble != actualPriceDouble {
            self.discountPriceView.isHidden = false
            self.actualPriceLbl.textAlignment = L102Language.isCurrentLanguageArabic() ? .right : .left
            self.discountPriceLbl.textAlignment = L102Language.isCurrentLanguageArabic() ? .left : .right
        }
        
    }
}
