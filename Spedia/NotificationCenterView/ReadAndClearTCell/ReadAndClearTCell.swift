//
//  ReadAndClearTCell.swift
//  Spedia
//
//  Created by Viraj Sharma on 17/09/22.
//  Copyright © 2022 Viraj Sharma. All rights reserved.
//

import UIKit

class ReadAndClearTCell: UITableViewCell {

    @IBOutlet weak var markAsReadButton: CustomButton!
    @IBOutlet weak var clearAllButton: CustomButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.markAsReadButton.setTitle("mark_as_read_ph".localized(), for: .normal)
        self.clearAllButton.setTitle("clear_all_ph".localized(), for: .normal)
        
        self.markAsReadButton.clipsToBounds = true
        self.markAsReadButton.layer.cornerRadius = 6.0
        self.clearAllButton.clipsToBounds = true
        self.clearAllButton.layer.cornerRadius = 6.0
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
