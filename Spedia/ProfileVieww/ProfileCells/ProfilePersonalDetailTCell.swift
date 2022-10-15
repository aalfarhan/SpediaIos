//
//  ProfilePersonalDetailTCell.swift
//  Spedia
//
//  Created by Viraj Sharma on 16/07/2020.
//  Copyright © 2020 Viraj Sharma. All rights reserved.
//

import UIKit

class ProfilePersonalDetailTCell: UITableViewCell {

    //Placeholder's...
    @IBOutlet weak var personalInfoLbl: CustomLabel!
    @IBOutlet weak var emailLbl: CustomLabel!
    @IBOutlet weak var fullNameLbl: CustomLabel!
    @IBOutlet weak var studentPhoneLbl: CustomLabel!
    @IBOutlet weak var locationLbl: CustomLabel!
    
    
    //Labels...
    @IBOutlet weak var profileUsernameLbl: CustomLabel!
    @IBOutlet weak var profileFullNameLbl: CustomLabel!
    @IBOutlet weak var phoneLbl: CustomLabel!
    @IBOutlet weak var profileLocationLabel: CustomLabel!
    
    
    //Responsive
    @IBOutlet weak var leftPedding: NSLayoutConstraint!
    @IBOutlet weak var rightPedding: NSLayoutConstraint!
    
    
    @IBOutlet weak var membershipIcon: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let peddingValue = Int(DeviceSize.screenWidth / 15.36)
        
        print(peddingValue)
        
        self.leftPedding.constant = UIDevice.isPad ? CGFloat(peddingValue) : 16
        self.rightPedding.constant = UIDevice.isPad ? CGFloat(peddingValue) : 16
        
        
        
        //1
        personalInfoLbl.text = L102Language.isCurrentLanguageArabic() ? "المعلومات الشخصية" : "Personal Information"
        //2
        fullNameLbl.text = "fullname_ph".localized()
        
        //3
        emailLbl.text = "username".localized() //"email_ph".localized()
        
        //4
        studentPhoneLbl.text = L102Language.isCurrentLanguageArabic() ? "رقم الهاتف": "Student Phone"
        //5
        locationLbl.text = "membership_no".localized()
        
        
    }

   
    
}
