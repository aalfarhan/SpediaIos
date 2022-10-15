//
//  IntroVideoTCell.swift
//  Spedia
//
//  Created by Viraj Sharma on 11/02/22.
//  Copyright © 2022 Viraj Sharma. All rights reserved.
//

import UIKit
import Kingfisher

class IntroVideoTCell: UITableViewCell {

    @IBOutlet weak var containerVieww: UIView!
    @IBOutlet weak var bannerImageView: UIImageView!
    
    //Responsive...
    @IBOutlet weak var leftPeddingConst: NSLayoutConstraint!
    @IBOutlet weak var rightPeddingConst: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.containerVieww.layer.cornerRadius = 10.0
        self.containerVieww.clipsToBounds = true
        
        //Responsive...
        self.leftPeddingConst.constant = UIDevice.isPad ? 50.0 : 16.0
        self.rightPeddingConst.constant = UIDevice.isPad ? 50.0 : 16.0
        
    }

    func configureViewWithData(imageUrl: String) {
        //...
        let imageLink = URL(string: imageUrl)
        self.bannerImageView.kf.setImage(with: imageLink, placeholder: UIImage.init(named: "subscriptionBkg"))
    }
    
}
