//
//  UnivercityTCell.swift
//  Spedia
//
//  Created by Viraj Sharma on 08/07/2020.
//  Copyright © 2020 Viraj Sharma. All rights reserved.
//

import UIKit
import SwiftyJSON

class UnivercityTCell: UITableViewCell {

    @IBOutlet weak var containerVieww: UIView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var subtitleLbl: CustomLabel!
    @IBOutlet weak var nameLbl: CustomLabel!
    @IBOutlet weak var arrowImgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        // Configure the view for the selected state
        self.arrowImgView.transform =  L102Language.isCurrentLanguageArabic() ? CGAffineTransform(scaleX: -1.0, y: 1.0) : CGAffineTransform(scaleX: 1.0, y: -1.0)
        
        containerVieww.layer.cornerRadius = 10
        containerVieww.layer.borderWidth = 1
        containerVieww.layer.borderColor = Colors.APP_BORDER_GRAY?.cgColor
        containerVieww.backgroundColor = UIColor.clear
    }


    func configureViewWith( data : JSON) {
    
     let nameStr = L102Language.isCurrentLanguageArabic() ? data["ClassNameAr"].stringValue : data["ClassNameEn"].stringValue
     nameLbl.text = nameStr
     
     //let fromStr = L102Language.isCurrentLanguageArabic() ? data["DecriptionAr"].stringValue : data["DecriptionEn"].stringValue
     subtitleLbl.text = "Master of Information Tech."
        
    }
    
    
    
}
