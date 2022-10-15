//
//  QrCodeDetailView.swift
//  Spedia
//
//  Created by Viraj Sharma on 29/09/22.
//  Copyright © 2022 Viraj Sharma. All rights reserved.
//

import UIKit
import SwiftyJSON

class QrCodeDetailView: UIView {

    //1 Objects...
    @IBOutlet var containerVieww: UIView!
    @IBOutlet var whiteBoxView: UIView!
    @IBOutlet var qrImageView: UIImageView!
    @IBOutlet var titleLbl: CustomLabel!
    @IBOutlet var closeButton: CustomButton!
    @IBOutlet var qrImageContainerView: UIView!
    
    //Responsive..
    @IBOutlet weak var heightConst: NSLayoutConstraint!
    
    //1
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    //2
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    //3
    private func commonInit() {
                
        Bundle.main.loadNibNamed("QrCodeDetailView", owner: self, options: nil)
        addSubview(containerVieww)
        
        self.layer.cornerRadius = 0
        self.clipsToBounds = true
        
        self.containerVieww.frame = self.bounds
        self.containerVieww.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.containerVieww.layer.cornerRadius = 0
        self.containerVieww.clipsToBounds = true
    
        self.whiteBoxView.clipsToBounds = true
        self.whiteBoxView.layer.cornerRadius = 15.0
        
        //Set Up Done
        self.setUpView()
        self.whiteBoxView.isHidden = true
        self.qrImageContainerView.isHidden = true
    }
    
    func setUpView() {
        self.closeButton.setTitle("close".localized(), for: .normal)
    }
    
    
    @IBAction func closeButtonAction(_ sender: Any) {
        print("noButtonAction")
        self.isHidden = true
    }
    
    func callQrCodeApi(withImage: Bool) {
        self.whiteBoxView.isHidden = true
        self.qrImageContainerView.isHidden = !withImage
        self.isHidden = false
        let urlString = getQRCodeForStudent
        
        let params = ["SessionToken": sessionTokenGlobal ?? "",
                      "StudentID": studentIdGlobal ?? 0] as [String : Any]
        
        ServiceManager().postRequest(urlString, loader: true, parameters: params) { (status, jsonResponse) in
            
            if status {
                
                let data = JSON.init(jsonResponse ?? "NO DTA")
                let qrCodeStr = "studentId?" + data["QRCode"].stringValue
                let descriptionStr = data["QRCodeDescription" + Lang.code()].stringValue
                self.titleLbl.text = descriptionStr
                if withImage {
                 self.qrImageView.image = self.generateQRCode(from: qrCodeStr) ?? UIImage.init(named: "qrcode")
                }
                self.whiteBoxView.isHidden = false
            }
        }
    }
    
    func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)
        
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)
            
            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }
        return nil
    }
}
