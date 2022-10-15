//
//  Extension.swift
//  Spedia
//
//  Created by Viraj Sharma on 17/05/2020.
//  Copyright © 2020 Viraj Sharma. All rights reserved.
//

import Foundation
import UIKit


//MARK:=====================================
//MARK: String
//MARK:=====================================

extension String {

    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return nil
        }
    }
    
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
    
    
    var containsNonEnglishNumbers: Bool {
        return !isEmpty && range(of: "[^0-9]", options: .regularExpression) == nil
    }
    
    var english: String {
        return self.applyingTransform(StringTransform.toLatin, reverse: false) ?? self
    }
    
    
    func convertToAttributedFromHTML(fontSize: CGFloat) -> NSAttributedString? {
        
        /*
         var attributedText: NSAttributedString?
         
         let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue]
         if let data = data(using: .unicode, allowLossyConversion: true), let attrStr = try? NSAttributedString(data: data, options: options, documentAttributes: nil) {
         attributedText = attrStr
         }
         
         return attributedText
         */
        
        var attributedText =  NSMutableAttributedString(string: self)
        
        //let options: [NSMutableAttributedString.DocumentReadingOptionKey: Any] = [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue]
        
        let options: [NSMutableAttributedString.DocumentReadingOptionKey: Any] = [.documentType: NSAttributedString.DocumentType.html]
        
        if let data = data(using: .unicode, allowLossyConversion: true), let attrStr = try? NSMutableAttributedString(data: data, options: options, documentAttributes: nil) {
            attributedText = attrStr
        }
        
        attributedText.addAttributes([NSAttributedString.Key.font: UIFont(name: "BOLD".localized(), size: fontSize) ??  UIFont.systemFont(ofSize: 26)], range: NSMakeRange(0,attributedText.length))
        
        
        
        return attributedText
        
    }
    
    
    func localized(bundle: Bundle = .main, tableName: String = "Localizable") -> String {
        return NSLocalizedString(self, tableName: tableName, value: "**\(self)**", comment: "")
    }
    
    
    func getAttributedString<T>(_ key: NSAttributedString.Key, value: T) -> NSAttributedString {
        let applyAttribute = [ key: T.self ]
        let attrString = NSAttributedString(string: self, attributes: applyAttribute)
        return attrString
    }
    
    func strikeThrough(showOrNot: Bool) -> NSAttributedString {
        
        let attributeString =  NSMutableAttributedString(string: self)
        
        attributeString.addAttribute(
            NSAttributedString.Key.strikethroughStyle,
            value: NSUnderlineStyle.single.rawValue,
            range:NSMakeRange(0,attributeString.length))
        
        attributeString.addAttribute(.strikethroughColor, value: showOrNot ? UIColor.black : UIColor.clear, range: NSMakeRange(0,attributeString.length))
        
        return attributeString
    }
    
    
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
    
    
    func countryFlag(countryCode: String) -> String {
        return String(String.UnicodeScalarView(
                        countryCode.unicodeScalars.compactMap(
                            { UnicodeScalar(127397 + $0.value) })))
    }
    
    func image() -> UIImage? {
        let size = CGSize(width: 20, height: 20)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        UIColor.clear.set()
        let rect = CGRect(origin: .zero, size: size)
        UIRectFill(CGRect(origin: .zero, size: size))
        (self as AnyObject).draw(in: rect, withAttributes: [.font: UIFont.systemFont(ofSize: 20)])
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    func decodeUniCode() -> String {
        let data = self.data(using: .utf16)!
        return String(data: data, encoding: .nonLossyASCII) ?? self
    }
    
    func encodeUniCode() -> String {
        let data = self.data(using: .nonLossyASCII, allowLossyConversion: true)!
        return String(data: data, encoding: .utf16)!
    }
    
}


extension UIImageView {
    
   func setImageColor(color: UIColor) {
    let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
    self.image = templateImage
    self.tintColor = color
  }
    
