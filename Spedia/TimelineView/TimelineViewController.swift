//
//  TimelineViewController.swift
//  YachtZap
//
//  Created by Viraj Sharma on 22/12/2020.
//  Copyright © 2020 Rahul Goku. All rights reserved.
//

import UIKit
import SwiftyJSON

class TimelineViewController: UIViewController {

    //1 Outlets.......
    @IBOutlet weak var datesContainerView: UIView!
    @IBOutlet weak var datesCollView: UICollectionView!
    @IBOutlet weak var collView: UICollectionView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var headerTitleLbl: CustomLabel!
    @IBOutlet weak var headerSubTitleLbl: CustomLabel!
    
    //MARK: NoData Customer Support View
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var noSupportDataView: NoDataCustomerSupportView!
    
    
    //2 Data.........
    var mainJson = JSON()
    var dataJson = JSON()
    var daysJson = JSON()
    
    
    //1
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nibName = UINib(nibName: "TimeCollCell", bundle:nil)
        self.collView.register(nibName, forCellWithReuseIdentifier: "timeCollCell")
        
        let dateNibName = UINib(nibName: "TimelineDateCollView", bundle:nil)
        self.datesCollView.register(dateNibName, forCellWithReuseIdentifier: "timelineDateCollView")
        
        self.datesCollView.delegate = self
        self.datesCollView.dataSource = self
        
        self.containerView.isHidden = true
        self.noSupportDataView.isHidden = true
        self.datesContainerView.isHidden = true
        
        AppShared.object.timelineSelectedSubjectId = 0
        AppShared.object.timelineSelectedDaysInt = 7
        AppShared.object.timelineSelectedFromDateStr = ""
        AppShared.object.timelineSelectedToDateStr = ""
        AppShared.object.timelineSelectedTypeInt = 0
        
    }
    
    
    //2
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setUpView()
        self.getTimelineDataNow()
    }
   
    
    //3
    func setUpView() {
        
        //1 timeline my_recent_activities
        self.headerTitleLbl.text = "timeline".localized()
        self.headerSubTitleLbl.text = "my_recent_activities".localized()
        
        //2
        self.backButton.imageView?.transform =  L102Language.isCurrentLanguageArabic() ? CGAffineTransform(scaleX: -1.0, y: 1.0) : CGAffineTransform(scaleX: 1.0, y: -1.0)
    
    }
    
    
    
    @IBAction func backButtonAction(_ sender: Any) {
       //self.dismiss(animated: true, completion: nil)
       self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func applyFilterButtonAction(_ sender: Any) {
        
        if let vc = FilterTimelineViewController.instantiate(fromAppStoryboard: .main) {
            vc.modalPresentationStyle = .fullScreen
            vc.dataJson = self.mainJson
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    
    //4 Call API.....
    
    func getTimelineDataNow() {
        
        let urlString = getTimeline
        
        let params = ["SessionToken" : sessionTokenGlobal ?? "",
                      "StudentID" : studentIdGlobal ?? 0,
                      "ClassID": classIdGlobal ?? 0,
                      "SubjectID": AppShared.object.timelineSelectedSubjectId,
                      "Days": AppShared.object.timelineSelectedDaysInt,
                      "FromDate": AppShared.object.timelineSelectedFromDateStr,
                      "ToDate": AppShared.object.timelineSelectedToDateStr,
                      "Type": AppShared.object.timelineSelectedTypeInt] as [String : Any]
        
        
        ServiceManager().postRequest(urlString, loader: true, parameters: params) { (status, jsonResponse) in
             
            if status {
                
                let dataRes = JSON.init(jsonResponse ?? "NO DTA")
                
                //0
                self.mainJson = dataRes
                
                //1
                self.daysJson = dataRes["Days"]
                
                //2
                self.dataJson = dataRes
                self.dataJson = self.dataJson["TimeLine"]
                
                
                if self.dataJson.count == 0 { //no data here...
                    self.containerView.isHidden = true
                    self.noSupportDataView.isHidden = false
                    self.datesContainerView.isHidden = true
                    
                } else {
                    
                    self.containerView.isHidden = false
                    self.noSupportDataView.isHidden = true
                    self.datesContainerView.isHidden = false
                    self.collView.reloadData()
                    self.datesCollView.reloadData()
                }
                
                
            }
        }
        
    }
    
    
}







//MARK:================================================
//MARK: CollectionView (Timeline Coll View)
//MARK:================================================

extension TimelineViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == datesCollView {
            return self.daysJson.count
        } else {
          return self.dataJson.count
        }
    
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == datesCollView {
            
            let cell = self.datesCollView.dequeueReusableCell(withReuseIdentifier: "timelineDateCollView", for: indexPath) as? TimelineDateCollView

            cell?.configureCellWithData(data: self.daysJson[indexPath.row])
            
            cell?.tabButton.tag = indexPath.row
            cell?.tabButton.addTarget(self, action: #selector(didTapOnDaysCollections(sender:)), for: .touchUpInside)
            
            return cell ?? UICollectionViewCell()
        
        } else {
        
        let cell = self.collView.dequeueReusableCell(withReuseIdentifier: "timeCollCell", for: indexPath) as? TimeCollCell

        //cell?.containerView.backgroundColor = Colors.Cell_Bkg_Blue
        //cell?.containerView.layer.cornerRadius = 20
        //cell?.backgroundColor = UIColor.cyan
        
        //cell?.expandDownButton.tag = indexPath.row - 1 //Down Animation
        //cell?.expandDownButton.addTarget(self, action: #selector(expondButtonsAction(sender:)), for: .touchUpInside)
                
        cell?.configureCellWithData(data: self.dataJson[indexPath.row])
        
        return cell ?? UICollectionViewCell()
            
        }
    }
    
    
    @objc func didTapOnDaysCollections(sender: UIButton) {
        
        print("didTapOnCrossButton ====> \(sender.tag)")
    
        AppShared.object.timelineSelectedDaysInt = self.daysJson[sender.tag]["Day"].intValue
        
        self.getTimelineDataNow()
    }
        
    
    
    /*
    func didTapOnExpandedCell (model : JSON) {
        
        print("didTapOnExpandedCell ====> \(model)")
        
        if let vc = VideoViewController.instantiate(fromAppStoryboard: .main) {
           vc.modalPresentationStyle = .fullScreen
           vc.subjectId = self.selectedModel[SubjectsKey.SubjectID].intValue
           vc.subjectPriceId = self.selectedModel[SubjectsKey.SubjectPriceID].intValue
           vc.selectedModel = model
           //vc.videoURL = model["VideoPathWithoutMediaPlayer"].stringValue
           vc.hidesBottomBarWhenPushed = true
           self.navigationController?.pushViewController(vc, animated: true)
           
           //self.present(vc, animated: true, completion: nil)
           
        }
    }
    */
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == datesCollView {
            return CGSize(width: 40, height: 40)
        } else {
          return CGSize(width: self.collView.frame.width, height: 165)
        }
        
    }
    
    
    
 
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        if collectionView == datesCollView {
            return 0
        }
        return 0 //Left-Right Space
        
    }
      
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
         
        if collectionView == datesCollView {
        return 10
        }
        return 20 //Top-Bottom Space
    }
    
    
    //func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)  {
    //}
    
    
}
