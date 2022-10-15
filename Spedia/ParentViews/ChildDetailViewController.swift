//
//  ChildDetailViewController.swift
//  Spedia
//
//  Created by Viraj Sharma on 07/11/2020.
//  Copyright © 2020 Viraj Sharma. All rights reserved.
//

import UIKit
import SwiftyJSON

class ChildDetailViewController: UIViewController {

    //Outlets
    
    //0
    @IBOutlet weak var containerVieww: UIView!
    @IBOutlet weak var videoContainerVieww: UIView!
    @IBOutlet weak var exerciseContainerVieww: UIView!
   
    //1 Place holders
    @IBOutlet weak var completeTrainingPHLbl: CustomLabel!
    @IBOutlet weak var videoWatchedPHLbl: CustomLabel!
    @IBOutlet weak var videosPHLabel: CustomLabel!
    @IBOutlet weak var exersicePHLabel: CustomLabel!
    @IBOutlet weak var subscriotionPHLbl: CustomLabel!
    
    //2 Objects
    @IBOutlet weak var profilePicImageView: UIImageView!
    @IBOutlet weak var nameLbl: CustomLabel!
    @IBOutlet weak var rankLbl: CustomLabel!
    @IBOutlet weak var dateAndTimeLbl: CustomLabel!
    @IBOutlet weak var completeCountLbl: CustomLabel!
    @IBOutlet weak var videoWatchedCountLbl: CustomLabel!
    @IBOutlet weak var lastEntryDayLbl: CustomLabel!
    @IBOutlet weak var lastActivityLbl: CustomLabel!
    
    //3 Defualts
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var videosCollView: UICollectionView!
    @IBOutlet weak var exercisesCollView: UICollectionView!
    
    //4 Data Objests...
    var studentSelectedId = Int()
    var dataJson = JSON()
    var videosData = JSON()
    var exersciseDate = JSON()
    
    
    //5 Hide/SHow
    @IBOutlet weak var videoWatchedVieww: UIView!
    @IBOutlet weak var completeTraningVieww: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerCells()
        
