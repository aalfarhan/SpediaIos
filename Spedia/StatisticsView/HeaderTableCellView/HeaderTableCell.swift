//
//  HeaderTableCell.swift
//  Spedia
//
//  Created by Viraj Sharma on 30/12/2020.
//  Copyright © 2020 Viraj Sharma. All rights reserved.
//

import UIKit
import UICircularProgressRing
import SwiftyJSON

class HeaderTableCell: UITableViewCell {

    //1..
    @IBOutlet weak var lastActivityLabel: CustomLabel!
    @IBOutlet weak var lastActivityDateLabel: CustomLabel!
    @IBOutlet weak var joinedSinceLabel: CustomLabel!
    @IBOutlet weak var joinedSinceDateLabel: CustomLabel!
    
    //2..
    @IBOutlet weak var practiceAndViewPHTitleLabel: CustomLabel!
    @IBOutlet weak var viewTimeLineButton: CustomButton!
    
    
    //2.1 Practice Object
    @IBOutlet weak var praticeColorVieww: UIView!
    @IBOutlet weak var totalPracticePHLabel: CustomLabel!
    @IBOutlet weak var totalPracticeCountLabel: CustomLabel!
    
    //2.2 Views Object
    @IBOutlet weak var viewColorVieww: UIView!
    @IBOutlet weak var totalViewPHLabel: CustomLabel!
    @IBOutlet weak var totalViewCountLabel: CustomLabel!
     
    
    //3..
    @IBOutlet weak var practiceContainerVieww: UIView!
    @IBOutlet var progressCircleView: UICircularProgressRing!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        practiceContainerVieww.layer.cornerRadius = 10.0
        practiceContainerVieww.layer.borderWidth = 1
        practiceContainerVieww.layer.borderColor = Colors.APP_BORDER_GRAY?.cgColor
        
        //timelineHistoryVieww.layer.cornerRadius = 10.0
        //self.sectionTitleLabel.text = "my_videos_stats".localized()
        //self.totalPracticeLabel.text = "total_practice".localized()
        //self.totalViewLabel.text = "total_views".localized()
        //self.timelineHistoryLabel.text = "timeline_history".localized()
        //self.myRecentActivityLabel.text = "my_recent_activities".localized()
        
        self.viewTimeLineButton.setTitle("view_timeline".localized(), for: .normal)
        
    
    }

    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

    
    //Configration...
    func configureCellWithData(data : JSON) {
        
        //For setup:-
        self.praticeColorVieww.isHidden = false
        self.totalPracticePHLabel.isHidden = false
        self.totalPracticeCountLabel.isHidden = false
        self.viewColorVieww.isHidden = false
        self.totalViewPHLabel.isHidden = false
        self.totalViewCountLabel.isHidden = false
        
        //1
        let progressValue = data["PracticePercentage"].floatValue
        self.progressCircleView.value = CGFloat(progressValue)
        
        //2
        self.practiceAndViewPHTitleLabel.text = L102Language.isCurrentLanguageArabic() ? data["TitleAr"].stringValue : data["TitleEn"].stringValue
        
        
        //2.1
        self.totalPracticePHLabel.text = L102Language.isCurrentLanguageArabic() ? data["TotalPracticeTextAr"].stringValue : data["TotalPracticeTextEn"].stringValue
        self.totalPracticeCountLabel.text = data["TotalPractice"].stringValue //Count Str
        
        
    
        //2.2
        self.totalViewPHLabel.text = L102Language.isCurrentLanguageArabic() ? data["TotalViewsTextAr"].stringValue : data["TotalViewsTextEn"].stringValue
        self.totalViewCountLabel.text = data["TotalViews"].stringValue //Count Str
        
        
        //Hide
        if data["TotalPractice"].intValue == 0 {
            
            self.praticeColorVieww.isHidden = true
            self.totalPracticePHLabel.isHidden = true
            self.totalPracticeCountLabel.isHidden = true
            
        }
        
        if data["TotalViews"].intValue == 0 {
            
            self.viewColorVieww.isHidden = true
            self.totalViewPHLabel.isHidden = true
            self.totalViewCountLabel.isHidden = true
        }
        
    
        //Multi Color Text :-
        //let totalCount = data["TotalPracticeTextEn"].stringValue.westernArabicNumeralsOnly
        
    }
    
}




extension NSMutableAttributedString {

    func setColorForText(textForAttribute: String, withColor color: UIColor) {
        let range: NSRange = self.mutableString.range(of: textForAttribute, options: .caseInsensitive)

        // Swift 4.2 and above
        self.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
    }

}


extension String {
    var westernArabicNumeralsOnly: String {
        let pattern = UnicodeScalar("0")..."9"
        return String(unicodeScalars.compactMap { pattern ~= $0 ? Character($0) : nil })
    }
}
