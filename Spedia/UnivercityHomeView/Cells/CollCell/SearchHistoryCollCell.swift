//
//  SearchHistoryCollCell.swift
//  Spedia
//
//  Created by Viraj Sharma on 13/06/2021.
//  Copyright © 2021 Viraj Sharma. All rights reserved.
//

import UIKit
import SwiftyJSON

class SearchHistoryCollCell: UICollectionViewCell {
    
    //1 Cell Outlets.....
    @IBOutlet weak var containerVieww: UIView!
    @IBOutlet weak var historyLabel: CustomLabel!
    @IBOutlet weak var crossButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        containerVieww.layer.cornerRadius = 5.0
        //containerVieww.layer.borderWidth = 1
        //containerVieww.layer.borderColor = UIColor.clear.cgColor
    }

    
    func configureCellWithData(data: JSON) {
    
        /*self.nameLabel.text = data["FullName"].stringValue
        self.pontsLabel.text = L102Language.isCurrentLanguageArabic() ?  data["Points"].stringValue + " " + "نقطة" : data["Points"].stringValue + " pts"
        
        self.rankLabel.text = "#" + data["Rank"].stringValue
        let url = URL(string: data["ProfilePicPath"].stringValue)
        self.imgView.kf.setImage(with: url, placeholder: UIImage.init(named: "profile_icon_placeholder"))*/
    
    }
    
}
