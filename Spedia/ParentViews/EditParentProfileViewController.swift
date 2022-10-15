//
//  EditParentProfileViewController.swift
//  Spedia
//
//  Created by Viraj Sharma on 07/11/2020.
//  Copyright © 2020 Viraj Sharma. All rights reserved.
//

import UIKit
import SwiftyJSON
import SVProgressHUD

class EditParentProfileViewController: UIViewController {
    
    //1 Placeholders
    @IBOutlet weak var headerTitleLbl: CustomLabel!
    @IBOutlet weak var fullNameLbl: CustomLabel!
    @IBOutlet weak var emailLbl: CustomLabel!
    @IBOutlet weak var phoneLbl: CustomLabel!
    @IBOutlet weak var createPassLbl: CustomLabel!
    @IBOutlet weak var confirmPassLbl: CustomLabel!
    @IBOutlet weak var fileNameLbl: CustomLabel!
    
    //2 TFT's
    @IBOutlet weak var firstNameTFT: CustomTFT!
    @IBOutlet weak var lastNameTFT: CustomTFT!
    @IBOutlet weak var emailTFT: CustomTFT!
    @IBOutlet weak var mobileTFT: CustomTFT!
    @IBOutlet weak var placeTFT: CustomTFT!
    @IBOutlet weak var titleTFT: CustomTFT!
    
    
    //3 Button's
    @IBOutlet weak var saveButton: CustomButton!
    @IBOutlet weak var backButton: UIButton!
    

    //5 Other's
    var isPhoneNoVerified = true
    var profileImageNameStr = ""
    @IBOutlet weak var checkBoxImageView: UIImageView!
    var isTermsChecked = false
    
    
    //4 Constratins For Responsive
    @IBOutlet weak var leftPedding: NSLayoutConstraint!
    @IBOutlet weak var rightPedding: NSLayoutConstraint!
        
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        //self.getLiveClassData()
        self.setUpViews()
        
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
           self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func checkBoxButtonAction(_ sender: Any) {
        if isTermsChecked {
            isTermsChecked = false
            checkBoxImageView.image = #imageLiteral(resourceName: "terms_icon_nill")
        } else {
            isTermsChecked = true
            checkBoxImageView.image = #imageLiteral(resourceName: "terms_icon_fill")
        }
    }
    
    //MARK: UI & View SETUP
    func setUpViews() {
        
        //back button
        self.backButton.imageView?.transform =  L102Language.isCurrentLanguageArabic() ? CGAffineTransform(scaleX: -1.0, y: 1.0) : CGAffineTransform(scaleX: 1.0, y: -1.0)
        
        //...
        //self.gradeButton.setTitle("reserve_now".localized(), for: .normal)
        //self.headerTitleLbl.text = "no_reserved_data".localized()
        //self.headerSubTitleLbl.text = "no_reserved_data".localized()
        
    }
    
    
    @IBAction func saveButtonAction(_ sender: Any) {
        
        if validateFields() {
            
            let urlString = updateParentProfile
            
            let pranentData = [
                "ParentID": parentIdGlobal,
                "FirstName":firstNameTFT.text!,
                "MiddleName":"",
                "LastName":lastNameTFT.text!,
                "MobileNo":mobileTFT.text!,
                "Email":emailTFT.text!,
                "ProfilePic": profileImageNameStr
                ] as [String : Any]
            
        
            let params = ["SessionToken": sessionTokenGlobal ?? "",
                          "Parent": pranentData] as [String : Any]
            
            ServiceManager().postRequest(urlString, loader: true, parameters: params) { (status, jsonResponse) in
                
                if status {
                    
                    fullNameGlobal = self.firstNameTFT.text!
                    emailIdGlobal = self.emailTFT.text!
                    mobileNoGlobal = self.mobileTFT.text!
                    self.backButtonAction(self)
                    
                }
            }
        }
    }
    
    
    private func validateFields()->Bool {
        
        var validateFields = true
        
        //1
        let firstNameStr = firstNameTFT.text ?? ""
        if firstNameStr.isEmpty {
            SVProgressHUD.showInfo(withStatus: "valid_fullname".localized())
            validateFields = false
        }
        
        let lastNameStr = lastNameTFT.text ?? ""
        if lastNameStr.isEmpty {
            SVProgressHUD.showInfo(withStatus: "valid_fullname".localized())
            validateFields = false
        }
        
        
        //2
        let emailStr = emailTFT.text ?? ""
        if emailStr.isEmpty {
            SVProgressHUD.showInfo(withStatus: "valid_username".localized())
            validateFields = false
        }
        
        //3
        let mobileStr = mobileTFT.text ?? ""
        if mobileStr.isEmpty {
            SVProgressHUD.showInfo(withStatus: "valid_phone".localized())
            validateFields = false
        }
        
        //4
        let placeStr = placeTFT.text ?? ""
        if placeStr.isEmpty {
            SVProgressHUD.showInfo(withStatus: "MANDATORY_FIELDS".localized())
            validateFields = false
        }
        
        
        //5
        let titleStr = titleTFT.text ?? ""
        if titleStr.isEmpty {
            SVProgressHUD.showInfo(withStatus: "MANDATORY_FIELDS".localized())
            validateFields = false
        }
        

        return validateFields
        
    }
    
    
    
}


