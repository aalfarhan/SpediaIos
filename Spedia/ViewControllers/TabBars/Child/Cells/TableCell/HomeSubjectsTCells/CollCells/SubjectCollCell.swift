//
//  SubjectCollCell.swift
//  Spedia
//
//  Created by Viraj Sharma on 31/05/2020.
//  Copyright © 2020 Viraj Sharma. All rights reserved.
//

import UIKit

class SubjectCollCell: UICollectionViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var subjectImageView: UIImageView!
    @IBOutlet weak var subjectNameLable: UILabel!
    
    @IBOutlet weak var videosCountsView: UIView!
    @IBOutlet weak var videoCountsLabel: CustomLabel!
    
    @IBOutlet weak var videoIconImageView: UIImageView!
    
    @IBOutlet weak var videoIconCenterConst: NSLayoutConstraint!
    
    
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        // Initialization code
        //self.containerView.alpha = 0.10
     
        self.videosCountsView.layer.cornerRadius = 10.0
        
        self.containerView.backgroundColor = .clear
        self.containerView.layer.borderWidth = 1
        self.containerView.layer.borderColor = UIColor.lightGray.cgColor
        
        self.videoIconImageView.transform =  L102Language.isCurrentLanguageArabic() ? CGAffineTransform(scaleX: 1.0, y: -1.0) : CGAffineTransform(scaleX: -1.0, y: 1.0)
        
        self.videoIconCenterConst.constant = L102Language.isCurrentLanguageArabic() ? 10 : -10
        
    }
    

}
