//
//  UniversityUnitCollCell.swift
//  Spedia
//
//  Created by Viraj Sharma on 22/06/2021.
//  Copyright © 2021 Viraj Sharma. All rights reserved.
//

import UIKit
import SwiftyJSON

class UniversityUnitCollCell: UICollectionViewCell {

    @IBOutlet weak var expandDownButton: UIButton!
    @IBOutlet weak var unitNameLbl: CustomLabel!
    @IBOutlet weak var chanpterCountLbl: CustomLabel!
    @IBOutlet weak var courseCountLbl: CustomLabel!
    @IBOutlet weak var bkgImageView: UIImageView!
    
    @IBOutlet weak var addToCartButton: UIButton!
    @IBOutlet weak var priceLbl: CustomLabel!
     
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.addToCartButton.layer.cornerRadius = self.addToCartButton.frame.height / 2
        self.addToCartButton.clipsToBounds = true
    }

    
    func configureCellWithData(data:JSON) {
      
        //1
        let titleStr = L102Language.isCurrentLanguageArabic() ? data[UnitDetailKey.NameAr].stringValue : data[UnitDetailKey.NameEn].stringValue

        self.unitNameLbl.text = titleStr
        
        //2
        let counrseCountStr = L102Language.isCurrentLanguageArabic() ? data[UnitDetailKey.CoursesCountAr].stringValue : data[UnitDetailKey.CoursesCountEn].stringValue

        self.courseCountLbl.text = counrseCountStr
        
        //3
        
        let chapterCountStr = L102Language.isCurrentLanguageArabic() ? data[UnitDetailKey.ChaptersCountAr].stringValue : data[UnitDetailKey.ChaptersCountEn].stringValue

        self.chanpterCountLbl.text = chapterCountStr
         
        
        //4
        
        let url = URL(string: data[UnitDetailKey.Image].stringValue)
        self.bkgImageView.kf.setImage(with: url, placeholder: UIImage(named: "collBkg"))
        
        
        //5
        //let unitPrice = data["ActualPriceText"].floatValue
        //let priceStr = String(format: "%.3f", unitPrice)
       
        let unitPriceStr = data["ActualPriceText"].stringValue
        priceLbl.text = unitPriceStr
         
        
        //6
        let hideOrNot = data["HideAddToCart"].boolValue
        
        self.addToCartButton.isHidden = hideOrNot
        
        self.priceLbl.isHidden = hideOrNot
        
    }
    
}
