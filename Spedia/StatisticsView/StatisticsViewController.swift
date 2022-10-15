//
//  StatisticsViewController.swift
//  Spedia
//
//  Created by Viraj Sharma on 30/12/2020.
//  Copyright © 2020 Viraj Sharma. All rights reserved.
//

import UIKit
import SwiftyJSON

class StatisticsViewController: UIViewController {

    //1 Outlets.......
    @IBOutlet weak var listView: UITableView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var headerTitleLbl: CustomLabel!
    
    @IBOutlet weak var noDataLbl: CustomLabel!
     
    //2 Data.........
    var mainJson = JSON()
    var dataJson = JSON()
    
    //Responsive...
    @IBOutlet weak var leftPeddingConst: NSLayoutConstraint!
    @IBOutlet weak var rightPeddingConst: NSLayoutConstraint!
    
    
    //Category Selection
    @IBOutlet weak var videoStatsButton: CustomButton!
    @IBOutlet weak var quizStatsButton: CustomButton!
    @IBOutlet weak var statContViewHeight: NSLayoutConstraint!
    
    var selectedKey = "videoStatus"
    var selectedIndex = 1
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TableView...
        
        //1
        let tableCellNib = UINib(nibName: "HeaderTableCell", bundle:nil)
        self.listView.register(tableCellNib, forCellReuseIdentifier: "headerTableCell")
     
        //2
        let tableCell = UINib(nibName: "VideoStatsTableCell", bundle:nil)
        self.listView.register(tableCell, forCellReuseIdentifier: "videoStatsTableCell")
     
        
        //3  //register the header view
        //self.listView.register(UINib(nibName : "TableSectionView", bundle: nil), forCellReuseIdentifier: "tableSectionView")
        
        self.listView.isHidden = true
        self.statContViewHeight.constant = 0
        self.noDataLbl.text = ""
        
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
        self.headerTitleLbl.text = "statistics".localized()
        //self.headerSubTitleLbl.text = "performance_statistics".localized()
        
        //2
        self.backButton.imageView?.transform =  L102Language.isCurrentLanguageArabic() ? CGAffineTransform(scaleX: -1.0, y: 1.0) : CGAffineTransform(scaleX: 1.0, y: -1.0)
        

        //3
        self.getStatsData()
        
    }
    
    
    
    @IBAction func backButtonAction(_ sender: Any) {
        //self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func statsButtonsAction(_ sender: UIButton) {
         self.whichButtonActive(tag: sender.tag)
    }
    
    
    func whichButtonActive(tag : Int) {
        
        
        if tag == 1 { //Video Stats List
        
            self.selectedKey = "videoStatus"
            self.dataJson = self.mainJson[selectedKey]
            self.selectedIndex = 1
            self.videoStatsButton.backgroundColor = .clear
            self.videoStatsButton.setTitleColor(Colors.APP_LIGHT_GREEN, for: .normal)
            
            self.quizStatsButton.backgroundColor = UIColor.init(hexaRGB: "F1F9F4", alpha: 1.0)
            self.quizStatsButton.setTitleColor(Colors.APP_TEXT_BLACK, for: .normal)
            self.listView.reloadData()
            
        } else { //Quiz Stats List
            
            
            self.selectedKey = "examstatus"
            self.dataJson = self.mainJson[selectedKey]
            self.selectedIndex = 2
            self.quizStatsButton.backgroundColor = .clear
            self.quizStatsButton.setTitleColor(Colors.APP_LIGHT_GREEN, for: .normal)
            
            self.videoStatsButton.backgroundColor = UIColor.init(hexaRGB: "F1F9F4", alpha: 1.0)
            self.videoStatsButton.setTitleColor(Colors.APP_TEXT_BLACK, for: .normal)
            self.listView.reloadData()
            
        }
        
        
        
        if self.dataJson["StatusList"].count == 0 {
            //no data here... hide ALL
            self.statContViewHeight.constant = 0
            self.listView.isHidden = true
            self.noDataLbl.text = "no_data_found".localized()
            
        } else {
            self.listView.isHidden = false
            self.statContViewHeight.constant = 50
            self.noDataLbl.text = ""
        }
        
    }
        
    
    
    
    //4 Call API.....
    
    func getStatsData() {
        
        let urlString = getStatistics
        
        let params = ["SessionToken" : sessionTokenGlobal ?? "",
                      "StudentID" : studentIdGlobal ?? 0] as [String : Any]
        
        ServiceManager().postRequest(urlString, loader: true, parameters: params) { (status, jsonResponse) in
             
            if status {
                
                let dataRes = JSON.init(jsonResponse ?? "NO DTA")
                self.mainJson = dataRes
                
                
                self.quizStatsButton.isHidden = self.mainJson["examstatus"]["StatusList"].count == 0 ? true : false
                
                self.videoStatsButton.isHidden = self.mainJson["videoStatus"]["StatusList"].count == 0 ? true : false
                
                let videoTabTitleStr = L102Language.isCurrentLanguageArabic() ? self.mainJson["VideoTabTitleAr"].stringValue : self.mainJson["VideoTabTitleEn"].stringValue
                
                let quizTabTitleStr = L102Language.isCurrentLanguageArabic() ? self.mainJson["QuizTabTitleAr"].stringValue : self.mainJson["QuizTabTitleEn"].stringValue
                
                self.videoStatsButton.setTitle(videoTabTitleStr, for: .normal)
                
                self.quizStatsButton.setTitle(quizTabTitleStr, for: .normal)
                
                self.whichButtonActive(tag: self.selectedIndex)
                
            }
        }
        
    }
    
    
}





