//
//  ChapterTCell.swift
//  Spedia
//
//  Created by Viraj Sharma on 02/02/22.
//  Copyright © 2022 Viraj Sharma. All rights reserved.
//

import UIKit

class ChapterTCell: UITableViewCell {
    
    @IBOutlet weak var chapterNameLbl: CustomLabel!
    @IBOutlet weak var playTabButton: UIButton!
    //New
    @IBOutlet weak var bookIconImage: UIView!
    @IBOutlet weak var countContView: UIView!
    @IBOutlet weak var quizIconImage: UIView!
    @IBOutlet weak var countLabel: CustomLabel!
     
    
    @IBOutlet weak var chapterCenterConst: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        if L102Language.isCurrentLanguageArabic() {
            self.chapterCenterConst.constant = 0.0
            self.chapterNameLbl.textAlignment = .right
        } else {
            self.chapterCenterConst.constant = 0.0
            self.chapterNameLbl.textAlignment = .left
        }
        
        self.countContView.layer.cornerRadius = self.countContView.frame.height/2
        self.countContView.clipsToBounds = true
        self.countContView.layer.borderWidth = 1.0
        self.countContView.layer.borderColor = Colors.APP_LIME_GREEN?.cgColor
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
