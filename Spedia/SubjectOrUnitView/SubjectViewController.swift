//
//  SubjectViewController.swift
//  Spedia
//
//  Created by Viraj Sharma on 09/06/2020.
//  Copyright © 2020 Viraj Sharma. All rights reserved.
//

import UIKit
import SwiftyJSON
import Kingfisher
import SVProgressHUD

class SubjectViewController: UIViewController {

    @IBOutlet weak var subjectImageView: UIImageView!
    @IBOutlet weak var subjectTitleLbl: CustomLabel!
    @IBOutlet weak var subjectBkgImageView: UIImageView!
    @IBOutlet weak var addToCartButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var collView: UICollectionView!
    @IBOutlet weak var noDataLbl: UILabel!
    
    @IBOutlet weak var acutalPrice: CustomLabel!
    
    @IBOutlet weak var paymentPopUpVieww: PaymentPopUp!

    
    var selectedModel = JSON()
    var dataJson = JSON()
    var mainJson = JSON()
    
    var isExpandedSubUnit = false
    var expandingIndex = 0
    
    
    //MARK: TOP CATEGORY SELECTION View
    @IBOutlet weak var topCategoryTopCollView: UICollectionView!
    var selectedTopCategoryIndex = 0
    @IBOutlet weak var topCategoryCollViewHeight: NSLayoutConstraint!
    
    
    
    //MARK: Short Cut CollView
    @IBOutlet weak var shortcutCollView: UICollectionView!
    var selectedShortcutIndex = 0
    @IBOutlet weak var shortcutCollViewHeight: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    
        //Top Category CollView
        let catNib = UINib(nibName: "CategoryCollCell", bundle:nil)
        self.topCategoryTopCollView.register(catNib, forCellWithReuseIdentifier: "categoryCollCell")
        
        //shortcut Cell
        let shortcutNib = UINib(nibName: "ShortcutCollCell", bundle:nil)
        self.shortcutCollView.register(shortcutNib, forCellWithReuseIdentifier: "shortcutCollCell")
        

        let nibName = UINib(nibName: "SubUnitCollCell", bundle:nil)
        self.collView.register(nibName, forCellWithReuseIdentifier: "subUnitCollCell")
        
        //ExpandedCollCell
        let nibName2 = UINib(nibName: "ExpandedCollCell", bundle:nil)
        self.collView.register(nibName2, forCellWithReuseIdentifier: "expandedCollCell")
        
        
        self.shortcutCollView.semanticContentAttribute = L102Language.isCurrentLanguageArabic() ? .forceRightToLeft : .forceLeftToRight
        
        
        self.addToCartButton.isHidden = true
        self.acutalPrice.isHidden = true
        
