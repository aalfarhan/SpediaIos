//
//  SelectSchoolViewController.swift
//  Spedia
//
//  Created by Viraj Sharma on 08/07/2020.
//  Copyright © 2020 Viraj Sharma. All rights reserved.
//

import UIKit
import SwiftyJSON

class SelectSchoolViewController: UIViewController {

    var tempUserID = Int()
    @IBOutlet weak var nextButton: CustomButton!
    @IBOutlet weak var listView: UITableView!
    var dataJson = JSON()
    var selectdIndex = -1
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("\ntemp user id is=====> \(tempUserID)\n\n")
        self.nextButton.isEnabled = false
        self.nextButton.alpha = 0.5
        self.getClassedNow()
    }
    
    
    @objc func backButtonAction(sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //1
        self.setupView()
    }


    func getClassedNow() { //Get Method
        
        let urlString = getClasses
        //let params = ["CountryCode":  ""] as [String : String]
        
        ServiceManager().getRequest(urlString, loader: true, parameters: [:]) { (status, jsonResponse) in
             
            if status {
                self.dataJson = JSON.init(jsonResponse ?? "NO DTA")
                self.dataJson = self.dataJson["Categories"]
                self.listView.reloadData()
            }
        }
        
    }
    
    
    
    //1 Setup View...
    func setupView() {
      //2
      let nibName = UINib(nibName: "SchoolHeaderTCell", bundle:nil)
      self.listView.register(nibName, forCellReuseIdentifier: "schoolHeaderTCell")
      
      //3
      let nibName2 = UINib(nibName: "SchoolTableCell", bundle:nil)
      self.listView.register(nibName2, forCellReuseIdentifier: "schoolTableCell")
      
      //4
      self.nextButton.setTitle(L102Language.isCurrentLanguageArabic() ? "التالي" : "NEXT", for: .normal)
      
    }
    
    
    @IBAction func nextButtonAction(_ sender: Any) {
     
     if selectdIndex != -1 {
      if let vc = SelectGradeOrUnivercityViewController.instantiate(fromAppStoryboard: .main) {

         vc.modalPresentationStyle = .fullScreen
         vc.tempUserID = self.tempUserID
         vc.selectedJSon = self.dataJson[selectdIndex]["ClassList"]
         
         if self.dataJson[selectdIndex]["ClassCategoryID"].intValue == 4 {
            vc.isUniversity = true
         }
        
         self.present(vc, animated: true, completion: nil)
        
         }
        
     } else {
        //do nothing
     }
        
        
    }
    
}

extension SelectSchoolViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataJson.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
      if indexPath.row == 0 {
        
           let cell = self.listView.dequeueReusableCell(withIdentifier: "schoolHeaderTCell") as? SchoolHeaderTCell
                       
           cell?.selectionStyle = .none
        
           cell?.backButton.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
            
           return cell ?? UITableViewCell()
        
        //2 Options Cell
        } else {
            
            let cell = self.listView.dequeueReusableCell(withIdentifier: "schoolTableCell") as? SchoolTableCell
                        
            cell?.selectionStyle = .none
            cell?.checkedImgView.isHidden = true
        
            if selectdIndex == indexPath.row - 1 {
                cell?.checkedImgView.isHidden = false
                //cell?.dashBorderView.dashColor = Colors.APP_LIME_GREEN ?? UIColor.darkGray
            }
            
            cell?.configureViewWith(data: self.dataJson[indexPath.row - 1])
            return cell ?? UITableViewCell()
            
        }
            
    }
 
    
    
    //XLR8 - Status Change Action...
    @objc func backButtonCliked(sender: UIButton) {
      print("Back button hitzzz......")
    }
        
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row != 0 {
          self.nextButton.isEnabled = true
          self.nextButton.alpha = 1.0
          self.selectdIndex = indexPath.row - 1
          self.listView.reloadData()
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    
    }
    
}
