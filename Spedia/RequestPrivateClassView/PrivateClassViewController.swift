//
//  PrivateClassViewController.swift
//  Spedia
//
//  Created by Viraj Sharma on 03/09/2020.
//  Copyright © 2020 Viraj Sharma. All rights reserved.
//

import UIKit
import SwiftyJSON
import SVProgressHUD


class PrivateClassViewController: UIViewController, UITextFieldDelegate {
    
    
    //header object...
    @IBOutlet weak var headerTitleLbl: CustomLabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var activeButton: CustomButton!
    @IBOutlet weak var reservedButton: CustomButton!
    @IBOutlet weak var noDataLbl: CustomLabel!
    @IBOutlet weak var smilyFaceImage: UIImageView!
    @IBOutlet weak var activeClassListView: UITableView!
    @IBOutlet weak var activeClassContVieww: UIView!
    
    
    //Placehodler's
    @IBOutlet weak var subjectPHLbl: CustomLabel!
    @IBOutlet weak var datePHLbl: CustomLabel!
    @IBOutlet weak var timePHLbl: CustomLabel!
    @IBOutlet weak var hoursPHLbl: CustomLabel!
    @IBOutlet weak var typePHLbl: CustomLabel!
    @IBOutlet weak var notePHLbl: CustomLabel!
    @IBOutlet weak var byClickingLbl: CustomLabel!
    
    //TFT's
    @IBOutlet weak var subjectTFT: CustomTFT!
    @IBOutlet weak var dateTFT: CustomTFT!
    @IBOutlet weak var timeTFT: CustomTFT!
    @IBOutlet weak var hoursTFT: CustomTFT!
    @IBOutlet weak var typeTFT: CustomTFT!
    @IBOutlet weak var describtionTFT: CustomTFT!
    @IBOutlet weak var noteTFT: UITextView!
    
   
    //Buttons
    
    @IBOutlet weak var termsConditionButton: CustomButton!
    @IBOutlet weak var payNowButton: CustomButton!
    @IBOutlet weak var nextButton: CustomButton!
    

    
    //Other's
    var isTermsChecked = false
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var termsIconIV: UIImageView!
    @IBOutlet weak var priceView: UIView!
    
    @IBOutlet weak var priceLbl: CustomLabel!
    @IBOutlet weak var priceResevedClassLbl: CustomLabel!
    @IBOutlet weak var priceViewHeightConts: NSLayoutConstraint!
    
    
    var activeClassJson = JSON()
    @IBOutlet weak var attachFilePHLbl: CustomLabel!
    @IBOutlet weak var attachButton: CustomButton!
    var attchmentUrl = String()
    
    
    //Data
    //var isFirstTime = true
    var dataJson = JSON()
    var arrayKey = "Subjects"
    var subjectArrayCopy = JSON()
    var whereFromIAm = ""
    var isPresentingVC = false
    
    @IBOutlet weak var paymentPopUpVieww: PaymentPopUp!

    
    //List View
    //var selectdIndex = 0
    var selectedPrefferedTimeID = Int()
    var selectedHoursId = Int()
    var selectedTypeId = Int()
    var selectedSubjectID = Int()
    var selectedPriceID = Int()
    var selectedAppleProductId = ""
    var selectedSubscribeMsg = ""
    var isDropDownShowing = false
    
    var currentClickedPoints = CGPoint(x: 0, y: DeviceSize.screenHeight/2)
    
    @IBOutlet weak var listViewContainerVieww: UIView!
    @IBOutlet weak var listView: UITableView!
    @IBOutlet weak var constForListViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var mainContainerView: UIView!
    
