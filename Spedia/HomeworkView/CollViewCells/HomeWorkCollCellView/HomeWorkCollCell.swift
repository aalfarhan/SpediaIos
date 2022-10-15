//
//  HomeWorkCollCell.swift
//  Spedia
//
//  Created by Viraj Sharma on 03/09/2021.
//  Copyright © 2021 Viraj Sharma. All rights reserved.
//

import UIKit
import SwiftyJSON

class HomeWorkCollCell: UICollectionViewCell {
    
    @IBOutlet weak var containerVieww: UIView!
    
    //1
    @IBOutlet weak var circleColorView: UIView!
    @IBOutlet weak var titleLabel: CustomLabel!
    @IBOutlet weak var subTitleLabel: CustomLabel!
    @IBOutlet weak var pointsGetsLabel: CustomLabel!
    @IBOutlet weak var totalPointsLabel: CustomLabel!
    @IBOutlet weak var uploadAnswerPHLbl: CustomLabel!
    @IBOutlet weak var downloadQuestionPHLbl: CustomLabel!
    @IBOutlet weak var uploadButton: CustomButton!
    @IBOutlet weak var uploadedButton: CustomButton!
    @IBOutlet weak var downloadButton: CustomButton!
    @IBOutlet weak var uploadContainerVieww: UIView!
    @IBOutlet weak var downloadContainerVieww: UIView!
    
    @IBOutlet weak var marksContainerVieww: UIView!
    @IBOutlet weak var statusOfHomeworkLabel: CustomLabel!
    
    
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        // Initialization code
        self.containerVieww.layer.cornerRadius = 10
        self.containerVieww.layer.borderWidth = 1
        self.containerVieww.layer.borderColor = Colors.APP_BORDER_GRAY?.cgColor
        self.containerVieww.backgroundColor = .clear
        
        
        //1
        self.circleColorView.layer.cornerRadius = self.circleColorView.frame.height / 2
        self.circleColorView.layer.borderWidth = 5
        
        
        self.uploadAnswerPHLbl.text = "upload_answer_ph".localized()
        self.downloadQuestionPHLbl.text = "download_answer_ph".localized()
        
        
    }

    
    func configureCellWithData(data: JSON) {
        
        self.titleLabel.text = data["Title" + Lang.code()].stringValue
        
        self.subTitleLabel.text = data["SubTitle" + Lang.code()].stringValue
        
        self.pointsGetsLabel.text = data["ObtainedMark"].stringValue
        
        self.totalPointsLabel.text = data["MaximumMark"].stringValue
        
        
        if data["Status"].intValue == 4 {
            
            let colorCode = data["ColourCode"].stringValue
        
            self.circleColorView.layer.borderColor =  UIColor.init(hexaRGB: "\(colorCode)")?.withAlphaComponent(1.0).cgColor
            
            self.circleColorView.backgroundColor =  UIColor.init(hexaRGB: "\(colorCode)")?.withAlphaComponent(0.80)
            
            self.marksContainerVieww.isHidden = false
            self.statusOfHomeworkLabel.text = ""
        
        } else {
            
            let colorCode = data["ColourCode"].stringValue
        
            self.circleColorView.layer.borderColor =  UIColor.init(hexaRGB: "\(colorCode)")?.withAlphaComponent(1.0).cgColor
            
            self.circleColorView.backgroundColor =  UIColor.init(hexaRGB: "\(colorCode)")?.withAlphaComponent(0.80)
            
            self.marksContainerVieww.isHidden = true
            self.statusOfHomeworkLabel.text = data["HomeWorkStatus" + Lang.code()].stringValue
        }
        
        
        

        let uploadStr = data["UploadButtonText" + Lang.code()].stringValue
        
        let downloadStr = data["DownloadButtonText" + Lang.code()].stringValue
        
        self.uploadButton.setTitle(uploadStr, for: .normal)
        self.downloadButton.setTitle(downloadStr, for: .normal)
        self.uploadedButton.setTitle(uploadStr, for: .normal)
        
        if data["Status"].intValue == 0 {
            
            self.uploadedButton.isHidden = true
            self.uploadButton.isHidden = false
            self.uploadButton.isEnabled = false
            
        } else if data["Status"].intValue == 1 {
        
            self.uploadedButton.isHidden = true
            self.uploadButton.isHidden = false
            self.uploadButton.isEnabled = true
            
        
        } else {
            
            self.uploadedButton.isHidden = false
            self.uploadButton.isHidden = true
            self.uploadButton.isEnabled = false
        
        }
        
    }
}
