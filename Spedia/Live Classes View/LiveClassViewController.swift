//
//  LiveClassViewController.swift
//  Spedia
//
//  Created by Viraj Sharma on 13/07/2020.
//  Copyright © 2020 Viraj Sharma. All rights reserved.
//

import UIKit
//...
import SwiftyJSON
import Kingfisher
import SVProgressHUD

class LiveClassViewController: UIViewController {

    //header object...
    @IBOutlet weak var headerTitleLbl: CustomLabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet var activeButton: CustomButton!
    @IBOutlet var reservedButton: CustomButton!
    @IBOutlet var filterButton: CustomButton!
    //@IBOutlet weak var filterTFT: DataPickerTextField!
    
    //No DATA View...
    @IBOutlet weak var noDataView: UIView!
    @IBOutlet weak var noDataLbl: CustomLabel!
    @IBOutlet weak var reserveNowButton: CustomButton!

    @IBOutlet weak var paymentPopUpVieww: PaymentPopUp!

    //...
    @IBOutlet weak var collView: UICollectionView!
    //@IBOutlet weak var stackButtonWitdhConst: NSLayoutConstraint!
    
    //...
    var mainDataJson = JSON()
    var dataJson = JSON()
    var advBannerDataJson = JSON()
    
    var isExpandedSubList = false
    var expandingIndex = 0
    
    
    //MARK: TOP CATEGORY SELECTION View
    @IBOutlet weak var topCategoryTopCollView: UICollectionView!
    var selectedTopCategoryIndex = 0
    @IBOutlet weak var topCategoryCollViewHeight: NSLayoutConstraint!
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("liveClassNotificationIdentifierOLD"), object: nil)
        
        
        self.registerCells()
        
        self.setUpViews()
        
        self.backButton.isHidden = true
        
        
        //MARK:--------------------------------------------
        //MARK: 1 Check Resume Payment (SetUp)
        //MARK:--------------------------------------------
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            
            if globalshouldResumePaymentIAP && !isGuestLoginGlobal {
                globalshouldResumePaymentIAP = false
                self.paymentPopUpVieww.setUpView(withHtmlText: globalResumePaymentMsgIAP)
                self.paymentPopUpVieww.isHidden = false
                self.paymentPopUpVieww.delegateObj = self

            }
            
        }
    }

    
    
    override func viewWillAppear(_ animated: Bool) {
        
       super.viewWillAppear(animated)
    
       self.getLiveClassData()
        
    }
    
    
    
    @objc func methodOfReceivedNotification(notification: Notification) {
         self.getLiveClassData()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: Notification.Name("liveClassNotificationIdentifierOLD"), object: nil)
    
    }
    
    
    @IBAction func reservNowButtonAction(_ sender: Any) {
        self.whiceButtonActiveWithTag(tag: 1)
    }
    
    
    @IBAction func reservCleasesButtonAction(_ sender: Any) {
        
        self.whiceButtonActiveWithTag(tag: 2)
        
        //fakeZoomMeeting()
    
    }
    
    
    @IBAction func activeClassesButtonAction(_ sender: Any) {
        self.whiceButtonActiveWithTag(tag: 1)
    }
    

    func whiceButtonActiveWithTag (tag : Int) {
        
        UIView.animate(withDuration: 0.50) {
            
        if tag == 1 { //Active List
            
            self.noDataLbl.text = "no_active_data".localized()
            //indexactive = 1
            self.activeButton.backgroundColor = .white
            self.activeButton.setTitleColor(Colors.APP_LIGHT_GREEN, for: .normal)
            
            self.reservedButton.backgroundColor = .clear
            self.reservedButton.setTitleColor(.white, for: .normal)
            
            self.dataJson = self.mainDataJson["LiveclassCategorys"][self.selectedTopCategoryIndex]["ActiveList"]
            
            self.collView.reloadData()
            
            
            self.topCategoryCollViewHeight.constant = 50.0
            if self.mainDataJson["LiveclassCategorys"].count <= 1 {
                self.topCategoryCollViewHeight.constant = 0.0
            }
            
        
            
            
        } else { //Reserved List
            
            self.noDataLbl.text = "no_reserved_data".localized()
            //activeIndex = 2
            self.activeButton.backgroundColor = .clear
            self.activeButton.setTitleColor(.white, for: .normal)
                       
            self.reservedButton.backgroundColor = .white
            self.reservedButton.setTitleColor(Colors.APP_LIGHT_GREEN, for: .normal)
            
            self.dataJson = self.mainDataJson["ReserveList"]
            
            self.collView.reloadData()
            
            self.topCategoryCollViewHeight.constant = 0.0
            //self.arrowHieght.constant = 0.0
            
        }
         
         self.view.layoutIfNeeded()
        
        }
         
        
        self.checkForNoData()
        
    }
    
    

    

    @IBAction func backButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: API Calling...
    func getLiveClassData() {
       
       self.noDataView.isHidden = true
       self.collView.isHidden = true
       
        
       let urlString = getLiveCourses
            let params = ["SessionToken" : sessionTokenGlobal ?? "",
                          "StudentID" : studentIdGlobal ?? 0,
                          "DeviceType": DeviceType.iPhone] as [String : Any]
            
       ServiceManager().postRequest(urlString, loader: true, parameters: params) { (status, jsonResponse) in
                 
                if status {
                    
                    let dataRes = JSON.init(jsonResponse ?? "NO DTA")
                    
                    self.mainDataJson = dataRes
                        
                    self.headerTitleLbl.text = L102Language.isCurrentLanguageArabic() ? dataRes["HeadingAr"].stringValue : dataRes["HeadingEn"].stringValue
                    
                    self.advBannerDataJson = dataRes["\(MyCartKeys.Advertisements)"]
                    
                    
                    //self.whiceButtonActiveWithTag(tag: whichLiveClassPageIndexGloba)
                
                    self.topCategoryTopCollView.reloadData()
                    
                    
                    //MARK: For App Instruction Pop-Up
                    
                    if !UserDefaults.standard.bool(forKey: "isInstructionOnLiveClassFirstTimeKey") {
                        
                        UserDefaults.standard.setValue(true, forKey: "isInstructionOnLiveClassFirstTimeKey")
                        showCustomInstructionBox(imageJson: self.mainDataJson["InstructionImages"])
                                    
                    }
                       

                }
            }
     }
    
    
    
     //MARK: NODATA CHECK:-
     func checkForNoData() {
    
        if self.dataJson.count == 0 {
            self.noDataView.isHidden = false
            self.collView.isHidden = true
        } else {
            self.noDataView.isHidden = true
            self.collView.isHidden = false
        }
    }
    
    

    //MARK: UI & View SETUP
    func setUpViews() {
        
       
        
        
        //back button
        self.backButton.imageView?.transform =  L102Language.isCurrentLanguageArabic() ? CGAffineTransform(scaleX: -1.0, y: 1.0) : CGAffineTransform(scaleX: 1.0, y: -1.0)
        
        //...
        self.reserveNowButton.setTitle("reserve_now".localized(), for: .normal)
        
        
        self.activeButton.setTitle("active_classes".localized(), for: .normal)
        self.reservedButton.setTitle("reserved_classes".localized(), for: .normal)
        
        
        
    }
    
    
    
    
    
    
    //MARK: Register Cells
    func registerCells() {
        
        let nibName = UINib(nibName: "LiveClassHeaderCell", bundle:nil)
        self.collView.register(nibName, forCellWithReuseIdentifier: "liveClassHeaderCell")
        
        let nibName2 = UINib(nibName: "ActiveClassCollCell", bundle:nil)
        self.collView.register(nibName2, forCellWithReuseIdentifier: "activeClassCollCell")
    
        
        //Top Category CollView
        let catNib = UINib(nibName: "CategoryCollCell", bundle:nil)
        self.topCategoryTopCollView.register(catNib, forCellWithReuseIdentifier: "categoryCollCell")
        
    }
    

}




