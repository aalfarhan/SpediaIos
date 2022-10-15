//
//  ProfileViewController.swift
//  Spedia
//
//  Created by Viraj Sharma on 14/07/2020.
//  Copyright © 2020 Viraj Sharma. All rights reserved.
//

import UIKit
import SwiftyJSON

class ProfileViewController: UIViewController {

    //Only for Profile refresh
    @IBOutlet var profilePic: UIImageView!
    
    @IBOutlet weak var listView: UITableView!
    var dataJson = JSON()
    var deleteMsg = ""
    var deleteTitle = ""
    var backButtonType = ""

    let qrCodeDetailViewObj = QrCodeDetailView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //self.title = TabBarTitleStr().profile
        //self.tabBarItem.image = #imageLiteral(resourceName: "icon_profile_pdf")
        //self.tabBarItem.imageInsets = UIEdgeInsets(top: 10, left: 0, bottom: -10, right: 0)
        //self.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 10)
        self.getData()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //1
        self.setupView()
        
        //2
        //MARK: QRCODE VIEW
        self.qrCodeDetailViewObj.frame = self.view.frame
        self.view.addSubview(self.qrCodeDetailViewObj)
        self.qrCodeDetailViewObj.isHidden = true
        
    }
    
    

    
    func setupView() {
        
        //1
        let nibName = UINib(nibName: "ProfileHeaderTCell", bundle:nil)
        self.listView.register(nibName, forCellReuseIdentifier: "profileHeaderTCell")
        
        //2
        let nibName2 = UINib(nibName: "SubscribedSubjectTCell", bundle:nil)
        self.listView.register(nibName2, forCellReuseIdentifier: "subscribedSubjectTCell")
        
        //3
        let nibName3 = UINib(nibName: "ProfilePersonalDetailTCell", bundle:nil)
        self.listView.register(nibName3, forCellReuseIdentifier: "profilePersonalDetailTCell")
        
    }
 

    func getData() {
        
        let urlString = getProfileData
            
           
           let params = ["SessionToken": sessionTokenGlobal ?? "",
                         "StudentID": studentIdGlobal ?? 0] as [String : Any]
           
           ServiceManager().postRequest(urlString, loader: true, parameters: params) { (status, jsonResponse) in
                
               if status {
                   self.dataJson = JSON.init(jsonResponse ?? "NO DTA")
                   self.deleteMsg = self.dataJson["DeleteAccountMsg" + Lang.code()].string ?? "delete_msg_ph".localized()
                   self.deleteTitle = self.dataJson["DeleteAccountTitle" + Lang.code()].string ?? "delete_title_ph".localized()
                   
                   self.listView.reloadData()
                }
           }
    }
    
    
    
}



//==================================
//MARK: TABLE VIEW
//==================================

extension ProfileViewController : UITableViewDelegate, UITableViewDataSource {
     
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
         
