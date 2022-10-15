//
//  ProfileHeaderTCell.swift
//  Spedia
//
//  Created by Viraj Sharma on 16/07/2020.
//  Copyright © 2020 Viraj Sharma. All rights reserved.
//

import UIKit

class ProfileHeaderTCell: UITableViewCell {

    
    //...
    @IBOutlet weak var whiteDashCircleIV: UIImageView!
    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var profileHeaderBackButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var editProfilePicButton: UIButton!
    @IBOutlet weak var headerFullNameLbl: CustomLabel!
    @IBOutlet weak var headerUsernameLbl: CustomLabel!
    @IBOutlet weak var scanCodeButton: CustomButton!
    
    @IBOutlet weak var showSkillButton: UIButton!
    @IBOutlet weak var showLeaderBord: UIButton!
    @IBOutlet weak var infoButton: UIButton!
    
    @IBOutlet weak var scanCodeTapButton: UIButton!

    
    //Level View..
    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var LevelVieww: UIView!
    //@IBOutlet weak var lblLevel: CustomLabel!
    @IBOutlet weak var lblPoints: CustomLabel!
    @IBOutlet weak var levelViewWitdhConst: NSLayoutConstraint!
    
    //...
    @IBOutlet weak var joinDateView: UIView!
    @IBOutlet weak var gradeView: UIView!
    @IBOutlet weak var joinDateLbl: CustomLabel!
    @IBOutlet weak var studentGradeLbl: CustomLabel!
    @IBOutlet weak var dateLbl: CustomLabel!
    @IBOutlet weak var gradeLbl: CustomLabel!
    
    
    //Responsive
    @IBOutlet weak var leftPedding: NSLayoutConstraint!
    @IBOutlet weak var rightPedding: NSLayoutConstraint!
    
    @IBOutlet weak var qrCodeStackView: UIStackView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
        //self.whiteDashCircleIV.image = #imageLiteral(resourceName: "white_dash_circle")
        
        let peddingValue = Int(DeviceSize.screenWidth / 15.36)
        print(peddingValue)
        self.leftPedding.constant = UIDevice.isPad ? CGFloat(peddingValue) : 16
        self.rightPedding.constant = UIDevice.isPad ? CGFloat(peddingValue) : 16
        
        
        
        
        //self.levelViewWitdhConst.constant = (self.borderView.bounds.width / 2) + 30
        borderView.layer.cornerRadius = 20
        borderView.layer.borderWidth = 1
        borderView.layer.borderColor = Colors.APP_LIGHT_GREEN?.cgColor
        borderView.backgroundColor = UIColor.clear
        
        //LevelVieww.layer.cornerRadius = 20
        //LevelVieww.layer.borderWidth = 0
        //LevelVieww.layer.borderColor = UIColor.clear.cgColor
        //LevelVieww.backgroundColor = Colors.APP_LIGHT_GREEN
    
        //joinDateView.backgroundColor = Colors.APP_LIGHT_GREEN?.withAlphaComponent(0.10)
        //gradeView.backgroundColor = Colors.APP_LIGHT_GREEN?.withAlphaComponent(0.10)
    
        //1
        joinDateLbl.text = L102Language.isCurrentLanguageArabic() ? "تاريخ الاشتراك" : "Joined since"
        //2
        studentGradeLbl.text = L102Language.isCurrentLanguageArabic() ? "الصف" : "Student Grade"
         
        profileHeaderBackButton.imageView?.transform =  L102Language.isCurrentLanguageArabic() ? CGAffineTransform(scaleX: -1.0, y: 1.0) : CGAffineTransform(scaleX: 1.0, y: -1.0)
        
        
        //3
        profileImgView.layer.cornerRadius = profileImgView.frame.height/2
        //profileImgView.layer.borderWidth = 2
        //profileImgView.layer.borderColor = UIColor.white.cgColor
        
        //4
        self.scanCodeButton.setTitle("my_qr_code".localized(), for: .normal)
     
    }

    
   
}