//MARK:================================================
//MARK: CollectionView
//MARK:================================================

extension LiveClassViewController: UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, ActiveClassCollCellDelegate {
 
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
        //if collectionView == topCategoryTopCollView && whichLiveClassPageIndexGloba == 1 {
           // return self.mainDataJson["LiveclassCategorys"].count
        //}
        
        return self.dataJson.count + 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        if collectionView == topCategoryTopCollView {
            
            let cell = self.topCategoryTopCollView.dequeueReusableCell(withReuseIdentifier: "categoryCollCell", for: indexPath) as? CategoryCollCell
            
            cell?.categoryNameLabel.text = L102Language.isCurrentLanguageArabic() ? self.mainDataJson["LiveclassCategorys"][indexPath.row]["CategoryNameAr"].stringValue : self.mainDataJson["LiveclassCategorys"][indexPath.row]["CategoryNameEn"].stringValue
            
            
            cell?.bottomLineLabel.backgroundColor = .clear
            cell?.categoryNameLabel.textColor = Colors.APP_TEXT_BLACK
            
            cell?.liveClassCategorySelected(isCellSelected: selectedTopCategoryIndex == indexPath.row ? true : false)
          
            
            return cell ?? UICollectionViewCell()
        
            
            
        } else {
        
        if indexPath.row == 0 {
    
        let cell = self.collView.dequeueReusableCell(withReuseIdentifier: "liveClassHeaderCell", for: indexPath) as? LiveClassHeaderCell
            
        cell?.tapCellButton.addTarget(self, action: #selector(startButtonAction), for: .touchUpInside)
      
        cell?.dataJson = self.advBannerDataJson
        //cell.delegateObj = self
        cell?.reloadCellUI()
        //cell?.backgroundColor = .lightGray
         
        return cell ?? UICollectionViewCell()
            
        } else {
           
            let cell = self.collView.dequeueReusableCell(withReuseIdentifier: "activeClassCollCell", for: indexPath) as? ActiveClassCollCell
             
            let index = indexPath.row - 1
            
            cell?.closeOpenButton.tag = index
            cell?.closeOpenButton.addTarget(self, action: #selector(closeOrOpenAction), for: .touchUpInside)
            
            cell?.configureCellWithData(data: self.dataJson[index])
        
            /*if whichLiveClassPageIndexGloba == 1 { //Active Classes
                
                let hideOrNot = self.dataJson[index]["HideAddToCart"].boolValue
                
                cell?.addToCartButton.isHidden = hideOrNot
                cell?.actualPriceLbl.isHidden = hideOrNot
            
                cell?.downloadButton.isSelected = true
                
           } else { //Reserved Classes
               
               cell?.addToCartButton.isHidden = true
               cell?.actualPriceLbl.isHidden = true
               cell?.downloadButton.isSelected = false
                
            }
            */
            
            cell?.closseOnlyIconButton.isSelected = self.dataJson[index]["isExpanded"].boolValue
            
            cell?.moreButton.isSelected = self.dataJson[index]["hasMoreButton"].boolValue
            
            cell?.delegateObj = self
         
            cell?.downloadButton.tag = index
            cell?.downloadButton.addTarget(self, action: #selector(downloadButtonAction), for: .touchUpInside)
            
            
            let checkPdf = self.dataJson[index]["FilePath"].stringValue
            //verifyUrl(urlString: self.dataJson[index]["FilePath"].stringValue)
            
            cell?.downloadButton.isHidden = checkPdf.isEmpty ? true : false
            
           
            cell?.addToCartButton.tag = index
            cell?.addToCartButton.addTarget(self, action: #selector(addToCartButtonAction), for: .touchUpInside)
        
            cell?.moreButton.tag = index
            cell?.moreButton.addTarget(self, action: #selector(moreButtonAction), for: .touchUpInside)
        
            return cell ?? UICollectionViewCell()
          }
        
        }
     
    }
    
    
    @objc func moreButtonAction(sender: UIButton) {
        
        if self.dataJson[sender.tag]["hasMoreButton"].boolValue == false {
            self.dataJson[sender.tag]["hasMoreButton"].boolValue = true
            self.collView.reloadData()
        } else {
            self.dataJson[sender.tag]["hasMoreButton"].boolValue = false
            self.collView.reloadData()
        }
        
    }
    
    
    @objc func downloadButtonAction(sender: UIButton) {
        
        if let vc = DocumentViewController.instantiate(fromAppStoryboard: .main) {
          vc.modalPresentationStyle = .fullScreen
          //vc.isCommingFromQuizzWithPdf = isBooks
          vc.pdfString = self.dataJson[sender.tag]["FilePath"].stringValue
          self.present(vc, animated: true, completion: nil)
        }
        
    }
     
    
    //0
    //=================================================
    //MARK: ADD TO CART ACTION
    //=================================================
    
    @objc func addToCartButtonAction(sender: UIButton) {
        
        // IAP 6
        let subscriptionMsg = L102Language.isCurrentLanguageArabic() ? self.dataJson[sender.tag]["SubcribeMessageAr"].stringValue : self.dataJson[sender.tag]["SubcribeMessageEn"].stringValue
        
        globalProductIdStrIAP = self.dataJson[sender.tag]["AppleProductID"].stringValue
        globalSubjectPriceIdIAP = self.dataJson[sender.tag]["SubjectPriceID"].intValue
        globalIsPrivateClassTypeIAP = false
        globalResumePaymentMsgIAP = subscriptionMsg

        //showCustomInAppPurchaseBox(title: subscriptionMsg, subTitle: "", buttonType: "buy_now", imageName: "addToCartSuccess", textColor: UIColor.black)
        
        self.paymentPopUpVieww.setUpView(withHtmlText: subscriptionMsg)
         self.paymentPopUpVieww.isHidden = false
         self.paymentPopUpVieww.delegateObj = self
              
        
        //self.dataJson[sender.tag]["HideAddToCart"].boolValue = true
        
        //Update View with calling API
        //self.getLiveClassData()
        
    }
    
    
    
    @objc func closeOrOpenAction(sender: UIButton) {
        
        print("closeOrOpenAction")
        
        if self.dataJson[sender.tag]["isExpanded"].boolValue == false {
            self.dataJson[sender.tag]["isExpanded"].boolValue = true
            self.collView.reloadData()
        } else {
            self.dataJson[sender.tag]["isExpanded"].boolValue = false
            self.collView.reloadData()
        }
        
    }
    
    
    @objc func startButtonAction(sender: UIButton) {
        
        self.tabBarController?.selectedIndex = 3
        
    }
    
    
    
    
    
    //MARK: Join Button API...
    func didTapOnJoinButton(model : JSON) {
          
        
          let urlString = studentJoined
               let params = ["SessionToken" : sessionTokenGlobal ?? "",
                             "StudentID" : studentIdGlobal ?? 0,
                             "LiveClassDetailID" : model["LiveClassDetailID"].intValue] as [String : Any]
               
          ServiceManager().postRequest(urlString, loader: true, parameters: params) { (status, jsonResponse) in
                    
            if status {
                
                //Zoom SDK : 5
                ZoomGlobalMeetingClass.object.isFromLiveClass = true
                ZoomGlobalMeetingClass.object.liveClassIdObj = model["LiveClassDetailID"].intValue
                ZoomGlobalMeetingClass.object.joinMeetingWithData(model: model)
                 
            }
          }
        
    }
    

    

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        print("Count is------>", self.mainDataJson["LiveclassCategorys"].count)
        
        if collectionView == topCategoryTopCollView {
            
            if self.mainDataJson["LiveclassCategorys"].count > 0 {
                
                if self.mainDataJson["LiveclassCategorys"].count <= 3 {
                    return CGSize(width: (Int(self.topCategoryTopCollView.frame.width) / self.mainDataJson["LiveclassCategorys"].count) - 12, height: 36)
                }
                return CGSize(width: self.topCategoryTopCollView.frame.width / 3.5, height: 36)
                
            } else {
               
                return CGSize(width: 0, height: 36)
            
            }
            
        
    
        } else {
            
            if indexPath.row == 0 {
                
                
                /*
                 if AppShared.object. {
                 
                 return CGSize(width: self.collView.frame.width - 32, height: 75)
                 
                 } else {
                 
                 let witdh = self.collView.frame.width - 32
                 var height = CGFloat(85)
                 
                 if self.advBannerDataJson.count > 0 {
                 let heightValue = (self.collView.frame.width / 344) * 79
                 height = height + heightValue + 0
                 } else {
                 height = height - 20
                 }
                 
                 return CGSize(width: witdh, height: height)
                 */
                
                
                
                    let witdhValue = self.collView.frame.width - 32
                    var heightValue = (self.collView.frame.width / 344) * 79
                    
                    if self.advBannerDataJson.count > 0 {
                        heightValue = heightValue + 10
                    } else {
                        heightValue = 0
                    }
                    
                    return CGSize(width: witdhValue, height: heightValue)
                    
                
                
                
                
            } else {
            
            let index = indexPath.row - 1
            
            let rowCount = self.dataJson[index]["hasMoreButton"].boolValue ? self.dataJson[index]["SubList"].count : self.dataJson[index]["SubList"].count > 3 ? 3 : self.dataJson[index]["SubList"].count
            
            if self.dataJson[index]["isExpanded"].boolValue == false {
                
               return CGSize(width: self.collView.frame.width - 32, height: UIDevice.isPad ? 130 : 100)
                
            } else {
            
            let witdhValue = self.collView.frame.width - 32
            let heightValue = CGFloat((UIDevice.isPad ? 130 : 100) + (60 * rowCount))
            
            print("\n\n\n Cell Total Value----> \(heightValue), and Count are \(rowCount)\n\n\n")
                
            return CGSize(width: witdhValue, height: heightValue)
                
            }
           }
        
        }
    }
    
    

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        if collectionView == topCategoryTopCollView {
         return 0
        }
        
        return 0
        
    }
      
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
          
        if collectionView == topCategoryTopCollView {
         return 0
        }
        
        return 10
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
     
        if collectionView == topCategoryTopCollView {
            
            self.selectedTopCategoryIndex = indexPath.row
            
            //self.whiceButtonActiveWithTag(tag: whichLiveClassPageIndexGloba)
        
            self.topCategoryTopCollView.reloadData()
        }
        
        
    }
    
    
   
    
    
    
}




 func verifyUrl (urlString: String?) -> Bool {
    if let urlString = urlString {
        if let url = NSURL(string: urlString) {
            return UIApplication.shared.canOpenURL(url as URL)
        }
    }
    return false
}





//MARK:================================================
//MARK: Payment Pop Deletegate
//MARK:================================================


extension LiveClassViewController: PaymentPopUpDelegate {
    func crossButtonClick() {
        self.paymentPopUpVieww.isHidden = true
    }

}
