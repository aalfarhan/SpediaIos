//
//  ReadMoreFooterTCell.swift
//  Spedia
//
//  Created by Viraj Sharma on 15/02/22.
//  Copyright © 2022 Viraj Sharma. All rights reserved.
//

import UIKit

class ReadMoreFooterTCell: UITableViewCell {
    
    //Object's and Outlet's
    @IBOutlet weak var containerVieww: UIView!
    @IBOutlet weak var shadowCellView: ShadowView!
    @IBOutlet weak var readMoreButton: CustomButton!
    
    //Responsive...
    @IBOutlet weak var leftPeddingConst: NSLayoutConstraint!
    @IBOutlet weak var rightPeddingConst: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //1
        self.leftPeddingConst.constant = UIDevice.isPad ? 50.0 : 16.0
        self.rightPeddingConst.constant = UIDevice.isPad ? 50.0 : 16.0
        
        self.shadowCellView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }
    
    
    func configureFooterViewWithData(isExpanded : Bool, isReadMore : Bool, subListCount : Int) {
        
        //1
        if isReadMore {
            self.readMoreButton.setTitle("read_less".localized(), for: .normal)
        } else {
            self.readMoreButton.setTitle("read_more".localized(), for: .normal)
        }
        
        //2
        if isExpanded {
            
            if subListCount <= 2 {
                self.readMoreButton.isHidden = true
            } else {
                self.readMoreButton.isHidden = false
            }
            
        } else {
            
            self.readMoreButton.isHidden = true
        }
        
    }
    
}
