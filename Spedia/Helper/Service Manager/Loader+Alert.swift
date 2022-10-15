//
//  Loader+Alert.swift
//  Spedia
//
//  Created by Viraj Sharma on 16/08/2020.
//  Copyright © 2020 Rahul Goku. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher
import SVProgressHUD
import SwiftyJSON


let win:UIWindow = ((UIApplication.shared.delegate?.window)!)!


//MARK: CUSTOM ALERT BOX :-

public func showCustomAlertBox(title : String, subTitle : String, buttonType : String, imageName: String, textColor : UIColor) {
    
        //0
        print("\n\n\nCustom AlertBox Shown")
        let subViewArray = win.subviews.filter { (view) -> Bool in
            view.tag == 1002
        }
        if subViewArray.count > 0 {
            subViewArray[0].removeFromSuperview()
        }
    
        //1
        let loaderContainerView = UIView()
        loaderContainerView.frame = win.frame
        loaderContainerView.backgroundColor = UIColor.black.withAlphaComponent(0.70)
        loaderContainerView.tag = 1002
       
        //1.1
        let whiteBox = UIView()
        
        let iPhone = CGRect(x: 20, y: (DeviceSize.screenHeight/2) - (DeviceSize.screenWidth / 2) , width: DeviceSize.screenWidth - 40, height: DeviceSize.screenWidth + 50)
    
        let iPad = CGRect(x: 20, y: (DeviceSize.screenHeight/2) - 240 , width: 440, height: 460)
        
       
       
        whiteBox.frame = UIDevice.isPad ? iPad : iPhone
        
        if UIDevice.isPad {
         whiteBox.center = loaderContainerView.center
        }
    
        whiteBox.backgroundColor = UIColor.white
        whiteBox.layer.cornerRadius = 20.0
        
        
    
        //2 Image
        let cloudImageView = UIImageView.init(image: UIImage.init(named: imageName))
        cloudImageView.frame = CGRect(x: (whiteBox.frame.width / 2) - (90), y: 20, width: 180.0, height: 180.0)
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
        titleLbl.textColor = textColor
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
        let button = AlertRetryButton()
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
        
    
        //4...
        loaderContainerView.addSubview(whiteBox)
        win.addSubview(loaderContainerView)
        win.bringSubviewToFront(loaderContainerView)
    
}


public func hideCustomAlertBox() {
    
    let subViewArray = win.subviews.filter { (view) -> Bool in
        view.tag == 1002
    }
    if subViewArray.count > 0 {
        subViewArray[0].removeFromSuperview()
    }
}



//MARK: Okay Button
class AlertOkButton: UIButton {
    
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


//MARK: Retry Button
class AlertRetryButton: UIButton {
    
    override init(frame: CGRect) {
         super.init(frame: frame)
         self.setup()
    }

    required init?(coder aDecoder: NSCoder) {
         super.init(coder: aDecoder)
         self.setup()
    }

