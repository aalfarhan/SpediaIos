//
//  AnswerRelatedCollCell.swift
//  Spedia
//
//  Created by Viraj Sharma on 12/07/2021.
//  Copyright © 2021 Viraj Sharma. All rights reserved.
//

import UIKit
import SwiftyJSON

class AnswerRelatedCollCell: UICollectionViewCell {

    //1 Outlets.......
    @IBOutlet weak var containerVieww: UIView!
    @IBOutlet weak var titleLabel: CustomLabel!
    @IBOutlet weak var answerTabButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        self.containerVieww.layer.cornerRadius = 10
        self.containerVieww.layer.borderWidth = 1
        self.containerVieww.layer.borderColor = Colors.APP_BORDER_GRAY?.cgColor
        self.containerVieww.backgroundColor = .clear
        
    }

    
    func configureViewWithDate(data: JSON) {
        //+Lang.code()
        self.titleLabel.text = data["Title"+Lang.code()].stringValue
        
    }
    
}
