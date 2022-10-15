//
//  CategoryCollCell.swift
//  Spedia
//
//  Created by Viraj Sharma on 02/01/2021.
//  Copyright © 2021 Viraj Sharma. All rights reserved.
//

import UIKit

class CategoryCollCell: UICollectionViewCell {

    @IBOutlet weak var containerVieww: UIView!
    @IBOutlet weak var categoryTapButton: UIButton!
    @IBOutlet weak var categoryNameLabel: CustomLabel!
    @IBOutlet weak var bottomLineLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        //self.containerVieww.backgroundColor = .clear
        //self.containerVieww.layer.borderWidth = 1
        //self.containerVieww.layer.cornerRadius = 18
        //self.containerVieww.layer.borderColor = Colors.APP_LIGHT_GREEN?.cgColor
        
        //self.containerVieww.layer.cornerRadius = self.containerVieww.frame.height / 2
        self.containerVieww.clipsToBounds = true
        self.containerVieww.layer.borderWidth = 1.0
    }
    
    
    
    func setUPForSubjectView() {
        self.bottomLineLabel.isHidden = false
        self.containerVieww.layer.cornerRadius = 0
        self.containerVieww.layer.borderColor = UIColor.clear.cgColor
    }
    
    
    func liveClassCategorySelected(isCellSelected : Bool)  {
      
        self.bottomLineLabel.isHidden = true
        
        if isCellSelected {
            
            self.containerVieww.backgroundColor = .white
            self.containerVieww.layer.borderColor = Colors.APP_LIGHT_GREEN?.cgColor
            self.categoryNameLabel.textColor = Colors.APP_LIGHT_GREEN
            self.categoryNameLabel.font = UIFont(name: "BOLD".localized(), size: 14.0)
            
            self.containerVieww.layer.cornerRadius = self.containerVieww.bounds.height / 2
            
        } else {
            
            self.containerVieww.backgroundColor = .clear
            self.containerVieww.layer.borderColor = UIColor.clear.cgColor
            self.categoryNameLabel.textColor = Colors.APP_PLACEHOLDER_GRAY25
            self.categoryNameLabel.font = UIFont(name: "REGULAR".localized(), size: 13.0)
            
        }
         
        
    }

    
}