        self.profilePicImageView.layer.cornerRadius = self.profilePicImageView.bounds.height / 2
    }

    
    
    override func viewWillAppear(_ animated: Bool) {
        
       super.viewWillAppear(animated)
       
       self.containerVieww.isHidden = true
       self.getStudentSummary()
       self.setUpViews()
       
    }
    
    
    
    func getStudentSummary() {
        
        let urlString = getStudentProgressSummary
        
        
        let params = ["SessionToken": sessionTokenGlobal ?? "",
                      "StudentID": studentSelectedId] as [String : Any]
        
        ServiceManager().postRequest(urlString, loader: true, parameters: params) { (status, jsonResponse) in
            
            if status {
                
                self.dataJson = JSON.init(jsonResponse ?? "NO DTA")
                self.dataJson = self.dataJson["data"]
                
                self.fillData()
                self.videosCollView.reloadData()
                self.exercisesCollView.reloadData()
                
                
                //No data check....
                if self.dataJson["VideoProgressList"].count <= 0 {
                    self.videoContainerVieww.isHidden = true
                }
                
                //No data check...
                if self.dataJson["QuizProgressList"].count <= 0 {
                    self.exerciseContainerVieww.isHidden = true
                }
                
            }
        }
    }
    
    
    func fillData() {
        
        //1 Name
        nameLbl.text = self.dataJson["FirstName"].stringValue
        
        //2 Student Rank
        rankLbl.text = L102Language.isCurrentLanguageArabic() ?  "student_rank_ph".localized() + " " + self.dataJson["Rank"].stringValue : self.dataJson["Rank"].stringValue + " " + "student_rank_ph".localized()
        
        //3 Date
        dateAndTimeLbl.text = self.dataJson["LastSubscribedDate"].stringValue
        
        //4 Counts
        completeCountLbl.text = self.dataJson["QuizAttendedCount"].stringValue
        videoWatchedCountLbl.text = self.dataJson["VideosWatchedCount"].stringValue
        
        
        //5 Entry and Activity
        lastEntryDayLbl.text = L102Language.isCurrentLanguageArabic() ? "last_entry_ph".localized() + " " + self.dataJson["RegistrationDate"].stringValue : self.dataJson["RegistrationDate"].stringValue + " " + "last_entry_ph".localized()
        
        lastActivityLbl.text = L102Language.isCurrentLanguageArabic() ? "last_activity_ph".localized() + " " + self.dataJson["LastActivity"].stringValue : self.dataJson["LastActivity"].stringValue + " " + "last_activity_ph".localized()
            
        
        
        //6 ProfilePicImageView
        let url = URL(string: self.dataJson["ProfilePicPath"].stringValue)
        self.profilePicImageView.kf.setImage(with: url, placeholder: nil)
        
        
        //7 Show Al Now
        self.containerVieww.isHidden = false
        
        
        //No complete traning count
        if self.dataJson["QuizAttendedCount"].count == 0 {
            self.completeTraningVieww.isHidden = true
        }
        
        //No video watch count
        if self.dataJson["VideosWatchedCount"].count == 0 {
            //self.videoWatchedVieww.isHidden = true
        }
        
    }
    
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func profileButtonAction(_ sender: Any) {
       if let vc = PerentProfileViewController.instantiate(fromAppStoryboard: .main) {
           vc.modalPresentationStyle = .fullScreen
           //self.present(vc, animated: true, completion: nil)
           self.navigationController?.pushViewController(vc, animated: true)
       }
    }
    
    
    
    //MARK: UI & View SETUP
    func setUpViews() {
        
        //back button
        self.backButton.imageView?.transform =  L102Language.isCurrentLanguageArabic() ? CGAffineTransform(scaleX: -1.0, y: 1.0) : CGAffineTransform(scaleX: 1.0, y: -1.0)
        
        //...
        //2
        subscriotionPHLbl.text = "subs_history_ph".localized()
        completeTrainingPHLbl.text = "complete_training_ph".localized()
        videoWatchedPHLbl.text = "videos_watched_ph".localized()
        videosPHLabel.text = "videos_ph".localized()
        exersicePHLabel.text = "exercises_ph".localized()
        
    }
    
    //MARK: Register Cells
    func registerCells() {
        
        let nibName = UINib(nibName: "PercentSubjectCollCell", bundle:nil)
        self.videosCollView.register(nibName, forCellWithReuseIdentifier: "percentSubjectCollCell")
        
        let nibName2 = UINib(nibName: "PercentSubjectCollCell", bundle:nil)
        self.exercisesCollView.register(nibName2, forCellWithReuseIdentifier: "percentSubjectCollCell")
        
        
        self.exercisesCollView.delegate = self
        self.exercisesCollView.dataSource = self
        
        self.videosCollView.delegate = self
        self.videosCollView.dataSource = self
    
    }
    
}




//MARK:================================================
//MARK: CollectionView
//MARK:================================================

extension ChildDetailViewController: UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
 
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == self.videosCollView {
            return self.dataJson["VideoProgressList"].count
        } else {
            return self.dataJson["QuizProgressList"].count
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.videosCollView {
            
            let cell = self.videosCollView.dequeueReusableCell(withReuseIdentifier: "percentSubjectCollCell", for: indexPath) as? PercentSubjectCollCell
            
            
            cell?.configureViewCell(data : self.dataJson["VideoProgressList"][indexPath.row])
            
            return cell ?? UICollectionViewCell()
        
        } else {
            
            let cell = self.videosCollView.dequeueReusableCell(withReuseIdentifier: "percentSubjectCollCell", for: indexPath) as? PercentSubjectCollCell
            
            cell?.configureViewCell(data : self.dataJson["QuizProgressList"][indexPath.row])
            
            return cell ?? UICollectionViewCell()
        }
        
        
    }
    


    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        //let witdh = self.collView.frame.width - 50
        //let ratioHeight = (self.collView.frame.width / 261) * 175
    
        return CGSize(width: 104, height: 104)
        
    }
    
        
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
}
