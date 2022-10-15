//
//  BookmarkCollCell.swift
//  Spedia
//
//  Created by Viraj Sharma on 23/06/2021.
//  Copyright © 2021 Viraj Sharma. All rights reserved.
//

import UIKit
import SwiftyJSON

class BookmarkCollCell: UICollectionViewCell {

    //1 Cell Outlets.....
    @IBOutlet weak var containerVieww: UIView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var subjectSubtitleLbl: CustomLabel!
    @IBOutlet weak var subjectTitlteLbl: CustomLabel!
    @IBOutlet weak var timeLbl: CustomLabel!
    @IBOutlet weak var tapBookmarkButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        containerVieww.layer.cornerRadius = 10.0
        containerVieww.layer.borderWidth = 1
        containerVieww.layer.borderColor = Colors.APP_BORDER_GRAY?.cgColor
    }

    
    
    func configureCellWithData(data: JSON) {
        
        self.subjectTitlteLbl.text = data["Title"].stringValue
        
        self.subjectSubtitleLbl.text = L102Language.isCurrentLanguageArabic() ?  data["SubjectNameAr"].stringValue : data["SubjectNameEn"].stringValue
        
        self.timeLbl.text = data["Time"].stringValue
        

        //Image
        let url = URL(string: data["BannerImage"].stringValue)
        self.imgView.kf.setImage(with: url, placeholder: UIImage.init(named: "collBkg"))
        
        
    }
    
}

