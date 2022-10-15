//
//  SkillSubCategoryCollCell.swift
//  Spedia
//
//  Created by Viraj Sharma on 29/12/2020.
//  Copyright © 2020 Viraj Sharma. All rights reserved.
//

import UIKit
import SwiftyJSON

class SkillSubCategoryCollCell: UICollectionViewCell {

    @IBOutlet weak var contianerVieww: UIView!
    @IBOutlet weak var tapButton: UIButton!
    @IBOutlet weak var categoryimageView: UIImageView!
    @IBOutlet weak var categoryNameLabel: CustomLabel!
    @IBOutlet weak var categoryDetailLabel: CustomLabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.contianerVieww.layer.cornerRadius = 10.0
        self.contianerVieww.layer.borderWidth = 1
        self.contianerVieww.layer.borderColor = Colors.APP_LIME_GREEN?.cgColor
    }

    func configureCellWithData(data: JSON) {
        
        //1
        self.categoryNameLabel.text = L102Language.isCurrentLanguageArabic() ? data["TitleAr"].stringValue : data["TitleEn"].stringValue
        
        //2
        self.categoryDetailLabel.text = L102Language.isCurrentLanguageArabic() ? data["Description"].stringValue : data["Description"].stringValue
        //3
        let url = URL(string: data["IconPath"].stringValue)
        self.categoryimageView.kf.setImage(with: url, placeholder: nil)
        
        
    }
    
}
