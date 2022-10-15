//
//  AskSpediaViewController.swift
//  Spedia
//
//  Created by Viraj Sharma on 01/08/2020.
//  Copyright © 2020 Viraj Sharma. All rights reserved.
//

import UIKit
import SVProgressHUD
import SwiftyJSON

class AskSpediaViewController: UIViewController {
    
    //MARK: Object's and Outlet's
    @IBOutlet weak var headerTitleLbl: CustomLabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var subTitleLbl: CustomLabel!
    @IBOutlet weak var subjectPHLbl: CustomLabel!
    @IBOutlet weak var subjectTFT: CustomTFT!
    @IBOutlet weak var typeYourQuestionPHLbl: CustomLabel!
    @IBOutlet weak var typeYourTextView: UITextView!
    @IBOutlet weak var attachFilePHLbl: CustomLabel!
    @IBOutlet weak var attachButton: CustomButton!
    @IBOutlet weak var askNowButton: CustomButton!
    @IBOutlet weak var dropDownButton: UIButton!
    
    //Subject List
    var subjectList = JSON()
    @IBOutlet weak var listView: UITableView!
    var selectdIndex = 0
    @IBOutlet weak var arrowImageIcon: UIImageView!
    @IBOutlet weak var constForListViewHeight: NSLayoutConstraint!
    
    
    //Catch Object
    var subjectNameObj = String()
    var subjectIdObj = Int()
    var attchmentUrl = String()
    
    //MARK: LIFE CYCLE's
    
    //1
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //2
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setUpView()
    }
    
    
    
    //3
    func setUpView() {
        
        self.headerTitleLbl.text = "ask_spedia".localized()
        self.subTitleLbl.text = "if_question".localized()
        self.subjectPHLbl.text = "subject".localized()
        
        self.subjectTFT.placeholder = "please_select_your_subject".localized()
        
        self.typeYourQuestionPHLbl.text = "type_your_question".localized()
        
        self.attachFilePHLbl.text = "attach_file".localized()
        
        self.attachButton.setTitle("attach_file".localized(), for: .normal)
        
        self.askNowButton.setTitle("ask_now".localized(), for: .normal)
        
        self.backButton.imageView?.transform =  L102Language.isCurrentLanguageArabic() ? CGAffineTransform(scaleX: -1.0, y: 1.0) : CGAffineTransform(scaleX: 1.0, y: -1.0)
        
        self.constForListViewHeight.constant = 0.0
        
        let nibName2 = UINib(nibName: "GradeTableCell", bundle:nil)
        self.listView.register(nibName2, forCellReuseIdentifier: "gradeTableCell")
        
        
        if !subjectNameObj.isEmpty && subjectIdObj > 0 {
            self.dropDownButton.isHidden = true
            self.arrowImageIcon.isHidden = true
            self.subjectTFT.text = subjectNameObj
            self.subjectTFT.isUserInteractionEnabled = false
        }
        
    }
    
    
    @IBAction func backButtonAction(_ sender: Any) {
      self.dismiss(animated: true, completion: nil)
    }
    
    
    
    //MARK: ACTION's
    
    @IBAction func subjectDropDownAction(_ sender: Any) {
      constForListViewHeight.constant == 0.0 ? self.dropDownViewShow() : self.dropDownViewHide()
    }
    
    
    func dropDownViewShow() {
        self.constForListViewHeight.constant = 400.0
        
        UIView.animate(withDuration: 0.33) {
            self.arrowImageIcon.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            self.view.layoutIfNeeded()
        }
    }
    
    func dropDownViewHide() {
        self.constForListViewHeight.constant = 0.0
        UIView.animate(withDuration: 0.33) {
            self.arrowImageIcon.transform = CGAffineTransform(scaleX: 1.0, y: -1.0)
            self.view.layoutIfNeeded()
        }
    }
    
    
    

    
    @IBAction func askNowButtonAction(_ sender: Any) {
        
        let subjectStr = subjectTFT.text ?? ""
        let typeQuestionStr = typeYourTextView.text ?? ""
        
        if subjectStr.isEmpty {
         
            SVProgressHUD.showInfo(withStatus: "please_select_your_subject".localized())
        
        } else if typeQuestionStr.isEmpty {
            SVProgressHUD.showInfo(withStatus: "please_type_your_question".localized())
        
        } else {
            
        let urlString = askSpedia
             
        let params = ["Message" :"\(typeYourTextView.text ?? "")",
                      "SessionToken" : sessionTokenGlobal ?? "",
                      "SubjectID" : self.subjectIdObj,
                      "StudentID" : studentIdGlobal ?? 0,
                      "Attachment": self.attchmentUrl] as [String : Any]
        
            ServiceManager().postRequest(urlString, loader: true, parameters: params) { (status, jsonResponse) in
                if status {
                    
                     SVProgressHUD.showInfo(withStatus: "sent_successfully".localized())
                     
                     DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                         self.dismiss(animated: true, completion: nil)
                     }
                     
                }
            }
        }
        
    }
    
    
    
}




//===========================
//MARK: LIST VIEW
//===========================

extension AskSpediaViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.subjectList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.listView.dequeueReusableCell(withIdentifier: "gradeTableCell") as? GradeTableCell
                    
        cell?.selectionStyle = .none
        
        cell?.checkImageView.isHidden = true
        cell?.roundImageView.isHidden = false
        
        if selectdIndex == indexPath.row {
            cell?.checkImageView.isHidden = false
            cell?.roundImageView.isHidden = true
        }
        
        cell?.nameLbl.text = L102Language.isCurrentLanguageArabic() ? self.subjectList[indexPath.row]["TextAr"].stringValue : self.subjectList[indexPath.row]["TextEn"].stringValue
    
        return cell ?? UITableViewCell()
    
    }
 

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.selectdIndex = indexPath.row
        
        self.subjectTFT.text = L102Language.isCurrentLanguageArabic() ? self.subjectList[indexPath.row]["TextAr"].stringValue : self.subjectList[indexPath.row]["TextEn"].stringValue
        
        self.listView.reloadData()
        
        self.subjectIdObj = self.subjectList[indexPath.row]["ID"].intValue
        
        self.dropDownViewHide()
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 60.0
    
    }
    

}





//MARK:- Image Picker
extension AskSpediaViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

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
        
        //let fileUrl = info[UIImagePickerController.InfoKey.imageURL] as? URL else { return }
        
        let urlString = uploadFile + "/\(sessionTokenGlobal ?? "")"+"/AskSpedia.jpg/AskSpedia/\(studentIdGlobal ?? "0")"
     
        let paramsValue = ["stream" : pickerImage.compressedData(quality: 0.33)]
        
        
        ServiceManager().uploadPhoto(urlString, imageExtension: "jpg", imageData: pickerImage.compressedData(), params: paramsValue, header: [:]) { (status, jsonResponse) in
              
              if status {
                
                let dataJson = JSON.init(jsonResponse ?? "NO DATA")
                
                if dataJson["Status"].boolValue {
                  self.attchmentUrl = dataJson["FileName"].stringValue
                  self.attachButton.setTitle("\(self.attchmentUrl)", for: .normal)
                  print("Upload Success File URL======> \(self.attchmentUrl)")
                }
              }
        }
            
        
        
        
        
    }

    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

}
