//
//  AddressListCollCell.swift
//  Spedia
//
//  Created by Viraj Sharma on 23/08/2021.
//  Copyright © 2021 Viraj Sharma. All rights reserved.
//

import UIKit
import SwiftyJSON


class AddressListCollCell: UICollectionViewCell {

    @IBOutlet weak var containerVieww: UIView!
    
    @IBOutlet weak var nameLbl: CustomLabel!
    @IBOutlet weak var addressLbl: CustomLabel!
    
    @IBOutlet weak var addressTabButton: UIButton!
    @IBOutlet weak var editAddressButton: UIButton!
    
    /*@IBOutlet weak var nameLbl: CustomTFT!
    @IBOutlet weak var mobileLbl: CustomTFT!
    @IBOutlet weak var pincodeLbl: CustomTFT!
    @IBOutlet weak var flatHourseNumberLbl: CustomTFT!
    @IBOutlet weak var streetLbl: CustomTFT!
    @IBOutlet weak var landmarkLbl: CustomTFT!
    @IBOutlet weak var cityLbl: CustomTFT!
    @IBOutlet weak var stateLbl: CustomTFT!*/
    
    
     
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.containerVieww.layer.cornerRadius = 5.0
        self.containerVieww.clipsToBounds = true
        self.containerVieww.backgroundColor = .white
        self.containerVieww.layer.borderWidth = 1
        self.containerVieww.layer.borderColor = Colors.APP_BORDER_GRAY?.cgColor
    }

    
    func configureCellWith(data: JSON, isSelectedValue: Bool) {
        
        /*let nameStr = data["Name"].stringValue
        let mobileStr = data["MobileNumber"].stringValue
        let pinCodeStr = data["PinCode"].stringValue
        let flatNoStr = data["FlatNo"].stringValue
        let streetStr = data["Street"].stringValue
        let landmarkStr = data["Landmark"].stringValue
        let cityStr = data["City"].stringValue
        let stateStr = data["State"].stringValue*/
        
        let nameStr = data["Name"].stringValue
        let finalAddressStr = data["FinalAddress"].stringValue
        
        //1
        self.nameLbl.text = nameStr
        
        //2 ALL Combined
        self.addressLbl.text = finalAddressStr
        
        //3
        if isSelectedValue {
            self.containerVieww.layer.borderColor = Colors.APP_LIGHT_GREEN?.cgColor
        } else {
            self.containerVieww.layer.borderColor = Colors.APP_BORDER_GRAY?.cgColor
        }
        
    }
}