    private func setup() {
        self.addTarget(self, action: #selector(retryButtonTapped), for: .touchUpInside)
    }
        
    @objc func retryButtonTapped(sender: UIButton) {
        
        hideCustomAlertBox()
        if let topController = UIApplication.topViewController() {
            topController.dismiss(animated: true, completion: nil)
        }
        
    }
    
}














//MARK: NETWORK ERROR :-

public func showNetworkError() {
    
        //0
        print("\n\n\nNetwork Error Shown")
        let subViewArray = win.subviews.filter { (view) -> Bool in
            view.tag == 1001
        }
        if subViewArray.count > 0 {
            subViewArray[0].removeFromSuperview()
        }
    
        //1
        let loaderContainerView = UIView()
        loaderContainerView.frame = win.frame
        loaderContainerView.backgroundColor = Colors.APP_LIME_GREEN
        loaderContainerView.tag = 1001
        
        //2 Image
        let cloudImageView = UIImageView.init(image: UIImage.init(named: "no_network"))
        cloudImageView.frame = CGRect(x: win.center.x - 95, y: 180, width: 190.0, height: 190.0)
        cloudImageView.backgroundColor = UIColor.clear
        cloudImageView.contentMode = .scaleAspectFit
        loaderContainerView.addSubview(cloudImageView)
         
        //3 Label
        
        //3.1
        let titleLbl = UILabel(frame: CGRect(x: 0, y: cloudImageView.center.y + 95, width: DeviceSize.screenWidth, height: 25))
        titleLbl.textAlignment = .center
        titleLbl.backgroundColor = UIColor.clear
        titleLbl.font = UIFont(name: "BOLD".localized(), size: 18)
        titleLbl.textColor = UIColor.white
        titleLbl.text = "no_network".localized()
        loaderContainerView.addSubview(titleLbl)
    
        //3.2
        let subTitleLbl = UILabel(frame: CGRect(x: 10, y: cloudImageView.center.y + 190, width: DeviceSize.screenWidth - 20, height: 80))
        subTitleLbl.textAlignment = .center
        subTitleLbl.numberOfLines = 2
        subTitleLbl.backgroundColor = UIColor.clear
        subTitleLbl.font = UIFont(name: "REGULAR".localized(), size: 18)
        subTitleLbl.textColor = UIColor.white
        subTitleLbl.text = ""//"poor_connetction".localized()
        loaderContainerView.addSubview(subTitleLbl)
    
       
        //4 Button
        let button = RetryButton()
        button.frame = CGRect(x: subTitleLbl.center.x - 60, y: subTitleLbl.center.y + 60, width: 120, height: 40)
        button.setTitle("retry".localized(), for: .normal)
        button.backgroundColor = Colors.TAB_TINT_ORANGE
        button.titleLabel?.font = UIFont(name: "BOLD".localized(), size: 15)
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = button.frame.height/2
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.clear.cgColor
        //button.clipsToBounds = true
        
        loaderContainerView.addSubview(button)
        
    
        //4...
        win.addSubview(loaderContainerView)
        win.bringSubviewToFront(loaderContainerView)
    
}


public func hideNetworkError() {
    
    let subViewArray = win.subviews.filter { (view) -> Bool in
        view.tag == 1001
    }
    if subViewArray.count > 0 {
        subViewArray[0].removeFromSuperview()
    }
}



//MARK: Retry Button
class RetryButton: UIButton {
    
    override init(frame: CGRect) {
         super.init(frame: frame)
         self.setup()
    }

    required init?(coder aDecoder: NSCoder) {
         super.init(coder: aDecoder)
         self.setup()
    }
    
    
    private func setup() {
        self.addTarget(self, action: #selector(retryButtonTapped), for: .touchUpInside)
    }
    
    
    @objc func retryButtonTapped(sender: UIButton) {
        print("retryButtonTapped....")
        if Connectivity.isConnectedToInternet {
         hideNetworkError()
         if let topController = UIApplication.topViewController() {
            topController.viewWillAppear(false)
          }
        }
    }
    
    
}



//MARK: RECODING SCREEN ERROR :-

public func showRecordingError() {

        //0
        let subViewArray = win.subviews.filter { (view) -> Bool in
            view.tag == 887
        }
    
        if subViewArray.count > 0 {
            subViewArray[0].removeFromSuperview()
        }
    
        //1
        let loaderContainerView = UIView.init(frame: CGRect(x: 0, y: 0, width: UIDevice.current.orientation.isLandscape ? DeviceSize.screenHeight : DeviceSize.screenWidth, height: UIDevice.current.orientation.isLandscape ? DeviceSize.screenWidth : DeviceSize.screenHeight))
    
        loaderContainerView.backgroundColor = Colors.APP_LIME_GREEN
        loaderContainerView.layer.cornerRadius = 0
        loaderContainerView.layoutIfNeeded()
        loaderContainerView.tag = 887
     
        //print("\n\n\n Show Recording Error, With Frame",loaderContainerView.frame)

        //2 Image
        let cloudImageView = UIImageView.init(image: UIImage.init(named: "no_recoding"))
        cloudImageView.frame = CGRect(x: loaderContainerView.center.x - 50, y: loaderContainerView.center.y - 50, width: 100.0, height: 100.0)
        cloudImageView.backgroundColor = UIColor.clear
        cloudImageView.contentMode = .scaleAspectFit
        loaderContainerView.addSubview(cloudImageView)
         
        //3 Label
        
        //3.1
    let titleLbl = UILabel(frame: CGRect(x: 0, y: cloudImageView.center.y + 50, width: UIDevice.current.orientation.isLandscape ? DeviceSize.screenHeight : DeviceSize.screenWidth, height: 25))
        titleLbl.textAlignment = .center
        titleLbl.backgroundColor = UIColor.clear
        titleLbl.font = UIFont(name: "BOLD".localized(), size: 18)
        titleLbl.textColor = UIColor.white
        titleLbl.text = "no_recoding_text".localized()
        loaderContainerView.addSubview(titleLbl)
    
    
        //4 Button
        let button = StopRecodingButton()
        button.frame = CGRect(x: titleLbl.center.x - 60, y: titleLbl.center.y + 60, width: 120, height: 40)
        button.setTitle("retry".localized(), for: .normal)
        button.backgroundColor = Colors.TAB_TINT_ORANGE
        button.titleLabel?.font = UIFont(name: "BOLD".localized(), size: 15)
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = button.frame.height/2
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.clear.cgColor
        //button.clipsToBounds = true
        
        loaderContainerView.addSubview(button)
        
    
        //4...
        loaderContainerView.layoutIfNeeded()
        win.addSubview(loaderContainerView)
        win.bringSubviewToFront(loaderContainerView)
    
}


public func hideRecodingError() {
    
    let subViewArray = win.subviews.filter { (view) -> Bool in
        view.tag == 887
    }
    if subViewArray.count > 0 {
        subViewArray[0].removeFromSuperview()
    }
}





//MARK: Retry Button
class StopRecodingButton: UIButton {
    
