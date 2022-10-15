//
//  QuestionFooterTCell.swift
//  Spedia
//
//  Created by Viraj Sharma on 16/06/2020.
//  Copyright © 2020 Viraj Sharma. All rights reserved.
//

import UIKit

class QuestionFooterTCell: UITableViewCell {

    @IBOutlet weak var confirmButton: CustomButton!
    @IBOutlet weak var nextButton: CustomButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.confirmButton.setTitle("confirm_ph".localized(), for: .normal)
        self.nextButton.setTitle("next".localized(), for: .normal)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func reloadConfirmButton(isLastQ: Bool) {
        
        if isLastQ {
            self.nextButton.isHidden = true
            self.confirmButton.isHidden = false
        } else {
            self.nextButton.isHidden = false
            self.confirmButton.isHidden = true
        }
        
    }
    
}