        self.paymentPopUpVieww.isHidden = true
            
        
        self.setUpView()
        self.getData()
    }


    @IBAction func backButtonAction(_ sender: Any) {
        //self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }

    
    
    
    //=================================================
    //MARK: ADD TO CART ACTION
    //=================================================
    
    @IBAction func addToCartAction(_ sender: Any) {
        
        //self.addToCartButton.isHidden = true
        //self.acutalPrice.isHidden = true
        
        // IAP 6
        let subscriptionMsg = L102Language.isCurrentLanguageArabic() ? self.selectedModel["SubcribeMessageAr"].stringValue : self.selectedModel["SubcribeMessageEn"].stringValue
        
        globalProductIdStrIAP = self.selectedModel["AppleProductID"].stringValue
        globalSubjectPriceIdIAP = self.selectedModel["SubjectPriceID"].intValue
        globalIsPrivateClassTypeIAP = false
        globalResumePaymentMsgIAP = subscriptionMsg
        
        //showCustomInAppPurchaseBox(title: subscriptionMsg, subTitle: "", buttonType: "subscribe_now", imageName: "addToCartSuccess", textColor: UIColor.black)
        
        
        self.paymentPopUpVieww.setUpView(withHtmlText: subscriptionMsg)
        self.paymentPopUpVieww.isHidden = false
        self.paymentPopUpVieww.delegateObj = self
        
    }

    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        //self.tabBarController?.tabBar.isHidden = false
        //self.hidesBottomBarWhenPushed = false
        
        print("Expanded------> \(expandingIndex),  \(isExpandedSubUnit) ")
    }
    
    
    func setUpView() {
        //1
        let titleStr = L102Language.isCurrentLanguageArabic() ? self.selectedModel[SubjectsKey.SubjectNameAr].stringValue : self.selectedModel[SubjectsKey.SubjectNameEn].stringValue

        self.subjectTitleLbl.text = titleStr
        
        
        //2
        let url = URL(string: self.selectedModel[SubjectsKey.IconPath].stringValue)
        self.subjectImageView.kf.setImage(with: url)
    
        self.subjectImageView.isHidden = self.subjectImageView.image == nil ? true : false
        
        
        
        //3
        self.backButton.imageView?.transform =  L102Language.isCurrentLanguageArabic() ? CGAffineTransform(scaleX: -1.0, y: 1.0) : CGAffineTransform(scaleX: 1.0, y: -1.0)
        
        //4
        //let buttonText = L102Language.isCurrentLanguageArabic() ? "أضف للسلة" : "ADD TO CART"
        //self.addToCartButton.setTitle(buttonText, for: .normal)
         
        
        
        //1 Get Values...
        let actualPriceStr = self.selectedModel["ActualPriceText"].stringValue
        self.acutalPrice.text = actualPriceStr
        
        
        
    }
    

    func getData() {
        
        let urlString = getUnits
        let params = ["SessionToken" : sessionTokenGlobal ?? "",
                      "SubjectID" : self.selectedModel[SubjectsKey.SubjectID].intValue,
                      "StudentID" : studentIdGlobal ?? 0,
                      "ClassID" : classIdGlobal ?? 0] as [String : Any]
        
    
        ServiceManager().postRequest(urlString, loader: true, parameters: params) { (status, jsonResponse) in
             
            if status {
                
                let dataRes = JSON.init(jsonResponse ?? "NO DTA")
                
                self.mainJson = dataRes
                
                self.dataJson = self.mainJson["Categorys"][self.selectedTopCategoryIndex]["\(UnitDetailKey.UnitsArray)"]
                
                //ShortCuts
                
                
                self.collView.reloadData()
                
                self.topCategoryTopCollView.reloadData()
                
                self.shortcutCollView.reloadData()
                
                let hideOrNot = self.mainJson["HideAddToCart"].boolValue
                
                self.addToCartButton.isHidden = hideOrNot
                self.acutalPrice.isHidden = hideOrNot
                
                //dataRes[UnitDetailKey.HideAddToCart].boolValue
                
                //if self.dataJson[UnitDetailKey.UnitsArray].count == 0 {
                    //self.collView.isHidden = true
                    //self.noDataLbl.text = "no_data_found".localized()
                //} else {
                    //self.noDataLbl.text = ""
                //}
                
                
            
                //MARK: For App Instruction Pop-Up
                
                if !UserDefaults.standard.bool(forKey: "isInstructionOnSubjectFirstTimeKey") {
                    
                    UserDefaults.standard.setValue(true, forKey: "isInstructionOnSubjectFirstTimeKey")
                    showCustomInstructionBox(imageJson: self.mainJson["InstructionImages"])
                                
                }
                 
            }
        }
        
        
    }
    
    
    

}



//MARK:================================================
//MARK: CollectionView (Custom TabBar View)
//MARK:================================================


extension SubjectViewController: UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, ExpandedCollCellDelegate, VideoViewControllerDelegate {
 
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == topCategoryTopCollView {
            return self.mainJson["Categorys"].count
        }
        
        if collectionView == shortcutCollView {
            return self.mainJson["ShortCuts"].count
        }
        
        return self.dataJson.count //+1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == shortcutCollView {
        
            let cell = self.shortcutCollView.dequeueReusableCell(withReuseIdentifier: "shortcutCollCell", for: indexPath) as? ShortcutCollCell
        
            cell?.configureCellData(data: self.mainJson["ShortCuts"][indexPath.row])
             
            cell?.showAllButton.tag = indexPath.row
            cell?.showAllButton.addTarget(self, action: #selector(showAllButtonAction(sender:)), for: .touchUpInside)
             
            return cell ?? UICollectionViewCell()
        
        }
        
