//
//  HomeworkViewController.swift
//  Spedia
//
//  Created by Viraj Sharma on 04/07/2021.
//  Copyright © 2021 Viraj Sharma. All rights reserved.
//


/*
import UIKit
import SwiftyJSON
//import PDFKit

class HomeworkViewController: UIViewController {
    
    
    //1 Outlets.......
    @IBOutlet weak var listView: UITableView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var headerTitleLbl: CustomLabel!
    @IBOutlet weak var headerSubTitleLbl: CustomLabel!
    @IBOutlet weak var noDataLbl: CustomLabel!
    //@IBOutlet weak var bellIconButton: BellIconButton!
    //@IBOutlet weak var supportIconButton: SupportButton!
    
    
    //2 Data.........
    var dataJson = JSON()
    var currentSelectedSubjectIndex = 0
    var uploadButtonIndex = 0
    var selectedHomeWorkdId = 0
    //var isLoaded = false
    //var selectedSubjectId = 0
    
    //Responsive...
    //@IBOutlet weak var leftPeddingConst: NSLayoutConstraint!
    //@IBOutlet weak var rightPeddingConst: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TableView...
        self.listView.isHidden = true
        self.noDataLbl.text = ""
    
        //1
        let tableCellNib = UINib(nibName: "HomeworkHeaderTCell", bundle:nil)
        self.listView.register(tableCellNib, forCellReuseIdentifier: "homeworkHeaderTCell")
     
        //2
        let tableCell = UINib(nibName: "HomeWorkMiddleTCell", bundle:nil)
        self.listView.register(tableCell, forCellReuseIdentifier: "homeWorkMiddleTCell")
     
        //self.getHomeWorkDataNow()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.getHomeWorkDataNow()
        self.didTapOnTopHomeworkCollView(atIndex: 0)
        
    }
    //2
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setUpView()
    }
    

    
    //3
    func setUpView() {
        
        //0
        //self.leftPeddingConst.constant = UIDevice.isPad ? 50 : 16
        //self.rightPeddingConst.constant = UIDevice.isPad ? 50 : 16
    
        //2
        self.backButton.imageView?.transform =  L102Language.isCurrentLanguageArabic() ? CGAffineTransform(scaleX: -1.0, y: 1.0) : CGAffineTransform(scaleX: 1.0, y: -1.0)
        
        //Bell ICON
        //self.bellIconButton.updateBellCount(color: Colors.APP_LIGHT_GREEN ?? .cyan)
        
    }
    
    
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        //self.navigationController?.popViewController(animated: true)
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
                    self.listView.isHidden = true
                    self.noDataLbl.text = "no_data_found".localized()
                
                } else {
                    
                    self.noDataLbl.text = ""
                    self.listView.isHidden = false
                    
                    self.listView.reloadData()
                    
                    self.didTapOnTopHomeworkCollView(atIndex: self.currentSelectedSubjectIndex)
                }
                 
            }
        }
        
    }
    
    
}




//MARK:================================================
//MARK: TableView Extension
//MARK:================================================

extension HomeworkViewController : UITableViewDelegate, UITableViewDataSource, HomeworkHeaderTCellDelegate, UIDocumentPickerDelegate {
    
    //1
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 + self.dataJson[self.currentSelectedSubjectIndex]["HomeWork"].count
    }

    //2
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            
            let cell = self.listView.dequeueReusableCell(withIdentifier: "homeworkHeaderTCell") as? HomeworkHeaderTCell
            
            cell?.selectionStyle = .none
            
            cell?.subjectsDataJson = self.dataJson
            
            cell?.reloadColletionsView()
            
            cell?.delegateObj = self
            
            return cell ?? UITableViewCell()
            
            
        } else {
            
            
            let cell = self.listView.dequeueReusableCell(withIdentifier: "homeWorkMiddleTCell") as? HomeWorkMiddleTCell
            
            cell?.selectionStyle = .none
            
            let index = indexPath.row - 1
            
            cell?.configureCellWithData(data: self.dataJson[self.currentSelectedSubjectIndex]["HomeWork"][index])
            
            cell?.downloadButton.tag = index
            cell?.downloadButton.addTarget(self, action: #selector(downloadButtonAction), for: .touchUpInside)
            
            cell?.uploadButton.tag = index
            cell?.uploadButton.addTarget(self, action: #selector(uploadButtonAction), for: .touchUpInside)
            
            return cell ?? UITableViewCell()
            
        }
        
        
    }
 
    
    func didTapOnTopHomeworkCollView(atIndex : Int) {
        
        self.currentSelectedSubjectIndex = atIndex
        self.listView.reloadData()
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    
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
        print(cico)
        print(url)
        
        print(url.lastPathComponent)
        
        print(url.pathExtension)
        
        let url = URL(fileURLWithPath: url.path)

        do {
            
            let data = try Data(contentsOf: url)
        
            self.uploadF(fileDataPicked: data, fileUrl: url)
            
        } catch {
            
            
        }
             //guard let doc = data else {
                //  Utility.showAlert(message: Strings.ERROR.text, title: Strings.DOCUMENT_FORMAT_NOT_SUPPORTED.text, controller: self)
              //  return
            //}
            
    }
    
    
    func upload(fileDataPicked: Data, fileUrl : URL) {
        
        //UploadHomeWorkAnswer/{SessionToken}/{StudentID}/{filename}/{HomeWorkID}
        
        var fileName = fileUrl.lastPathComponent
        fileName = fileName.replacingOccurrences(of: " ", with: "")
        
        let urlString = uploadHomeWorkAnswer + "/\(sessionTokenGlobal ?? "")/\(studentIdGlobal ?? "")/\(fileName)/\(self.selectedHomeWorkdId)"
        
        
        let paramsValue = ["stream" : fileDataPicked]
        
        
        ServiceManager().(urlString, fileExtension: "\(fileUrl.pathExtension)", fileData: fileDataPicked, params: paramsValue, header: [:]) { (status, jsonResponse) in
            
            
            if status {
                
                let dataJson = JSON.init(jsonResponse ?? "NO DATA")
                
                //UploadButtonTextEn
                self.dataJson[self.currentSelectedSubjectIndex]["HomeWork"][self.uploadButtonIndex]["Status"].intValue = 2
                
                self.dataJson[self.currentSelectedSubjectIndex]["HomeWork"][self.uploadButtonIndex]["UploadButtonText" + Lang.code()].stringValue = "uploaded_ph".localized()
                
                self.listView.reloadData()
                
                print(dataJson)
                
            }
        }
    }
    
}

*/
