//
//  UniversitySubjectCollCell.swift
//  Spedia
//
//  Created by Viraj Sharma on 13/06/2021.
//  Copyright © 2021 Viraj Sharma. All rights reserved.
//


import UIKit
import SwiftyJSON


class UniversitySubjectCollCell: UICollectionViewCell {

    
    @IBOutlet weak var tabButton: UIButton!
    @IBOutlet weak var subjectNameLbl: CustomLabel!
    @IBOutlet weak var chanpterCountLbl: CustomLabel!
    @IBOutlet weak var bkgImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    
    func configureCellWithData(data:JSON) {
        
        //1
        let titleStr = L102Language.isCurrentLanguageArabic() ? data["SubjectNameAr"].stringValue : data["SubjectNameEn"].stringValue

        self.subjectNameLbl.text = titleStr
        
        
        //2
       let chapterCountStr = L102Language.isCurrentLanguageArabic() ? data["ChapterCountAr"].stringValue : data["ChapterCountEn"].stringValue

        self.chanpterCountLbl.text = chapterCountStr
         
        
        //3
        let url = URL(string: data["BackgroundImagePath"].stringValue)
        self.bkgImageView.kf.setImage(with: url, placeholder: UIImage(named: "collBkg"))
        
    }
    
}
