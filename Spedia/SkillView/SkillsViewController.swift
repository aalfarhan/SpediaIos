//
//  SkillsViewController.swift
//  Spedia
//
//  Created by Viraj Sharma on 31/12/2020.
//  Copyright © 2020 Viraj Sharma. All rights reserved.
//

import UIKit
import SwiftyJSON


class SkillsViewController: UIViewController {
    
    //1 Outlets.......
    @IBOutlet weak var listView: UITableView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var headerTitleLbl: CustomLabel!
    @IBOutlet weak var headerSubTitleLbl: CustomLabel!
     
    //2 Data.........
    var dataJson = JSON()
    var currentSelectedSubjectIndex = 0
    var isLoaded = false
    var selectedSubjectId = 0
    var forVideoOrQuiz = ""
    
    //Responsive...
    @IBOutlet weak var leftPeddingConst: NSLayoutConstraint!
    @IBOutlet weak var rightPeddingConst: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TableView...
        self.listView.isHidden = true
        
        //1
        let tableCellNib = UINib(nibName: "SkillHeaderTableCell", bundle:nil)
        self.listView.register(tableCellNib, forCellReuseIdentifier: "skillHeaderTableCell")
     
        //2
        let tableCell = UINib(nibName: "SkillStrenthTableCell", bundle:nil)
        self.listView.register(tableCell, forCellReuseIdentifier: "skillStrenthTableCell")
     
        //3
        self.skillAnalysisDataNow()
    }
    
    
    
    //2
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setUpView()
    }
    
    
    //3
    func setUpView() {
        
        //0
        self.leftPeddingConst.constant = UIDevice.isPad ? 50 : 16
        self.rightPeddingConst.constant = UIDevice.isPad ? 50 : 16
        
        //1
        self.headerTitleLbl.text = "skill_analysis".localized()
        self.headerSubTitleLbl.text = "analysis_based".localized()
        
        //2
        self.backButton.imageView?.transform =  L102Language.isCurrentLanguageArabic() ? CGAffineTransform(scaleX: -1.0, y: 1.0) : CGAffineTransform(scaleX: 1.0, y: -1.0)
        
    }
    
    
    
    @IBAction func backButtonAction(_ sender: Any) {
        //self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    //4 Call API.....
    
    func skillAnalysisDataNow() {
        
        let urlString = skillAnalysisData
        let params = ["SessionToken" : sessionTokenGlobal ?? "",
                      "StudentID" : studentIdGlobal ?? 0,
                      "SelectedSubjectMasterID" : selectedSubjectId,
                      "ForVideoOrQuiz" : self.forVideoOrQuiz] as [String : Any]
        
        ServiceManager().postRequest(urlString, loader: true, parameters: params) { (status, jsonResponse) in
             
            if status {
                
                let dataRes = JSON.init(jsonResponse ?? "NO DTA")
                self.dataJson = dataRes
                
                self.listView.reloadData()
                
                if self.dataJson["Subjects"].count > 0 {
                    self.listView.isHidden = false
                }
                
                DispatchQueue.main.async {
                    //self.didTapOnTopSubjectCollView(atIndex: 0)
                    self.isLoaded = false
                    self.currentSelectedSubjectIndex = 0
                    self.listView.reloadData()
                }
                
                
                //self.dataJson = self.dataJson["\(UnitDetailKey.UnitsArray)"]
                //self.listView.reloadData()
                
                //dataRes[UnitDetailKey.HideAddToCart].boolValue
                
                //if self.dataJson[UnitDetailKey.UnitsArray].count == 0 {
                    //self.collView.isHidden = true
                    //self.noDataLbl.text = "no_data_found".localized()
                //} else {
                    //self.noDataLbl.text = ""
                //}
                 
            }
        }
        
    }
    
    
}




//MARK:================================================
//MARK: TableView Extension
//MARK:================================================

extension SkillsViewController : UITableViewDelegate, UITableViewDataSource, SkillHeaderTableCellDelegate {
    

    //ROW...
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            
            let cell = self.listView.dequeueReusableCell(withIdentifier: "skillHeaderTableCell") as? SkillHeaderTableCell
            
            cell?.selectionStyle = .none
            
            cell?.isQuizType = self.forVideoOrQuiz == "forQuiz" ? true : false
            
