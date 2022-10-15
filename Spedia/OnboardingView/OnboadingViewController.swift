//
//  OnboadingViewController.swift
//  Spedia
//
//  Created by Viraj Sharma on 03/07/2021.
//  Copyright © 2021 Viraj Sharma. All rights reserved.
//

import UIKit
import SwiftyJSON

class OnboadingViewController: UIViewController {

    //1 Outlets.......
    @IBOutlet weak var collView: UICollectionView!
    @IBOutlet weak var nextButton: CustomButton!
    @IBOutlet weak var pageController: UIPageControl!
    
    var dataJson = JSON.init()
    
    /*([
        [
          "Image" : "http://livetest.spediaapp.com//Uploads//AppIntroduction//LessonClass_7584.jpeg",
          "SubTitleAr" : "اختيار المادة و اضافتها الى سلة المشتريات تمهيدا للاشتراك",
          "TitleEn" : "اختيار المادة",
          "Type" : "Image",
          "Video" : "",
          "TitleAr" : "اختيار المادة",
          "SubTitleEn" : "اختيار المادة و اضافتها الى سلة المشتريات تمهيدا للاشتراك"
        ],
        [
          "Image" : "",
          "SubTitleAr" : "فيديوهات Spedia المسجلة عن طريق احدث الوسائل التقنية و التكنولوجية و التربوية مراعاة لأهمية ايصال المعلومات في أبسط صورة",
          "TitleEn" : "شرح المناهج",
          "Type" : "Video",
          "Video" : "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4",
          "TitleAr" : "شرح المناهج",
          "SubTitleEn" : "فيديوهات Spedia المسجلة عن طريق احدث الوسائل التقنية و التكنولوجية و التربوية مراعاة لأهمية ايصال المعلومات في أبسط صورة"
        ],
        [
          "Image" : "http://livetest.spediaapp.com:80/Uploads/AppIntroduction/LessonClass_7584.jpeg",
          "SubTitleAr" : "مع الدورات  المباشرة ستكون في أقصر طريق نحو التميز و الإبداع",
          "TitleEn" : "الدروس المباشرة",
          "Type" : "Video",
          "Video" : "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4",
          "TitleAr" : "الدروس المباشرة",
          "SubTitleEn" : "مع الدورات  المباشرة ستكون في أقصر طريق نحو التميز و الإبداع"
        ]
      ])*/
    
    
    //1
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getDataFromGeneralAPI()
        
        let nibName = UINib(nibName: "OnboardingCollCell", bundle:nil)
        self.collView.register(nibName, forCellWithReuseIdentifier: "onboardingCollCell")
        
        self.collView.delegate = self
        self.collView.dataSource = self
        
        self.pageController.transform = CGAffineTransform(scaleX: 1.5, y: 1.5);
        
        self.pageController.hidesForSinglePage = true
        
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        DispatchQueue.main.async {
        self.pageController.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
        
        if self.pageController.currentPage+1 == self.dataJson.count {
            self.nextButton.setTitle("finish".localized(), for: .normal)
        } else {
            self.nextButton.setTitle("التالي", for: .normal)
        }
        }
    }
    
    
    
    //2
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setUpView()
        AppShared.object.updateLangNow(didSetRoot: false, isStaticSetEnAr: "ar")
    }
   
    
    //3
    func setUpView() {
        
        //self.getDataFromGeneralAPI()
        
    }
    
    
    func getDataFromGeneralAPI() { //Get Method
        
        let urlString = getSpediaOnBoarding
        
        ServiceManager().getRequest(urlString, loader: true, parameters: [:]) { (status, jsonResponse) in
            
            if status {
                
                let dataRes = JSON.init(jsonResponse ?? "NO DTA")
                self.dataJson = dataRes["onboardingList"]
                
                DispatchQueue.main.async {
                    if self.dataJson.count == 0 {
                        
                        L102Language.setAppleLAnguageTo(lang: "ar")
                        UIView.appearance().semanticContentAttribute = .forceRightToLeft
                        
                        UserDefaults.standard.setValue(true, forKey: "isOnboardingFirstTimeKey")
                        setLoginAsRootView()
                    
                    } else {
                        
                        self.pageController.numberOfPages = self.dataJson.count
                        self.collView.reloadData()
                        
                    }
                    
                }
            }
            
        }
    }
    
    
    
    @IBAction func nextButtonAction(_ sender: Any) {
        DispatchQueue.main.async {
        if self.pageController.currentPage+1 == self.dataJson.count {
            
            print("END OF THE PAGE")
            
            L102Language.setAppleLAnguageTo(lang: "ar")
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
            
            UserDefaults.standard.setValue(true, forKey: "isOnboardingFirstTimeKey")
            setLoginAsRootView()
            
            
        } else {
            
            if self.dataJson.count > 0 {
                self.collView.scrollToItem(at: IndexPath.init(row: self.pageController.currentPage+1, section: 0), at: .centeredHorizontally, animated: true)
            }
            
        }
       }
        
    }
    
    
    
    func scrollToNextCell() {
        
        let contentOffset = collView.contentOffset
        
        if collView.contentSize.width <= collView.contentOffset.x + collView.frame.width {
            
            /*let r = CGRect(x: 0, y: contentOffset.y, width: collView.frame.width, height: collView.frame.height)
            collView.scrollRectToVisible(r, animated: true)*/

        } else {
    
            let r = CGRect(x: 0, y: contentOffset.y, width: collView.frame.width, height: collView.frame.height)
            collView.scrollRectToVisible(r, animated: true)
        }
        
        

    }
       
    
}





//MARK:================================================
//MARK: CollectionView (Onboading Coll View)
//MARK:================================================

extension OnboadingViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.dataJson.count
    
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = self.collView.dequeueReusableCell(withReuseIdentifier: "onboardingCollCell", for: indexPath) as? OnboardingCollCell

        let index = indexPath.row
        
        let type = self.dataJson[index]["Type"].stringValue
        
        if type == "Video" {
            cell?.configureCellForVideoWithData(data: self.dataJson[index])
            
        } else {
            cell?.configureCellForImageWithData(data: self.dataJson[index])
            
        }
        
        
        return cell ?? UICollectionViewCell()
            
    }
    
    
    //@objc func didTapOnDaysCollections(sender: UIButton) {
        
    //}
            
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: self.collView.frame.width, height: self.collView.frame.height + 0)
        
    }
    
    
    
 
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0 //Left-Right Space
        
    }
      
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
         
        return 0 //Top-Bottom Space
    }
    
    
    //func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)  {
    //}
    
    
    
    // Bare bones implementation
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
      if let cell = cell as? OnboardingCollCell {
          cell.avpController.player?.pause()
      }
    }
    
    
}

