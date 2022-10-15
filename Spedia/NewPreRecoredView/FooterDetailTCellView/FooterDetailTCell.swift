//
//  FooterDetailTCell.swift
//  Spedia
//
//  Created by Viraj Sharma on 07/09/22.
//  Copyright © 2022 Viraj Sharma. All rights reserved.
//

import UIKit
import SwiftyJSON

class FooterDetailTCell: UITableViewCell {
    
    @IBOutlet weak var containerVieww: UIView!
    @IBOutlet weak var borderContainerVieww: UIView!
    @IBOutlet weak var subTitleLbl: CustomLabel!
    @IBOutlet weak var downArrowImage: UIImageView!
    @IBOutlet weak var expandTabButton: UIButton!
    @IBOutlet weak var descriptionLLbl: CustomLabel!
    
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
        
        let subTitleText = data["SubTitle" + Lang.code()].stringValue
        self.subTitleLbl.text = subTitleText
        
        let detailText = data["Content" + Lang.code()].stringValue
        self.descriptionLLbl.text = detailText
        
        
        //2 Arrow Animation
        self.downArrowImage?.transform = CGAffineTransform(rotationAngle: data["Expand"].boolValue ? .pi : 0)
        
        //4 Responsive Value..
        let descriptionSpace = data["Expand"].boolValue ? 10.0 : 0.0
        
        self.descriptionTopConst.constant = descriptionSpace
        self.descriptionBottomConst.constant = descriptionSpace
        
        self.layoutIfNeeded()
    }
    
}
