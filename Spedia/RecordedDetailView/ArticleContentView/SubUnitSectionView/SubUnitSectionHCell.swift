//
//  SubUnitSectionHCell.swift
//  Spedia
//
//  Created by Viraj Sharma on 03/02/22.
//  Copyright © 2022 Viraj Sharma. All rights reserved.
//

import UIKit

class SubUnitSectionHCell: UITableViewCell {

    @IBOutlet weak var sectionLbl: CustomLabel!
    @IBOutlet weak var lockIconImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