    //Responsive
    @IBOutlet weak var leftPedding: NSLayoutConstraint!
    @IBOutlet weak var rightPedding: NSLayoutConstraint!
    @IBOutlet weak var mainPageWitdhConst: NSLayoutConstraint!
    
    
    //1 MVC
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //1
        self.subjectTFT.delegate = self
        self.subjectTFT.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        self.subjectTFT.addTarget(self, action: #selector(self.textFieldDidEndEditing(_:)), for: .editingDidEndOnExit)
        self.subjectTFT.addTarget(self, action: #selector(self.textFieldDidBeginEditing(_:)), for: .touchUpInside)
        
        
        //2
        self.dateTFT.delegate = self
        self.dateTFT.setInputViewDatePicker(target: self, selector: #selector(tapDone))
        
        if UIDevice.isPhone {
            self.mainScrollView.delegate = self
        }
        
        

        
        //MARK:Adjust Event Set 105 RPC :NEW
        GlobalFunctions.object.setAdjustEvent(eventName: "njk88c")
        
        
        DispatchQueue.main.async {
          self.setUpView()
          self.getDataWith(hours: 0, type: 0, subjectId: 0)
        }
        
    }
    
    
    func emptyAllFiledNow(shouldCallDataAPI : Bool) {
        
        subjectTFT.text = ""
        dateTFT.text = ""
        timeTFT.text = ""
        hoursTFT.text = ""
        //typeTFT.text = ""
        describtionTFT.text = ""
        noteTFT.text = ""
        
        self.attchmentUrl = ""
        
        self.attachButton.setTitle("attach_file".localized(), for: .normal)
        self.attachButton.setTitleColor( #colorLiteral(red: 0.1019607843, green: 0.1019607843, blue: 0.1019607843, alpha: 0.4), for: .normal)
        
        self.payNowButton.isHidden = false
        self.priceViewHeightConts.constant = 0.0
        self.nextButton.isHidden = true
        
        isTermsChecked = false
        termsIconIV.image =  #imageLiteral(resourceName: "terms_icon_nill")
        
        selectedPrefferedTimeID = 0
        selectedHoursId = 0
        selectedTypeId = 0
        selectedSubjectID = 0
        selectedPriceID = 0
        selectedAppleProductId = ""
        selectedSubscribeMsg = ""
        //isDropDownShowing = false
        
        //self.isFirstTime = true
        
        if shouldCallDataAPI {
          self.getDataWith(hours: 0, type: 0, subjectId: 0)
        }
        
    }
    
    
    //2
    @objc func tapDone() {
        
        if let datePicker = self.dateTFT.inputView as? UIDatePicker { // 2-1
            
            let dateFormatter = DateFormatter()
            
            let loc = Locale(identifier: "us") //2.1
            dateFormatter.locale = loc //2.2
            
            dateFormatter.dateFormat = "dd-MM-yyyy" //24-09-2020
            let selectedDate = dateFormatter.string(from: datePicker.date)
            self.dateTFT.text = selectedDate
            
        }
        self.dateTFT.resignFirstResponder() // 2-5
        
    }
    
    
    
    
    //2
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if UIDevice.isPad {
            self.mainPageWitdhConst.constant = DeviceSize.screenWidth - 100
        } else {
            
        }
        
        //Neww
        /*if isPresentingVC == false {
           self.setUpView()
           self.getDataWith(hours: 0, type: 0, subjectId: 0)
        }*/
        
        
    }
    
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

    //3
    func setUpView() {
        
        //0
        self.backButton.isHidden = true
        self.activeClassListView.isHidden = true
        self.noDataLbl.text = ""
        self.smilyFaceImage.isHidden = true
        
        //3.1 Label's
        self.headerTitleLbl.text = "private_request_class".localized()
        self.subjectPHLbl.text = "subject".localized()
        self.datePHLbl.text = "data_ph".localized()
        self.timePHLbl.text = "time_ph".localized()
        self.hoursPHLbl.text = "no_of_hours".localized()
        //self.typePHLbl.text = "type".localized()
        self.notePHLbl.text = "add_note_ph".localized()
        self.byClickingLbl.text = "by_clicking".localized()
        self.priceResevedClassLbl.text = "total".localized()
        
        self.subjectTFT.placeholder = "subject_tft_ph".localized()
        self.timeTFT.placeholder = "choose_time_ph".localized()
        self.dateTFT.placeholder = "choose_date_ph".localized()
        self.hoursTFT.placeholder = "no_of_hours_tft_ph".localized()
        //self.typeTFT.placeholder = "type".localized()
        //self.describtionTFT.placeholder = "type".localized()
        
        self.noteTFT.placeholder = "type_something_ph".localized()
        
        //3.2 Button's
        self.termsConditionButton.setTitle("terms_and_condition".localized(), for: .normal)
        self.payNowButton.setTitle("buy_now_ph".localized(), for: .normal)
        self.nextButton.setTitle("next".localized(), for: .normal)
        
        //3.3
        self.attachFilePHLbl.text = "add_attachment_ph".localized()
        self.attachButton.setTitle("add_attachment_ph".localized(), for: .normal)
        
        
        self.backButton.imageView?.transform =  L102Language.isCurrentLanguageArabic() ? CGAffineTransform(scaleX: -1.0, y: 1.0) : CGAffineTransform(scaleX: 1.0, y: -1.0)
        
       
        //Cell's 3.3
        let nibName2 = UINib(nibName: "GradeTableCell", bundle:nil)
        self.listView.register(nibName2, forCellReuseIdentifier: "gradeTableCell")
        
        
        //4.0
        let joinNib = UINib(nibName: "ActiveRPClassTCell", bundle:nil)
        self.activeClassListView.register(joinNib, forCellReuseIdentifier: "activeRPClassTCell")
        
                
            self.listViewContainerVieww.frame = CGRect(x: 0, y: 0, width: DeviceSize.screenWidth, height: 0)
            
            self.priceView.frame = CGRect(x: 0, y: DeviceSize.screenHeight, width: DeviceSize.screenWidth, height: 0)
            
        
        
        
        self.payNowButton.isHidden = false
        self.priceViewHeightConts.constant = 0.0
        self.nextButton.isHidden = true
        
        
        
        self.activeButton.setTitle("rp_active_class_button_text".localized(), for: .normal)
        self.reservedButton.setTitle("rp_request_private_button_text".localized(), for: .normal)
        
        self.whiceButtonActiveWithTag(tag: whichRPCPageIndexGlobal)
        
    }
    
    
    
    @IBAction func reservCleasesButtonAction(_ sender: Any) {
        self.whiceButtonActiveWithTag(tag: 2)
    }
    
    @IBAction func activeClassesButtonAction(_ sender: Any) {
        self.whiceButtonActiveWithTag(tag: 1)
    }
    
    
    func whiceButtonActiveWithTag (tag : Int) {
        
        //UIView.animate(withDuration: 0.50) {
            
        if tag == 1 { //Active List
            
            //self.noDataLbl.text = "no_active_data".localized()
            whichRPCPageIndexGlobal = 1
            self.mainScrollView.isHidden = true
            self.activeClassContVieww.isHidden = false
            self.listViewContainerVieww.isHidden = true
            self.activeButton.backgroundColor = .white
            self.activeButton.setTitleColor(Colors.APP_LIGHT_GREEN, for: .normal)
            
            self.reservedButton.backgroundColor = .clear
            self.reservedButton.setTitleColor(.white, for: .normal)
            
            self.activeClassListView.reloadData()
            
            //self.dataJson = self.mainDataJson["LiveclassCategorys"][self.selectedTopCategoryIndex]["ActiveList"]
            
            //self.collView.reloadData()
            
        } else { //Reserved List
            
            //self.noDataLbl.text = "no_reserved_data".localized()
            whichRPCPageIndexGlobal = 2
            self.mainScrollView.isHidden = false
            self.activeClassContVieww.isHidden = true
            self.listViewContainerVieww.isHidden = false
            self.activeButton.backgroundColor = .clear
            self.activeButton.setTitleColor(.white, for: .normal)
                       
            self.reservedButton.backgroundColor = .white
            self.reservedButton.setTitleColor(Colors.APP_LIGHT_GREEN, for: .normal)
            
            self.emptyAllFiledNow(shouldCallDataAPI: true)
            
            //self.dataJson = self.mainDataJson["ReserveList"]
            //self.collView.reloadData()
            
        }
         
         self.view.layoutIfNeeded()
        
        //}
        
    }
    
    
    //4
    func getDataWith(hours : Int, type : Int, subjectId : Int) {
        
        let urlString = getLiveClassRequestData
        
        let params = ["HourID" : hours,
                      "SessionToken" : sessionTokenGlobal ?? "",
                      "StudentID" : studentIdGlobal ?? 0,
                      "DeviceType": DeviceType.iPhone,
                      "SubjectID" : subjectId] as [String : Any]
        
        
        ServiceManager().postRequest(urlString, loader: true, parameters: params) { (status, jsonResponse) in
            
            if status {
                
                //if self.isFirstTime {
                    //self.isFirstTime = false
                    self.dataJson = JSON.init(jsonResponse ?? "NO DTA")
                    self.subjectArrayCopy = self.dataJson["Subjects"]
                    self.activeClassJson = self.dataJson["PrivateClassList"]
                    
                    
                    if self.activeClassJson.count == 0 {
                        
                        self.activeClassListView.isHidden = true
                        self.noDataLbl.text = "no_data_found".localized()
                        self.smilyFaceImage.isHidden = false
                    } else {
                        self.activeClassListView.isHidden = false
                        self.noDataLbl.text = ""
                        self.smilyFaceImage.isHidden = true
                        self.activeClassListView.reloadData()
                    }
                    
                //}
                
                
                let data = JSON.init(jsonResponse ?? "NO DTA")
                
                if data["PriceID"].intValue > 0 {
                    
                    self.selectedPriceID = data["PriceID"].intValue
                    self.selectedAppleProductId = data["AppleProductID"].stringValue
                    self.selectedSubscribeMsg = L102Language.isCurrentLanguageArabic() ? data["SubcribeMessageAr"].stringValue : data["SubcribeMessageEn"].stringValue
                    
                    
                    let price = data["Price"].floatValue
                    let currencyCode = data["CurrencyCode"].string ?? ""
                    
                    self.priceLbl.text = String(format: "\(currencyCode) %.3f", price)
                    
                    UIView.animate(withDuration: 0.40) {
                        self.priceViewHeightConts.constant = 0
                        self.view.layoutIfNeeded()
                        self.payNowButton.isHidden = false
                        self.nextButton.isHidden = true
                    }
                }
                
                //MARK: For App Instruction Pop-Up
                
                if !UserDefaults.standard.bool(forKey: "isInstructionOnPrivateFirstTimeKey") {
                    
                    UserDefaults.standard.setValue(true, forKey: "isInstructionOnPrivateFirstTimeKey")
                    showCustomInstructionBox(imageJson: self.dataJson["InstructionImages"])
                }
                
                
                
            }
        }
        
        
    }
    
    
    private func validateFields()->Bool {
        
        var validateFields = true
        
        //1
        let subject = subjectTFT.text ?? ""
        if subject.isEmpty {
            subjectTFT.layer.borderColor = UIColor.red.cgColor
            validateFields = false
        } else {
            subjectTFT.layer.borderColor = UIColor.white.cgColor
        }
        
        
        //2
        let dateStr = dateTFT.text ?? ""
        if dateStr.isEmpty {
            dateTFT.layer.borderColor = UIColor.red.cgColor
            validateFields = false
        } else {
            dateTFT.layer.borderColor = UIColor.white.cgColor
        }
        
        
        //3
        /*let typeStr = typeTFT.text ?? ""
        if typeStr.isEmpty {
            typeTFT.layer.borderColor = UIColor.red.cgColor
            validateFields = false
        } else {
            typeTFT.layer.borderColor = UIColor.white.cgColor
        }*/
        
        
        
        //4
        let hoursStr = hoursTFT.text ?? ""
        
        if hoursStr.isEmpty {
            hoursTFT.layer.borderColor = UIColor.red.cgColor
            validateFields = false
        } else {
            hoursTFT.layer.borderColor = UIColor.white.cgColor
        }
        
        
        
        //5
        let timeStr = timeTFT.text ?? ""
        if timeStr.isEmpty  {
            timeTFT.layer.borderColor = UIColor.red.cgColor
            validateFields = false
        } else {
            timeTFT.layer.borderColor = UIColor.white.cgColor
        }
        
        
        
        //6
        /*let noteStr = noteTFT.text ?? ""
         if noteStr.isEmpty  {
         noteTFT.layer.borderColor = UIColor.red.cgColor
         validateFields = false
         } else {
         noteTFT.layer.borderColor = UIColor.white.cgColor
         }*/
        
        
        // 7
        if isTermsChecked == false {
            SVProgressHUD.showInfo(withStatus: "iagreedTC".localized())
            validateFields = false
        }
        
        return validateFields
        
    }
    
    
    
    
    //Action's
    
    
    //===============================================
    //MARK: Auto Fill & Searching With TFT
    //===============================================
    
    //1
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        let searchText = textField.text ?? ""
        
        print("Typing...", searchText)
        
        
        if searchText.isEmpty {
            self.dataJson["Subjects"] = self.subjectArrayCopy
            self.listView.reloadData()
            
        } else {
            
            //let valueKey = L102Language.isCurrentLanguageArabic() ? "TextAr" : "TextEn"
            
            let searchPredicate = NSPredicate(format: "(TextEn contains[c] %@) OR (TextAr contains[c] %@)", searchText, searchText)
            
            if let array = self.subjectArrayCopy.arrayObject {
                
                let foundItems = JSON(array.filter { searchPredicate.evaluate(with: $0) })
                self.dataJson["Subjects"] = foundItems
                self.listView.reloadData()
            }
            
        }
        
    }
    
    /*func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
     // Implement your Date Time Picker initial Code here
     if textField == subjectTFT || textField == dateTFT {
     return false
     }
     
     return true
     }*/
    
    
    
    //Show Auto List on Start/Click TFT
    @objc func textFieldDidBeginEditing(_ textField: UITextField) {
        self.dropDownViewHide(points: currentClickedPoints)
    }
    
    
    //Hide Keyboard Action....
    @objc func textFieldDidEndEditing(_ textField: UITextField) {
        print("End End")
        self.dropDownViewHide(points: currentClickedPoints)
    }
    
    
    
    //1
    @IBAction func subjectSelectAction(_ sender: Any) {
        
        if !self.isDropDownShowing {
            
            self.arrayKey = "Subjects"
            self.listView.reloadData()
            
            self.currentClickedPoints = subjectTFT.superview?.convert(subjectTFT.frame.origin, to: nil) ?? CGPoint()
            self.dropDownViewShow(points: currentClickedPoints)
            
        } else {
            
            self.dropDownViewHide(points: currentClickedPoints)
            
        }
        
    }
    
    
    //2
    @IBAction func timeSelectionAction(_ sender: Any) {
        
        if !self.isDropDownShowing {
            
            self.arrayKey = "PrefferedTimes"
            self.listView.reloadData()
            
            self.currentClickedPoints = timeTFT.superview?.convert(timeTFT.frame.origin, to: nil) ?? CGPoint()
            self.dropDownViewShow(points: currentClickedPoints)
            
        } else {
            
            self.dropDownViewHide(points: currentClickedPoints)
            
        }
        
    }
    
    
    //3
    @IBAction func hoursSelectionAction(_ sender: Any) {
        
        if !self.isDropDownShowing {
            
            self.arrayKey = "Hours"
            self.listView.reloadData()
            
            self.currentClickedPoints = hoursTFT.superview?.convert(hoursTFT.frame.origin, to: nil) ?? CGPoint()
            self.dropDownViewShow(points: currentClickedPoints)
            
        } else {
            
            self.dropDownViewHide(points: currentClickedPoints)
            
        }
        
    }
    
    
    //4
    @IBAction func typeSelectionAction(_ sender: Any) {
        
       
    }
    
    
    //5
    @IBAction func checkBoxAction(_ sender: Any) {
        
        if isTermsChecked {
            
            isTermsChecked = false
            termsIconIV.image =  #imageLiteral(resourceName: "terms_icon_nill")
            
            self.payNowButton.isHidden = false
            self.priceViewHeightConts.constant = 0.0
            self.nextButton.isHidden = true
            
        } else {
            isTermsChecked = true
            termsIconIV.image =  #imageLiteral(resourceName: "terms_icon_fill")
        }
        
    }
    
    
    //6
    @IBAction func termsButtonAction(_ sender: Any) {
        
        if let vc = TermsAndPolicyViewController.instantiate(fromAppStoryboard: .main) {
            vc.modalPresentationStyle = .fullScreen
            vc.webPageURLStr = ContactUs.liveClassTermsLink
            
            //Note: For Prevent reloading of form page (can't use viewDid Api call)
            self.isPresentingVC = true
            
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    
    //7
    @IBAction func payNowButtonAction(_ sender: Any) {
        print("payNowButtonAction")
        
        if self.validateFields() {
            self.requestForLiveClass()
        }
    }
    
    
    //7
    @IBAction func nextButtonAction(_ sender: Any) {
        
      
    }
    
    
    func requestForLiveClass() {
        
        // IAP 1
      
        globalProductIdStrIAP = self.selectedAppleProductId
        //MARK: DND globalSubjectPriceIdIAP = self.selectedPriceID
        globalIsPrivateClassTypeIAP = true
        globalResumePaymentMsgIAP = self.selectedSubscribeMsg

        //showCustomInAppPurchaseBox(title: self.selectedSubscribeMsg, subTitle: "", buttonType: "buy_now", imageName: "addToCartSuccess", textColor: UIColor.black)
        
        self.paymentPopUpVieww.setUpView(withHtmlText: selectedSubscribeMsg)
        self.paymentPopUpVieww.isHidden = false
        self.paymentPopUpVieww.delegateObj = self
        self.paymentPopUpVieww.isRPCPage = true

        
    }
    
    
}




//===========================
//MARK: LIST VIEW (Selection Data View)
//===========================

extension PrivateClassViewController : UITableViewDelegate, UITableViewDataSource {

    //0 Add Top Space On TableView
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Section \(section)"
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let vw = UIView()
        vw.backgroundColor = UIColor.clear
        
        return vw
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if tableView == activeClassListView {
            return 20
        }
        return 0
    }
    
    
    

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == activeClassListView {
            return self.activeClassJson.count
        }
        
        return self.dataJson[arrayKey].count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == activeClassListView {
            
            let cell = self.activeClassListView.dequeueReusableCell(withIdentifier: "activeRPClassTCell") as? ActiveRPClassTCell
                        
            cell?.selectionStyle = .none
        
            
            let titleStr = L102Language.isCurrentLanguageArabic() ? self.activeClassJson[indexPath.row]["TitleAr"].stringValue : self.activeClassJson[indexPath.row]["TitleEn"].stringValue
            
            let subTitleStr = L102Language.isCurrentLanguageArabic() ? self.activeClassJson[indexPath.row]["DetailsAr"].stringValue : self.activeClassJson[indexPath.row]["DetailsEn"].stringValue
            
            let joinButtonStatusStr = L102Language.isCurrentLanguageArabic() ? self.activeClassJson[indexPath.row]["StatusAr"].stringValue : self.activeClassJson[indexPath.row]["StatusEn"].stringValue
            
            
            //..
            cell?.classTitleLbl.text = titleStr
            cell?.classTimeLbl.text = subTitleStr
            
            //...
            cell?.joinButton.setTitle(joinButtonStatusStr, for: .normal)
            cell?.joinButton.tag = indexPath.row
            cell?.joinButton.addTarget(self, action: #selector(joinButtonTapped(sender:)), for: .touchUpInside)
            
            if self.activeClassJson[indexPath.row]["Join"].boolValue {
              
                cell?.joinButton.isUserInteractionEnabled = true
                cell?.joinButton.backgroundColor = UIColor.init(hexaRGB: "FF3B30")
                
            } else {
                
                cell?.joinButton.isUserInteractionEnabled = false
                
                if self.activeClassJson[indexPath.row]["StatusEn"].stringValue.lowercased() == "pending" {
                    cell?.joinButton.backgroundColor = UIColor.init(hexaRGB: "F98D23")
                } else {
                    cell?.joinButton.backgroundColor = UIColor.init(hexaRGB: "34C759")
                }
                
            }
            
            
            cell?.attacmentButton.tag = indexPath.row
            cell?.attacmentButton.addTarget(self, action: #selector(attachmentButtonAction), for: .touchUpInside)
           
            let checkPdf = self.activeClassJson[indexPath.row]["FilePath"].stringValue
            //verifyUrl(urlString: self.dataJson[index]["FilePath"].stringValue)
            cell?.attacmentButton.isHidden = checkPdf.isEmpty ? true : false
            
            return cell ?? UITableViewCell()
        
            
            
            
            
        } else {
        
        let cell = self.listView.dequeueReusableCell(withIdentifier: "gradeTableCell") as? GradeTableCell
        
        cell?.selectionStyle = .none
        
        cell?.checkImageView.isHidden = true
        cell?.roundImageView.isHidden = false
        
        if self.dataJson[arrayKey][indexPath.row]["isSelected"].boolValue {
            cell?.checkImageView.isHidden = false
            cell?.roundImageView.isHidden = true
        }
        
        cell?.nameLbl.text = L102Language.isCurrentLanguageArabic() ? self.dataJson[arrayKey][indexPath.row]["TextAr"].stringValue : self.dataJson[arrayKey][indexPath.row]["TextEn"].stringValue
        
        //cell?.backgroundColor = UIColor.clear
        
        return cell ?? UITableViewCell()
            
        }
    }
    
    
    @objc func attachmentButtonAction(sender: UIButton) {
        
        if let vc = DocumentViewController.instantiate(fromAppStoryboard: .main) {
          vc.modalPresentationStyle = .fullScreen
          //vc.isCommingFromQuizzWithPdf = isBooks
          vc.pdfString = self.activeClassJson[sender.tag]["FilePath"].stringValue
            
          self.present(vc, animated: true, completion: nil)
        }
        
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if tableView == activeClassListView {
         
            
        } else {
        
        var count = 0
        for _ in self.dataJson[arrayKey] {
            self.dataJson[arrayKey][count]["isSelected"] = false
            count = count + 1
        }
        
        self.dataJson[arrayKey][indexPath.row]["isSelected"].boolValue = true
        
        
        //Subjects, PrefferedTimes,Hours, RequestTypes
        
        if self.arrayKey == "Subjects" {
            
            self.subjectTFT.text = L102Language.isCurrentLanguageArabic() ? self.dataJson[arrayKey][indexPath.row]["TextAr"].stringValue : self.dataJson[arrayKey][indexPath.row]["TextEn"].stringValue
            
            self.selectedSubjectID = self.dataJson[arrayKey][indexPath.row]["ID"].intValue
            
            //self.isFirstTime = true
            
            
            self.getDataWith(hours: self.selectedHoursId, type: self.selectedTypeId, subjectId: self.selectedSubjectID)
            
            self.hoursTFT.text = ""
            
            
        }
        
        
        if self.arrayKey == "PrefferedTimes" {
            self.timeTFT.text = L102Language.isCurrentLanguageArabic() ? self.dataJson[arrayKey][indexPath.row]["TextAr"].stringValue : self.dataJson[arrayKey][indexPath.row]["TextEn"].stringValue
            
            self.selectedPrefferedTimeID = self.dataJson[arrayKey][indexPath.row]["ID"].intValue
        }
        
        
        if self.arrayKey == "Hours" {
            
            self.hoursTFT.text = L102Language.isCurrentLanguageArabic() ? self.dataJson[arrayKey][indexPath.row]["TextAr"].stringValue : self.dataJson[arrayKey][indexPath.row]["TextEn"].stringValue
            
            self.selectedPriceID = self.dataJson[arrayKey][indexPath.row]["PriceID"].intValue
            
            self.selectedAppleProductId = self.dataJson[arrayKey][indexPath.row]["AppleProductID"].stringValue
            
            self.selectedSubscribeMsg = L102Language.isCurrentLanguageArabic() ? self.dataJson[arrayKey][indexPath.row]["SubcribeMessageAr"].stringValue : self.dataJson[arrayKey][indexPath.row]["SubcribeMessageEn"].stringValue
            
            
            
            print("\n\n\n-------->", self.selectedAppleProductId, self.selectedPriceID)
            
            
        }
        
        if self.arrayKey == "RequestTypes" {
            /*self.typeTFT.text = L102Language.isCurrentLanguageArabic() ? self.dataJson[arrayKey][indexPath.row]["TextAr"].stringValue : self.dataJson[arrayKey][indexPath.row]["TextEn"].stringValue
            
            self.selectedTypeId = self.dataJson[arrayKey][indexPath.row]["ID"].intValue*/
        }
        
        self.listView.reloadData()
        
        self.dropDownViewHide(points: currentClickedPoints)
            
        }
    }
    
    
    
    //XLR8 - Status Change Action...
    @objc func joinButtonTapped(sender: UIButton) {
      
      let data = self.activeClassJson[sender.tag]
      print("\n\n Selected Data------> \(data)\n\n")
      self.didTapOnJoinButton(model: data)
     
    }
    
    
    //MARK: Join Button API...
    func didTapOnJoinButton(model : JSON) {
          
        
          let urlString = studentJoined
               let params = ["SessionToken" : sessionTokenGlobal ?? "",
                             "StudentID" : studentIdGlobal ?? 0,
                             "LiveClassDetailID" : model["LiveClassDetailID"].intValue] as [String : Any]
               
          ServiceManager().postRequest(urlString, loader: true, parameters: params) { (status, jsonResponse) in
                    
                   if status {
                    
                    //Zoom SDK : 6
                    ZoomGlobalMeetingClass.object.isFromLiveClass = true
                    ZoomGlobalMeetingClass.object.liveClassIdObj = model["LiveClassDetailID"].intValue
                    ZoomGlobalMeetingClass.object.joinMeetingWithData(model: model)
                    
                }
          }
        
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if tableView == activeClassListView {
            return 100.0 //Row Height 80 and 20 Bottom Space
        }
        
        return 60.0
    }
    
    
    
    func dropDownViewShow(points : CGPoint) { //points : CGPoint
        
        self.dateTFT.resignFirstResponder()
        self.listViewContainerVieww.isHidden = false
        if self.dataJson[arrayKey].count == 0 {
            
            self.isDropDownShowing = false
            self.showAlert(alertText: "", alertMessage: "no_data_found".localized())
            
        } else {
            
            if UIDevice.isPhone {
              self.mainScrollView.isScrollEnabled = true
            }
            
            self.isDropDownShowing = true
            
            
            /*if UIDevice.isPad {
            
                self.listViewContainerVieww.frame = CGRect(x: mainContainerView.frame.origin.x, y: points.y + 60, width: mainContainerView.frame.width, height: 0)
                
                UIView.animate(withDuration: 0.50) {
                               
                    self.listViewContainerVieww.frame = CGRect(x: self.mainContainerView.frame.origin.x, y: points.y + 60, width: self.mainContainerView.frame.width, height: DeviceSize.screenHeight - (points.y + 110))
                           self.view.layoutIfNeeded()
                               
                }
                
                
            } else {*/
            
            
            self.listViewContainerVieww.frame = CGRect(x: 0, y: points.y + 60, width: DeviceSize.screenWidth, height: 0)
            
            UIView.animate(withDuration: 0.50) {
                           
                       self.listViewContainerVieww.frame = CGRect(x: 0, y: points.y + 60, width: DeviceSize.screenWidth, height: DeviceSize.screenHeight - (points.y + 110))
                       self.view.layoutIfNeeded()
                           
                       }
                
            //}
                
           
        }
        
    }
    
    
    
    func dropDownViewHide(points : CGPoint) {
        
        /*if UIDevice.isPad {
            
            UIView.animate(withDuration: 0.40) {
                
                self.listViewContainerVieww.frame = CGRect(x: self.mainContainerView.frame.origin.x, y: points.y + 60, width: self.mainContainerView.frame.width, height: 0)
                
                self.view.layoutIfNeeded()
                
            }
            
        } else {*/
            
            self.mainScrollView.isScrollEnabled = true
            
            UIView.animate(withDuration: 0.40) {
                
                self.listViewContainerVieww.frame = CGRect(x: 0, y: points.y + 60, width: DeviceSize.screenWidth, height: 0)
                
                self.view.layoutIfNeeded()
                
            }
            
        //}
        
    
        self.isDropDownShowing = false
        self.payNowButton.isHidden = false
        self.nextButton.isHidden = true
    }
    
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
         print("scrollViewWillBeginDragging")
        
        if UIDevice.isPhone && scrollView != self.listView {
            
            self.mainScrollView.isScrollEnabled = true
            self.listViewContainerVieww.isHidden = true
            
          
        }
    }
    
    
    
}



extension UITextField {
    
    func setInputViewDatePicker(target: Any, selector: Selector) {
        
        // Create a UIDatePicker object and assign to inputView
        let screenWidth = UIScreen.main.bounds.width
        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 300))//1
        datePicker.datePickerMode = .date //2
        datePicker.minimumDate = Date()
        //let loc = Locale(identifier: "us") //2.1
        //datePicker.locale = loc //2.2
        
        if #available(iOS 14.0, *) {
            datePicker.preferredDatePickerStyle = .wheels
        } else {
            
            // Fallback on earlier versions
            if #available(iOS 13.4, *) {
                datePicker.preferredDatePickerStyle = .automatic
            } else {
                // Fallback on earlier versions
            }
            
        }
        
        datePicker.backgroundColor = .white
        
        self.inputView = datePicker //3
        
        // Create a toolbar and assign it to inputAccessoryView
        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 44.0)) //4
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil) //5
        let cancel = UIBarButtonItem(title: "CANCEL".localized(), style: .plain, target: nil, action: #selector(tapCancel)) // 6
        let barButton = UIBarButtonItem(title: "OK".localized(), style: .plain, target: target, action: selector) //7
        toolBar.setItems([cancel, flexible, barButton], animated: false) //8
        self.inputAccessoryView = toolBar //9
    }
    
    @objc func tapCancel() {
        self.resignFirstResponder()
    }
    
}




