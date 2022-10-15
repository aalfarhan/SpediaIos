//
//  SchoolHeaderTCell.swift
//  Spedia
//
//  Created by Viraj Sharma on 08/07/2020.
//  Copyright © 2020 Viraj Sharma. All rights reserved.
//

import UIKit

class SchoolHeaderTCell: UITableViewCell {

    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var titleLabel: CustomLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //1
        self.backButton.imageView?.transform =  L102Language.isCurrentLanguageArabic() ? CGAffineTransform(scaleX: -1.0, y: 1.0) : CGAffineTransform(scaleX: 1.0, y: -1.0)
        
        //2
        titleLabel.text = L102Language.isCurrentLanguageArabic() ? "إختيار المرحلة الدراسية" : "Which grade are you currently on?"
    }


}
