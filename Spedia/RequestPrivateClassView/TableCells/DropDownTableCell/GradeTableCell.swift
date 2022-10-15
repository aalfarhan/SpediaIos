//
//  GradeTableCell.swift
//  Spedia
//
//  Created by Viraj Sharma on 08/07/2020.
//  Copyright © 2020 Viraj Sharma. All rights reserved.
//

import UIKit

class GradeTableCell: UITableViewCell {

    @IBOutlet weak var containerVieww: UIView!
    @IBOutlet weak var nameLbl: CustomLabel!
    @IBOutlet weak var checkImageView: UIImageView!
    @IBOutlet weak var roundImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        containerVieww.layer.cornerRadius = 10
        containerVieww.layer.borderWidth = 1
        containerVieww.layer.borderColor = UIColor.clear.cgColor
        //containerVieww.backgroundColor = UIColor.clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
