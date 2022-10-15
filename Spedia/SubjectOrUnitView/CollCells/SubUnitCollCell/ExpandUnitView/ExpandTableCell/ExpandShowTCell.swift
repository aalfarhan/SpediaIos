//
//  ExpandShowTCell.swift
//  Spedia
//
//  Created by Viraj Sharma on 24/06/2020.
//  Copyright © 2020 Viraj Sharma. All rights reserved.
//

import UIKit

class ExpandShowTCell: UITableViewCell {

    
    @IBOutlet weak var titleLbl: CustomLabel!
    @IBOutlet weak var showButton: CustomButton!
    @IBOutlet weak var cellTapButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.titleLbl.textAlignment = L102Language.isCurrentLanguageArabic() ? .right : .left
        
        //self.showButton.setTitle(L102Language.isCurrentLanguageArabic() ? "عرض" : "Show", for: .normal)
        
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
