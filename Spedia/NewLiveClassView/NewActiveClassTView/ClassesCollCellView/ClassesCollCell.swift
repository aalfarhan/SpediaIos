//
//  ClassesCollCell.swift
//  Spedia
//
//  Created by Viraj Sharma on 11/02/22.
//  Copyright © 2022 Viraj Sharma. All rights reserved.
//

import UIKit
import SwiftyJSON
import Kingfisher

class ClassesCollCell: UICollectionViewCell {
    
    @IBOutlet weak var containerVieww: UIView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var nameLbl: CustomLabel!
    @IBOutlet weak var dateTimeLbl: CustomLabel!
    @IBOutlet weak var descriptionLbl: CustomLabel!
    
    @IBOutlet weak var priceStackView: UIStackView!
    @IBOutlet weak var actualPriceLbl: CustomLabel!
    @IBOutlet weak var discountPriceLbl: CustomLabel!
    
    @IBOutlet weak var tabCellButton: UIButton!
    @IBOutlet weak var imageViewHeight: NSLayoutConstraint!
    
    var isOnlyClassNameAndTimeBool = false
    
    
    //Responsive...
    @IBOutlet weak var nameLabelTopSpaceConst: NSLayoutConstraint!
    @IBOutlet weak var nameLabelBottomSpaceConst: NSLayoutConstraint!
    @IBOutlet weak var dateTimeLabelBottomSpaceConst: NSLayoutConstraint!
    @IBOutlet weak var discriptionLabelBottomSpaceConst: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        self.containerVieww.layer.cornerRadius = 10.0
        self.containerVieww.clipsToBounds = false
        
        self.imgView.layer.cornerRadius = 10.0
        self.imgView.clipsToBounds = true
        
        //Aspect Ration:-
        //2.3:1 Ratio Formula
        let devideValue = UIDevice.isPad ? 2.3 : 2.3
        let ratioHeight = (imgView.frame.width / devideValue) * 1
        self.imageViewHeight.constant = ratioHeight
        
        if L102Language.isCurrentLanguageArabic() {
            self.nameLabelTopSpaceConst.constant = 0.0
            self.nameLabelBottomSpaceConst.constant = 0.0
            self.dateTimeLabelBottomSpaceConst.constant = 0.0
            self.discriptionLabelBottomSpaceConst.constant = 0.0
        }
        
    }
    
    func reloadCollCellUI() {
        
        //Multiple Use Same Cell...
        self.priceStackView.isHidden = isOnlyClassNameAndTimeBool
        self.descriptionLbl.isHidden = isOnlyClassNameAndTimeBool
        
        self.layoutIfNeeded()
    }
    
    
    func configureViewWithData(data:JSON) {
        
        self.nameLbl.text = data["CourseName" + Lang.code()].stringValue
        self.dateTimeLbl.text = data["CourseTime" + Lang.code()].stringValue
        
        //...
        let imageUrl = URL(string: data["CourseImage"].stringValue)
        self.imgView.kf.setImage(with: imageUrl, placeholder: nil)
        
        if isOnlyClassNameAndTimeBool == false {
            //1
            let descriptionText = data["CourseDescription" + Lang.code()].stringValue
            self.descriptionLbl.text = descriptionText
            
            //2
            let discountPriceText = data["PreviousPriceText"].stringValue
            self.discountPriceLbl.attributedText = discountPriceText.strikeThrough(showOrNot: true)
            
            //3
            let acutalPriceText = data["ActualPriceText"].stringValue
            self.actualPriceLbl.text = acutalPriceText
            
            //4 PreviousPrice ActualPrice
            self.discountPriceLbl.isHidden = true
            
            let discountPriceDouble = data["PreviousPrice"].floatValue
            let actualPriceDouble = data["Price"].floatValue
            
            if discountPriceDouble != actualPriceDouble {
                self.discountPriceLbl.isHidden = false
            }
        }
    }

}
