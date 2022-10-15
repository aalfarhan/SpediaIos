//
//  ParentChildsCollCell.swift
//  Spedia
//
//  Created by Viraj Sharma on 06/11/2020.
//  Copyright © 2020 Viraj Sharma. All rights reserved.
//

import UIKit

class ParentChildsCollCell: UICollectionViewCell {

    //Object...
    @IBOutlet weak var childNameLbl: CustomLabel!
    @IBOutlet weak var gradeLbl: CustomLabel!
    @IBOutlet weak var childImage: UIImageView!
     
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.childImage.layer.cornerRadius = self.childImage.bounds.height / 2
        self.childImage.layer.masksToBounds = true
    }

}
