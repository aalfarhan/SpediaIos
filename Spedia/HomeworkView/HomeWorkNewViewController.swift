//
//  HomeWorkNewViewController.swift
//  Spedia
//
//  Created by Viraj Sharma on 03/09/2021.
//  Copyright © 2021 Viraj Sharma. All rights reserved.
//

import UIKit
import SwiftyJSON

class HomeWorkNewViewController: UIViewController {

    //1 Outlets.......
    @IBOutlet weak var topSubjectCollView: UICollectionView!
    @IBOutlet weak var collView: UICollectionView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var headerTitleLbl: CustomLabel!
    @IBOutlet weak var headerSubTitleLbl: CustomLabel!
    
    @IBOutlet weak var noDataLbl: CustomLabel!
    
    
    //2 Data.........
    var dataJson = JSON()
    var currentSelectedSubjectIndex = 0
    var uploadButtonIndex = 0
    var selectedHomeWorkdId = 0
    var timeStempForFile = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.collView.isHidden = true
        self.topSubjectCollView.isHidden = true
        self.noDataLbl.text = ""
        
        
        //CollView
        let cellNib = UINib(nibName: "SkillSubjectCollView", bundle:nil)
        self.topSubjectCollView.register(cellNib, forCellWithReuseIdentifier: "skillSubjectCollView")

        let cellHomeworkNib = UINib(nibName: "HomeWorkCollCell", bundle:nil)
        self.collView.register(cellHomeworkNib, forCellWithReuseIdentifier: "homeWorkCollCell")

        self.collView.delegate = self
        self.collView.dataSource = self
        
        
        self.topSubjectCollView.delegate = self
        self.topSubjectCollView.dataSource = self
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setUpView()
        self.getHomeWorkDataNow()
        
        //For Uploading File with Recoding file time and date (check upload file API)
        self.timeStempForFile = String(Date().currentTimeMillis())
    
    }
    
    
    
    func setUpView() {
       
        self.backButton.imageView?.transform =  L102Language.isCurrentLanguageArabic() ? CGAffineTransform(scaleX: -1.0, y: 1.0) : CGAffineTransform(scaleX: 1.0, y: -1.0)
    
    }
    
    
    @IBAction func backButtonAction(_ sender: Any) {
        //self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    //4 Call API.....
    
    func getHomeWorkDataNow() {
        
        let urlString = getHomeWork
        let params = ["SessionToken" : sessionTokenGlobal ?? "",
                      "StudentID" : studentIdGlobal ?? 0,
                      "ClassID" : classIdGlobal ?? ""] as [String : Any]
        
        ServiceManager().postRequest(urlString, loader: true, parameters: params) { (status, jsonResponse) in
             
            if status {
                
                let dataRes = JSON.init(jsonResponse ?? "NO DTA")
                //3 Data Json
                self.dataJson = dataRes["Subjects"]
                
                //1 Header Titles
                self.headerTitleLbl.text = dataRes["Title" + Lang.code()].stringValue
                self.headerSubTitleLbl.text = dataRes["SubTitle" + Lang.code()].stringValue
                
                
                //2 Notification Count
                
                if self.dataJson.count == 0 { //no data here...
                    self.collView.isHidden = true
                    self.noDataLbl.text = "no_data_found".localized()
                
                } else {
                    
                    self.noDataLbl.text = ""
                    self.collView.isHidden = false
                    self.topSubjectCollView.isHidden = false
                    
                    self.collView.reloadData()
                    self.topSubjectCollView.reloadData()
                    
                }
                 
            }
        }
        
    }
    
    
}



//MARK:================================================
//MARK: CollectionView (Homework Coll View)
//MARK:================================================

extension HomeWorkNewViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIDocumentPickerDelegate {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == self.topSubjectCollView {
            return self.dataJson.count
        }
        
