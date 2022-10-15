//
//  DummyViewController.swift
//  Spedia
//
//  Created by Viraj Sharma on 22/01/22.
//  Copyright © 2022 Viraj Sharma. All rights reserved.
//

import UIKit

class DummyViewController: UIViewController {

    //MARK: 1). Outlet's, Object's And Data Model
    //1.1
    @IBOutlet weak var topHeaderLogoView: UIView!
    
    
    //MARK: 2). ViewLifeCycles
    
    //2.1
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpViewDidLoad()
    }
    
    //2.2
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setUpViewWillAppear()
    }

    //2.3
    private func setUpViewDidLoad() {
        
    }
    
    
    //2.4
    private func setUpViewWillAppear() {
        let topHeaderLogoViewObj = TopHeaderLogoView()
        topHeaderLogoViewObj.frame = self.topHeaderLogoView.frame
        self.topHeaderLogoView.addSubview(topHeaderLogoViewObj)
    }

    
    //2.5
    private func callApiNow() {
        
    }

}


/*
 //===========================
 //MARK: LIST VIEW
 //===========================

 extension HomeSubscribedViewController : UITableViewDelegate, UITableViewDataSource {
     
     func numberOfSections(in tableView: UITableView) -> Int {
         return 1
     }
     
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return 2 + self.mainDataJson["complexskill"].count + self.mainDataJson["FacultyDetails"].count
     }
     
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         
         let cell = self.listView.dequeueReusableCell(withIdentifier: "unitTCell") as? UnitTCell
         
         cell?.selectionStyle = .none
         
         let index = indexPath.row// - 2
         
         cell?.dataJson = self.mainDataJson["complexskill"][index]
         cell?.configureViewWithData(data: self.mainDataJson["complexskill"][index], atIndex: index)
         
         cell?.articleTitleLbl.text = self.mainDataJson["ArticleConten
 " + Lang.code()].stringValue
         
         //cell?.expandTabButton.tag = index
         //cell?.expandTabButton.addTarget(self, action: #selector(expandCellButtonAction(sender:)), for: .touchUpInside)
         
         return cell ?? UITableViewCell()
     }
  
     
     @objc func readMoreCellButtonAction(sender: UIButton) {
         
     
     }
     

     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         return UITableView.automaticDimension
     }

 }

 */
