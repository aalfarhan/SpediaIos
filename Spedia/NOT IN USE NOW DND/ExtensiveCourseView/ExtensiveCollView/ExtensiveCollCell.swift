//
//  ExtensiveCollCell.swift
//  Spedia
//
//  Created by Viraj Sharma on 25/12/2020.
//  Copyright © 2020 Viraj Sharma. All rights reserved.
//

import UIKit

class ExtensiveCollCell: UICollectionViewCell {

    //1 Cell Outlets.....
    @IBOutlet weak var containerVieww: UIView!
    
    @IBOutlet weak var iconContainerVieww: UIView!
    @IBOutlet weak var subjectIcon: UIImageView!
    @IBOutlet weak var viewDetailButton: CustomButton!
    @IBOutlet weak var subjectTitlteLbl: CustomLabel!
    @IBOutlet weak var subjectSubtitleLbl: CustomLabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        containerVieww.layer.cornerRadius = 10.0
        containerVieww.layer.borderWidth = 1
        containerVieww.layer.borderColor = Colors.APP_BORDER_GRAY?.cgColor
        
        iconContainerVieww.layer.cornerRadius = iconContainerVieww.bounds.height / 2
        
    }

}
