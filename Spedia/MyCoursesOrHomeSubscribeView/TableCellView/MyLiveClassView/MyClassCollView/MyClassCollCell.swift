//
//  MyClassCollCell.swift
//  Spedia
//
//  Created by Viraj Sharma on 07/02/22.
//  Copyright © 2022 Viraj Sharma. All rights reserved.
//

import UIKit
import SwiftyJSON

class MyClassCollCell: UICollectionViewCell {
    
    //1
    @IBOutlet weak var containerVieww: UIView!
    @IBOutlet weak var classTitleLbl: CustomLabel!
    @IBOutlet weak var classTimeLbl: CustomLabel!
    @IBOutlet weak var joinButton: CustomButton!
    
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        self.containerVieww.layer.cornerRadius = 10.0
        self.containerVieww.clipsToBounds = false
    }

    //2
    func configureViewWithData(data: JSON) {
        
        self.classTitleLbl.text = data["CourseName" + Lang.code()].stringValue
        self.classTimeLbl.text = data["TotalHours" + Lang.code()].stringValue + "\n" + data["CourseTime" + Lang.code()].stringValue
        //data["CourseTime" + Lang.code()].stringValue
        
        if data["IsLive"].boolValue {
            
            self.joinButton.backgroundColor = UIColor.init(hexaRGB: "FF3B30") //RED
            self.joinButton.isUserInteractionEnabled = true
            self.joinButton.setTitle("join".localized(), for: .normal)
            
        } else {
            self.joinButton.backgroundColor = UIColor.init(hexaRGB: "F98D23") //YELLOW
            self.joinButton.isUserInteractionEnabled = false
            self.joinButton.setTitle("pending_ph".localized(), for: .normal)
        }
    }
    
    
    
     
    
}