    override init(frame: CGRect) {
         super.init(frame: frame)
         self.setup()
    }

    required init?(coder aDecoder: NSCoder) {
         super.init(coder: aDecoder)
         self.setup()
    }
    
    
    private func setup() {
        self.addTarget(self, action: #selector(stopRecodingTapped), for: .touchUpInside)
    }
    
    
    @objc func stopRecodingTapped(sender: UIButton) {
        
        let isCaptured = UIScreen.main.isCaptured

        print("stopRecodingTapped....",isCaptured)
        
        if !isCaptured {
            hideRecodingError()
        }
        
    }
    
    
}











//MARK: QR CODE IMAGE POP-UP :-

public func showQRCodeImage(imageObj : UIImage, Desc: String) {
    
    let subViewArray = win.subviews.filter { (view) -> Bool in
        view.tag == 701
    }
    if subViewArray.count > 0 {
        subViewArray[0].removeFromSuperview()
    }
    
    //1
    let loaderContainerView = UIView()
    loaderContainerView.frame = win.frame
    loaderContainerView.backgroundColor = UIColor.black.withAlphaComponent(0.70)
    loaderContainerView.tag = 701
    
    //1.1
    let whiteBox = UIView()
    
    let iPhone = CGRect(x: 20, y: (DeviceSize.screenHeight/2) - (DeviceSize.screenWidth / 2) , width: DeviceSize.screenWidth - 40, height: DeviceSize.screenWidth + 50)
    
    let iPad = CGRect(x: 20, y: (DeviceSize.screenHeight/2) - 240 , width: 440, height: 460)
    
    
    
    whiteBox.frame = UIDevice.isPad ? iPad : iPhone
    
    if UIDevice.isPad {
        whiteBox.center = loaderContainerView.center
    }
    
    whiteBox.backgroundColor = UIColor.white
    whiteBox.layer.cornerRadius = 20.0
    
    
    
    //1 QRCode ImageView
    let qrCodeImageView = UIImageView()
    qrCodeImageView.frame = CGRect(x: (whiteBox.frame.width / 2) - (100), y: 20, width: 200.0, height: 200.0)
    qrCodeImageView.backgroundColor = UIColor.clear
    qrCodeImageView.contentMode = .redraw
    qrCodeImageView.clipsToBounds = true
    qrCodeImageView.backgroundColor = UIColor.clear
    qrCodeImageView.image = imageObj
    whiteBox.addSubview(qrCodeImageView)
    
    let titleLbl = UILabel(frame: CGRect(x: 0, y: qrCodeImageView.frame.midY+100 , width: whiteBox.frame.width, height: 70))
    titleLbl.textAlignment = .center
    titleLbl.backgroundColor = UIColor.clear
    titleLbl.font = UIFont(name: "REGULAR".localized(), size: 14)
    titleLbl.textColor = UIColor.black
    titleLbl.text = Desc
    titleLbl.numberOfLines = 0
    titleLbl.clipsToBounds = true
    whiteBox.addSubview(titleLbl)
    
    //3 Close Button
    let button = AlertCloseButton()
    button.frame = CGRect(x: (whiteBox.frame.width / 2) - 60, y: titleLbl.center.y + 60, width: 120, height: 40)
    button.setTitle("close".localized(), for: .normal)
    button.backgroundColor = Colors.APP_LIGHT_GREEN
    button.titleLabel?.font = UIFont(name: "BOLD".localized(), size: 15)
    button.setTitleColor(UIColor.white, for: .normal)
    button.layer.cornerRadius = button.frame.height/2
    button.layer.borderWidth = 2
    button.layer.borderColor = UIColor.clear.cgColor
    //button.clipsToBounds = true
    whiteBox.addSubview(button)
    
    //4...
    loaderContainerView.addSubview(whiteBox)
    win.addSubview(loaderContainerView)
    win.bringSubviewToFront(loaderContainerView)
    
}


public func hideQRCodeImage() {
    
    let subViewArray = win.subviews.filter { (view) -> Bool in
        view.tag == 701
    }
    if subViewArray.count > 0 {
        subViewArray[0].removeFromSuperview()
    }
}




//MARK: Close Button
class AlertCloseButton: UIButton {
    
