//
//  ShortcutCollCell.swift
//  Spedia
//
//  Created by Viraj Sharma on 09/01/2021.
//  Copyright © 2021 Viraj Sharma. All rights reserved.
//

import UIKit
import SwiftyJSON


class ShortcutCollCell: UICollectionViewCell {

    @IBOutlet weak var containerVieww: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: CustomLabel!
    @IBOutlet weak var showAllButton: CustomButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    
    func configureCellData(data: JSON) {
      
        //1
        let titleStr = L102Language.isCurrentLanguageArabic() ? data["TitleAr"].stringValue : data["TitleEn"].stringValue
        
        //2
        let buttonStr = L102Language.isCurrentLanguageArabic() ? data["ButtonTitleAr"].stringValue : data["ButtonTitleEn"].stringValue
        
        //3
        let type = data["Type"].stringValue
        
        
        if type.contains("book") {
            self.iconImageView.image = #imageLiteral(resourceName: "icon_book")
        }
        
        if type.contains("previoustest") {
            self.iconImageView.image = #imageLiteral(resourceName: "icon_history")
        }
        
        if type.contains("quiz") {
            self.iconImageView.image = #imageLiteral(resourceName: "icon_clipboard")
        }
        
        
        //Set
        self.titleLabel.text = titleStr
        self.showAllButton.setTitle(buttonStr, for: .normal)
    }
    
    
}
