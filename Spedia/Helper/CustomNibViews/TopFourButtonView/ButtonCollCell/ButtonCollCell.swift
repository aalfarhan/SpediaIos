//
//  ButtonCollCell.swift
//  Spedia
//
//  Created by Viraj Sharma on 28/08/22.
//  Copyright © 2022 Viraj Sharma. All rights reserved.
//

import UIKit

class ButtonCollCell: UICollectionViewCell {

    @IBOutlet var titleLabel: CustomLabel!
    @IBOutlet var tapButton: UIButton!
    
    var cellSelectedIndex = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.titleLabel.clipsToBounds = true
        self.titleLabel.layer.cornerRadius = self.titleLabel.frame.height/2
        self.titleLabel.backgroundColor = .clear
        self.titleLabel.textColor = .white
    
    }

    func whiceButtonActiveWithTag (index : Int) { //preRecodredSelectedIndexGlobal = tag
        if index == self.cellSelectedIndex {
            self.titleLabel.textColor = Colors.APP_LIGHT_GREEN
            self.titleLabel.backgroundColor = .white
        } else {
            self.titleLabel.textColor = .white
            self.titleLabel.backgroundColor = .clear
        }
    }
}
