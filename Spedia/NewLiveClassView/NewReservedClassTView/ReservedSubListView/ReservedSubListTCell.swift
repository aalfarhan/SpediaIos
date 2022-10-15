//
//  ReservedSubListTCell.swift
//  Spedia
//
//  Created by Viraj Sharma on 14/02/22.
//  Copyright © 2022 Viraj Sharma. All rights reserved.
//

import UIKit
import SwiftyJSON

class ReservedSubListTCell: UITableViewCell {

    //Object's and Outlet's
    //@IBOutlet weak var containerVieww: UIView!
    @IBOutlet weak var shadowCellView: ShadowView!
    @IBOutlet weak var titleLbl: CustomLabel!
    @IBOutlet weak var dateTimeLbl: CustomLabel!
    @IBOutlet weak var joinButton: CustomButton!
    
    
    //Responsive...
    @IBOutlet weak var leftPeddingConst: NSLayoutConstraint!
    @IBOutlet weak var rightPeddingConst: NSLayoutConstraint!
    @IBOutlet weak var cellBottomSpace: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //1
        self.leftPeddingConst.constant = UIDevice.isPad ? 50.0 : 16.0
        self.rightPeddingConst.constant = UIDevice.isPad ? 50.0 : 16.0
        //self.shadowCellView.layer.cornerRadius = 0
        self.joinButton.setTitle("join".localized(), for: .normal)
        
    }

    func configureViewWithData(data:JSON, isLastRow: Bool, showReadMore: Bool) {
        
        self.titleLbl.text = data["Title" + Lang.code()].stringValue
        self.dateTimeLbl.text = data["ClassTime" + Lang.code()].stringValue
        
        self.joinButton.isHidden = !data["IsLive"].boolValue
        
        self.shadowCellView.layer.cornerRadius = 0
        
        if isLastRow {
            
            self.cellBottomSpace.constant = 0.0
            //self.shadowCellView.layer.cornerRadius = 10
            //self.shadowCellView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            
        } else {
            
            self.cellBottomSpace.constant = 0.0
            //self.shadowCellView.layer.cornerRadius = 0
            
        }
    }
    
    
}
