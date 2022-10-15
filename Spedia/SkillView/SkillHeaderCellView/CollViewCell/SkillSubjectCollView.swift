//
//  SkillSubjectCollView.swift
//  Spedia
//
//  Created by Viraj Sharma on 27/12/2020.
//  Copyright © 2020 Viraj Sharma. All rights reserved.
//

import UIKit
import SwiftyJSON

class SkillSubjectCollView: UICollectionViewCell {

    @IBOutlet weak var imageContainerVieww: UIView!
    @IBOutlet weak var tapButton: UIButton!
    @IBOutlet weak var subjectNameLbl: CustomLabel!
    @IBOutlet weak var subjectIconIV: UIImageView!
    
    var isCellSelected = false
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.imageContainerVieww.layer.cornerRadius = self.imageContainerVieww.bounds.height / 2
        
    }

    
    func configureCellWithData(data: JSON) {
    
        if isCellSelected {
            self.imageContainerVieww.backgroundColor = Colors.APP_LIGHT_GREEN?.withAlphaComponent(0.10)
            
            self.subjectNameLbl.textColor = Colors.APP_LIGHT_GREEN
            
        } else {
            self.subjectNameLbl.textColor = Colors.APP_PLACEHOLDER_GRAY25
            self.imageContainerVieww.backgroundColor = Colors.APP_PLACEHOLDER_GRAY25?.withAlphaComponent(0.10)
        }
        
        //1
        self.subjectNameLbl.text = L102Language.isCurrentLanguageArabic() ? data["NameAr"].stringValue : data["NameEn"].stringValue

        let imageName = data["IconPath"].stringValue
        
        
        let url = URL(string: imageName)
        
        self.subjectIconIV.kf.setImage(
            with: url,
            placeholder: UIImage(named: ""),
            options: [], completionHandler:  {
                result in
                switch result {
                case .success(let value):
                    print("Task done for: \(value.source.url?.absoluteString ?? "")")
                    self.subjectIconIV.image = self.subjectIconIV.image?.imageWithColor(color1: self.isCellSelected ? Colors.APP_LIGHT_GREEN ?? UIColor.green : Colors.APP_PLACEHOLDER_GRAY25 ?? UIColor.gray)
                    
                case .failure(let error):
                    print("Job failed: \(error.localizedDescription)")
                }
            })
        
    }
    
}