         if indexPath.row == 0 { //1 Header Cell..
        
           let cell = self.listView.dequeueReusableCell(withIdentifier: "profileHeaderTCell") as? ProfileHeaderTCell
           cell?.selectionStyle = .none
           
           cell?.dateLbl.text = L102Language.isCurrentLanguageArabic() ? self.dataJson[ProfileKeys.JoinedDateAr].stringValue : self.dataJson[ProfileKeys.JoinedDateEn].stringValue
            
            
            cell?.gradeLbl.text = L102Language.isCurrentLanguageArabic() ? self.dataJson[ProfileKeys.ClassNameAr].stringValue : self.dataJson[ProfileKeys.ClassNameEn].stringValue
            
            
            //cell?.lblLevel.text = (L102Language.isCurrentLanguageArabic() ? self.dataJson[ProfileKeys.LevelAr].stringValue : self.dataJson[ProfileKeys.LevelEn].stringValue).uppercased()
            
            let pointStr = L102Language.isCurrentLanguageArabic() ?  self.dataJson[ProfileKeys.AcademicPoints].stringValue + " " + "نقطة" : self.dataJson[ProfileKeys.AcademicPoints].stringValue + " pts"
            
            cell?.lblPoints.text = pointStr
            
           cell?.headerFullNameLbl.text = self.dataJson[ProfileKeys.FullName].stringValue
            
           cell?.headerUsernameLbl.text = self.dataJson[ProfileKeys.Email].stringValue
           
           cell?.profileHeaderBackButton.addTarget(self, action: #selector(backButtonCliked(sender:)), for: .touchUpInside)
            
           cell?.editButton.addTarget(self, action: #selector(editButtonCliked(sender:)), for: .touchUpInside)
            
           cell?.scanCodeTapButton.addTarget(self, action: #selector(getStudentQrCodeValue), for: .touchUpInside)
            
           cell?.editProfilePicButton.addTarget(self, action: #selector(editProfilePicButtonCliked(sender:)), for: .touchUpInside)
            
        
            cell?.showLeaderBord.addTarget(self, action: #selector(showLeaderBordCliked(sender:)), for: .touchUpInside)
            
            cell?.showSkillButton.addTarget(self, action: #selector(showSkillButtonCliked(sender:)), for: .touchUpInside)
             
            cell?.infoButton.addTarget(self, action: #selector(infoButtonAction(sender:)), for: .touchUpInside)
            
            
           //Profile Pic Image.... ProfilePic
           let url = URL(string: self.dataJson[ProfileKeys.ProfilePic].stringValue)
           cell?.profileImgView.kf.indicatorType = .activity
           cell?.profileImgView.kf.setImage(with: url, placeholder: UIImage.init(named: "profile_icon_placeholder"))
           //cell?.profileImgView.kf.setImage(with: url, placeholder: UIImage(named: "profile_icon_placeholder"), options: [.forceRefresh])
            
        
           return cell ?? UITableViewCell()
        
            
        } else if indexPath.row == 1 { //2 Personal Detail Cell..
        
           let cell = self.listView.dequeueReusableCell(withIdentifier: "profilePersonalDetailTCell") as? ProfilePersonalDetailTCell
           
           cell?.selectionStyle = .none
           
           cell?.profileFullNameLbl.text = self.dataJson[ProfileKeys.FullName].stringValue

           cell?.profileUsernameLbl.text =  self.dataJson[ProfileKeys.Username].stringValue

           cell?.phoneLbl.text = self.dataJson[ProfileKeys.Phone].stringValue

           cell?.profileLocationLabel.text = self.dataJson[ProfileKeys.MembershipNo].stringValue
            
            let membershipStatus = self.dataJson["MembershipStatus"].boolValue
            
            //MembershipStatus
            if membershipStatus {
                cell?.membershipIcon.image = #imageLiteral(resourceName: "check_green_icon")
            } else {
                cell?.membershipIcon.image = #imageLiteral(resourceName: "check_red_icon")
            }
            
           return cell ?? UITableViewCell()
        
            
        } else { //3 Subscribed Subject List Cell
            
            let cell = self.listView.dequeueReusableCell(withIdentifier: "subscribedSubjectTCell") as? SubscribedSubjectTCell
            cell?.selectionStyle = .none
            
            cell?.privateRequestDataJson = self.dataJson[ProfileKeys.PrivateclassRequestsList]
            
            cell?.subscribedSubjectDataJson = self.dataJson[ProfileKeys.SubscribedSubjectList]
            
    
            cell?.configureViewNow()
             
            self.view.layoutIfNeeded()
            
            return cell ?? UITableViewCell()
        }
        
    
    }
 
    /*
    func loadProfileImage(imageUrl : String) {
        
        //Profile Pic Image.... ProfilePic
        let url = URL(string: imageUrl)
        
        self.profilePic.kf.setImage(with: url, placeholder: nil, options: [.waitForCache], completionHandler:  { result in
             switch result {
             case .success(let value):
                 
                 //print("Image: \(value.image). Got from: \(value.cacheType)")
                 
                 UserDefaults.standard.set(value.image.pngData(), forKey: "")
                 UserDefaults.standard.synchronize()
                 
                 let button = ProfileButton()
                 print(button)
                 
                 //let button2 = ProfileButton()
                 //print(button2)
                 
             case .failure(let error):
                 print("Error: \(error)")
             }
         })
    }
    */
    
    @objc func backButtonCliked(sender: UIButton) {
        //self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
     
    
    @objc func editButtonCliked(sender: UIButton) {
        
        if let vc = EditProfileViewController.instantiate(fromAppStoryboard: .main) {
            vc.modalPresentationStyle = .fullScreen
            
            nameGlobal = self.dataJson[ProfileKeys.FullName].stringValue
            phoneNoGlobal = self.dataJson[ProfileKeys.Phone].stringValue
            emailGlobal = self.dataJson[ProfileKeys.Email].stringValue
            vc.msgString = self.deleteMsg
            vc.titleString = self.deleteTitle
            vc.dataJson = self.dataJson
            self.present(vc, animated: true, completion: nil)
        }
        
    }
    
    
    @objc func showSkillButtonCliked(sender: UIButton) {
        
      if let vc = StatisticsViewController.instantiate(fromAppStoryboard: .main) {
       vc.modalPresentationStyle = .fullScreen
       self.navigationController?.pushViewController(vc, animated: true)
       //self.present(vc, animated: true, completion: nil)
      }
        
    }
    
    @objc func showLeaderBordCliked(sender: UIButton) {
        
        if let vc = LeaderViewController.instantiate(fromAppStoryboard: .main) {
       vc.modalPresentationStyle = .fullScreen
       self.navigationController?.pushViewController(vc, animated: true)
       //self.present(vc, animated: true, completion: nil)
      }
    
    }
    
    //MARK: SHOW QR CODE WITH IMAGE
    @objc func getStudentQrCodeValue(sender: UIButton) {
        self.qrCodeDetailViewObj.callQrCodeApi(withImage: true)
    }
    
    @objc func infoButtonAction(sender: UIButton) {
        self.qrCodeDetailViewObj.callQrCodeApi(withImage: false)
    }
    
    @objc func editProfilePicButtonCliked(sender: UIButton) {
        self.showPhotoAlert(sender: sender)
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    
    }
    
    
}






//MARK:- Image Picker
extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

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
        
    
        let urlString = uploadFile + "/\(sessionTokenGlobal ?? "")"+"/editProfile.jpg/EditProfile/\(studentIdGlobal ?? "0")"
     
        let paramsValue = ["stream" : pickerImage.compressedData(quality: 0.7)]
            
        ServiceManager().uploadPhoto(urlString, imageExtension: "jpg", imageData: pickerImage.compressedData(), params: paramsValue, header: [:]) { (status, jsonResponse) in
              
              if status {
                
                let dataJson = JSON.init(jsonResponse ?? "NO DATA")
                
                print(dataJson)
                
                if dataJson["Status"].boolValue {
                   //let imageUrl = dataJson["FilePath"].stringValue
                   //self.dataJson[ProfileKeys.ProfilePic].stringValue = imageUrl
                   //self.listView.reloadData()
                   self.getData()
                }
              }
        }
            
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    
}
