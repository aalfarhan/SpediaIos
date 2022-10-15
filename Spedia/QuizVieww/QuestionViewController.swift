//
//  QuestionViewController.swift
//  Spedia
//
//  Created by Viraj Sharma on 15/06/2020.
//  Copyright © 2020 Viraj Sharma. All rights reserved.
//

import UIKit
import SwiftyJSON


class QuestionViewController: UIViewController {

    //0.1 Header View
    @IBOutlet weak var outOfLabel: CustomLabel!
    
    @IBOutlet weak var listView: UITableView!
    @IBOutlet weak var greenBorderView: UIView!
    @IBOutlet weak var timerView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var noDataLbl: CustomLabel!
    
    var isLoaded = false
    var dataJson = JSON()
    var mainJson = JSON()
    
    var selectedQuestionIndex = 0
    var selectedOptionIndex = -1
    
    @IBOutlet var countDownLabel: UILabel!
    var quizCurrentTimeInteger = 0
    var countdownTimer = Timer()
    
    
    //5.1 Quiz Remain Pop-Up
    @IBOutlet weak var quizRemainContainerVieww: UIView!
    @IBOutlet weak var quizRemainView: QuizRemainPopView!
    
    
    //MARK: Number CollView
    @IBOutlet weak var numberCollViewHieght: NSLayoutConstraint!
    @IBOutlet weak var numberCollView: UICollectionView!
    var numberCollViewCount = 0
    var selectIndex = 0
    var cellWitdh = CGFloat()
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.setupView()
        self.setupNumberCollViewNow()
         
        
        self.quizRemainView.delegateObj = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(didEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        
        //NotificationCenter.default.addObserver(self, selector: #selector(didUserTakeScreenshot), name: UIApplication.userDidTakeScreenshotNotification, object: nil)
        
        self.listView.isHidden = true
        self.greenBorderView.isHidden = true
        self.noDataLbl.text = ""
        countDownLabel.text = ""
        self.outOfLabel.text = ""
        
    }
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        
        if(self.quizCurrentTimeInteger > 0) {
            let examId = self.mainJson["ExamAnswerID"].stringValue
            
            AppShared.object.updateTimeWithAPI(withTime: self.quizCurrentTimeInteger, examId: examId)
            
        }
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: UIApplication.didEnterBackgroundNotification, object: nil)
        
    }
    
    
    @objc func didUserTakeScreenshot() {
        print("\n\n\n didUserTakeScreenshot \n\n\n")
        //showAlert(alertText: "Sorry", alertMessage: "Time's UP, you just took screenshot")
    }
    
    @objc func didEnterBackground() {
       // do what's needed
        
        if(self.quizCurrentTimeInteger > 0) {
        
        let examId = self.mainJson["ExamAnswerID"].stringValue
        
            AppShared.object.updateTimeWithAPI(withTime: self.quizCurrentTimeInteger, examId: examId)
            
        }
        
    }
    
    
    
    @objc func updateTime() {
        
        if(self.quizCurrentTimeInteger > 0) {
            
            let minutes = Int(self.quizCurrentTimeInteger / 60)
            let seconds = Int(self.quizCurrentTimeInteger % 60)
            
            
            countDownLabel.text = String(format:"%02i:%02i", minutes, seconds)
            //"\(minutes)" + ":" + "\(seconds)"
            self.quizCurrentTimeInteger = self.quizCurrentTimeInteger - 1
            //print("Timer Alived")
        } else {
            countdownTimer.invalidate()
            countDownLabel.text = "00"
            countDownLabel.textColor = .red
            self.finishDoneQuizNow()
        }
        
        //self.updateTimeWithAPI(withTime: count)
    }
    
    
    func lockQuizAnswer(atRowValue : Int) {
        
        if(self.quizCurrentTimeInteger > 0) {
            
            let examId = self.mainJson["ExamAnswerID"].stringValue
            let questionIdStr = self.dataJson[atRowValue]["QuestionID"].stringValue
            let questionTypeIdStr = self.dataJson[atRowValue]["QuestionTypeID"].stringValue
            let qMainIdStr = self.dataJson[atRowValue]["QMainTypeID"].stringValue
            let optionIdStr = self.dataJson[atRowValue]["OptionList"][self.selectedOptionIndex]["OptionID"].stringValue
            
            
            
            let urlString = getSaveQuizAnswer
            
            
            let params = ["SessionToken": sessionTokenGlobal ?? "",
                          "StudentID": studentIdGlobal ?? 0,
                          "Time": "\(self.quizCurrentTimeInteger)",
                          "ExamAnswerID": examId,
                          "QuestionID": questionIdStr,
                          "QuestionTypeID": questionTypeIdStr,
                          "AnswerID": optionIdStr,
                          "QMainTypeID": qMainIdStr] as [String : Any]
            
            
            ServiceManager().postRequest(urlString, loader: false, parameters: params) { (status, jsonResponse) in
                
                if status {
                    
                    print("\n\n\n Save Quiz Answer Done !!!! \n\n\n")
                    
                }
            }
            
        }
    }
    
    
    
    func finishDoneQuizNow() {
        
        let examId = self.mainJson["ExamAnswerID"].stringValue
        
        let urlString = getUpdateExamAnswerMark
         
        
        let params = ["SessionToken": sessionTokenGlobal ?? "",
                      "ExamAnswerID": examId] as [String : Any]
        
        
        ServiceManager().postRequest(urlString, loader: false, parameters: params) { (status, jsonResponse) in
             
            if status {
                
                print("\n\n\n Finish Quiz Answer Done !!!! \n\n\n")
                
                self.confirmButtonCliked(sender: UIButton())
                
            }
        }
    }
    
    
    
    @IBAction func backButtonAction(_ sender: Any) {
      self.dismiss(animated: true, completion: nil)
    }
      
    
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      
      if isLoaded == false {
         self.getQuestionData()
      }
      
    }
    
    
    
    
    
    func getQuestionData() {
        
        let urlString = getSelectQuestions
         
        
        ///let params = ["QuizID": "1375", "SessionToken": sessionTokenGlobal ?? "", "Pending": "n", "StudentID": studentIdGlobal ?? 0] as [String : Any]
        
        let params = ["SessionToken" : sessionTokenGlobal ?? "",
                      "QuizID" : "\(AppShared.object.quizIDGlobal)",
                      "StudentID" : studentIdGlobal ?? 0,
                      "Pending" : AppShared.object.quizStatusGloabl] as [String : Any]
        
        ServiceManager().postRequest(urlString, loader: true, parameters: params) { (status, jsonResponse) in
             
            if status {
                
                self.mainJson = JSON.init(jsonResponse ?? "NO DTA")
                self.dataJson = self.mainJson["QuestionList"]
                
                self.listView.reloadData()
                self.numberCollView.reloadData()
                
                self.outOfLabel.text = L102Language.isCurrentLanguageArabic() ? "السؤال 1/\(self.dataJson.count)" : "Question 1/\(self.dataJson.count)"
                self.quizCurrentTimeInteger = self.mainJson["QuizTime"].intValue
                
                self.countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateTime), userInfo: nil, repeats: true)
                
                
                self.isLoaded = true
                
                let examId = self.mainJson["ExamAnswerID"].intValue
                AppShared.object.quizIDGlobal = examId
                AppShared.object.quizStatusGloabl = "p"
                
                
                if self.dataJson.count == 0 { //no data here...
                    self.listView.isHidden = true
                    self.greenBorderView.isHidden = true
                    self.noDataLbl.text = "no_data_found".localized()
                } else {
                    
                    self.noDataLbl.text = ""
                    self.listView.isHidden = false
                    self.greenBorderView.isHidden = false
                }
            }
        }
        
        
    }
    
    
    
    
    func setupView() {
        
        //1
        let nibName = UINib(nibName: "QuestionTCell", bundle:nil)
        self.listView.register(nibName, forCellReuseIdentifier: "questionTCell")
        
        //2
        let nibName2 = UINib(nibName: "FourOptionTCell", bundle:nil)
        self.listView.register(nibName2, forCellReuseIdentifier: "fourOptionTCell")
        
        //3
        let nibName3 = UINib(nibName: "QuestionFooterTCell", bundle:nil)
        self.listView.register(nibName3, forCellReuseIdentifier: "questionFooterTCell")
        
        
        //4
        self.greenBorderView.layer.cornerRadius = self.greenBorderView.frame.height / 2
        self.greenBorderView.layer.borderWidth = 1
        self.greenBorderView.layer.borderColor = Colors.APP_LIGHT_GREEN?.cgColor
        self.greenBorderView.backgroundColor = UIColor.clear
        
        //5
        self.timerView.layer.cornerRadius = self.timerView.frame.height / 2
        self.timerView.layer.borderWidth = 1
        self.timerView.layer.borderColor = UIColor.clear.cgColor
        self.timerView.backgroundColor = Colors.APP_LIGHT_GREEN
        
        
        //6
        self.backButton.imageView?.transform =  L102Language.isCurrentLanguageArabic() ? CGAffineTransform(scaleX: -1.0, y: 1.0) : CGAffineTransform(scaleX: 1.0, y: -1.0)
                
    }
    
}