//MARK:- Image Picker
extension PrivateClassViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

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
        
        let urlString = uploadFile + "/\(sessionTokenGlobal ?? "")"+"/RequestPrivateImage.jpg/rpc/\(studentIdGlobal ?? "0")"
         
        let paramsValue = ["stream" : pickerImage.compressedData(quality: 0.7)]
            
     
        ServiceManager().uploadPhoto(urlString, imageExtension: "jpg", imageData: pickerImage.compressedData(), params: paramsValue, header: [:]) { (status, jsonResponse) in
              
              if status {
                
                let dataJson = JSON.init(jsonResponse ?? "NO DATA")
                
                print("Upload Respone Data======>",dataJson)
                
                if dataJson["Status"].boolValue {
                  self.attchmentUrl = dataJson["FileName"].stringValue
                  self.attachButton.setTitle("\(self.attchmentUrl)", for: .normal)
                  self.attachButton.setTitleColor(.black, for: .normal)
                    
                  print("Upload Success File URL======> \(self.attchmentUrl)")
                }
              }
        }
            
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

}





//MARK:================================================
//MARK: Payment Pop Deletegate
//MARK:================================================


extension PrivateClassViewController: PaymentPopUpDelegate {
    
    func crossButtonClick() {
        self.paymentPopUpVieww.isHidden = true
        
        self.requestPrivateLiveClassFirst()
    }


    func requestPrivateLiveClassFirst() {
        
        let urlString = requestLiveClass
        
        let params = ["SessionToken" : sessionTokenGlobal ?? "",
                      "StudentID" : studentIdGlobal ?? 0,
                      "SubjectID" : selectedSubjectID,
                      "Date" : dateTFT.text ?? "",
                      "Notes" : self.noteTFT.text ?? "",
                      "PriceID" : selectedPriceID,
                      "PrefferedTimeID" : selectedPrefferedTimeID,
                      "FileName" : self.attchmentUrl] as [String : Any]
        
        ServiceManager().postRequest(urlString, loader: false, parameters: params) { (status, jsonResponse) in
            
            if status {
                
                let dataRes = JSON.init(jsonResponse ?? "NO DTA")
                globalSubjectPriceIdIAP = dataRes["SubjectPriceID"].intValue
                
                print("\n\n\n\n Request Private First Is Called \n\n\n\n")
                self.emptyAllFiledNow(shouldCallDataAPI: false)
                
            }
        }
    }

}
