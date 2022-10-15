//
//  ScannerViewController.swift
//  Spedia
//
//  Created by Viraj Sharma on 25/08/2021.
//  Copyright © 2021 Viraj Sharma. All rights reserved.
//

import AVFoundation
import UIKit
import SVProgressHUD

class ScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    //1 Objects
    @IBOutlet weak var headerTitleLbl: CustomLabel!
    @IBOutlet weak var scannerViewContainer: UIView!
    @IBOutlet weak var borderVieww: UIView!
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!

    
    
    //My
    @IBAction func crossButtonAction(_ sender: Any) {
        
        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
        }
       self.dismiss(animated: true, completion: nil)
       //self.navigationController?.popViewController(animated: true)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.black
        captureSession = AVCaptureSession()

        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput

        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }

        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }

        let metadataOutput = AVCaptureMetadataOutput()

        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)

            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            failed()
            return
        }

        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        self.scannerViewContainer.layer.addSublayer(previewLayer)

        captureSession.startRunning()
        
        
        self.borderVieww.layer.borderWidth = 3.0
        self.borderVieww.layer.borderColor = Colors.APP_LIGHT_GREEN?.cgColor
        self.borderVieww.layer.cornerRadius = 10
        self.borderVieww.clipsToBounds = true
        
    }

    
    func failed() {
        showAlert(alertText: "invalid_qr_code".localized(), alertMessage: "")
        captureSession = nil
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if (captureSession?.isRunning == false) {
            captureSession.startRunning()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
        }
    }

    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()

        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: stringValue)
        }

        dismiss(animated: true)
    }

    
    func found(code: String) {
        
        print("\n\nYou Scanner Scan String is:====>", code)
        
        
        if !code.contains("Videos?") {
            
            
            // Create the alert controller
            let alertController = UIAlertController(title: "qr_code_error".localized(), message: "", preferredStyle: .alert)
            
            // Create the actions
            let okAction = UIAlertAction(title: "OK".localized(), style: UIAlertAction.Style.default) {
                UIAlertAction in
                NSLog("OK Pressed")
                self.crossButtonAction(self)
            }
            
            // Add the actions
            alertController.addAction(okAction)
            //alertController.addAction(cancelAction)
            
            // Present the controller
            self.present(alertController, animated: true, completion: nil)
            
            
        } else {
            
            var subjedScannedId = ""
            var unitScannedId = ""
            var subSkillVideoId = ""
            var videoLength = ""
            
            let arrayOfValues = code.split{$0 == "?"}.map(String.init)
            
            //1). On 1st Index Alywas: UnitID Will Came
            //2). On 2nd Index Alywas: SubjectID Will Came
            //3). On 4th Index Alywas: SubSkillVideoID Will Came
            
            if arrayOfValues.count >= 2 {
                //https://app.spediaapp.com/Home/Videos?UnitID=1700&SubjectID=151&SkillID=1700&IsbookMark=True&SubSkillVideoID=9368&Legth=90
                let valueStr = arrayOfValues[1]
                
                let parmasArray = valueStr.split{$0 == "&"}.map(String.init)
               
                print("Array of Values----->", parmasArray)
                
                if parmasArray.count >= 2 {
                    
                    if let range = parmasArray[0].range(of: "UnitID=") {
                        unitScannedId = String(parmasArray[0][range.upperBound...])
                        print("Your Unit ID IS:", unitScannedId)
                    }
                    
                    if let range = parmasArray[1].range(of: "SubjectID=") {
                        subjedScannedId = String(parmasArray[1][range.upperBound...])
                        print("Your Subject ID IS:", subjedScannedId)
                        
                    }
                    
                    if let range = parmasArray[4].range(of: "SubSkillVideoID=") {
                        subSkillVideoId = String(parmasArray[4][range.upperBound...])
                        print("Your SubSkillVideoID ID IS:", subSkillVideoId)
                        
                    }
                    
                    if let range = parmasArray[5].range(of: "Legth=") {
                        videoLength = String(parmasArray[5][range.upperBound...])
                        print("Your Video Length IS:", videoLength)
                        
                    }
                }
                
            }
            

            
        if !unitScannedId.isEmpty && !subjedScannedId.isEmpty && !subSkillVideoId.isEmpty {
            
            self.gotoVideoPageNowWith(unitId: unitScannedId, subjectId: subjedScannedId, subSkillVideoId: subSkillVideoId, length: videoLength)
        
        } else {
            
            self.crossButtonAction(self)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                SVProgressHUD.showInfo(withStatus: "invalid_qr_code".localized())
            }
            
         }
      }
        
    }

   
    func gotoVideoPageNowWith(unitId: String, subjectId: String, subSkillVideoId: String, length: String) {
        
        self.crossButtonAction(self)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            if let topController = UIApplication.topViewController() {
                if let vc = VideoViewController.instantiate(fromAppStoryboard: .main) {
                    vc.modalPresentationStyle = .fullScreen
                    vc.whereFromAmI = WhereFromAmIKeys.bookmark
                    vc.subjectId = Int(subjectId) ?? 0
                    vc.preRecSubSkillId = 0 
                    vc.unitId = Int(unitId) ?? 0
                    vc.bookmarkWatchedLength = Int(length) ?? 0
                    vc.subSkillVideoIdStr = subSkillVideoId
                    topController.present(vc, animated: true, completion: nil)
                }
            }
        }
    }
    
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}