//MARK:- Image Picker
extension EditParentProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    //This is the tap gesture added on my UIImageView.
    @IBAction func attachButtonAction(_ sender: Any) {
    //@IBAction func didTapOnImageView(sender: UITapGestureRecognizer) {
        //call Alert function
        self.showPhotoAlert(sender: sender)
    
    }

    //Show alert to selected the media source type.
    private func showPhotoAlert(sender: Any) {

        guard let button = sender as? UIView else {
               return
        }
        
        let alert = UIAlertController(title: "choose_photo".localized(), message: "", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "camera".localized(), style: .default, handler: {(action: UIAlertAction) in
            self.getImage(fromSourceType: .camera)
        }))
        alert.addAction(UIAlertAction(title: "gallery".localized(), style: .default, handler: {(action: UIAlertAction) in
            self.getImage(fromSourceType: .photoLibrary)
        }))
        alert.addAction(UIAlertAction(title: "CANCEL".localized(), style: .destructive, handler: nil))
        
        if let presenter = alert.popoverPresentationController {
            presenter.sourceView = button
            presenter.sourceRect = button.bounds
        }
        
        self.present(alert, animated: true, completion: nil)
    }

    
    //get image from source type
    private func getImage(fromSourceType sourceType: UIImagePickerController.SourceType) {

        //Check is source type available
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = sourceType
            self.present(imagePickerController, animated: true, completion: nil)
        }
    }

    //MARK:- UIImagePickerViewDelegate.
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true)

        guard var pickerImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        
        if picker.sourceType == .camera {
            pickerImage = pickerImage.rotated(by: 0) ?? UIImage()
        }
        
        let urlString = uploadFile + "/\(sessionTokenGlobal ?? "")"+"/editProfile.jpg/EditProfile/\(String(parentIdGlobal))"
     
        
        let paramsValue = ["stream" : pickerImage.compressedData(quality: 0.7)]
            
        
        ServiceManager().uploadPhoto(urlString, imageExtension: "jpg", imageData: pickerImage.compressedData(), params: paramsValue, header: [:]) { (status, jsonResponse) in
              
            
              if status {
                
                let dataJson = JSON.init(jsonResponse ?? "NO DATA")
                
                print(dataJson)
                
                if dataJson["Status"].boolValue {
                   
                    self.profileImageNameStr = dataJson["FileName"].stringValue
                    self.fileNameLbl.text = self.profileImageNameStr
                    
                }
              }
        }
            
    }
 
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    
}
