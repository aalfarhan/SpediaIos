//
//  ScanQrViewController.swift
//  Spedia
//
//  Created by Viraj Sharma on 09/11/2020.
//  Copyright © 2020 Viraj Sharma. All rights reserved.
//


import UIKit
import AVFoundation
import AudioToolbox
import SVProgressHUD

class ScanQrViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var scannerViewContainer: UIView!
    
    var captureSession = AVCaptureSession()
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var barCodeFrameView: UIView?
    
    
    var initialized = false
    
    let barCodeTypes = [AVMetadataObject.ObjectType.upce,
                        AVMetadataObject.ObjectType.code39,
                        AVMetadataObject.ObjectType.code39Mod43,
                        AVMetadataObject.ObjectType.code93,
                        AVMetadataObject.ObjectType.code128,
                        AVMetadataObject.ObjectType.ean8,
                        AVMetadataObject.ObjectType.ean13,
                        AVMetadataObject.ObjectType.aztec,
                        AVMetadataObject.ObjectType.pdf417,
                        AVMetadataObject.ObjectType.itf14,
                        AVMetadataObject.ObjectType.dataMatrix,
                        AVMetadataObject.ObjectType.interleaved2of5,
                        AVMetadataObject.ObjectType.qr]

    
    var crosshairView: CrosshairView? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Bar Code Scanner"
    }
    
    
    @IBAction func backButtonAction(_ sender: Any) {
            self.dismiss(animated: true, completion: nil)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        //back button
        self.backBtn.imageView?.transform =  L102Language.isCurrentLanguageArabic() ? CGAffineTransform(scaleX: -1.0, y: 1.0) : CGAffineTransform(scaleX: 1.0, y: -1.0)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if crosshairView == nil {
            crosshairView = CrosshairView(frame: CGRect(x: 0, y: 0, width: self.scannerViewContainer.frame.width, height: self.scannerViewContainer.frame.height))
            crosshairView?.backgroundColor = UIColor.clear
            self.scannerViewContainer.addSubview(crosshairView!)
        }
        setupCapture()
        
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    @objc func willEnterForeground() {
        setupCapture()
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
   
    @IBAction func back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func setupCapture() {
        if let barCodeFrameView = barCodeFrameView {
            barCodeFrameView.removeFromSuperview()
            self.barCodeFrameView = nil
        }
        var success = false
        var accessDenied = false
        var accessRequested = false
        if let barCodeFrameView = barCodeFrameView {
            barCodeFrameView.removeFromSuperview()
            self.barCodeFrameView = nil
        }
        
        let authorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
        if authorizationStatus == .notDetermined {
            accessRequested = true
            AVCaptureDevice.requestAccess(for: .video,
                                          completionHandler: { (granted:Bool) -> Void in
                                            self.setupCapture();
            })
            return
        }
        if authorizationStatus == .restricted || authorizationStatus == .denied {
            accessDenied = true
        }
        
        if initialized {
            success = true
        }
        else {
             var deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera, .builtInTelephotoCamera], mediaType: AVMediaType.video, position: .unspecified)
            if #available(iOS 10.2, *) {
                deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera, .builtInTelephotoCamera, .builtInDualCamera], mediaType: AVMediaType.video, position: .unspecified)
            } else {
               
            }
            
            if let captureDevice = deviceDiscoverySession.devices.first {
                do {
                    let videoInput = try AVCaptureDeviceInput(device: captureDevice)
                    captureSession.addInput(videoInput)
                    success = true
                } catch {
                    NSLog("Cannot construct capture device input")
                }
            }
            else {
                NSLog("Cannot get capture device")
            }
            
            if success {
                DispatchQueue.main.async {
                    let captureMetadataOutput = AVCaptureMetadataOutput()
                    self.captureSession.addOutput(captureMetadataOutput)
                    let newSerialQueue = DispatchQueue(label: "barCodeScannerQueue") // in iOS 11 you can use main queue
                    captureMetadataOutput.setMetadataObjectsDelegate(self, queue: newSerialQueue)
                    captureMetadataOutput.metadataObjectTypes = self.barCodeTypes
                    self.videoPreviewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
                    self.videoPreviewLayer?.videoGravity = .resizeAspectFill
                    self.videoPreviewLayer?.frame = self.scannerViewContainer.layer.bounds
                    self.scannerViewContainer.layer.addSublayer(self.videoPreviewLayer!)
                    self.initialized = true
                }
            } else{
                
            }
        }
        if success {
            captureSession.startRunning()
            view.bringSubviewToFront(crosshairView!)
        }
        
        if !success {
            if !accessRequested {
                var message = "Cannot access camera to scan bar codes"
                #if (arch(i386) || arch(x86_64)) && (!os(macOS))
                message = "You are running on the simulator, which does not hae a camera device.  Try this on a real iOS device."
                #endif
                if accessDenied {
                    message = "You have denied this app permission to access to the camera.  Please go to settings and enable camera access permission to be able to scan bar codes"
                }
                let alertPrompt = UIAlertController(title: "Cannot access camera", message: message, preferredStyle: .alert)
                let confirmAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (action) -> Void in
                    self.navigationController?.popViewController(animated: true)
                })
                alertPrompt.addAction(confirmAction)
                self.present(alertPrompt, animated: true, completion: {
                })
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // Swift 3.x callback
//    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
//        processBarCodeData(metadataObjects: metadataObjects as! [AVMetadataObject])
//    }
    
    // Swift 4 callback
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        processBarCodeData(metadataObjects: metadataObjects)
    }
    
    func processBarCodeData(metadataObjects: [AVMetadataObject]) {
        if metadataObjects.count == 0 {
            barCodeFrameView?.frame = CGRect.zero // Extra credit section 3
            return
        }
        
        if let metadataObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject {
            if barCodeTypes.contains(metadataObject.type) {
                let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObject)
                DispatchQueue.main.async {
                    if self.barCodeFrameView == nil {
                        self.barCodeFrameView = UIView()
                        if let barCodeFrameView = self.barCodeFrameView {
                            barCodeFrameView.layer.borderColor = UIColor.yellow.cgColor
                            barCodeFrameView.layer.borderWidth = 2
                            self.scannerViewContainer.addSubview(barCodeFrameView)
                            self.scannerViewContainer.bringSubviewToFront(barCodeFrameView)
                        }
                    }
                    self.barCodeFrameView?.frame = barCodeObject!.bounds
                }
                
                if metadataObject.stringValue != nil {
                    captureSession.stopRunning()
                    displayBarCodeResult(code: metadataObject.stringValue!)
                    return
                }
            }
        }
    }
     
    
    func displayBarCodeResult(code: String) {
        
        if !code.contains("studentId?") {
            
            // Create the alert controller
            let alertController = UIAlertController(title: "qr_code_error".localized(), message: "", preferredStyle: .alert)
            
            // Create the actions
            let okAction = UIAlertAction(title: "OK".localized(), style: UIAlertAction.Style.default) {
                UIAlertAction in
                NSLog("OK Pressed")
                self.setupCapture()
            }
            
            // Add the actions
            alertController.addAction(okAction)
            //alertController.addAction(cancelAction)
            
            // Present the controller
            self.present(alertController, animated: true, completion: nil)
            
        } else {
        
        let replaceStr = code.replacingOccurrences(of: "studentId?", with: "")
        addStudent(qrCode: replaceStr)
        
        let alertPrompt = UIAlertController(title: "Bar code detected", message: code, preferredStyle: .alert)
        if let url = URL(string: code) {
            let confirmAction = UIAlertAction(title: "Launch URL", style: UIAlertAction.Style.default, handler: { (action) -> Void in
                UIApplication.shared.open(url, options: [:], completionHandler: { (result) in
                    if result {
                        NSLog("opened url")
                    }
                    else {
                        let alertPrompt = UIAlertController(title: "Cannot open url", message: nil, preferredStyle: .alert)
                        let confirmAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (action) -> Void in
                        })
                        alertPrompt.addAction(confirmAction)
                        self.present(alertPrompt, animated: true, completion: {
                            self.setupCapture()
                        })
                    }
                })
                
            })
            alertPrompt.addAction(confirmAction)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: { (action) -> Void in
            self.setupCapture()
        })
        alertPrompt.addAction(cancelAction)