    override init(frame: CGRect) {
         super.init(frame: frame)
         self.setup()
    }

    required init?(coder aDecoder: NSCoder) {
         super.init(coder: aDecoder)
         self.setup()
    }

    private func setup() {
        self.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
    }
        
    @objc func closeButtonTapped(sender: UIButton) {
        hideQRCodeImage()
    }
    
    
}








//MARK: Show App Instruction Slider :-


// , completion: ((Bool) -> Void)? = nil) {

public func showCustomInstructionBox(imageJson : JSON) {

    //Check for App Instruction
    var appInstructionImages = [String]()
    let items = imageJson
    if items.count > 0 {
        for i in 0 ..< items.count {
            let currentLValue = L102Language.isCurrentLanguageArabic() ? "Ar" : "En"
            let imageUrl = UIDevice.isPad ? items[i]["ImageTab\(currentLValue)"].stringValue : items[i]["Image\(currentLValue)"].stringValue
            appInstructionImages.append(imageUrl)
        }
    }
    
    if appInstructionImages.count > 0 {
        
        //1
        SVProgressHUD.show()
        
        print("\n\n\nCustom AlertBox Shown")
        let subViewArray = win.subviews.filter { (view) -> Bool in
            view.tag == 1222
        }
        if subViewArray.count > 0 {
            subViewArray[0].removeFromSuperview()
        }
        
        let loaderContainerView = UIView()
        loaderContainerView.frame = win.frame
        loaderContainerView.backgroundColor = UIColor.white //.withAlphaComponent(0.30)
        loaderContainerView.tag = 1222
        
        
        //2 Create UISCrollView
        let carousel = UIScrollView(frame: loaderContainerView.frame)
        carousel.showsHorizontalScrollIndicator = false
        carousel.isPagingEnabled = true
        
        for i in 0 ..< appInstructionImages.count {
            
            let offset = i == 0 ? 0 : (CGFloat(i) * loaderContainerView.bounds.width)
            let imgView = UIImageView(frame: CGRect(x: offset, y: 0, width: loaderContainerView.bounds.width, height: loaderContainerView.bounds.height))
            imgView.clipsToBounds = true
            imgView.contentMode = .scaleToFill
            
            
            let url = URL(string: appInstructionImages[i])
            
            imgView.kf.setImage(
                with: url,
                placeholder: UIImage(named: ""),
                options: [], completionHandler:  {
                    result in
                    switch result {
                    case .success(let value):
                        print("Task done for: \(value.source.url?.absoluteString ?? "")")
                        
                        carousel.addSubview(imgView)
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            SVProgressHUD.dismiss()
                        }
                        
                        //completion?(true)
                        
                        
                    case .failure(let error):
                        SVProgressHUD.dismiss()
                        //completion?(false)
                        print("Job failed: \(error.localizedDescription)")
                    }
                })
            
        }
        
        carousel.contentSize = CGSize(width: CGFloat(appInstructionImages.count) * loaderContainerView.bounds.width, height: loaderContainerView.bounds.height)
        
        loaderContainerView.addSubview(carousel)
        
        
        //Add Hide Button
        //3 Close Button
        let button = CloseInstructionPopUpButton()
        button.frame = CGRect(x: (loaderContainerView.frame.width / 2) - 120, y: loaderContainerView.bounds.height - 225, width: 240, height: 60)
        button.setTitle("okay_thanks".localized(), for: .normal)
        button.backgroundColor = Colors.APP_LIGHT_GREEN
        button.titleLabel?.font = UIFont(name: "BOLD".localized(), size: 18)
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = button.frame.height/2
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.clear.cgColor
        //button.clipsToBounds = true
        loaderContainerView.addSubview(button)
        
        //4...
        win.addSubview(loaderContainerView)
        win.bringSubviewToFront(loaderContainerView)
    }
    
}




//MARK: Close Button
class CloseInstructionPopUpButton: UIButton {
    