  func tintImageColor(color : UIColor) {
        if (image?.responds(to: #selector(image?.withRenderingMode(_:))) ?? false){
            guard self.image != nil else{return}
            if #available(iOS 11, *) {
                self.image = self.image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
            }
        }else{
            
        }
        self.tintColor = color
   }
    
}





enum AppStoryboard: String {
    
    case main = "Main"
    //case home = "Home"
    //case mycart = "MyCart"
    //case chat = "Chat"
    //case tranning = "Traning"
    //case more = "More"
    
    var instance: UIStoryboard {
        
        let name = mainStoryboadName
       
        return UIStoryboard(name: name, bundle: Bundle.main)
    }
    
    func viewController<T: UIViewController>(viewControllerClass: T.Type) -> T? {
        let storyboardID = (viewControllerClass as UIViewController.Type).storyboardID
        return instance.instantiateViewController(withIdentifier: storyboardID) as? T
    }
    
}








@IBDesignable
class GradientView: UIView {
    
    @IBInspectable public var showGradient : Bool = false {
        didSet{
            if showGradient == true{
                
            }else{
                
            }
        }
    }
    
    @IBInspectable
    public var startColor: UIColor = .white {
        didSet {
            if showGradient == true{
                layer.insertSublayer(gradientLayer, at: 0)
                layer.insertSublayer(gradientLayer, at: 0)
                gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
                setNeedsDisplay()
            }
        }
    }
    
    @IBInspectable
    public var endColor: UIColor = .white {
        didSet {
            if showGradient == true{
                gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
                gradientLayer.locations = [0, 1]
                setNeedsDisplay()
            }
        }
    } 
    
    @IBInspectable
    public var shadowColor: UIColor = .lightGray {
        didSet {
            self.layer.shadowColor = UIColor.darkGray.cgColor
        }
    }
    
    @IBInspectable
    public var shadowRadius: CGFloat = 0 {
        didSet {
            self.layer.shadowColor = UIColor.darkGray.cgColor
            self.layer.shadowRadius = shadowRadius
        }
    }
    
    @IBInspectable
    public var ShadowOpacity: Float = 0.5 {
        didSet{
            self.layer.shadowOpacity = ShadowOpacity
        }
    }
    
    @IBInspectable
    public var ShadowWidth: CGFloat = 0 {
        didSet{
            self.layer.shadowOffset = CGSize(width: ShadowWidth, height: ShadowHeight)
        }
    }
    
    @IBInspectable
    public var ShadowHeight: CGFloat = 0 {
        didSet{
            self.layer.shadowOffset = CGSize(width: ShadowWidth, height: ShadowHeight)
        }
    }
    
    @IBInspectable
    public var cornerRadius : CGFloat = 0 {
        didSet{
            self.layer.cornerRadius = cornerRadius
            gradientLayer.cornerRadius = cornerRadius
            
        }
    }
    
    @IBInspectable
    public var roundImage : Bool = false{
        didSet{
            if roundImage == true{
                self.layer.cornerRadius = self.frame.height / 2
                self.clipsToBounds = false
            }else{
                self.layer.cornerRadius = 0
                self.clipsToBounds = true
            }
        }
    }
    
    @IBInspectable
    public var BorderWidth: CGFloat = 0 {
        didSet {
            self.layer.borderWidth = BorderWidth
        }
    }
    
    @IBInspectable
    public var BorderColor: UIColor = .white {
        didSet {
            self.layer.borderColor = BorderColor.cgColor
        }
    }
   
    @IBInspectable
    public var isTopToBottom: Bool = false {
        didSet {
            if isTopToBottom {
                gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
                gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.8)
            }else{
                gradientLayer.startPoint = CGPoint(x: 0.25, y: 0.5)
                gradientLayer.endPoint = CGPoint(x: 0.75, y: 0.5)
            }
        }
    }
    
    lazy var gradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.colors = [self.startColor.cgColor, self.endColor.cgColor]
        if isTopToBottom {
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
            gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.8)
        }else{
            gradientLayer.startPoint = CGPoint(x: 0.25, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 0.75, y: 0.5)
        }
        
        return gradientLayer
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        gradientLayer.locations = [0, 1]
    }
    
    override func layoutSubviews() {
        gradientLayer.frame = bounds
    }
    
    typealias GradientType = (x: CGPoint, y: CGPoint)
    
    class GradientLayer : CAGradientLayer {
        var gradient: GradientType? {
            didSet {
                startPoint = gradient?.x ?? CGPoint.zero
                endPoint = gradient?.y ?? CGPoint.zero
            }
        }
    }
}






