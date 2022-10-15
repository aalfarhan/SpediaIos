//
//  SubUnitCell.swift
//  Spedia
//
//  Created by Viraj Sharma on 09/06/2020.
//  Copyright © 2020 Viraj Sharma. All rights reserved.
//

import UIKit
import SwiftyJSON

class SubUnitCollCell: UICollectionViewCell {

    @IBOutlet weak var expandDownButton: UIButton!
    @IBOutlet weak var unitNameLbl: CustomLabel!
    @IBOutlet weak var chanpterCountLbl: CustomLabel!
    @IBOutlet weak var courseCountLbl: CustomLabel!
    @IBOutlet weak var bkgImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
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
        
    }
    
}
