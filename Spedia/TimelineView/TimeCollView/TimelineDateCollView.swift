//
//  TimelineDateCollView.swift
//  Spedia
//
//  Created by Viraj Sharma on 14/06/2021.
//  Copyright © 2021 Viraj Sharma. All rights reserved.
//

import UIKit
import SwiftyJSON

class TimelineDateCollView: UICollectionViewCell {
    
    //1 Cell Outlets.....
    @IBOutlet weak var containerVieww: UIView!
    @IBOutlet weak var dateLbl: CustomLabel!
    @IBOutlet weak var dayPHLbl: CustomLabel!
    @IBOutlet weak var tabButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        containerVieww.layer.cornerRadius = 5.0
        containerVieww.layer.borderWidth = 1
        containerVieww.layer.borderColor = Colors.APP_BORDER_GRAY?.cgColor
        
        self.dayPHLbl.text = "day_ph".localized()
        
    }
    
    func configureCellWithData(data: JSON) {
    
        self.dateLbl.text = data["Day"].stringValue
        
        if data["IsSelected"].boolValue {
            self.containerVieww.backgroundColor = Colors.APP_LIME_GREEN?.withAlphaComponent(0.5)
        } else {
            self.containerVieww.backgroundColor = UIColor.clear
        }
    
    }
    
}