//MARK:================================================
//MARK: TableView Extension
//MARK:================================================

extension StatisticsViewController : UITableViewDelegate, UITableViewDataSource {
    
    /*
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 0 {
            return 0
        }
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let cell = self.listView.dequeueReusableCell(withIdentifier: "tableSectionView" ) as!  TableSectionView
        
        cell.sectionTitleLabel.text = "Section Title"
        
        return cell
        
    }*/
    
    
    
    //ROW...
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataJson["StatusList"].count + 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            
            let cell = self.listView.dequeueReusableCell(withIdentifier: "headerTableCell") as? HeaderTableCell
            
            cell?.selectionStyle = .none
            
            cell?.configureCellWithData(data: self.dataJson["PracticeViews"])
            
            cell?.viewTimeLineButton.addTarget(self, action: #selector(viewTimelineButtonAction), for: .touchUpInside)
            
            return cell ?? UITableViewCell()
            
        } else {
            
            let cell = self.listView.dequeueReusableCell(withIdentifier: "videoStatsTableCell") as? VideoStatsTableCell
            
            cell?.selectionStyle = .none
            
            let index = indexPath.row - 1
            
            cell?.configureCellWithData(data: self.dataJson["StatusList"][index])
            
            cell?.tabCellButton.tag = index
            cell?.tabCellButton.addTarget(self, action: #selector(tabCellButtonAction), for: .touchUpInside)
            
            return cell ?? UITableViewCell()
        }
        
    }
 
    

    @objc func viewTimelineButtonAction(sender: UIButton) {
        if let vc = TimelineViewController.instantiate(fromAppStoryboard: .main) {
            vc.modalPresentationStyle = .fullScreen
            //vc.hidesBottomBarWhenPushed = false
            
            //self.present(vc, animated: true, completion: nil)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
        
    
    @objc func tabCellButtonAction(sender: UIButton) {
        
        if let vc = SkillsViewController.instantiate(fromAppStoryboard: .main) {
            vc.modalPresentationStyle = .fullScreen
            vc.selectedSubjectId = self.dataJson["StatusList"][sender.tag]["SubjectMasterID"].intValue
            
            vc.forVideoOrQuiz = self.selectedIndex == 1 ? "forVideo" : "forQuiz"
            //vc.hidesBottomBarWhenPushed = false
            
            self.navigationController?.pushViewController(vc, animated: true)
            //self.present(vc, animated: true, completion: nil)
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    
    }
    
}

