//
//  NewReservedClassesTCell.swift
//  Spedia
//
//  Created by Viraj Sharma on 11/02/22.
//  Copyright © 2022 Viraj Sharma. All rights reserved.
//

import UIKit
import SwiftyJSON


class NewReservedClassesTCell: UITableViewCell {
    
    //Object's and Outlet's
    @IBOutlet weak var containerVieww: UIView!
    @IBOutlet weak var shadowView: ShadowView!
    @IBOutlet weak var arrowImageView: UIImageView!
    @IBOutlet weak var titleLbl: CustomLabel!
    @IBOutlet weak var dateTimeLbl: CustomLabel!
    @IBOutlet weak var notesButton: CustomButton!
    @IBOutlet weak var expandTCellButton: UIButton!
    
    //Responsive...
    @IBOutlet weak var leftPeddingConst: NSLayoutConstraint!
    @IBOutlet weak var rightPeddingConst: NSLayoutConstraint!
    @IBOutlet weak var sectionBottomSpace: NSLayoutConstraint!
    
    
    var dataJson = JSON()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
        //1
        self.leftPeddingConst.constant = UIDevice.isPad ? 50.0 : 16.0
        self.rightPeddingConst.constant = UIDevice.isPad ? 50.0 : 16.0
    
        //2
        self.containerVieww.layer.cornerRadius = 10.0
        self.containerVieww.clipsToBounds = false
        self.shadowView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
        self.notesButton.setTitle("note_count_ph".localized(), for: .normal)
    }

    func configureViewWithData(data:JSON) {
        
        self.titleLbl.text = data["CourseName" + Lang.code()].stringValue 
        self.dateTimeLbl.text = data["CourseTime" + Lang.code()].stringValue
        
        let isExpanded = data["isExpanded"].boolValue
        
        //2 Arrow Animation
        self.arrowImageView?.transform = CGAffineTransform(rotationAngle: isExpanded ? .pi : 0)
        
        if isExpanded {
            self.sectionBottomSpace.constant = -10.0
            self.shadowView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        } else {
            self.sectionBottomSpace.constant = 10.0
            self.shadowView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        }
        
        //Download Notes OR PDF File For View
        let checkPdf = data["FilePath"].stringValue
        self.notesButton.isHidden = checkPdf.isEmpty ? true : false
        
        
    }
    
    func reloadTableCellUI() {
        //self.titleLbl.text = self.dataJson["CourseName" + Lang.code()].stringValue
        //self.dateTimeLbl.text = self.dataJson["CourseTime" + Lang.code()].stringValue
        //self.layoutIfNeeded()
    }

}