        return self.dataJson[self.currentSelectedSubjectIndex]["HomeWork"].count
    
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        if collectionView == self.topSubjectCollView {
        
            let cell = self.topSubjectCollView.dequeueReusableCell(withReuseIdentifier: "skillSubjectCollView", for: indexPath) as? SkillSubjectCollView
            
        
            cell?.isCellSelected = false
            
            if indexPath.row == self.currentSelectedSubjectIndex {
                cell?.isCellSelected = true
            }
            
            cell?.configureCellWithData(data: self.dataJson[indexPath.row])
            
            cell?.tapButton.tag = indexPath.row
            cell?.tapButton.addTarget(self, action: #selector(subjectTapButtonAction(sender:)), for: .touchUpInside)
            
            
            return cell ?? UICollectionViewCell()
        
        } else {
             
            let cell = self.collView.dequeueReusableCell(withReuseIdentifier: "homeWorkCollCell", for: indexPath) as? HomeWorkCollCell
            
            let index = indexPath.row
            
            cell?.configureCellWithData(data: self.dataJson[self.currentSelectedSubjectIndex]["HomeWork"][index])
            
            cell?.downloadButton.tag = index
            cell?.downloadButton.addTarget(self, action: #selector(downloadButtonAction), for: .touchUpInside)
            
            cell?.uploadButton.tag = index
            cell?.uploadButton.addTarget(self, action: #selector(uploadButtonAction), for: .touchUpInside)
            
            return cell ?? UICollectionViewCell()
            
            
        }
        
            
    }
    
    
    @objc func subjectTapButtonAction(sender: UIButton) {
    
        self.currentSelectedSubjectIndex = sender.tag
        self.topSubjectCollView.reloadData()
        self.collView.reloadData()
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == self.topSubjectCollView {
            
            return CGSize(width: (self.topSubjectCollView.frame.width / 4.5) - 7, height: 120)
        
        } else {
        
        let gridPart = CGFloat(UIDevice.isPad ? 2 : 1)
        let spaceBtw = CGFloat(UIDevice.isPad ? 30 : 0)
        
        var witdh = self.collView.frame.width - spaceBtw
        witdh = witdh / gridPart
        //let height = round(witdh / 0.8)
        
        return CGSize(width: witdh, height: 220)
        
        }
    
    }
    
 
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        if collectionView == self.topSubjectCollView {
            
            return 0 //Left-Right Space
            
        } else {
            return UIDevice.isPad ? 0 : 0
        }
        
    }
      
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
         
        if collectionView == self.topSubjectCollView {
            return 10
        }
        return 20 //Top-Bottom Space
    }
    
    
    
    @objc func downloadButtonAction(sender: UIButton) {
        
        print("downloadButtonAction---->", sender.tag)
        
        let data = self.dataJson[self.currentSelectedSubjectIndex]["HomeWork"][sender.tag]
        
        if let vc = DocumentViewController.instantiate(fromAppStoryboard: .main) {
            vc.modalPresentationStyle = .fullScreen
            vc.isFromHomeWorkDownload = true
            vc.homeWorkId = data["HomeWorkID"].intValue
            vc.pdfString = data["QuestionPath"].stringValue
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    
    @objc func uploadButtonAction(sender: UIButton) {
        
        let data = self.dataJson[self.currentSelectedSubjectIndex]["HomeWork"][sender.tag]
        
        self.uploadButtonIndex = sender.tag
        self.selectedHomeWorkdId = data["HomeWorkID"].intValue
        
        let documentPicker = UIDocumentPickerViewController(documentTypes: ["public.text", "com.apple.iwork.pages.pages", "public.data"], in: .import)
        
        documentPicker.delegate = self
        present(documentPicker, animated: true, completion: nil)
    }
    

    
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        
        let cico = url as URL
        //print(cico)
        //print(url)
        //print(url.pathExtension)
        //print(url.lastPathComponent)
        
        let checkExtension = url.pathExtension.lowercased()
        
        if checkExtension == "pdf" || checkExtension == "doc" || checkExtension == "docx"{
            
            let url = URL(fileURLWithPath: url.path)

            do {
                
                let data = try Data(contentsOf: url)
            
                self.uploadFileWithData(fileDataPicked: data, fileUrl: url)
                
            } catch {
             
            }
            
        } else {
            
            self.showAlert(alertText: "please_upload_correct_file".localized(), alertMessage: "")
        }
        
    }
    
    
    func uploadFileWithData(fileDataPicked: Data, fileUrl : URL) {
        
        //UploadHomeWorkAnswer/{SessionToken}/{StudentID}/{filename}/{HomeWorkID}
        
        let fileName = self.timeStempForFile + "." + fileUrl.pathExtension
        
        let urlString = uploadHomeWorkAnswer + "/\(sessionTokenGlobal ?? "")/\(studentIdGlobal ?? "")/\(fileName)/\(self.selectedHomeWorkdId)"
        
        let paramsValue = ["stream" : fileDataPicked]
        
        ServiceManager().uploadFileOrPdf(urlString, fileExtension: "\(fileUrl.pathExtension)", fileData: fileDataPicked, params: paramsValue, header: [:]) { (status, jsonResponse) in
            
            
            if status {
                
                self.getHomeWorkDataNow()
                
            } else {
                
              self.showAlert(alertText: "please_upload_correct_file".localized(), alertMessage: "")
            }
            
        }
    }
    
}
