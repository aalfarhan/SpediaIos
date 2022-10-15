//
//  TestTableViewExtension.swift
//  Spedia
//
//  Created by Viraj Sharma on 08/09/22.
//  Copyright © 2022 Viraj Sharma. All rights reserved.
//

import Foundation
import UIKit


extension TestTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func registerTableViewCells() {
        let nibName = UINib(nibName: "AskListTableCell", bundle:nil)
        self.listView.register(nibName, forCellReuseIdentifier: "askListTableCell")
        self.listView.delegate = self
        self.listView.dataSource = self
    }
    
    func reloadTableViewNow() {
        DispatchQueue.main.async {
            self.listView.isHidden = false
            self.listView.reloadData()
            self.listView.layoutIfNeeded()
            self.view.layoutIfNeeded()
        }
    }
    
    //
    //MARK: Data Source And Delegates
    //
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.mainDataJson["ListItems"].count + 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.listView.dequeueReusableCell(withIdentifier: "askListTableCell") as? AskListTableCell
        
        cell?.selectionStyle = .none
        
        let index = indexPath.row
        
        cell?.dateAndTimeLbl.text = self.mainDataJson["ListItems"][index]["SendDate"].stringValue
        
        cell?.adminOrUserLbl.text = self.mainDataJson["ListItems"][index]["notificaitonTitle"].stringValue
        
        cell?.msgLbl.text = self.mainDataJson["ListItems"][index]["notificationMsg"].stringValue
        
        cell?.moreButton.isHidden = true
        cell?.msgLbl.numberOfLines = 3
        cell?.constForMoreButtonHieght.constant = 0
        
        //cell?.moreButton.tag = index
        //cell?.moreButton.addTarget(self, action: #selector(moreButtonAction), for: .touchUpInside)
        
        return cell ?? UITableViewCell()
    
    }
 
    
    
    //@objc func moreButtonAction(sender: UIButton) { }
        
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    
    }
    
}