    override init(frame: CGRect) {
         super.init(frame: frame)
         self.setup()
    }

    required init?(coder aDecoder: NSCoder) {
         super.init(coder: aDecoder)
         self.setup()
    }

    private func setup() {
        self.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
    }
        
    @objc func closeButtonTapped(sender: UIButton) {
        let subViewArray = win.subviews.filter { (view) -> Bool in
            view.tag == 1222
        }
        if subViewArray.count > 0 {
            subViewArray[0].removeFromSuperview()
        }
    }
    
    
}









//MARK: CUSTOM ADD TO CART BOX :-

public func showCustomInAppPurchaseBox(title : String, subTitle : String, buttonType : String, imageName: String, textColor : UIColor) {
    
    print("\n\n\n\n\n Apple Params is: Msg = \(title)\n Apple Id = \(globalProductIdStrIAP)\n PriceId= \(globalSubjectPriceIdIAP)\n\n")
    
    //let str = title.replacingOccurrences(of: "\\n", with: "\n")
    
    //0
    let subViewArray = win.subviews.filter { (view) -> Bool in
        view.tag == 667
    }
    if subViewArray.count > 0 {
        subViewArray[0].removeFromSuperview()
    }
    
    //1
    let loaderContainerView = UIView()
    loaderContainerView.frame = win.frame
    loaderContainerView.backgroundColor = UIColor.black.withAlphaComponent(0.70)
    loaderContainerView.tag = 667
    
    //1.1
    let whiteBox = UIView()
    
    let iPhone = CGRect(x: 20, y: (DeviceSize.screenHeight/2) - (DeviceSize.screenWidth / 2) , width: DeviceSize.screenWidth - 40, height: DeviceSize.screenWidth)
    
    let iPad = CGRect(x: 20, y: (DeviceSize.screenHeight/2) - 240 , width: 370, height: 370)
    
    
    whiteBox.frame = UIDevice.isPad ? iPad : iPhone
    
    if UIDevice.isPad {
        whiteBox.center = loaderContainerView.center
    }
    
    whiteBox.backgroundColor = UIColor.white
    whiteBox.layer.cornerRadius = 20.0
    
    
    
    //2 Image
    let cloudImageView = UIImageView.init(image: UIImage.init(named: imageName))
    cloudImageView.frame = CGRect(x: (whiteBox.frame.width / 2) - (50), y: 50, width: 100.0, height: 100.0)
    cloudImageView.backgroundColor = UIColor.clear
    cloudImageView.contentMode = .scaleAspectFit
    cloudImageView.clipsToBounds = true
    cloudImageView.backgroundColor = UIColor.clear
    whiteBox.addSubview(cloudImageView)
    
    
    //3 Label
    let labelHeight = title.height(withConstrainedWidth: whiteBox.frame.width - 20, font: UIFont(name: "REGULAR".localized(), size: 18) ?? UIFont.systemFont(ofSize: 18))
    
    //3.1
    let titleLbl = UILabel(frame: CGRect(x: 10, y: cloudImageView.bounds.maxY + 60, width: whiteBox.frame.width - 20, height: labelHeight))

    titleLbl.textAlignment = .center
    titleLbl.minimumScaleFactor = 0.5
    titleLbl.numberOfLines = 0
    titleLbl.font = UIFont(name: "REGULAR".localized(), size: 18)
    titleLbl.textColor = textColor
    titleLbl.attributedText = title.htmlToAttributedString
    titleLbl.clipsToBounds = true
    //titleLbl.sizeToFit()
    //titleLbl.backgroundColor = UIColor.clear
    whiteBox.addSubview(titleLbl)
    
    if buttonType == "subscribe_now" {
        
        let buttonTwo = SubscribeNowButton()
        buttonTwo.frame = CGRect(x: (whiteBox.frame.width / 2) - 75, y: cloudImageView.center.y + 210, width: 150, height: 40)
        buttonTwo.setTitle("subscribe_ph".localized(), for: .normal)
        buttonTwo.backgroundColor = Colors.TAB_TINT_ORANGE
        buttonTwo.titleLabel?.font = UIFont(name: "BOLD".localized(), size: 15)
        buttonTwo.setTitleColor(UIColor.white, for: .normal)
        buttonTwo.layer.cornerRadius = buttonTwo.frame.height/2
        buttonTwo.layer.borderWidth = 2
        buttonTwo.layer.borderColor = UIColor.clear.cgColor
        //button.clipsToBounds = true
        whiteBox.addSubview(buttonTwo)

    }
    
    if buttonType == "buy_now" {
        
        let buttonTwo = BuyNowButton()
        buttonTwo.frame = CGRect(x: (whiteBox.frame.width / 2) - 75, y: cloudImageView.center.y + 210, width: 150, height: 40)
        buttonTwo.setTitle("buy_now_ph".localized(), for: .normal)
        buttonTwo.backgroundColor = Colors.TAB_TINT_ORANGE
        buttonTwo.titleLabel?.font = UIFont(name: "BOLD".localized(), size: 15)
        buttonTwo.setTitleColor(UIColor.white, for: .normal)
        buttonTwo.layer.cornerRadius = buttonTwo.frame.height/2
        buttonTwo.layer.borderWidth = 2
        buttonTwo.layer.borderColor = UIColor.clear.cgColor
        //button.clipsToBounds = true
        whiteBox.addSubview(buttonTwo)

    }
        
    //4...
    loaderContainerView.addSubview(whiteBox)
    win.addSubview(loaderContainerView)
    win.bringSubviewToFront(loaderContainerView)
    
}


public func hideCustomAddToCartBox() {
    
    let subViewArray = win.subviews.filter { (view) -> Bool in
        view.tag == 667
    }
    if subViewArray.count > 0 {
        subViewArray[0].removeFromSuperview()
    }
}



//MARK: Okay Button
class ContinueButton: UIButton {
    
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
        hideCustomAddToCartBox()
    }
    
}


//MARK: Retry Button
class SubscribeNowButton: UIButton {
    
