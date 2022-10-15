//
//  LiveNowCollCell.swift
//  Spedia
//
//  Created by Viraj Sharma on 23/01/22.
//  Copyright © 2022 Viraj Sharma. All rights reserved.
//

import UIKit
import SwiftyJSON
import Kingfisher


class LiveNowCollCell: UICollectionViewCell {
    
    @IBOutlet weak var containerVieww: UIView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var nameLbl: CustomLabel!
    @IBOutlet weak var dateTimeLbl: CustomLabel!
    @IBOutlet weak var tabCellButton: UIButton!
    
    @IBOutlet weak var imageViewHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.containerVieww.layer.cornerRadius = 10.0
        self.containerVieww.clipsToBounds = false
        
        self.imgView.layer.cornerRadius = 10.0
        self.imgView.clipsToBounds = true
        
        //Aspect Ration:-
        //2.3:1 Ratio Formula
        let devideValue = UIDevice.isPad ? 2.3 : 2.3
        let ratioHeight = (imgView.frame.width / devideValue) * 1
        self.imageViewHeight.constant = ratioHeight
        
        self.layoutIfNeeded()
    }
    
    
    func configureViewWithData(data:JSON) {
        
        self.nameLbl.text = data["Title" + Lang.code()].stringValue
        self.dateTimeLbl.text = data["TotalHours" + Lang.code()].stringValue + "\n" + data["StartTime" + Lang.code()].stringValue
        
        //...
        let imageUrl = URL(string: data["CourseImage"].stringValue)
        self.imgView.kf.setImage(with: imageUrl, placeholder: nil)
        
    }

}
