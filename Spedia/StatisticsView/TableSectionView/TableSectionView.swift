//
//  TableSectionView.swift
//  Spedia
//
//  Created by Viraj Sharma on 31/12/2020.
//  Copyright © 2020 Viraj Sharma. All rights reserved.
//

import UIKit

class TableSectionView: UITableViewCell {

    @IBOutlet weak var sectionTitleLabel: CustomLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