import SwiftyJSON

//1
func convertDateFormatter(date: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    //this your string date format
    dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
    dateFormatter.locale = Locale(identifier: "en")
    let convertedDate = dateFormatter.date(from: date)

    guard dateFormatter.date(from: date) != nil else {
        //assert(false, "no date from string")
        return ""
    }

    dateFormatter.dateFormat = "yyyy-MM-dd"
    dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
    let timeStamp = dateFormatter.string(from: convertedDate!)

    return timeStamp
}



//2
extension JSON {
    mutating func merge(other: JSON) {
        for (key, subJson) in other {
            self[key] = subJson
        }
    }

    func merged(other: JSON) -> JSON {
        var merged = self
        merged.merge(other: other)
        return merged
    }
}



//IF IS STUDENT
func setRootView(tabBarIndex : Int) {
     //MARK: DND
     let mainStoryBoard = UIStoryboard(name: mainStoryboadName, bundle: nil)
     let vc = mainStoryBoard.instantiateViewController(withIdentifier: "BottomTabBarViewController") as! BottomTabBarViewController
     vc.selectedIndex = tabBarIndex
     let appDelegate = UIApplication.shared.delegate as! AppDelegate
     appDelegate.window?.rootViewController = vc

}


//IF IS PARENT
func setParentRootView() {
    let mainStoryBoard = UIStoryboard(name: mainStoryboadName, bundle: nil)
      let vc = mainStoryBoard.instantiateViewController(withIdentifier: "ParentChildsViewController") as! ParentChildsViewController
     let appDelegate = UIApplication.shared.delegate as! AppDelegate
     appDelegate.window?.rootViewController = vc
}



//IF UNIVERSITY
func setUniversityRootView(tabBarIndex : Int) {
     //MARK: DND
     let mainStoryBoard = UIStoryboard(name: mainStoryboadName, bundle: nil)
     let vc = mainStoryBoard.instantiateViewController(withIdentifier: "UniversityTabBarViewController") as! UniversityTabBarViewController
     vc.selectedIndex = tabBarIndex
     let appDelegate = UIApplication.shared.delegate as! AppDelegate
     appDelegate.window?.rootViewController = vc
}



//


//MARK: ONLY ....
func setTimeLineRoot() {
  
    let mainStoryBoard = UIStoryboard(name: mainStoryboadName, bundle: nil)
      let vc = mainStoryBoard.instantiateViewController(withIdentifier: "AskSpediaViewController") as! AskSpediaViewController
     let appDelegate = UIApplication.shared.delegate as! AppDelegate
     appDelegate.window?.rootViewController = vc
    
}



func setCartRootView() {
      
     let mainStoryBoard = UIStoryboard(name: mainStoryboadName, bundle: nil)
      let vc = mainStoryBoard.instantiateViewController(withIdentifier: "BottomTabBarViewController") as! BottomTabBarViewController
     let appDelegate = UIApplication.shared.delegate as! AppDelegate
     //vc.tabBarController?.selectedIndex = 2
     appDelegate.window?.rootViewController = vc
    
}


func setLiveClassAsRootView() {
  
    if let topController = UIApplication.topViewController() {
        
        //Goto Home First
        topController.tabBarController?.selectedIndex = 0
        
        //Then Goto Live Page
        //MARK: Otherwise App may crash
        topController.tabBarController?.selectedIndex = 2
        
    }
    
}


func setNotificationAsRootView() {
  
     let mainStoryBoard = UIStoryboard(name: mainStoryboadName, bundle: nil)
       let redViewController = mainStoryBoard.instantiateViewController(withIdentifier: "NotificaitonViewController") as! NotificaitonViewController
     redViewController.whereFromCome = "Redirection"
     let appDelegate = UIApplication.shared.delegate as! AppDelegate
     appDelegate.window?.rootViewController = redViewController
    
}


