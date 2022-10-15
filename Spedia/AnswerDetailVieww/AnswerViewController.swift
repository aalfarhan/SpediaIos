//
//  AnswerViewController.swift
//  Spedia
//
//  Created by Viraj Sharma on 16/06/2020.
//  Copyright © 2020 Viraj Sharma. All rights reserved.
//

import UIKit
import SwiftyJSON


class AnswerViewController: UIViewController, AnswerTCellDelegate {

    @IBOutlet weak var headerTitleLabel: CustomLabel!
    @IBOutlet weak var listView: UITableView!
    @IBOutlet weak var noDataLbl: CustomLabel!
    @IBOutlet weak var backButton: UIButton!

    var examIdInt = 0
    var isLoaded = true
    var dataJson = JSON()
    var mainJson = JSON()
    var selectedQuestionIndex = 0
    var selectedOptionIndex = -1
         
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        
        self.listView.isHidden = true
        self.noDataLbl.text = ""
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.headerTitleLabel.text = "answer_detail_ph".localized()
        self.getAnswerDetailNow()
    }
    
    
    @IBAction func backButtonAction(_ sender: Any) {
        //self.dismiss(animated: true, completion: nil)
        
        setRootView(tabBarIndex: 0)
        
    }
      
    
    
    func setupView() {
        
        let nibName = UINib(nibName: "AnswerTCell", bundle:nil)
        self.listView.register(nibName, forCellReuseIdentifier: "answerTCell")
        
        //2
        let nibName2 = UINib(nibName: "FourOptionTCell", bundle:nil)
        self.listView.register(nibName2, forCellReuseIdentifier: "fourOptionTCell")
        
        //3
        let nibName3 = UINib(nibName: "AnswerFooterTCell", bundle:nil)
        self.listView.register(nibName3, forCellReuseIdentifier: "answerFooterTCell")
        
        //4
        self.backButton.imageView?.transform =  L102Language.isCurrentLanguageArabic() ? CGAffineTransform(scaleX: -1.0, y: 1.0) : CGAffineTransform(scaleX: 1.0, y: -1.0)
        
        self.listView.delegate = self
        self.listView.dataSource = self
        
    }
    
    
    
    func getAnswerDetailNow() {
        
        //OnlyForTesting...
        //self.examIdInt = 33 //186
        
        let urlString = getExamResultApi
        
        let params = ["SessionToken" : sessionTokenGlobal ?? "",
                      "StudentID" : studentIdGlobal ?? 0,
                      "ExamAnswerID" : self.examIdInt] as [String : Any]
        
        ServiceManager().postRequest(urlString, loader: true, parameters: params) { (status, jsonResponse) in
             
            
            if status {
                
                self.mainJson = JSON.init(jsonResponse ?? "NO DTA")
                self.dataJson = self.mainJson["QuestionList"]
            
                if self.dataJson.count == 0 { //no data here...
                    self.listView.isHidden = true
                    self.noDataLbl.text = "no_data_found".localized()
                } else {
                    self.noDataLbl.text = ""
                    self.listView.isHidden = false
                    self.listView.reloadData()
                }
                 
            }
        }
        
    }
    
}




extension AnswerViewController : UITableViewDelegate, UITableViewDataSource, AnswerFooterTCellDelegate {
   

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataJson[selectedQuestionIndex]["OptionList"].count + 2
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        //0 Last Cell Footer View
        let lastSectionIndex = tableView.numberOfSections - 1
        let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
        