extension QuestionViewController : UITableViewDelegate, UITableViewDataSource, QuestionTCellDelegate {
    
    
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
               
            let cell = self.listView.dequeueReusableCell(withIdentifier: "questionFooterTCell") as? QuestionFooterTCell
          
            cell?.selectionStyle = .none
          
            //cell?.fourOptionTapButton.tag = atIndex
            cell?.confirmButton.addTarget(self, action: #selector(confirmButtonCliked(sender:)), for: .touchUpInside)
            
            cell?.nextButton.addTarget(self, action: #selector(nextButtonCliked(sender:)), for: .touchUpInside)
            
            cell?.reloadConfirmButton(isLastQ: selectIndex+1 == self.dataJson.count ? true : false)
            
            return cell ?? UITableViewCell()
           
        
            //1 QuestionTCell Cell
        
        } else if indexPath.row == 0 {
        
           let cell = self.listView.dequeueReusableCell(withIdentifier: "questionTCell") as? QuestionTCell
                       
           cell?.selectionStyle = .none
           cell?.delegateObj = self
        
           cell?.numberCollViewCount = self.dataJson.count
           let dataObj = self.dataJson[self.selectedQuestionIndex]
           cell?.loadCollectionView(data: dataObj)
            
           return cell ?? UITableViewCell()
        
        //2 Options Cell
        } else {
            
            let atIndex = indexPath.row - 1
            //let isLtrValue = L102Language.isCurrentLanguageArabic() ? false : true
            
            let cell = self.listView.dequeueReusableCell(withIdentifier: "fourOptionTCell") as? FourOptionTCell
                        
            cell?.selectionStyle = .none
            
            let dataObj = self.dataJson[selectedQuestionIndex]["OptionList"][atIndex]
            cell?.loadOptionTextView(data: dataObj)
            
            cell?.fourOptionTapButton.tag = atIndex
            cell?.fourOptionTapButton.addTarget(self, action: #selector(optionTabButtonSelection(sender:)), for: .touchUpInside)
            
            
            //Selection..
            let isOptionSelected = dataObj["IsSelected"].boolValue
            cell?.selectionViewSetUp(isCheck: isOptionSelected ? true : false)
            
            
            //cell?.containerVieww.layer.borderWidth = 1
            //cell?.containerVieww.layer.borderColor = UIColor.clear.cgColor
            //cell?.containerVieww.backgroundColor = Colors.APP_RED_WITH5
             
           
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
 
    
    @objc func optionTabButtonSelection(sender: UIButton) {
        
        var count = 0
        for _ in self.dataJson[selectedQuestionIndex]["OptionList"] {
            self.dataJson[selectedQuestionIndex]["OptionList"][count]["IsSelected"] = false
            count = count + 1
        }
        
        self.dataJson[selectedQuestionIndex]["OptionList"][sender.tag]["IsSelected"] = true
        
        self.selectedOptionIndex = sender.tag
        
        self.lockQuizAnswer(atRowValue: self.selectedQuestionIndex)
        
        self.listView.reloadData()
        
    }
    
    
    
    //XLR8 - Status Change Action...
    @objc func nextButtonCliked(sender: UIButton) {
        
      print("Next button hitzzz......Total Count---\(self.dataJson.count), Selected---\(selectIndex+1)")
    
        if self.selectIndex < self.dataJson.count {
        self.selectIndex = selectIndex+1
        self.numberCollView.reloadData()
        
        //Reload PerentView...
        self.didTapOnQuestionTCell(atIndex: self.selectIndex)
        }
        
    }
    
    
    //XLR8 - Status Change Action...
    @objc func confirmButtonCliked(sender: UIButton) {
      print("Back button hitzzz......")
      
        let totalQuiz = self.mainJson["QuestionCount"].intValue
        var givenAnswerCount = 0
        var skippedCount = totalQuiz
        
       
        for index in 0..<totalQuiz {
            
            let checkArray = self.dataJson[index]["OptionList"]
            
            for row in 0..<checkArray.count {
                
                if checkArray[row]["IsSelected"] == true {
                    
                    givenAnswerCount = givenAnswerCount + 1
                    skippedCount = skippedCount - 1
                    
                } else {
                    
                }
                
                
            }
            
        }
        
        self.quizRemainContainerVieww.isHidden = false
        self.quizRemainView.loadDataWith(totalAnserValue: "\(givenAnswerCount)", totalSkipValue:  "\(skippedCount)")
        
        
    }
        
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    
    }
    
    
    
    func didTapOnQuestionTCell(atIndex : Int) {
        
        self.selectedQuestionIndex = atIndex
        
        self.outOfLabel.text = L102Language.isCurrentLanguageArabic() ? "السؤال \(atIndex+1)/\(self.dataJson.count)" : "Question \(atIndex+1)/\(self.dataJson.count)"
        self.listView.reloadData()
    }
    
    
}




//MARK:================================================
//MARK: Quiz Remain Extension
//MARK:================================================

extension QuestionViewController : QuizRemainPopViewDelegate {
    
    func didConfirmButtonClicked() {
        
        let examId = self.mainJson["ExamAnswerID"].stringValue
        
        let urlString = getUpdateExamAnswerMark
         
        
        let params = ["SessionToken": sessionTokenGlobal ?? "",
                      "ExamAnswerID": examId] as [String : Any]
        
        
        ServiceManager().postRequest(urlString, loader: false, parameters: params) { (status, jsonResponse) in
             
            if status {
                
                print("\n\n\n Finish Quiz Answer Done !!!! \n\n\n")
                
                if let vc = AnswerViewController.instantiate(fromAppStoryboard: .main) {
                    vc.modalPresentationStyle = .fullScreen
                    vc.examIdInt = self.mainJson["ExamAnswerID"].intValue
                    self.present(vc, animated: true, completion: nil)
                }
                
            }
        }
        
    }
    
    
    func didCancelButtonClicked() {
        self.quizRemainContainerVieww.isHidden = true
    }
    
}





//MARK:================================================
//MARK: Number CollectionView (UICollectionView)
//MARK:================================================

extension QuestionViewController: UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
 
    func setupNumberCollViewNow() {
        // Initialization code
        cellWitdh = self.numberCollView.frame.width
        cellWitdh = round(cellWitdh / 9)
        cellWitdh = cellWitdh + 1
        numberCollViewHieght.constant = cellWitdh
        
        let nibName = UINib(nibName: "NumberCollCell", bundle:nil)
        self.numberCollView.register(nibName, forCellWithReuseIdentifier: "numberCollCell")
        
        self.numberCollView.delegate = self
        self.numberCollView.dataSource = self
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataJson.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = numberCollView.dequeueReusableCell(withReuseIdentifier: "numberCollCell", for: indexPath) as? NumberCollCell
        
        cell?.numberLabel.text = "\(indexPath.row + 1)"
        cell?.numberLabel.layer.cornerRadius = cellWitdh / 2
        cell?.numberLabel.clipsToBounds = true
        
        
        if indexPath.row == selectIndex {
            
            cell?.numberLabel.textColor = Colors.APP_LIME_GREEN
            cell?.numberLabel.layer.borderColor = Colors.APP_LIME_GREEN?.cgColor
            //cell?.numberLabel.backgroundColor = UIColor.clear
            
        } else {
            
            cell?.numberLabel.textColor = .gray
            cell?.numberLabel.layer.borderColor = Colors.APP_BORDER_GRAY?.cgColor
            //cell?.numberLabel.backgroundColor = Colors.APP_RED_WITH5
            
        }
        
    
        return cell ?? UICollectionViewCell()
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: cellWitdh, height: cellWitdh)
    }
     
 
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
          return 0
    }
      
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
          return 10
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
        self.selectIndex = indexPath.row
        self.numberCollView.reloadData()
        
        //Reload PerentView...
        self.didTapOnQuestionTCell(atIndex: self.selectIndex)
        
    }
    
    
}






/*
 func showTimesUpPopUp() {
     
     // Create the alert controller
     let alertController = UIAlertController(title: "times_up".localized(), message: "your_quiz_finished".localized(), preferredStyle: .alert)
     
     // Create the actions
     let okAction = UIAlertAction(title: "OK".localized(), style: UIAlertAction.Style.default) {
         UIAlertAction in
         NSLog("OK Pressed")
         if let vc = AnswerViewController.instantiate(fromAppStoryboard: .main) {
             vc.modalPresentationStyle = .fullScreen
             vc.examIdInt = self.mainJson["ExamAnswerID"].intValue
             self.present(vc, animated: true, completion: nil)
         }
     }
     
     // Add the actions
     alertController.addAction(okAction)
     //alertController.addAction(cancelAction)
     
     // Present the controller
     self.present(alertController, animated: true, completion: nil)
 }
 */