    override init(frame: CGRect) {
         super.init(frame: frame)
         self.setup()
    }

    required init?(coder aDecoder: NSCoder) {
         super.init(coder: aDecoder)
         self.setup()
    }

    private func setup() {
        self.addTarget(self, action: #selector(subscribeButtonTapped), for: .touchUpInside)
    }
        
    
    @objc func subscribeButtonTapped(sender: UIButton) {
        
        hideCustomAddToCartBox()
        
        GlobalFunctions.object.makeIAPNonAtomicPaymentNow(productIdStr: globalProductIdStrIAP)
        
    }
    
}


//MARK: Retry Button
class BuyNowButton: UIButton {
    
    override init(frame: CGRect) {
         super.init(frame: frame)
         self.setup()
    }

    required init?(coder aDecoder: NSCoder) {
         super.init(coder: aDecoder)
         self.setup()
    }

    private func setup() {
        self.addTarget(self, action: #selector(buyNowButtonTapped), for: .touchUpInside)
    }
        
    
    @objc func buyNowButtonTapped(sender: UIButton) {
        
        hideCustomAddToCartBox()
        
        GlobalFunctions.object.makeIAPNonAtomicPaymentNow(productIdStr: globalProductIdStrIAP)
        
    }
    
}



class LoginButton: UIButton {
    
    override init(frame: CGRect) {
         super.init(frame: frame)
         self.setup()
    }

    required init?(coder aDecoder: NSCoder) {
         super.init(coder: aDecoder)
         self.setup()
    }

    private func setup() {
        self.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
    }
        
    @objc func loginButtonTapped(sender: UIButton) {
        hideCustomAddToCartBox()
        logoutNow()
    }
    
}
