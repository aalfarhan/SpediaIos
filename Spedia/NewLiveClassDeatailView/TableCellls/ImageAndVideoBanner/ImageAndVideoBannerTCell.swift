//
//  ImageAndVideoBannerTCell.swift
//  Spedia
//
//  Created by Viraj Sharma on 27/01/22.
//  Copyright © 2022 Viraj Sharma. All rights reserved.
//

import UIKit
import Kingfisher

class ImageAndVideoBannerTCell: UITableViewCell {

    @IBOutlet weak var containerVieww: UIView!
    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var blackOverLayerView: UIView!
    
    //Responsive
    //@IBOutlet weak var bannerTotalWitdhConst: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.bannerImageView.layer.cornerRadius = 10.0
        self.bannerImageView.clipsToBounds = true
        
        self.blackOverLayerView.layer.cornerRadius = 10.0
        self.blackOverLayerView.clipsToBounds = true
        
        //self.bannerTotalWitdhConst.constant = UIDevice.isPad ? (DeviceSize.screenWidth - 50.0) : (DeviceSize.screenWidth - 16.0)
    }

    func configureViewWithData(imageUrl: String) {
        //...
        let imageLink = URL(string: imageUrl)
        self.bannerImageView.kf.setImage(with: imageLink, placeholder: UIImage.init(named: "subscriptionBkg"))
    }
    
}