func setAskSpediaListAsRootView() {
  
     let mainStoryBoard = UIStoryboard(name: mainStoryboadName, bundle: nil)
       let redViewController = mainStoryBoard.instantiateViewController(withIdentifier: "AskSpediaListViewController") as! AskSpediaListViewController
     redViewController.whereFromCome = "Redirection"
     let appDelegate = UIApplication.shared.delegate as! AppDelegate
     appDelegate.window?.rootViewController = redViewController
    
}



func logoutNow() {
  
  //KeychainItem.deleteUserIdentifierFromKeychain()
  
  UserDefaults.standard.set(nil, forKey: UserDefaultKeys.userPersonalDataKey)
  loadUserData()
    
  let mainStoryBoard = UIStoryboard(name: mainStoryboadName, bundle: nil)
    let redViewController = mainStoryBoard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
  let appDelegate = UIApplication.shared.delegate as! AppDelegate
  appDelegate.window?.rootViewController = redViewController

    
}


func setOnboardingRoot() {
  
    let mainStoryBoard = UIStoryboard(name: mainStoryboadName, bundle: nil)
      let vc = mainStoryBoard.instantiateViewController(withIdentifier: "OnboadingViewController") as! OnboadingViewController
     let appDelegate = UIApplication.shared.delegate as! AppDelegate
     appDelegate.window?.rootViewController = vc
    
}


func setLoginAsRootView() {
  
    let mainStoryBoard = UIStoryboard(name: mainStoryboadName, bundle: nil)
      let redViewController = mainStoryBoard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    appDelegate.window?.rootViewController = redViewController
    
}




