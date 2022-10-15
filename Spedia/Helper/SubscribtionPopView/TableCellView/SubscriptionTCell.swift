//
//  SubscriptionTCell.swift
//  Spedia
//
//  Created by Viraj Sharma on 05/02/22.
//  Copyright © 2022 Viraj Sharma. All rights reserved.
//

import UIKit
import SwiftyJSON

class SubscriptionTCell: UITableViewCell {

    @IBOutlet weak var contianerVieww: UIView!
    @IBOutlet weak var redFlagView: UIView!
    @IBOutlet weak var subscriptionTypeLbl: CustomLabel!
    @IBOutlet weak var priceLbl: CustomLabel!
    @IBOutlet weak var expiringOnLbl: CustomLabel!
    @IBOutlet weak var youWillSaveLbl: CustomLabel!
    @IBOutlet weak var tabCellButton: UIButton!
    
    //Responsive...
    @IBOutlet weak var listRowHeightConst: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.contianerVieww.layer.cornerRadius = 10.0
        self.contianerVieww.layer.borderColor = UIColor.lightGray.cgColor
        self.contianerVieww.layer.borderWidth = 2.0
        self.contianerVieww.clipsToBounds = true
        
        
    }

    func configureViewWithData(dataModel: JSON) {
        
        let typeStr = dataModel["MonthOrSem" + Lang.code()].stringValue
        self.subscriptionTypeLbl.text = typeStr
        
        let priceStr = dataModel["PriceText" + Lang.code()].stringValue
        self.priceLbl.text = priceStr
        
        let expiringOnStr = dataModel["ExpireOn" + Lang.code()].stringValue
        
        print("\n\n Expire String-----> \(expiringOnStr)\n\n")
        
        self.expiringOnLbl.text = expiringOnStr
        
        let noteStr = dataModel["Note" + Lang.code()].stringValue
        self.redFlagView.isHidden = noteStr.isEmpty ? true : false
        self.youWillSaveLbl.text = noteStr
        
        
        if dataModel["IsSelected"].boolValue {
            self.contianerVieww.layer.borderColor = Colors.APP_LIGHT_GREEN?.cgColor
        } else {
            self.contianerVieww.layer.borderColor = UIColor.lightGray.cgColor
        }
        
    }
    
}
