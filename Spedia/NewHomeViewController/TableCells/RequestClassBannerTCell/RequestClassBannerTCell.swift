//
//  RequestClassBannerTCell.swift
//  Spedia
//
//  Created by Viraj Sharma on 22/01/22.
//  Copyright © 2022 Viraj Sharma. All rights reserved.
//

import UIKit
import SwiftyJSON
import Kingfisher

class RequestClassBannerTCell: UITableViewCell {

    @IBOutlet weak var titleLbl: CustomLabel!
    @IBOutlet weak var classNameLbl: CustomLabel!
    //@IBOutlet weak var classSubtitleLbl: CustomLabel!
    @IBOutlet weak var classButton: CustomButton!
    @IBOutlet weak var classImageView: UIImageView!
    
    //Responsive...
    @IBOutlet weak var containerViewHeight: NSLayoutConstraint!
    @IBOutlet weak var leftPeddingConst: NSLayoutConstraint!
    @IBOutlet weak var rightPeddingConst: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.classImageView.layer.cornerRadius = 10.0
        self.classImageView.clipsToBounds = true
        
        
        //Responsive...
        self.leftPeddingConst.constant = UIDevice.isPad ? 50.0 : 16.0
        self.rightPeddingConst.constant = UIDevice.isPad ? 50.0 : 16.0
        
        //Aspect Ration:-
        //2.3:1 Ratio Formula
        let devideValue = UIDevice.isPad ? 3.3 : 2.3
        let calculatedWitdh = DeviceSize.screenWidth - self.leftPeddingConst.constant
        let ratioHeight = (calculatedWitdh / devideValue) * 1
        self.containerViewHeight.constant = ratioHeight
        
        self.layoutIfNeeded()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func configureViewWithData(data:JSON) {
        
        let classNameStr = data["PrivateRequestTitle" + Lang.code()].stringValue
        self.classNameLbl.text = classNameStr
        
        //self.classSubtitleLbl.text = data["PrivateRequestDescripton" + Lang.code()].stringValue
        
        let buttonTitleStr = data["PrivateRequestButton" + Lang.code()].stringValue
        self.classButton.setTitle(buttonTitleStr, for: .normal)
        
        //...
        let imageUrl = URL(string: data["PrivateRequestImage" + Lang.code()].stringValue)
        self.classImageView.kf.setImage(with: imageUrl, placeholder: UIImage.init(named: "testImage234"))
        
    }
    
    
}