extension Date {
    func string(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    func currentTimeMillis() -> Int64 {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
}



import SVProgressHUD

extension UIViewController {
    
    //1 Main
    class var storyboardID: String {
        return "\(self)"
    }
    
    static func instantiate(fromAppStoryboard appStoryboard: AppStoryboard) -> Self? {
        return appStoryboard.viewController(viewControllerClass: self)
    }
    
    //2
    //Show a basic alert
    func showAlert(alertText : String, alertMessage : String) {
        let alert = UIAlertController(title: alertText, message: alertMessage, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK".localized(), style: UIAlertAction.Style.default, handler: nil))
        //Add more actions as you see fit
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    //3
    func alertWithAction(withTitle : String, yesButton : String, noButton : String, from : String, fromVc : UIViewController) {
        
        // Create the alert controller
        let alertController = UIAlertController(title: "", message: withTitle.localized(), preferredStyle: .alert)
        
        // Create the actions
        let okAction = UIAlertAction(title: yesButton.localized(), style: UIAlertAction.Style.default) {
            UIAlertAction in
            
            
            // IF FROM FORGOT PASSWORD PAGE...
            if from == "forgotView" {
                fromVc.dismiss(animated: true, completion: nil)
            }
            
        }
        
        
        let cancelAction = UIAlertAction(title: noButton.localized(), style: UIAlertAction.Style.cancel) {
            UIAlertAction in
            
            if from == "requestPrivateClassView"  {
                setRootView(tabBarIndex: 2)
            }
            
        }
        
        // Add the actions
        alertController.addAction(okAction)
        
        if !noButton.isEmpty {
            alertController.addAction(cancelAction)
        }
        
        
        // Present the controller
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    
    
    
    
    func selectEng() {
        
        if L102Language.isCurrentLanguageArabic() {
            
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
            self.view.layoutIfNeeded()
            self.view.layoutSubviews()
            
            L102Language.setAppleLAnguageTo(lang: "en")
            
            viewWillAppear(false)
        }
        
        
        UIView.appearance().semanticContentAttribute = .forceLeftToRight
        
        UIView.transition(with: self.view, duration: 0.5, options: .transitionCrossDissolve, animations: { () -> Void in
        }) { (finished) -> Void in
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
            self.view.layoutIfNeeded()
            self.view.layoutSubviews()
        }
        
    }
    
    
    func selectAr() {
        
        if L102Language.isCurrentLanguageArabic() == false {
            
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
            self.view.layoutIfNeeded()
            self.view.layoutSubviews()
            
            L102Language.setAppleLAnguageTo(lang: "ar")
            viewWillAppear(false)
        }
        
        
        UIView.appearance().semanticContentAttribute = .forceRightToLeft
        
        UIView.transition(with: self.view, duration: 0.5, options: .transitionCrossDissolve, animations: { () -> Void in
        }) { (finished) -> Void in
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
            self.view.layoutIfNeeded()
            self.view.layoutSubviews()
        }
        
    }
    

    
    //MARK: SHARE FILE WITH CLICK LOCATION's
    func shareFileWith(localFilePath : URL, sender: Any) {
        
        if UIApplication.shared.canOpenURL(localFilePath) {
            
            showAlert(alertText: "please_wait_loading".localized(), alertMessage: "")
            
        } else {
            //iPad Crash issue
            guard let button = sender as? UIView else {
                return
            }
            
            AppShared.object.docVC = UIDocumentInteractionController(url: localFilePath)
            AppShared.object.docVC.presentOptionsMenu(from: UIDevice.isPad ? button.frame : self.view.frame, in: self.view, animated: true)
            
        }
    }
    
    
    
    func showAlertWithList(title: String?, message: String?, buttonTitles: [String]? = nil, highlightedButtonIndex: Int? = nil, completion: ((Int) -> Void)? = nil) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        var allButtons = buttonTitles ?? [String]()
        if allButtons.count == 0 {
            allButtons.append("OK")
        }
        
        for index in 0..<allButtons.count {
            let buttonTitle = allButtons[index]
            let action = UIAlertAction(title: buttonTitle, style: .default, handler: { (_) in
                completion?(index)
            })
            alertController.addAction(action)
            // Check which button to highlight
            if let highlightedButtonIndex = highlightedButtonIndex, index == highlightedButtonIndex {
                alertController.preferredAction = action
            }
        }
        self.present(alertController, animated: true, completion: nil)
        return alertController
    }
    
    
    func addChildViewNow(_ viewController:UIViewController, inView view:UIView){
        viewController.willMove(toParent: self)
        viewController.view.frame = view.bounds
        view.addSubview(viewController.view)
        self.addChild(viewController)
        viewController.didMove(toParent: self)
    }
    
}


extension Data {
    var hexString: String {
        let hexString = map { String(format: "%02.2hhx", $0) }.joined()
        return hexString
    }
}




extension UIImage {
    
    func imageWithColor(color1: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        color1.setFill()
        
        let context = UIGraphicsGetCurrentContext()
        context?.translateBy(x: 0, y: self.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        context?.setBlendMode(CGBlendMode.normal)
        
        let rect = CGRect(origin: .zero, size: CGSize(width: self.size.width, height: self.size.height))
        context?.clip(to: rect, mask: self.cgImage!)
        context?.fill(rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    /// SwifterSwift: UIImage with rounded corners
    ///
    /// - Parameters:
    ///   - radius: corner radius (optional), resulting image will be round if unspecified
    /// - Returns: UIImage with all corners rounded
    func withRoundedCorners(radius: CGFloat? = nil) -> UIImage? {
        let maxRadius = min(size.width, size.height) / 2
        let cornerRadius: CGFloat
        if let radius = radius, radius > 0, radius <= maxRadius {
            cornerRadius = radius
        } else {
            cornerRadius = maxRadius
        }
        
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        
        let rect = CGRect(origin: .zero, size: size)
        UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).addClip()
        draw(in: rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    
    /// SwifterSwift: Size in bytes of UIImage
    func compressedData(quality: CGFloat = 1.0) -> Data {
        return jpegData(compressionQuality: quality) ?? Data()
    }
    
    
    /// - Parameter radians: The angle, in radians, by which to rotate the image.
    /// - Returns: A new image rotated by the given angle.
    func rotated(by radians: CGFloat) -> UIImage? {
        let destRect = CGRect(origin: .zero, size: size)
            .applying(CGAffineTransform(rotationAngle: radians))
        let roundedDestRect = CGRect(x: destRect.origin.x.rounded(),
                                     y: destRect.origin.y.rounded(),
                                     width: destRect.width.rounded(),
                                     height: destRect.height.rounded())
        
        UIGraphicsBeginImageContextWithOptions(roundedDestRect.size, false, scale)
        guard let contextRef = UIGraphicsGetCurrentContext() else { return nil }
        
        contextRef.translateBy(x: roundedDestRect.width / 2, y: roundedDestRect.height / 2)
        contextRef.rotate(by: radians)
        
        draw(in: CGRect(origin: CGPoint(x: -size.width / 2,
                                        y: -size.height / 2),
                        size: size))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
}




//MARK: LOAD ALL FONTS
public extension UIFont {
    
    class func loadAllFonts(bundleIdentifierString: String) {
        
        //English
        registerFontWithFilenameString(filenameString: "NunitoSans-Regular.ttf", bundleIdentifierString: bundleIdentifierString)
        registerFontWithFilenameString(filenameString: "NunitoSans-Bold.ttf", bundleIdentifierString: bundleIdentifierString)
        registerFontWithFilenameString(filenameString: "NunitoSans-ExtraBold.ttf", bundleIdentifierString: bundleIdentifierString)
        registerFontWithFilenameString(filenameString: "NunitoSans-ExtraLight.ttf", bundleIdentifierString: bundleIdentifierString)
        registerFontWithFilenameString(filenameString: "NunitoSans-Light.ttf", bundleIdentifierString: bundleIdentifierString)
        registerFontWithFilenameString(filenameString: "NunitoSans-SemiBold.ttf", bundleIdentifierString: bundleIdentifierString)
        
        
        //Arabic
        registerFontWithFilenameString(filenameString: "Kufi-Light.ttf", bundleIdentifierString: bundleIdentifierString)
        registerFontWithFilenameString(filenameString: "Kufi-Regular.ttf", bundleIdentifierString: bundleIdentifierString)
        registerFontWithFilenameString(filenameString: "Kufi-Bold.ttf", bundleIdentifierString: bundleIdentifierString)
    
    }
    
    /*
    static func registerFontWithFilenameString(filenameString: String, bundleIdentifierString: String) {

           let bundle = Bundle(identifier: bundleIdentifierString)!
        
           guard let pathForResourceString = bundle.path(forResource: filenameString, ofType: nil) else {
               print("UIFont+:  Failed to register font - path for resource not found.")
               return
           }

           guard let fontData = NSData(contentsOfFile: pathForResourceString) else {
               print("UIFont+:  Failed to register font - font data could not be loaded.")
               return
           }

           guard let dataProvider = CGDataProvider(data: fontData) else {
               print("UIFont+:  Failed to register font - data provider could not be loaded.")
               return
           }

           guard let font = CGFont(dataProvider) else {
               print("UIFont+:  Failed to register font - font could not be loaded.")
               return
           }

           var errorRef: Unmanaged<CFError>? = nil
           if (CTFontManagerRegisterGraphicsFont(font, &errorRef) == false) {
               print("UIFont+:  Failed to register font - register graphics font failed - this font may have already been registered in the main bundle.")
           }
    }*/
    
    
    
    static func registerFontWithFilenameString(filenameString: String, bundleIdentifierString: String) {
        if let frameworkBundle = Bundle(identifier: bundleIdentifierString) {
            let pathForResourceString = frameworkBundle.path(forResource: filenameString, ofType: nil)
            let fontData = NSData(contentsOfFile: pathForResourceString!)
            let dataProvider = CGDataProvider(data: fontData!)
            let fontRef = CGFont(dataProvider!)
            var errorRef: Unmanaged<CFError>? = nil
            
            if (CTFontManagerRegisterGraphicsFont(fontRef!, &errorRef) == false) {
                print("Failed to register font - register graphics font failed - this font may have already been registered in the main bundle.")
            }
        }
        else {
            print("Failed to register font - bundle identifier invalid.")
        }
    }
}




//=====================================================
//MARK: CONVERT HTML TEXT TO PLAIN TEXT START
//=====================================================

extension Data {
    var html2AttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: self, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            print("error:", error)
            return  nil
        }
    }
    var html2String: String { html2AttributedString?.string ?? "" }
}

extension StringProtocol {
    var html2AttributedString: NSAttributedString? {
        Data(utf8).html2AttributedString
    }
    var html2String: String {
        html2AttributedString?.string ?? ""
    }
}




//=====================================================
//MARK: CONVERT HTML TEXT TO PLAIN TEXT END
//=====================================================

func getHtmlStringByAdding(string:String,isLtr:Bool) -> String {
        var htmlString = ""
            htmlString += !isLtr ? "<html dir=\"rtl\">" : "<html dir=\"ltr\">"
//            htmlString += "<html dir=\"rtl\">"
            htmlString += "<Head>"
            htmlString += "<style type=\"text/css\">"
            htmlString += ".question_content_table{ vertical-align: middle; }"
            htmlString += ".question_content_table td{ vertical-align: middle; }"
            htmlString += ".question_content_table img {vertical-align: middle;margin:0;padding:0;outline:0;border:none;position:relative; top:-5px;}"
        
            if(UIDevice.current.userInterfaceIdiom == .pad) {
                htmlString += ".question_content_table td span{font-size:22px !important; font-weight:normal !important;}"
                htmlString += ".question_content_table td{font-size:22px !important; font-weight:normal !important;}"
            }
        
            htmlString += "</style>"
            htmlString += " </Head>"
            htmlString += "<body>"
            htmlString += "<table class='question_content_table'>"
            htmlString += "<td >"
            htmlString += string
            htmlString += "</td>"
            htmlString += "</table>"
            htmlString += "</body>"
            htmlString += "</html>"
        
        return htmlString
}




func isValidEmail(_ email: String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

    let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailPred.evaluate(with: email)
}





extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}


extension Double {
    func roundTo(decimalPlaces: Int) -> String {
        let str = String(format: "%.2f%%", decimalPlaces)
        return str
    }
    
    
    
    func toPrice(currency: String) -> String {
        let nf = NumberFormatter()
        nf.decimalSeparator = "."
        nf.groupingSeparator = ","
        nf.groupingSize = 0
        nf.usesGroupingSeparator = true
        nf.minimumFractionDigits = 0
        nf.maximumFractionDigits = 0
        nf.roundingMode = .halfEven
        return (nf.string(from: NSNumber(value: self)) ?? "?") + currency
    }
    
    
    
    
}



extension UIScrollView {
   func scrollToBottom(animated: Bool) {
     if self.contentSize.height < self.bounds.size.height { return }
     let bottomOffset = CGPoint(x: 0, y: self.contentSize.height - self.bounds.size.height)
     self.setContentOffset(bottomOffset, animated: animated)
  }
}




extension UICollectionViewFlowLayout {

    open override var flipsHorizontallyInOppositeLayoutDirection: Bool {
        return L102Language.isCurrentLanguageArabic() ? true : false
    }

}




func setSystemLangauge(code : String, withAnimaiton : Bool) {
/*
    L102Language.setAppleLAnguageTo(lang: "\(code)")
    UIView.appearance().semanticContentAttribute = L102Language.isCurrentLanguageArabic() ? .forceRightToLeft : .forceLeftToRight
    
    if withAnimaiton {
        let mainwindow = (UIApplication.shared.delegate?.window!)!
        mainwindow.backgroundColor = UIColor(hue: 0.6477, saturation: 0.6314, brightness: 0.6077, alpha: 0.8)
        UIView.transition(with: mainwindow, duration: 0.55001, options: .transitionFlipFromLeft, animations: { () -> Void in
        }) { (finished) -> Void in
            L012Localizer.DoTheSwizzling()
        }
    }
    */
}


extension UserDefaults {
    func imageForKey(key: String) -> UIImage? {
        var image: UIImage?
        if let imageData = data(forKey: key) {
            image = NSKeyedUnarchiver.unarchiveObject(with: imageData) as? UIImage
        }
        return image
    }
    func setImage(image: UIImage?, forKey key: String) {
        var imageData: NSData?
        if let image = image {
            imageData = NSKeyedArchiver.archivedData(withRootObject: image) as NSData?
        }
        set(imageData, forKey: key)
    }
}



extension UIButton {
    func setAttributedTextWithImagePrefix(image: UIImage, text: String, for state: UIControl.State) {
        let fullString = NSMutableAttributedString()
        
        if let imageString = getImageAttributedString(image: image) {
            fullString.append(imageString)
        }
        
        fullString.append(NSAttributedString(string: " " + text))
        
        self.setAttributedTitle(fullString, for: state)
    }
    
    func setAttributedTextWithImageSuffix(image: UIImage, text: String, for state: UIControl.State) {
        let fullString = NSMutableAttributedString(string: text + " ")
        
        if let imageString = getImageAttributedString(image: image) {
            fullString.append(imageString)
        }
        
        self.setAttributedTitle(fullString, for: state)
    }
    
    fileprivate func getImageAttributedString(image: UIImage) -> NSAttributedString? {
        let buttonHeight = self.frame.height
        
        if let resizedImage = image.getResizedWithAspect(maxHeight: buttonHeight - 14) {
            let imageAttachment = NSTextAttachment()
            imageAttachment.bounds = CGRect(x: 0, y: ((self.titleLabel?.font.capHeight ?? 20.0) - resizedImage.size.height).rounded() / 2, width: resizedImage.size.width, height: resizedImage.size.height)
            imageAttachment.image = resizedImage
            let image1String = NSAttributedString(attachment: imageAttachment)
            return image1String
        }
        
        return nil
    }
}


extension UIImage {
    
    func getResized(size: CGSize) -> UIImage? {
        if UIScreen.main.responds(to: #selector(NSDecimalNumberBehaviors.scale)) {
            UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale);
        } else {
            UIGraphicsBeginImageContext(size);
        }
        
        self.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height));
        let newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return newImage;
    }
    
    func getResizedWithAspect(scaledToMaxWidth width: CGFloat? = nil, maxHeight height: CGFloat? = nil) -> UIImage? {
        let oldWidth = self.size.width;
        let oldHeight = self.size.height;
        
        var scaleToWidth = oldWidth
        if let width = width {
            scaleToWidth = width
        }
        
        var scaleToHeight = oldHeight
        if let height = height {
            scaleToHeight = height
        }
        
        let scaleFactor = (oldWidth > oldHeight) ? scaleToWidth / oldWidth : scaleToHeight / oldHeight;
        
        let newHeight = oldHeight * scaleFactor;
        let newWidth = oldWidth * scaleFactor;
        let newSize = CGSize(width: newWidth, height: newHeight);
        
        return getResized(size: newSize);
    }
}


//MARK: UITABLEVIEW EXTENTIONS
extension UITableView {
    
    /// - Parameter completion: completion handler to run after reloadData finishes.
    func reloadDataWithBlock(_ completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0, animations: {
            self.reloadData()
        }, completion: { _ in
            completion()
        })
    }
    
    
    //func reloadDataWithBlockOLD(_ completion: @escaping () -> Void) {
        /*SVProgressHUD.show()
        self.isHidden = true
        self.scrollToBottom(animated: false)
        UIView.animate(withDuration: 3.0, animations: {
            self.reloadData()
            self.layoutIfNeeded()
        }, completion: { _ in
            completion()
            SVProgressHUD.dismiss()
            self.isHidden = false
        })*/
    //}
    
    func safeScrollToRow(at indexPath: IndexPath, at scrollPosition: UITableView.ScrollPosition, animated: Bool) {
        guard indexPath.section < numberOfSections else { return }
        guard indexPath.row < numberOfRows(inSection: indexPath.section) else { return }
        scrollToRow(at: indexPath, at: scrollPosition, animated: animated)
    }
}
