//
//  TimeCollCell.swift
//  YachtZap
//
//  Created by Viraj Sharma on 22/12/2020.
//  Copyright © 2020 Rahul Goku. All rights reserved.
//

import UIKit
import SwiftyJSON

class TimeCollCell: UICollectionViewCell {

    //1 Cell Outlets.....
    @IBOutlet weak var containerVieww: UIView!
    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var subjectSubtitleLbl: CustomLabel!
    @IBOutlet weak var subjectTitlteLbl: CustomLabel!
    @IBOutlet weak var timeLbl: CustomLabel!
    @IBOutlet weak var verticalDashView: UIView!
    @IBOutlet weak var scoreLabel: CustomLabel!
    @IBOutlet weak var playIconIV: UIImageView!
    
    @IBOutlet weak var dayLabel: CustomLabel!
    @IBOutlet weak var monthLabel: CustomLabel!
    @IBOutlet weak var tagButton: CustomButton!
    @IBOutlet weak var absentButton: CustomButton!
    @IBOutlet weak var tagButtonIcon: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        containerVieww.layer.cornerRadius = 10.0
        containerVieww.layer.borderWidth = 1
        containerVieww.layer.borderColor = Colors.APP_BORDER_GRAY?.cgColor
        
        //tagButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: L102Language.isCurrentLanguageArabic() ? 28 : 10, bottom: 0, right: L102Language.isCurrentLanguageArabic() ? 10 : 28)
        
        self.verticalDashView.addDashedVerticalLine(strokeColor: Colors.APP_PLACEHOLDER_GRAY25 ?? UIColor.gray, lineWidth: 3.0)
        
        self.absentButton.setTitle("absent_ph".localized(), for: .normal)
        
    }

    
    func configureCellWithData(data: JSON) {
        
        self.absentButton.isHidden = true
        self.scoreLabel.text = ""
        
        let titleStr = L102Language.isCurrentLanguageArabic() ?  data["TitleAr"].stringValue : data["TitleEn"].stringValue
        
        let subTitleStr = L102Language.isCurrentLanguageArabic() ?  data["SubTitleTopAr"].stringValue : data["SubTitleTopEn"].stringValue
        
        let timeStr = L102Language.isCurrentLanguageArabic() ?  data["TimeAr"].stringValue : data["TimeEn"].stringValue
        
        
        //Fill
        self.subjectTitlteLbl.text = titleStr.isEmpty ? "No Title" : titleStr.capitalized
        self.subjectSubtitleLbl.text = subTitleStr.isEmpty ? "No SubTitle" : subTitleStr.capitalized
        self.timeLbl.text = timeStr.isEmpty ? "No Time" : timeStr
        
        self.dayLabel.text = data["Day"].stringValue
        self.monthLabel.text = data["Month"].stringValue.uppercased()
    
        
        //1 Tag Button
        let tagStr = L102Language.isCurrentLanguageArabic() ?  data["TypeAr"].stringValue : data["TypeEn"].stringValue
        self.tagButton.setTitle(tagStr.uppercased(), for: .normal)
        
        //2
        let colorCode = data["TypeColor"].stringValue
        self.tagButton.backgroundColor = UIColor.init(hexaRGB: "\(colorCode)")?.withAlphaComponent(1.00)
        
        
        //Check....
        if data["TypeEn"].stringValue == "Live Course" { //
            
            let scoreStr = L102Language.isCurrentLanguageArabic() ?  data["SubTitleAr"].stringValue : data["SubTitleEn"].stringValue
            self.subjectTitlteLbl.numberOfLines = 1
            self.scoreLabel.text = scoreStr.isEmpty ? "No Score" : scoreStr
            
            self.absentButton.isHidden = !data["Absent"].boolValue
            
        }
        
        
        if data["TypeEn"].stringValue == "Videos" {
            
            self.subjectTitlteLbl.numberOfLines = 2
            self.scoreLabel.text = ""
        }
        let scoreStr = L102Language.isCurrentLanguageArabic() ?  data["SubTitleAr"].stringValue : data["SubTitleEn"].stringValue
        self.scoreLabel.text = scoreStr.isEmpty ? "" : scoreStr
    }
    
}


