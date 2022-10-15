//
//  UniversityUnitViewController.swift
//  Spedia
//
//  Created by Viraj Sharma on 21/06/2021.
//  Copyright © 2021 Viraj Sharma. All rights reserved.
//

import UIKit
import SwiftyJSON
import Kingfisher
import SVProgressHUD

class UniversityUnitViewController: UIViewController {

    @IBOutlet weak var subjectTitleLbl: CustomLabel!
    @IBOutlet weak var subjectTitleSubLbl: CustomLabel!
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
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    
        let nibName = UINib(nibName: "UniversityUnitCollCell", bundle:nil)
        self.collView.register(nibName, forCellWithReuseIdentifier: "universityUnitCollCell")
        
        //ExpandedCollCell
        let nibName2 = UINib(nibName: "ExpandedCollCell", bundle:nil)
        self.collView.register(nibName2, forCellWithReuseIdentifier: "expandedCollCell")
        
        
        self.addToCartButton.isHidden = true
        self.acutalPrice.isHidden = true
        
            
        
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
        
        self.addToCartWith(withId: self.selectedModel["SubjectPriceID"].intValue, withAppleProductId: self.selectedModel["AppleProductID"].stringValue)
   }

    
    func addToCartWith(withId : Int, withAppleProductId : String) {
        
        self.addToCartButton.isHidden = true
        self.acutalPrice.isHidden = true
        
        // IAP 6
        let subscriptionMsg = L102Language.isCurrentLanguageArabic() ? self.selectedModel["SubcribeMessageAr"].stringValue : self.selectedModel["SubcribeMessageEn"].stringValue
        
        globalProductIdStrIAP = withAppleProductId
        globalSubjectPriceIdIAP = withId
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
        
        
        //1.1
        let subTitle = self.selectedModel["SubTitle" + Lang.code()].stringValue
        self.subjectTitleSubLbl.text = subTitle
        
        
        
        //2
        self.backButton.imageView?.transform =  L102Language.isCurrentLanguageArabic() ? CGAffineTransform(scaleX: -1.0, y: 1.0) : CGAffineTransform(scaleX: 1.0, y: -1.0)
        
        //4
        //let buttonText = L102Language.isCurrentLanguageArabic() ? "أضف للسلة" : "ADD TO CART"
        //self.addToCartButton.setTitle(buttonText, for: .normal)
         
        
        //1 Get Values...
        
        let actualPriceStr = self.selectedModel["ActualPriceText"].stringValue
        
        self.acutalPrice.text = actualPriceStr
        
        
    }
    

    func getData() {
        
        //{"SessionToken":"{{token}}","SubjectID":130,"StudentID":1,"ClassID":33}
        
        let urlString = getUniversityUnits
        let params = ["SessionToken" : sessionTokenGlobal ?? "",
                      "SubjectID" : self.selectedModel[SubjectsKey.SubjectID].intValue,
                      "StudentID" : studentIdGlobal ?? "",
                      "ClassID" : classIdGlobal ?? 0,
                      "DeviceType": DeviceType.iPhone] as [String : Any]
        
        ServiceManager().postRequest(urlString, loader: true, parameters: params) { (status, jsonResponse) in
             
            if status {
                
                let dataRes = JSON.init(jsonResponse ?? "NO DTA")
                
                self.mainJson = dataRes
                
                self.dataJson = dataRes["Units"]
                
                //self.mainJson["Categorys"][self.selectedTopCategoryIndex]["\(UnitDetailKey.UnitsArray)"]
                
                
                self.collView.reloadData()
                
                let hideOrNot = self.mainJson["HideAddToCart"].boolValue
                
                self.addToCartButton.isHidden = hideOrNot
                self.acutalPrice.isHidden = hideOrNot
                
                
                
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


extension UniversityUnitViewController: UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, ExpandedCollCellDelegate, VideoViewControllerDelegate {
 
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
        return self.dataJson.count //+1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
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
           
            let cell = self.collView.dequeueReusableCell(withReuseIdentifier: "universityUnitCollCell", for: indexPath) as? UniversityUnitCollCell

            //cell?.containerView.backgroundColor = Colors.Cell_Bkg_Blue
            //cell?.containerView.layer.cornerRadius = 20
            //cell?.backgroundColor = UIColor.cyan
            
            cell?.expandDownButton.tag = indexPath.row //- 1 //Down Animation
            cell?.expandDownButton.addTarget(self, action: #selector(expondButtonsAction(sender:)), for: .touchUpInside)
               
            
            //cell?.addToCartButton.tag = indexPath.row
            //cell?.addToCartButton.addTarget(self, action: #selector(addToCartButtonAction(sender:)), for: .touchUpInside)
            
            
            cell?.configureCellWithData(data: self.dataJson[indexPath.row]) //-1
            
            return cell ?? UICollectionViewCell()
          
        } // ELSE ENDED.....
    
    }
    
    
    func didTapOnExpandedCell (model : JSON) {
        
        print("University Unit Selected For Video Open ====> \(model)")
        
        
        /*if let vc = VideoViewController.instantiate(fromAppStoryboard: .main) {
           vc.modalPresentationStyle = .fullScreen
           vc.subjectId = selectedModel["SubjectID"].intValue
           vc.subjectPriceId = selectedModel["SubjectPriceID"].intValue
           vc.unitId = model["SubUnitID"].intValue
           vc.whereFromAmI = WhereFromAmIKeys.bookmark
           vc.hidesBottomBarWhenPushed = true
           //self.navigationController?.pushViewController(vc, animated: true)
           self.present(vc, animated: true, completion: nil)
        }*/
        
        if let vc = VideoViewController.instantiate(fromAppStoryboard: .main) {
           vc.modalPresentationStyle = .fullScreen
           vc.subjectId = self.selectedModel["SubjectID"].intValue
           //vc.subjectPriceId = self.selectedModel["SubjectPriceID"].intValue
           vc.unitId = model["SubUnitID"].intValue
           vc.delegateObj = self
           vc.hidesBottomBarWhenPushed = false
           self.navigationController?.pushViewController(vc, animated: true)
        }

    }
    
    
    func didAddToCartTapped() { //ADD TO CART HIT ON VIDEO PAGE
        //self.addToCartButton.isHidden = true
        //self.acutalPrice.isHidden = true
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
    
    

    //=================================================
    //MARK: ADD TO CART ACTION
    //=================================================
    
    @objc func addToCartButtonAction(sender: UIButton) {
        
        let id = self.dataJson[sender.tag]["SubjectPriceID"].intValue
        let appleId = self.dataJson[sender.tag]["AppleProductID"].stringValue
        
        //self.dataJson[sender.tag]["HideAddToCart"].boolValue = true
        
        self.collView.reloadData()
        
        self.addToCartWith(withId: id, withAppleProductId: appleId)

     }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
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
    
    
    
 
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 20
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
         
       return 20
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
    }
    
    
}




//MARK:================================================
//MARK: Payment Pop Deletegate
//MARK:================================================


extension UniversityUnitViewController: PaymentPopUpDelegate {
    func crossButtonClick() {
        self.paymentPopUpVieww.isHidden = true
    }

}