        if indexPath.row == lastRowIndex {
               
            let cell = self.listView.dequeueReusableCell(withIdentifier: "answerFooterTCell") as? AnswerFooterTCell
          
            cell?.selectionStyle = .none
            cell?.delegateObj = self
            
            cell?.fileLinkButton.addTarget(self, action: #selector(fileLinkButtonAction(sender:)), for: .touchUpInside)
            
            cell?.imageLinkButton.addTarget(self, action: #selector(imageLinkButtonAction(sender:)), for: .touchUpInside)
            
            
            
            let dataObj = self.dataJson[self.selectedQuestionIndex]
            cell?.loadViewWithData(data: dataObj)
            
            return cell ?? UITableViewCell()
           
        
            //1 QuestionTCell Cell
        
        } else if indexPath.row == 0 {
            
            let cell = self.listView.dequeueReusableCell(withIdentifier: "answerTCell") as? AnswerTCell
            
            cell?.selectionStyle = .none
            
            
            cell?.mainJson = self.dataJson
            cell?.questionTotalCount = self.dataJson.count
            
            cell?.delegateObj = self
            
            let dataObj = self.dataJson[self.selectedQuestionIndex]
            cell?.loadCollectionView(data: dataObj)
            
            cell?.loadMiddleView(data: self.mainJson)
            
            
            return cell ?? UITableViewCell()
            
            //2 Options Cell
        } else {
            
            let atIndex = indexPath.row - 1
            //let isLtrValue = L102Language.isCurrentLanguageArabic() ? false : true
            
            let cell = self.listView.dequeueReusableCell(withIdentifier: "fourOptionTCell") as? FourOptionTCell
                        
            cell?.selectionStyle = .none
            
            let dataObj = self.dataJson[selectedQuestionIndex]["OptionList"][atIndex]
            cell?.loadOptionTextView(data: dataObj)
            
            //Selection..
            let isOptionSelected = dataObj["IsSelected"].boolValue
            let isCorrect = dataObj["IsCorrect"].boolValue
            cell?.selectionViewSetUpAnswer(isCheck: isOptionSelected ? true : false, isCorrect: isCorrect)
            
            
            //if dataObj["QMainTypeID"].stringValue == "3" {
              
                //let optionData = dataObj["OptionMultipleChoiceList"]
                
                //let optionStr = optionData[atIndex]["OptionUnEscaped"].stringValue
            
                //cell?.choiceID.text = optionData[atIndex]["OptionMultipleChoiceID"].stringValue
                
                //let htmlString = getHtmlStringByAdding(string: optionStr, isLtr: isLtrValue)
            
                //cell?.optionWebView.loadHTMLString(htmlString, baseURL: nil)
            
            //}
            
            
             //cell.featureModel = featuredList[indexPath.section]
             //cell?.loadCollectionView()
             return cell ?? UITableViewCell()
        }
        
        
        
    }
 
    
    @objc func fileLinkButtonAction(sender: UIButton) {
        print("fileLinkButtonAction")
        
        let urlString = self.mainJson["QuestionList"][selectedQuestionIndex]["HelpFile"].stringValue
        
        if let vc = DocumentViewController.instantiate(fromAppStoryboard: .main) {
            vc.modalPresentationStyle = .fullScreen
            //vc.isCommingFromQuizzWithPdf = isBooks
            vc.pdfString = urlString
            
            self.present(vc, animated: true, completion: nil)
        }
        
        /*ServiceManager().downloadFile(urlString) { (status, filePath) in
         if status {
         if let pdfFileUrlPath = filePath {
         self.shareFileWith(localFilePath: pdfFileUrlPath, sender: sender)
         } else {
         self.showAlert(alertText: "corrupt_file".localized(), alertMessage: "")
         }
         }
         }*/
    }
    
    
    @objc func imageLinkButtonAction(sender: UIButton) {
        print("imageLinkButtonAction")
        let urlString = self.mainJson["QuestionList"][selectedQuestionIndex]["HelpImage"].stringValue
        if let vc = ImageViewController.instantiate(fromAppStoryboard: .main) {
            vc.modalPresentationStyle = .fullScreen
            //vc.isCommingFromQuizzWithPdf = isBooks
            vc.pdfString = urlString
            
            self.present(vc, animated: true, completion: nil)
        }
        /*ServiceManager().downloadFile(urlString) { (status, filePath) in
            if status {
                if let pdfFileUrlPath = filePath {
                 self.shareFileWith(localFilePath: pdfFileUrlPath, sender: sender)
                } else {
                    self.showAlert(alertText: "corrupt_file".localized(), alertMessage: "")
                }
            }
        }*/
    }
    
    
    func didTabOnRelatedCollCell(data: JSON) {
        
        print(data)
    
        if let vc = VideoViewController.instantiate(fromAppStoryboard: .main) {
           vc.modalPresentationStyle = .fullScreen
           vc.subjectId = data[SubjectsKey.SubjectID].intValue
           //vc.subjectPriceId = data[SubjectsKey.SubjectPriceID].intValue
           vc.unitId = data[SubjectsKey.UnitID].intValue
           vc.whereFromAmI = WhereFromAmIKeys.answerDetail
            vc.subjectId = data[SubjectsKey.SubjectID].intValue
            vc.subSkillVideoIdStr = data[SubjectsKey.SubskillVideoID].stringValue
            vc.preRecSubSkillId = data[SubjectsKey.SubSkillID].intValue
           //vc.bookmarkWatchedLength = data["WatchedLength"].intValue
           //vc.hidesBottomBarWhenPushed = true
           //self.navigationController?.pushViewController(vc, animated: true)
            
            
            /*vc.modalPresentationStyle = .fullScreen
             vc.subjectId = data[SubjectsKey.SubjectID].intValue
             //vc.subjectPriceId = data[SubjectsKey.SubjectPriceID].intValue
             vc.unitId = data[SubjectsKey.UnitID].intValue
             vc.whereFromAmI = WhereFromAmIKeys.answerDetail
              vc.subSkillVideoIdStr = data[SubjectsKey.SubSkillVideoID].stringValue
              vc.preRecSubSkillId = data[SubjectsKey.SubSkillID].intValue*/
            
           self.present(vc, animated: true, completion: nil)
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    
    func didTapOnAnswerTCell(atIndex : Int) {
        
        self.selectedQuestionIndex = atIndex
        
        //self.outOfLabel.text = L102Language.isCurrentLanguageArabic() ? "السؤال \(atIndex+1)/\(10)" : "Question \(atIndex+1)/\(10)"
        
        self.listView.reloadData()
    }
    
    
}

