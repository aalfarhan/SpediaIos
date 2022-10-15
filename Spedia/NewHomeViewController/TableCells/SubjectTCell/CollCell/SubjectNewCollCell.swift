//
//  SubjectNewCollCell.swift
//  Spedia
//
//  Created by Viraj Sharma on 23/01/22.
//  Copyright © 2022 Viraj Sharma. All rights reserved.
//

import UIKit
import SwiftyJSON
import Kingfisher


class SubjectNewCollCell: UICollectionViewCell {

    @IBOutlet weak var containerVieww: UIView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var nameLbl: CustomLabel!
    @IBOutlet weak var tabCellButton: UIButton!
    
    @IBOutlet weak var priceStackView: UIStackView!
    @IBOutlet weak var actualPriceLbl: CustomLabel!
    @IBOutlet weak var discountPriceLbl: CustomLabel!
    
    var whereFrom = ""
    
    //Responsive...
    @IBOutlet weak var titleTopPaddingConst: NSLayoutConstraint!
    @IBOutlet weak var priceStackHeightConst: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.containerVieww.layer.cornerRadius = 5.0
        self.containerVieww.clipsToBounds = false
        
        self.imgView.layer.cornerRadius = 5.0
        self.imgView.clipsToBounds = true
        
        self.nameLbl.numberOfLines = L102Language.isCurrentLanguageArabic() ? 1 : 2
        
    }
    
    
    func configureViewWithData(data:JSON) {

        if self.whereFrom == WhereFromAmIKeys.videoLibraryPage {
            
            //1
            let nameStr = data["SubjectName" + Lang.code()].stringValue
            self.nameLbl.text = nameStr

            //1.1 Responsive...
            self.titleTopPaddingConst.constant = nameStr.count > 17 ? 0.0 : 10
            self.priceStackHeightConst.constant = nameStr.count > 17 ? 18 : 25
            self.priceStackView.isHidden = false
            
            
            //2
            let imageUrl = URL(string: data["SubjectImage"].stringValue)
            self.imgView.kf.setImage(with: imageUrl, placeholder: nil)
            
            //3
            //3.1
            let discountPriceText = data["PreviousPriceText"].stringValue
            self.discountPriceLbl.attributedText = discountPriceText.strikeThrough(showOrNot: true)
            
            //3.2
            let acutalPriceText = data["ActualPriceText"].stringValue
            self.actualPriceLbl.text = acutalPriceText
            
            //3.3 PreviousPrice ActualPrice
            self.discountPriceLbl.isHidden = true
            
            let discountPriceDouble = data["PreviousPrice"].floatValue
            let actualPriceDouble = data["ActualPrice"].floatValue
            
            if discountPriceDouble != actualPriceDouble {
                self.discountPriceLbl.isHidden = false
            }
            
            
            
        } else {
            
            //1
            let nameStr = data["Title" + Lang.code()].stringValue
            self.nameLbl.text = nameStr
            self.titleTopPaddingConst.constant = nameStr.count > 17 ? 3.0 : 10
            
            //2
            let imageUrl = URL(string: data["CourseImage"].stringValue)
            self.imgView.kf.setImage(with: imageUrl, placeholder: nil)
            
            //3
            self.priceStackView.isHidden = true
            
        }
        

    }

}

