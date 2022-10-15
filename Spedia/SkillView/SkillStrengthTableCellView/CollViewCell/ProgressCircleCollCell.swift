//
//  ProgressCircleCollCell.swift
//  Spedia
//
//  Created by Viraj Sharma on 01/01/2021.
//  Copyright © 2021 Viraj Sharma. All rights reserved.
//

import UIKit
import UICircularProgressRing

class ProgressCircleCollCell: UICollectionViewCell {

    @IBOutlet weak var containerVieww: UIView!
    @IBOutlet var circularProgressView: UICircularProgressRing!
    @IBOutlet weak var nameLabel: CustomLabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.containerVieww.layer.cornerRadius = 10.0
        self.containerVieww.layer.borderWidth = 1
        self.containerVieww.layer.borderColor = Colors.APP_BORDER_GRAY?.cgColor
    }

    
    
}