            cell?.lblLevel.text = L102Language.isCurrentLanguageArabic() ? self.dataJson["LevelAr"].stringValue : self.dataJson["LevelEn"].stringValue
            
            cell?.lblPoints.text = L102Language.isCurrentLanguageArabic() ? self.dataJson["PointsAr"].stringValue : self.dataJson["PointsEn"].stringValue
            
            cell?.subjectsDataJson = self.dataJson["Subjects"]
            cell?.overviewDataJson = self.dataJson["Overviews"]
            //let index = indexPath.row - 1
            
            //cell?.configureCellWithData(data: self.dataJson["VideoStatusList"])
            
            if isLoaded == false {
                
                let watchCount = self.dataJson["Subjects"][self.currentSelectedSubjectIndex]["WatchedVideosPerc"].intValue
                
                
                self.isLoaded = true
                cell?.percentageLabel.text = "0.0%"
                
                if watchCount > 0 {
                 cell?.incrementLabel(to: watchCount)
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    
                    let progressValue = self.dataJson["Subjects"][self.currentSelectedSubjectIndex]["WatchedVideosPerc"].floatValue
                    
                    cell?.subjectProgressVieww.startProgress(to: CGFloat(progressValue), duration: 1.5)
                    
                }
            }
            
            cell?.showLeaderBord.addTarget(self, action: #selector(showLeaderBordCliked(sender:)), for: .touchUpInside)
            
            //cell?.showSkillButton.addTarget(self, action: #selector(showSkillButtonCliked(sender:)), for: .touchUpInside)
            
            cell?.delegateObj = self
            
            cell?.reloadColletionsView()
            
            return cell ?? UITableViewCell()
            
            
        } else {
            
            let cell = self.listView.dequeueReusableCell(withIdentifier: "skillStrenthTableCell") as? SkillStrenthTableCell
            
            cell?.selectionStyle = .none //Skills
            
            cell?.isQuizType = self.forVideoOrQuiz == "forQuiz" ? true : false
            
            cell?.progressSkillData = self.dataJson["Subjects"][self.currentSelectedSubjectIndex]["Skills"]
            
            cell?.reloadColletionsView()
            
            cell?.collViewHeightConst.constant = self.getSkillCollViewHieght()
            
            return cell ?? UITableViewCell()
        }
        
    }
 
    
    @objc func showSkillButtonCliked(sender: UIButton) {
        
      if let vc = SkillsViewController.instantiate(fromAppStoryboard: .main) {
       vc.modalPresentationStyle = .fullScreen

       self.present(vc, animated: true, completion: nil)
      }
        
    }
    
    @objc func showLeaderBordCliked(sender: UIButton) {
        
        if let vc = LeaderViewController.instantiate(fromAppStoryboard: .main) {
       vc.modalPresentationStyle = .fullScreen
       self.navigationController?.pushViewController(vc, animated: true)
       //self.present(vc, animated: true, completion: nil)
      }
    
    }
    
    
    func getSkillCollViewHieght() -> CGFloat {
        
        //Step 1). Add 10px in Bottom Space : CHECK LAST RETUNR VALUE BELOW
        let heightForOneCell = UIDevice.isPad ? 135 : 135
        
        //Step 2).get subject count
        let numberOfRowInGrid = Double(self.dataJson["Subjects"][self.currentSelectedSubjectIndex]["Skills"].count) / 3.0
        
        //Step 3). calculated and round off value
        let totalCount = numberOfRowInGrid + 0.2
        
        //Step 4). multiply
        let totalHeight = Int(heightForOneCell) * Int(round(totalCount))
        
        //Step 5). Add Bottom Space
        let bottomSpace = Int(numberOfRowInGrid * 10) // 10px is one cell bottom space
        
        print("Rows are and Space----->", numberOfRowInGrid, bottomSpace)
        
        print("Total Coll Cell Height is----->", totalHeight)
        
        //Step 5). final return height
        return CGFloat(totalHeight + bottomSpace)
        
    }
    
    
    
    func didTapOnTopSubjectCollView (atIndex : Int) {
        
        print("didTapOnTopSubjectCollView ====> \(atIndex)")
        
        self.isLoaded = false
        self.currentSelectedSubjectIndex = atIndex
        self.listView.reloadData()
        //self.view.layoutIfNeeded()
    }

    
    //@objc func moreButtonAction(sender: UIButton) { }
        
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    
    }
    
}

