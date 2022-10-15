//
//  HomeCoursesTCell.swift
//  Spedia
//
//  Created by Viraj Sharma on 05/06/2020.
//  Copyright © 2020 Viraj Sharma. All rights reserved.
//

import UIKit

class HomeCoursesTCell: UITableViewCell {

    
    @IBOutlet weak var titleLabel: CustomLabel!
    @IBOutlet weak var subTitleLabel: CustomLabel!
    @IBOutlet weak var activeClassButton: CustomButton!
    @IBOutlet weak var viewAllButton: CustomButton!
    @IBOutlet weak var bkgImageView: UIImageView!
    @IBOutlet weak var cellTabButton: UIButton!
    
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        // Initialization code
        //self.titleLabel.text = L102Language.isCurrentLanguageArabic() ? " (LIVE)الفصل المباشر" : "Live Class"
        //self.subTitleLabel.text = L102Language.isCurrentLanguageArabic() ? "اختر فصلك الافتراضي أو اطلب حصة خاصة" : "Showing all list of available class videos"
        
        let viewStr = "view_all".localized()
        
        self.viewAllButton.setTitle(viewStr, for: .normal)
        
        self.bkgImageView.image = #imageLiteral(resourceName: "homeTestBkg1")
        
    }

    
    func configureViewWithData(data:Int) {
        
        /*
        if data == 0 {
            self.titleLabel.text = L102Language.isCurrentLanguageArabic() ? " (LIVE)الفصل المباشر" : "Live Class"
            self.subTitleLabel.text = L102Language.isCurrentLanguageArabic() ? "اختر فصلك الافتراضي أو اطلب حصة خاصة" : "Showing all list of available class videos"
            
            
            let activeStr = L102Language.isCurrentLanguageArabic() ? "3 فئة نشطة" : ""
            self.activeClassButton.setTitle(activeStr, for: .normal)
            
            let viewStr = "view_all".localized()
            self.viewAllButton.setTitle(viewStr, for: .normal)
            
            self.bkgImageView.image = #imageLiteral(resourceName: "homeTestBkg1")
        }
        
        if data == 1 {
            
            self.titleLabel.text = L102Language.isCurrentLanguageArabic() ? "دورة مكثفة" : "Extensive Course"
            
            self.subTitleLabel.text = L102Language.isCurrentLanguageArabic() ? "عرض جميع الدورات المكثفة المتاحة" : "Showing all of available extensive course"
            
            self.activeClassButton.isHidden = true
            
            let viewStr = "view_all".localized()
            self.viewAllButton.setTitle(viewStr, for: .normal)
            
            self.bkgImageView.image = #imageLiteral(resourceName: "homeTestBkg2")
            
        }
        
        if data == 2 {
            
            self.titleLabel.text = L102Language.isCurrentLanguageArabic() ? "دورة تدريبية" : "Training Course"
            
            self.subTitleLabel.text = L102Language.isCurrentLanguageArabic() ? "عرض جميع الدورات التدريبية التي قد تساعدك في دخول الجامعة" : "Showing all of training course that might help you enter university"
            
            self.activeClassButton.isHidden = true
            
            let viewStr = "view_all".localized()
            self.viewAllButton.setTitle(viewStr, for: .normal)
            
            self.bkgImageView.image = #imageLiteral(resourceName: "homeTestBkg3")
        }
        */
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
