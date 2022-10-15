//
//  LeaderCollCell.swift
//  Spedia
//
//  Created by Viraj Sharma on 23/12/2020.
//  Copyright © 2020 Viraj Sharma. All rights reserved.
//

import UIKit
import SwiftyJSON

class LeaderCollCell: UICollectionViewCell {
    
    //1 Cell Outlets.....
    @IBOutlet weak var containerVieww: UIView!
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var rankLabel: CustomLabel!
    @IBOutlet weak var pontsLabel: CustomLabel!
    @IBOutlet weak var nameLabel: CustomLabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        containerVieww.layer.cornerRadius = 10.0
        containerVieww.layer.borderWidth = 1
        containerVieww.layer.borderColor = Colors.APP_BORDER_GRAY?.cgColor
        
        imgView.layer.cornerRadius = imgView.bounds.height / 2
        
    }

    func configureCellWithData(data: JSON) {
    
        self.nameLabel.text = data["FullName"].stringValue
        
        self.pontsLabel.text = L102Language.isCurrentLanguageArabic() ?  data["Points"].stringValue + " " + "نقطة" : data["Points"].stringValue + " pts"
        
        self.rankLabel.text = data["Rank"].stringValue
        let url = URL(string: data["ProfilePicPath"].stringValue)
        self.imgView.kf.setImage(with: url, placeholder: UIImage.init(named: "profile_icon_placeholder"))
    
    }
    
}

