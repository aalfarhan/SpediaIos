//
//  FeaturesInnerTCell.swift
//  Spedia
//
//  Created by Viraj Sharma on 05/09/22.
//  Copyright © 2022 Viraj Sharma. All rights reserved.
//

import UIKit
import SwiftyJSON
import Kingfisher

class FeaturesInnerTCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    
    //For Only Title Type
    //@IBOutlet weak var titleView: UIView!
    //@IBOutlet weak var titleLbl: CustomLabel!
    
    //For Only Icons and Title Type
    @IBOutlet weak var iconView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var iconTitleLbl: CustomLabel!
    
    //@IBOutlet weak var containerBottomConst: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.iconView.isHidden = true
    }
    
    
    func configureIconViewWith(dataModel: JSON) {
        
        self.iconView.isHidden = false
        self.iconTitleLbl.text = dataModel["Text" + Lang.code()].stringValue
        
        let imageLink = URL(string: dataModel["IconPath"].stringValue)
        self.iconImageView.kf.setImage(with: imageLink, placeholder: UIImage.init(named: "dummyIconViewImage.pdf"))
    
    }
    
}