        else if collectionView == topCategoryTopCollView {
            
            let cell = self.topCategoryTopCollView.dequeueReusableCell(withReuseIdentifier: "categoryCollCell", for: indexPath) as? CategoryCollCell
            
            cell?.categoryNameLabel.text = L102Language.isCurrentLanguageArabic() ? self.mainJson["Categorys"][indexPath.row]["CategoryNameAr"].stringValue : self.mainJson["Categorys"][indexPath.row]["CategoryNameEn"].stringValue
            
            cell?.setUPForSubjectView()
            
            cell?.bottomLineLabel.backgroundColor = .clear
            cell?.categoryNameLabel.textColor = Colors.APP_TEXT_BLACK
            
            if selectedTopCategoryIndex == indexPath.row {
                cell?.categoryNameLabel.textColor = Colors.APP_LIGHT_GREEN
                cell?.bottomLineLabel.backgroundColor = Colors.APP_LIGHT_GREEN
            }
            
            
            
            if self.mainJson["Categorys"].count <= 1 {
                topCategoryCollViewHeight.constant = 0.0
            }
            
            
            return cell ?? UICollectionViewCell()
        
        } else {
        
        if indexPath.row == expandingIndex && isExpandedSubUnit { //ExpandedCollCell
           
           let cell = self.collView.dequeueReusableCell(withReuseIdentifier: "expandedCollCell", for: indexPath) as? ExpandedCollCell

           //cell?.containerView.backgroundColor = Colors.Cell_Bkg_Blue
           //cell?.containerView.layer.cornerRadius = 20
           //cell?.backgroundColor = UIColor.cyan
           
           cell?.delegateObj = self
           cell?.arrowButton.addTarget(self, action: #selector(collapsButtonsAction(sender:)), for: .touchUpInside)
            
           cell?.configureCellWithData(data: self.dataJson[indexPath.row]) //-1
        
           return cell ?? UICollectionViewCell()
        
        } else {
           
            let cell = self.collView.dequeueReusableCell(withReuseIdentifier: "subUnitCollCell", for: indexPath) as? SubUnitCollCell

            //cell?.containerView.backgroundColor = Colors.Cell_Bkg_Blue
            //cell?.containerView.layer.cornerRadius = 20
            //cell?.backgroundColor = UIColor.cyan
            
            cell?.expandDownButton.tag = indexPath.row //- 1 //Down Animation
            cell?.expandDownButton.addTarget(self, action: #selector(expondButtonsAction(sender:)), for: .touchUpInside)
                    
            cell?.configureCellWithData(data: self.dataJson[indexPath.row]) //-1
            
            return cell ?? UICollectionViewCell()
          }
        
        } // ELSE ENDED.....
    
    }
    
    
    func didTapOnExpandedCell (model : JSON) {
        
        print("didTapOnExpandedCell ====> \(model)")
        
        print("Selected Model ====> \(self.selectedModel)")
        
        
        
        if let vc = VideoViewController.instantiate(fromAppStoryboard: .main) {
           vc.modalPresentationStyle = .fullScreen
           vc.subjectId = self.selectedModel[SubjectsKey.SubjectID].intValue
           //vc.subjectPriceId = self.selectedModel[SubjectsKey.SubjectPriceID].intValue
           vc.unitId = model["SubUnitID"].intValue
           //vc.videoURL = model["VideoPathWithoutMediaPlayer"].stringValue
           vc.delegateObj = self
           vc.hidesBottomBarWhenPushed = true
           self.navigationController?.pushViewController(vc, animated: true)
           
        }
        
    }
    
    
    func didAddToCartTapped() { //ADD TO CART HIT ON VIDEO PAGE
        //self.addToCartButton.isHidden = true
       // self.acutalPrice.isHidden = true
    }
    
    
    @objc func expondButtonsAction(sender: UIButton) {
        
        print("expondButtonsAction")
        
        self.isExpandedSubUnit = true
        self.expandingIndex = 0 //0 is can't use header cell calling //sender.tag
        let seletedData = self.dataJson[sender.tag]
        self.dataJson.arrayObject?.remove(at: sender.tag)
        self.dataJson.arrayObject?.insert(seletedData, at: 0)
        self.collView.reloadData()
        
        self.collView.setContentOffset(.zero, animated: true)
        
        //self.collView?.scrollToItem(at: IndexPath(row: 0, section: 0),
          //                                at: .top,
            //                        animated: true)
    }
    
    
    @objc func collapsButtonsAction(sender: UIButton) {
        self.isExpandedSubUnit = false
        self.expandingIndex = sender.tag
        self.collView.reloadData()
    }
    
    

    @objc func showAllButtonAction(sender: UIButton) {
        
        print("showAllButtonAction ====> \(sender.tag)")
        
        let type = self.mainJson["ShortCuts"][sender.tag]["Type"].stringValue
        
        if type.contains("book") {
            if let vc = BooksAndTestViewController.instantiate(fromAppStoryboard: .main) {
                vc.modalPresentationStyle = .fullScreen
                vc.isBooks = true
                vc.subjectID = self.selectedModel[SubjectsKey.SubjectID].intValue
                self.present(vc, animated: true, completion: nil)
            }
        }
        
        else if type.contains("previoustest") {
            if let vc = BooksAndTestViewController.instantiate(fromAppStoryboard: .main) {
                vc.modalPresentationStyle = .fullScreen
                vc.isBooks = false
                vc.subjectID = self.selectedModel[SubjectsKey.SubjectID].intValue
                self.present(vc, animated: true, completion: nil)
            }
        }
        
        else  {
            SVProgressHUD.showInfo(withStatus: "coming_soon".localized())
        }
        
        
        
    }
    
    

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == shortcutCollView {
            
            var count = 1.0
            var spaceBtw = CGFloat(UIDevice.isPad ? 70 : 48)
            
            if self.mainJson["ShortCuts"].count == 1 {
                
                count = 1.0
                spaceBtw = CGFloat(UIDevice.isPad ? 70 : 32)
                
            } else if self.mainJson["ShortCuts"].count == 2 {
               
                count = 2.0
                
            } else if self.mainJson["ShortCuts"].count >= 3 {
                
                count = UIDevice.isPad ? 3 : 2.2
           
            }
            
            
            
            let gridPart = CGFloat(count)
            
            var witdh = self.shortcutCollView.frame.width - spaceBtw
            witdh = witdh / gridPart
            
            return CGSize(width: witdh, height: 165)
            //CGSize(width: self.collView.frame.width - 32, height: 270)
        }
        
        else if collectionView == topCategoryTopCollView {
            
            
            if self.mainJson["Categorys"].count > 0 {
                return CGSize(width: Int(self.topCategoryTopCollView.frame.width) / self.mainJson["Categorys"].count, height: 50)
            } else {
                return CGSize(width: DeviceSize.screenWidth, height: 0)
            }
            
            
        
        } else {
        
          if indexPath.row == expandingIndex && isExpandedSubUnit {
            
          let spaceBtw = CGFloat(UIDevice.isPad ? 40 : 32)
          let witdh = self.collView.frame.width - spaceBtw
          
          let count = self.dataJson[indexPath.row]["SubUnits"].count //-1
          let height = CGFloat(65 * count)
            
          return CGSize(width: witdh, height: height + 143)
            
        } else {
          
          let gridPart = CGFloat(UIDevice.isPad ? 3 : 2)
          let spaceBtw = CGFloat(UIDevice.isPad ? 80 : 52)
          
          var witdh = self.collView.frame.width - spaceBtw
          witdh = witdh / gridPart
          let height = round(witdh / 0.8)
          
          return CGSize(width: witdh, height: height)
        
          }
       }
        
    }
    
    
    
 
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        if collectionView == topCategoryTopCollView {
         return 0
        }
    
        if collectionView == shortcutCollView {
            return 0
        }
        
        return 20
        
    }
      
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
         
        if collectionView == topCategoryTopCollView {
         return 0
        }
        
        if collectionView == shortcutCollView {
            return UIDevice.isPad ? 28 : 16
        }
        
        return 20
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
     
        if collectionView == topCategoryTopCollView {
            
            self.selectedTopCategoryIndex = indexPath.row
            self.dataJson = self.mainJson["Categorys"][self.selectedTopCategoryIndex]["\(UnitDetailKey.UnitsArray)"]
            
            self.collView.reloadData()
            
            self.topCategoryTopCollView.reloadData()
        }
        
        
    }
    
    
}



//MARK:================================================
//MARK: Payment Pop Deletegate
//MARK:================================================


extension SubjectViewController: PaymentPopUpDelegate {
    func crossButtonClick() {
        self.paymentPopUpVieww.isHidden = true
    }

}
