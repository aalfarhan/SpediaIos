//
//  CustomButton.swift
//  Spedia
//
//  Created by Viraj Sharma on 20/05/2020.
//  Copyright © 2020 Viraj Sharma. All rights reserved.
//

import Foundation
import UIKit

class CustomButton: UIButton {
    
    var fntSz = CGFloat()
    
    @IBInspectable var showShadowBool: Bool {
        
        get { return false }
        
        set {
            self.updateLayerProperties()
        }
        
    }
        
    @IBInspectable var isNotRounded: Bool {
        
        get { return false }
        
        set {
            self.layer.cornerRadius = 10
            self.layer.masksToBounds = true
        }
        
    }
    
    @IBInspectable var isRounded: Bool {
        
        get { return false }
        
        set {
            self.layer.cornerRadius = self.bounds.height / 2
            self.layer.masksToBounds = true
        }
        
    }
    
    
    @IBInspectable var fontTypeName: String {
        
        get { return "" }
        
        set {
            
            self.layer.borderWidth = 1.0
            if UIDevice.current.userInterfaceIdiom == .pad {
                fntSz = self.titleLabel?.font.pointSize ?? 15  + DeviceSize.screenWidth / 160
            } else {
                fntSz = self.titleLabel?.font.pointSize ?? 15
            }
            
            switch newValue {
                
            case AppFontRegular:
                self.titleLabel?.font = UIFont(name: "REGULAR".localized(), size: self.fntSz)
                
            case AppFontSemiBold:
                self.titleLabel?.font = UIFont(name: "SEMIBOLD".localized(), size: self.fntSz)
                
            case AppFontBold:
                self.titleLabel?.font = UIFont(name: "BOLD".localized(), size: self.fntSz)
                
            case AppFontLight:
                self.titleLabel?.font = UIFont(name: "LIGHT".localized(), size: self.fntSz)
                
                
            case AppFontExBold:
                self.titleLabel?.font = UIFont(name: "XTRABOLD".localized(), size: self.fntSz)
                
            default:
                print("set as defual custom label")
                
            }
            
        }
        
    }
    
    
    //@IBInspectable var btnTitleColor: UIColor = .white {
    //  didSet {
    //    setTitleColor(btnTitleColor, for: .normal)
    //}
    //}
    
    //@IBInspectable var btnBkgColor: UIColor = UIColor.black {
    //  didSet {
    //    backgroundColor = btnBkgColor
    //}
    //}
    
    @IBInspectable var btnBorderColor: UIColor = .white {
        didSet {
            self.layer.borderColor = btnBorderColor.cgColor
        }
    }
    
    
    //1
    required init?(coder aDecoder:NSCoder) {
        super.init(coder:aDecoder)
        self.layoutSubviews()
    }
    
    //2
    override init(frame:CGRect) {
        super.init(frame:frame)
        self.layoutSubviews()
        
    }
    
    //3
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    
    override func draw(_ rect: CGRect) {
        
        //if showShadowBool {
         //   self.updateLayerProperties()
        //}
    }
    
    func updateLayerProperties() {
        self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 10.0
        self.layer.masksToBounds = false
    }
    
    /*@IBInspectable var adjustFontSizeToWidth: Bool {
     get {
     return self.titleLabel?.adjustsFontSizeToFitWidth ?? false
     }
     set {
     self.titleLabel?.numberOfLines = 1
     self.titleLabel?.adjustsFontSizeToFitWidth = newValue;
     self.titleLabel?.lineBreakMode = .byClipping;
     self.titleLabel?.baselineAdjustment = .alignCenters
     }
     }*/
    
    
}





//MARK: Bell ICON Button

class BellIconButton: UIButton {
    
    override init(frame: CGRect) {
         super.init(frame: frame)
         self.setup()
    }

    required init?(coder aDecoder: NSCoder) {
         super.init(coder: aDecoder)
         self.setup()
    }

