//
//  VideoFooterCell.swift
//  Spedia
//
//  Created by Viraj Sharma on 12/06/2020.
//  Copyright © 2020 Viraj Sharma. All rights reserved.
//

import UIKit

class VideoFooterCell: UITableViewCell {

    
    
    @IBOutlet weak var feedbackLbl: CustomLabel!
    
    @IBOutlet weak var discriptionLbl: CustomLabel!
    
    @IBOutlet weak var addReviewButton: CustomButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        if L102Language.isCurrentLanguageArabic() {
            
            self.feedbackLbl.textAlignment = .right
            self.discriptionLbl.textAlignment = .right
            
            self.feedbackLbl.text = "اترك تعليق"
            self.discriptionLbl.text = "أضف تعليقك عن الكورس\nالذي إلتحقت به"
            addReviewButton.setTitle("تعليق", for: .normal)
            
        } else {
            
            self.feedbackLbl.textAlignment = .left
            self.discriptionLbl.textAlignment = .left
            
            self.feedbackLbl.text = "Left Feedbacks"
            self.discriptionLbl.text = "Add review if you enjoying\nlearning with this course"
            addReviewButton.setTitle("Add Review", for: .normal)
        }
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
