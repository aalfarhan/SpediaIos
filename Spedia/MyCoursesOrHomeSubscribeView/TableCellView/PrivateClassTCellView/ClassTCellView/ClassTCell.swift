//
//  ClassTCell.swift
//  Spedia
//
//  Created by Viraj Sharma on 08/02/22.
//  Copyright © 2022 Viraj Sharma. All rights reserved.
//

import UIKit
import SwiftyJSON

class ClassTCell: UITableViewCell {

    //1
    @IBOutlet weak var containerVieww: UIView!
    @IBOutlet weak var classTitleLbl: CustomLabel!
    @IBOutlet weak var classTimeLbl: CustomLabel!
    @IBOutlet weak var joinButton: CustomButton!
    
    //Responsive...
    @IBOutlet weak var leftPeddingConst: NSLayoutConstraint!
    @IBOutlet weak var rightPeddingConst: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.joinButton.setTitle("pending_ph".localized(), for: .normal)
        
        self.leftPeddingConst.constant = UIDevice.isPad ? 50.0 : 16.0
        self.rightPeddingConst.constant = UIDevice.isPad ? 50.0 : 16.0
        
    }
    
    func configureViewWithData(data: JSON) {
        
        self.classTitleLbl.text = data["Title" + Lang.code()].stringValue
        self.classTimeLbl.text = data["ClassTime" + Lang.code()].stringValue
        
        let buttonTitleStr = data["Status" + Lang.code()].stringValue
        self.joinButton.setTitle(buttonTitleStr, for: .normal)
        
        let statusStr = data["StatusEn"].stringValue.lowercased()
        
        switch statusStr {
        case "join":
            self.joinButton.isUserInteractionEnabled = true
            self.joinButton.backgroundColor = UIColor.init(hexaRGB: "FF3B30") //RED
        case "approved":
            self.joinButton.isUserInteractionEnabled = false
            self.joinButton.backgroundColor = UIColor.init(hexaRGB: "34C759") //GREEN
        case "pending":
            self.joinButton.isUserInteractionEnabled = false
            self.joinButton.backgroundColor = UIColor.init(hexaRGB: "F98D23") //YELLOW
        default:
            self.joinButton.isUserInteractionEnabled = false
            self.joinButton.backgroundColor = UIColor.init(hexaRGB: "F98D23") //YELLOW IF UNKOWN
        }
        
        //self.joinButton.isHidden = !data["IsLive"].boolValue
         
    }
    
}
