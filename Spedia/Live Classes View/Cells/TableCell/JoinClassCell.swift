//
//  JoinClassCell.swift
//  Spedia
//
//  Created by Viraj Sharma on 30/07/2020.
//  Copyright © 2020 Viraj Sharma. All rights reserved.
//

import UIKit
import SwiftyJSON


class JoinClassCell: UITableViewCell {

    //1
    @IBOutlet weak var containerVieww: UIView!
    @IBOutlet weak var classTitleLbl: CustomLabel!
    @IBOutlet weak var classTimeLbl: CustomLabel!
    @IBOutlet weak var joinButton: CustomButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.joinButton.setTitle("join".localized(), for: .normal)
    }

    
    func configureViewWithData(data: JSON) {
        
        self.classTitleLbl.text = data["Title" + Lang.code()].stringValue
        self.classTimeLbl.text = data["Details" + Lang.code()].stringValue
        
        if data["IsLive"].boolValue {
            self.joinButton.isUserInteractionEnabled = true
            self.joinButton.alpha = 1.0
            self.joinButton.setTitle("join".localized(), for: .normal)
        } else {
            self.joinButton.isUserInteractionEnabled = false
            self.joinButton.alpha = 0.5
            self.joinButton.setTitle("pending_ph".localized(), for: .normal)
        }
    }
    
}
