//
//  CountryNameTCell.swift
//  Spedia
//
//  Created by Viraj Sharma on 08/02/2021.
//  Copyright © 2021 Viraj Sharma. All rights reserved.
//

import UIKit

class CountryNameTCell: UITableViewCell {

    @IBOutlet var containerVieww: UIView!
    @IBOutlet var countryNameLbl: CustomLabel!
    @IBOutlet var countryCodeLbl: CustomLabel!
    @IBOutlet var tabButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