    func setup() {
        self.clipsToBounds = false
        self.backgroundColor = UIColor.clear
        self.addTarget(self, action: #selector(bellButtonTapped), for: .touchUpInside)
        //self.setNeedsDisplay()
        self.updateBellCount(color: .black)
        
    }
    
    
    @IBInspectable var bellCountColor: UIColor {
        
        get { return .black }
        
        set { self.updateBellCount(color: newValue) }
        
    }
    
    
    func updateBellCount(color : UIColor) {
        
        for subview in self.subviews {
            
            if subview.tag == 8090 {
                subview.removeFromSuperview()
                print("\n\n\n\n subview tag is : \(subview.tag)\n")
            }
            
        }
        
        let count = AppShared.object.notificationCountGlobal
        
        if count != 0 && count > 0 {
            
            print("\n\n\n\n Bell Icon Count is : \(count)\n")
            
            let countButton = UIButton(frame: CGRect(x: 7, y: -10, width: 22, height: 22))
            countButton.backgroundColor = color
            
            let contentInsets = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
            countButton.contentEdgeInsets = contentInsets
            
            countButton.setTitle("\(count)", for: .normal)
            countButton.titleLabel?.font = .systemFont(ofSize: 14)
            //UIFont (name: "Regular".localized(), size: 8)
            countButton.titleLabel?.textColor = UIColor.white
            countButton.isUserInteractionEnabled = false
            countButton.titleLabel?.textAlignment = .center
            countButton.clipsToBounds = true
            
            /*countButton.text = "\(count)"
            countButton.font = .systemFont(ofSize: 14)
            //UIFont (name: "Regular".localized(), size: 8)
            countButton.textColor = UIColor.white
            countButton.isUserInteractionEnabled = false
            countButton.textAlignment = .center
            countButton.clipsToBounds = true*/
            
            if count > 99 {
               countButton.sizeToFit()
            }
            
            countButton.layer.cornerRadius = countButton.frame.size.height/2.0
            countButton.layer.masksToBounds = true
            countButton.tag = 8090
            self.addSubview(countButton)
            
        } else {
            
            //do nothing now
            
        }
        
        //self.setImage(#imageLiteral(resourceName: "icon_bell_24pt"), for: .normal)
        //self.setNeedsDisplay()
    }
    
    
    

    @objc func bellButtonTapped(sender: UIButton) {
        
        print("Bell Button Clicked....")
        
        if let topController = UIApplication.topViewController() {
            if let vc = NotificaitonViewController.instantiate(fromAppStoryboard: .main) {
               vc.modalPresentationStyle = .fullScreen
                vc.whereFromCome = WhereFromAmIKeys.bellIcon
               topController.present(vc, animated: true, completion: nil)
               //topController.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
    }
    
}



//MARK: Support (Customer Care) Button

class SupportButton: UIButton {
    
    override init(frame: CGRect) {
         super.init(frame: frame)
         self.setup()
    }

    required init?(coder aDecoder: NSCoder) {
         super.init(coder: aDecoder)
         self.setup()
    }

    private func setup() {
        
        self.setNeedsDisplay()
    
        self.clipsToBounds = true
        self.backgroundColor = UIColor.clear
        self.addTarget(self, action: #selector(supportButtonTapped), for: .touchUpInside)
        //self.imageView?.clipsToBounds = true
        self.setNeedsDisplay()
        
            
    }
    
    
    @objc func supportButtonTapped(sender: UIButton) {
        print("Support Clicked....")
        
        if let topController = UIApplication.topViewController() {
            if let vc = ChatViewController.instantiate(fromAppStoryboard: .main) {
               vc.modalPresentationStyle = .fullScreen
               topController.present(vc, animated: true, completion: nil)
               //topController.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
    }
    
}





//MARK: Bell ICON Button

class CallGenericButton: UIButton {
    
    override init(frame: CGRect) {
         super.init(frame: frame)
         self.setup()
    }

    required init?(coder aDecoder: NSCoder) {
         super.init(coder: aDecoder)
         self.setup()
    }

    private func setup() {
        
        self.setNeedsDisplay()
        self.clipsToBounds = true
        self.backgroundColor = UIColor.clear
        self.addTarget(self, action: #selector(callButtonTapped), for: .touchUpInside)
        //self.imageView?.clipsToBounds = true
        self.setNeedsDisplay()
        
            
    }
    
    
    @objc func callButtonTapped(sender: UIButton) {
        print("callButtonTapped Clicked....")
        
        if let topController = UIApplication.topViewController() {
            if let vc = ContactUsViewController.instantiate(fromAppStoryboard: .main) {
               vc.modalPresentationStyle = .fullScreen
               topController.present(vc, animated: true, completion: nil)
               //topController.navigationController?.pushViewController(vc, animated: true)
            }
        }
    
    }
    
}





//MARK: QRCode (Scan Video) Button

class ProfileButton: UIButton {
    
    override init(frame: CGRect) {
         super.init(frame: frame)
         self.setup()
    }

    required init?(coder aDecoder: NSCoder) {
         super.init(coder: aDecoder)
         self.setup()
    }

    private func setup() {
        
        self.setNeedsDisplay()
        
        self.setImage(UIImage(named: "qrcode_scanner_bkg"), for: .normal)
        self.setBackgroundImage(nil, for: .normal)
        //self.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        //self.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        self.clipsToBounds = true
        self.backgroundColor = UIColor.clear
        self.addTarget(self, action: #selector(qrCodeButtonTapped), for: .touchUpInside)
        //self.imageView?.clipsToBounds = true
        self.setNeedsDisplay()
        
    }
    
    
    @objc func qrCodeButtonTapped(sender: UIButton) {
        print("CodeButtonTapped Clicked....")
        
        
        if let topController = UIApplication.topViewController() {
            if let vc = ScannerViewController.instantiate(fromAppStoryboard: .main) {
               vc.modalPresentationStyle = .fullScreen
               topController.present(vc, animated: true, completion: nil)
               //topController.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
    }
    
}





//MARK: Profile Button (Generic)
/*
class ProfileButton: UIButton {
    
    
    override init(frame: CGRect) {
         super.init(frame: frame)

         DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.setup()
         }
         
    }

    required init?(coder aDecoder: NSCoder) {
         super.init(coder: aDecoder)
         DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.setup()
         }
    }

    private func setup() {
        
        //0 Background Image (Dash Circle Image)
        self.setNeedsDisplay()
        self.setBackgroundImage(#imageLiteral(resourceName: "profile_green_circle_bkg"), for: .normal)
        self.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        
        
        //1 Setup Defualts
        
        self.clipsToBounds = true
        self.backgroundColor = UIColor.clear
        self.addTarget(self, action: #selector(profileButtonTapped), for: .touchUpInside)
        
        
        //2 Get Local Save Image
        let placeHolderData = UIImage.init(named: "profile_icon_placeholder")
        
        guard let savedImageData = UserDefaults.standard.data(forKey: "") ?? placeHolderData?.pngData() else { return }
        
        let profileImg = UIImage(data: savedImageData)
        self.setImage(profileImg, for: .normal)
        
        
        //3 Front Image (User Profile Image)
        self.imageView?.layer.borderWidth = 1
        self.imageView?.layer.masksToBounds = false
        self.imageView?.layer.borderColor = UIColor.clear.cgColor
        self.imageView?.layer.cornerRadius = (self.imageView?.frame.height ?? 0) / 2
        self.imageView?.clipsToBounds = true
        
        self.setNeedsDisplay()
    }
    
    
    @objc func profileButtonTapped(sender: UIButton) {
        print("Profile Button Clicked....")
        
        if let topController = UIApplication.topViewController() {
            if let vc = ProfileViewController.instantiate(fromAppStoryboard: .main) {
               vc.modalPresentationStyle = .fullScreen
               //topController.present(vc, animated: true, completion: nil)
               topController.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
    }
    
}
*/
