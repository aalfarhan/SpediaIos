//
//  PercentSubjectCollCell.swift
//  Spedia
//
//  Created by Viraj Sharma on 07/11/2020.
//  Copyright © 2020 Viraj Sharma. All rights reserved.
//

import UIKit
import SwiftyJSON


class PercentSubjectCollCell: UICollectionViewCell {

    @IBOutlet weak var percentLbl: CustomLabel!
    @IBOutlet weak var subjectNameLbl: CustomLabel!
    @IBOutlet weak var containerVieww: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        containerVieww.layer.cornerRadius = containerVieww.bounds.height/2
        containerVieww.layer.borderWidth = 1
        containerVieww.layer.borderColor = Colors.APP_BORDER_GRAY?.cgColor
    }
    
    
    func configureViewCell(data : JSON) {
    
        let numberValue = NSNumber(value: data["CompeletePercentage"].floatValue / 100)
        self.percentLbl.text = numberValue.getPercentage()
        self.subjectNameLbl.text = L102Language.isCurrentLanguageArabic() ? data["SubjectMasterName"].stringValue : data["SubjectMasterNameEn"].stringValue
    }

}


extension NSNumber {
    func getPercentage() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.locale = Locale(identifier: "es_US")
        formatter.maximumFractionDigits = 2
        return formatter.string(from: self)!
    }
}
