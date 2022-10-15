//
//  ContentDetailTCell.swift
//  Spedia
//
//  Created by Viraj Sharma on 27/01/22.
//  Copyright © 2022 Viraj Sharma. All rights reserved.
//

import UIKit
import SwiftyJSON

class ContentDetailTCell: UITableViewCell {

    @IBOutlet weak var containerVieww: UIView!
    @IBOutlet weak var borderContainerVieww: UIView!
    @IBOutlet weak var titleLbl: CustomLabel!
    @IBOutlet weak var subTitleLbl: CustomLabel!
    @IBOutlet weak var downArrowImage: UIImageView!
    @IBOutlet weak var expandTabButton: UIButton!
    @IBOutlet weak var descriptionHTMLLbl: CustomLabel!
    
    //Responsive..
    @IBOutlet weak var descriptionTopConst: NSLayoutConstraint!
    @IBOutlet weak var descriptionBottomConst: NSLayoutConstraint!
    
    var isForFacultyMembersView = false
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.borderContainerVieww.layer.cornerRadius = 5.0
        self.borderContainerVieww.clipsToBounds = true
        self.borderContainerVieww.layer.borderColor = Colors.APP_LIGHT_GREEN?.cgColor
        self.borderContainerVieww.layer.borderWidth = 1.5
    }

    func configureViewWithData(data: JSON) {
        
        //1 Text's OR Label's
        if isForFacultyMembersView {
            
          self.descriptionHTMLLbl.text = data["Content" + Lang.code()].stringValue
          self.descriptionHTMLLbl.textAlignment = L102Language.isCurrentLanguageArabic() ? .right : .left
            
        } else {
            let descriptionHtmlText = data["Content" + Lang.code()].stringValue
            self.descriptionHTMLLbl.attributedText = descriptionHtmlText.htmlToAttributedString
        }
        
        let titleText = data["Title" + Lang.code()].stringValue
        self.titleLbl.text = titleText
        self.titleLbl.textAlignment = L102Language.isCurrentLanguageArabic() ? .right : .left
        
        let subTitleText = data["SubTitle" + Lang.code()].stringValue
        self.subTitleLbl.text = subTitleText
        self.subTitleLbl.textAlignment = L102Language.isCurrentLanguageArabic() ? .right : .left
    
        
        //2 Arrow Animation
        self.downArrowImage?.transform = CGAffineTransform(rotationAngle: data["Expand"].boolValue ? .pi : 0)
        
        //3 Read More
        //self.readMoreHeightConst.constant = data["Expand"].boolValue ? 30.0 : 0.0
        //self.readMoreButton.setTitle( data["ReadMore"].boolValue ? "read_less".localized() : "read_more".localized(), for: .normal)
    
        //4 Responsive Value..
        let descriptionSpace = data["Expand"].boolValue ? 10.0 : 0.0
        
        self.descriptionTopConst.constant = descriptionSpace
        self.descriptionBottomConst.constant = descriptionSpace
        
        self.layoutIfNeeded()
    }
    
}
