//
//  CustomLiveClassJoinAlertView.swift
//  Spedia
//
//  Created by Viraj Sharma on 08/07/2021.
//  Copyright © 2021 Viraj Sharma. All rights reserved.
//

/*
import Foundation
import UIKit
import Kingfisher
import SVProgressHUD
import SwiftyJSON


//MARK: CUSTOM ALERT BOX :-

class CustomLiveClassView: UIView {
    
    var facultyPicker: SearchCountryView!
    
    public func showCustomLiveClassAlertBox(title : String, subTitle : String, joinDate : String) {
        
        let subViewArray = win.subviews.filter { (view) -> Bool in
            view.tag == 8768
        }
        if subViewArray.count > 0 {
            subViewArray[0].removeFromSuperview()
        }
        
        //1
        let loaderContainerView = UIView()
        loaderContainerView.frame = win.frame
        loaderContainerView.backgroundColor = UIColor.black.withAlphaComponent(0.70)
        loaderContainerView.tag = 8768
        
        
        /*
         //1.1
         let whiteBox = UIView()
         
         let iPhone = CGRect(x: 20, y: (DeviceSize.screenHeight/2) - (DeviceSize.screenWidth / 2) , width: DeviceSize.screenWidth - 40, height: DeviceSize.screenWidth + 50)
         
         //let iPad = CGRect(x: 20, y: (DeviceSize.screenHeight/2) - 240 , width: 440, height: 460)
         
         
         whiteBox.frame = UIDevice.isPad ? iPhone : iPhone
         
         if UIDevice.isPad {
         whiteBox.center = loaderContainerView.center
         }
         
         whiteBox.backgroundColor = UIColor.white
         whiteBox.layer.cornerRadius = 20.0
         
         
         //2 Image
         let cloudImageView = UIImageView.init(image: UIImage.init(named: "imageName"))
         cloudImageView.frame = whiteBox.frame
         //CGRect(x: (whiteBox.frame.width / 2) - (90), y: 20, width: 180.0, height: 180.0)
         cloudImageView.backgroundColor = UIColor.clear
         cloudImageView.contentMode = .scaleAspectFit
         cloudImageView.clipsToBounds = true
         cloudImageView.backgroundColor = UIColor.clear
         whiteBox.addSubview(cloudImageView)
         
         
         //3 Label
         //3.1
         let titleLbl = UILabel(frame: CGRect(x: 5, y: cloudImageView.center.y + 90, width: whiteBox.frame.width - 10, height: 40))
         titleLbl.textAlignment = .center
         titleLbl.minimumScaleFactor = 0.5
         titleLbl.font = UIFont(name: "BOLD".localized(), size: 20)
         //titleLbl.textColor = textColor
         titleLbl.text = title
         titleLbl.clipsToBounds = true
         //titleLbl.sizeToFit()
         //titleLbl.backgroundColor = UIColor.clear
         whiteBox.addSubview(titleLbl)
         
         
         //3.2
         /*let subTitleLbl = UILabel(frame: CGRect(x: 5, y: cloudImageView.center.y + 130, width: whiteBox.frame.width - 10, height: 80))
         subTitleLbl.textAlignment = .center
         subTitleLbl.numberOfLines = 2
         subTitleLbl.backgroundColor = UIColor.clear
         subTitleLbl.font = UIFont(name: "REGULAR".localized(), size: 18)
         subTitleLbl.textColor = UIColor.black
         subTitleLbl.text = subTitle
         whiteBox.addSubview(subTitleLbl)*/
         
         
         //4 Button
         if buttonType == "OK" {
         let button = AlertOkButton()
         button.frame = CGRect(x: (whiteBox.frame.width / 2) - 60, y: cloudImageView.center.y + 200, width: 120, height: 40)
         button.setTitle("OK".localized(), for: .normal)
         button.backgroundColor = Colors.APP_DARK_GREEN
         button.titleLabel?.font = UIFont(name: "BOLD".localized(), size: 15)
         button.setTitleColor(UIColor.white, for: .normal)
         button.layer.cornerRadius = button.frame.height/2
         button.layer.borderWidth = 2
         button.layer.borderColor = UIColor.clear.cgColor
         //button.clipsToBounds = true
         
         whiteBox.addSubview(button)
         
         }
         
         //4.1
         if buttonType == "RETRY" {
         let button = JoinMeetingButton()
         button.frame = CGRect(x: (whiteBox.frame.width / 2) - 60, y: cloudImageView.center.y + 250, width: 120, height: 40)
         button.setTitle("retry".localized(), for: .normal)
         button.backgroundColor = Colors.APP_DARK_GREEN
         button.titleLabel?.font = UIFont(name: "BOLD".localized(), size: 15)
         button.setTitleColor(UIColor.white, for: .normal)
         button.layer.cornerRadius = button.frame.height/2
         button.layer.borderWidth = 2
         button.layer.borderColor = UIColor.clear.cgColor
         //button.clipsToBounds = true
         whiteBox.addSubview(button)
         
         }
         */
        
        //4...
        
        loaderContainerView.addSubview(facultyPicker)
        win.addSubview(loaderContainerView)
        win.bringSubviewToFront(loaderContainerView)
        
    }
}

public func crossButtonAction() {
    
    let subViewArray = win.subviews.filter { (view) -> Bool in
        view.tag == 8768
    }
    
    if subViewArray.count > 0 {
        subViewArray[0].removeFromSuperview()
    }
}


//MARK: Okay Button
class JoinMeetingButton: UIButton {
    
    override init(frame: CGRect) {
         super.init(frame: frame)
         self.setup()
    }

    required init?(coder aDecoder: NSCoder) {
         super.init(coder: aDecoder)
         self.setup()
    }

    private func setup() {
        self.addTarget(self, action: #selector(okButtonTapped), for: .touchUpInside)
    }
        
    @objc func okButtonTapped(sender: UIButton) {
        hideCustomAlertBox()
        setRootView(tabBarIndex: 0)
    }
    
}
*/