//        present(alertPrompt, animated: true, completion: nil)
        }
    }
    
    // ----------------------
    // Extra credit section 2
    // Draw crosshairs over camera view
    // ----------------------
    class CrosshairView: UIView {
        override init(frame: CGRect) {
            super.init(frame: frame)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        public override func draw(_ rect: CGRect) {
            let fWidth = self.frame.size.width
            let fHeight = self.frame.size.height
            let squareWidth = fWidth/2
            let topLeft = CGPoint(x: fWidth/2-squareWidth/2, y: fHeight/2-squareWidth/2)
            let topRight = CGPoint(x: fWidth/2+squareWidth/2, y: fHeight/2-squareWidth/2)
            let bottomLeft = CGPoint(x: fWidth/2-squareWidth/2, y: fHeight/2+squareWidth/2)
            let bottomRight = CGPoint(x: fWidth/2+squareWidth/2, y: fHeight/2+squareWidth/2)
            let cornerWidth = squareWidth/4
            
            if let context = UIGraphicsGetCurrentContext() {
                context.setLineWidth(2.0)
                context.setStrokeColor(Colors.APP_DARK_GREEN?.cgColor ?? UIColor.red.cgColor)
                
                // top left corner
                context.move(to: topLeft)
                context.addLine(to: CGPoint(x: fWidth/2-squareWidth/2+cornerWidth, y: fHeight/2-squareWidth/2))
                context.strokePath()
                
                context.move(to: topLeft)
                context.addLine(to: CGPoint(x: fWidth/2-squareWidth/2, y: fHeight/2-squareWidth/2+cornerWidth))
                context.strokePath()
                
                // top right corner
                context.move(to: topRight)
                context.addLine(to: CGPoint(x: fWidth/2+squareWidth/2, y: fHeight/2-squareWidth/2+cornerWidth))
                context.strokePath()
                
                context.move(to: topRight)
                context.addLine(to: CGPoint(x: fWidth/2+squareWidth/2-cornerWidth, y: fHeight/2-squareWidth/2))
                context.strokePath()
                
                // bottom right corner
                context.move(to: bottomRight)
                context.addLine(to: CGPoint(x: fWidth/2+squareWidth/2-cornerWidth, y: fHeight/2+squareWidth/2))
                context.strokePath()
                
                context.move(to: bottomRight)
                context.addLine(to: CGPoint(x: fWidth/2+squareWidth/2, y: fHeight/2+squareWidth/2-cornerWidth))
                context.strokePath()
                
                // bottom left corner
                context.move(to: bottomLeft)
                context.addLine(to: CGPoint(x: fWidth/2-squareWidth/2+cornerWidth, y: fHeight/2+squareWidth/2))
                context.strokePath()
                
                context.move(to: bottomLeft)
                context.addLine(to: CGPoint(x: fWidth/2-squareWidth/2, y: fHeight/2+squareWidth/2-cornerWidth))
                context.strokePath()
                
                
            }
        }
    }
    
    
    func addStudent(qrCode:String) {
        
        let params = ["QRCode": qrCode, "ParentID" : parentIdGlobal ,"SessionToken": sessionTokenGlobal ?? ""] as [String : Any]
        
        let urlString = addStudentUnderParentQRCode
         
        ServiceManager().postRequest(urlString, loader: true, parameters: params) { (status, jsonResponse) in
                
                if status {
                    //SVProgressHUD.showInfo(withStatus: "Success")
                }
                
               DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                 self.backButtonAction(self)
               }
                
            }
        
        
    }
    
}
