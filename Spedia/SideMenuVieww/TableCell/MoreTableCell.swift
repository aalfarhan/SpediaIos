//
//  MoreTableCell.swift
//  Spedia
//
//  Created by Viraj Sharma on 15/07/2020.
//  Copyright © 2020 Viraj Sharma. All rights reserved.
//

import UIKit

class MoreTableCell: UITableViewCell {

    //...
    @IBOutlet weak var titleLbl: CustomLabel!
    @IBOutlet weak var menuTabButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
