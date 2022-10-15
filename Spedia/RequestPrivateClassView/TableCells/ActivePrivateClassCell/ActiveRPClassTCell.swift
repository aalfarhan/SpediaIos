//
//  ActiveRPClassTCell.swift
//  Spedia
//
//  Created by Viraj Sharma on 04/02/2021.
//  Copyright © 2021 Viraj Sharma. All rights reserved.
//

import UIKit

class ActiveRPClassTCell: UITableViewCell {

    //1
    @IBOutlet weak var containerVieww: UIView!
    @IBOutlet weak var classTitleLbl: CustomLabel!
    @IBOutlet weak var classTimeLbl: CustomLabel!
    @IBOutlet weak var joinButton: CustomButton!
    @IBOutlet weak var attacmentButton: UIButton!
    @IBOutlet weak var joinButtonWitdhConts: NSLayoutConstraint!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        // Initialization code
        self.containerVieww.layer.cornerRadius = 10.0
        self.containerVieww.layer.borderWidth = 2
        self.containerVieww.layer.borderColor = Colors.APP_BORDER_GRAY?.cgColor
        self.attacmentButton.layer.cornerRadius = self.attacmentButton.bounds.height / 2
    
        
        //For Parent Setup...
        self.joinButton.isHidden = isParentGlobal ? true : false
        self.joinButtonWitdhConts.constant = isParentGlobal ? 0.0 : 60.0
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    

}
