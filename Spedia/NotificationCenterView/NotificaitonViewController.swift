//
//  NotificaitonViewController.swift
//  Spedia
//
//  Created by Viraj Sharma on 07/08/2020.
//  Copyright © 2020 Viraj Sharma. All rights reserved.
//

import UIKit
import SwiftyJSON

class NotificaitonViewController: UIViewController {

    //MARK: Object's and Outlet's
    @IBOutlet weak var headerTitleLbl: CustomLabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var listView: UITableView!
    
    @IBOutlet weak var noDataLbl: UILabel!
    @IBOutlet weak var noDataImageView: UIImageView!
    
    
    var dataJson = JSON()
    var whereFromCome = ""
    
    
    //MARK: LIFE CYCLE's
    
    //1
    override func viewDidLoad() {
        super.viewDidLoad()
        self.noDataLbl.text = ""
        self.noDataImageView.isHidden = true
        self.listView.isHidden = true
    }
    
    //2
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setUpView()
        self.getData()
    }
    
    
    //3
    func setUpView() {
        
        self.headerTitleLbl.text = "notification_ph".localized()
        self.backButton.imageView?.transform =  L102Language.isCurrentLanguageArabic() ? CGAffineTransform(scaleX: -1.0, y: 1.0) : CGAffineTransform(scaleX: 1.0, y: -1.0)
        
        //1
        let nibName = UINib(nibName: "NotificationTCell", bundle:nil)
        self.listView.register(nibName, forCellReuseIdentifier: "notificationTCell")
        
        //2
        let nibNameTwo = UINib(nibName: "ReadAndClearTCell", bundle:nil)
        self.listView.register(nibNameTwo, forCellReuseIdentifier: "readAndClearTCell")
        
        
    }
    
    
    func getData() {
        
        let urlString = getStudentNotificationHistory
         
        let params = ["SessionToken": sessionTokenGlobal ?? "",
                      "StudentID": studentIdGlobal ?? 0] as [String : Any]
        
        ServiceManager().postRequest(urlString, loader: true, parameters: params) { (status, jsonResponse) in
             
            if status {
                self.dataJson = JSON.init(jsonResponse ?? "NO DTA")
                
                DispatchQueue.main.async {
                    self.listView.reloadData()
                    
                    if self.dataJson["ListItems"].count == 0 {
                        self.listView.isHidden = true
                        self.noDataLbl.text = "the_page_is_empty".localized()
                        self.noDataImageView.isHidden = false
                    } else {
                        self.noDataLbl.text = ""
                        self.noDataImageView.isHidden = true
                        self.listView.isHidden = false
                    }
                }
            }
        }
    
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
      
      if whereFromCome == "Redirection" {
        
        if isLoginGlobal ?? false {
            setRootView(tabBarIndex: 0)
        } else {
            logoutNow()
        }
        
      } else if whereFromCome == WhereFromAmIKeys.bellIcon {
        
        self.dismiss(animated: true, completion: nil)
      }
      
      else {
         self.navigationController?.popViewController(animated: true)
      }
      
    }
 
}




extension NotificaitonViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataJson["ListItems"].count + 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            
            let cell = self.listView.dequeueReusableCell(withIdentifier: "readAndClearTCell") as? ReadAndClearTCell
            
            cell?.selectionStyle = .none
            
            
            cell?.markAsReadButton.addTarget(self, action: #selector(markAsReadButtonAction(sender:)), for: .touchUpInside)
            cell?.clearAllButton.addTarget(self, action: #selector(clearAllButtonAction(sender:)), for: .touchUpInside)
            
            return cell ?? UITableViewCell()
            
        } else {
            
            let cell = self.listView.dequeueReusableCell(withIdentifier: "notificationTCell") as? NotificationTCell
            
            cell?.selectionStyle = .none
            
            let index = indexPath.row
            cell?.configureNotificaitonCell(dataModel: self.dataJson["ListItems"][index], isRead: index / 2 == 0)
            
            cell?.deleteButton.tag = index
            cell?.deleteButton.addTarget(self, action: #selector(deleteButtonAction(sender:)), for: .touchUpInside)
            
            return cell ?? UITableViewCell()
            
        }
        
    }
 
    
    @objc func markAsReadButtonAction(sender: UIButton) {
        print("markAsReadButtonAction")
        self.updateNotificaitonWith(id: 0, action: "ReadAll")
    }
    
    @objc func clearAllButtonAction(sender: UIButton) {
        print("clearAllButtonAction")
        self.updateNotificaitonWith(id: 0, action: "RemoveAll")
    }
    
    
    @objc func deleteButtonAction(sender: UIButton) {
        print("deleteButton")
        let notificationId = self.dataJson["ListItems"][sender.tag]["NotificationID"].intValue
        self.updateNotificaitonWith(id: notificationId, action: "RemoveOne")
    }
        

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    func updateNotificaitonWith(id: Int, action: String) {
        
        let urlString = getNotificaitonActionApi
        
        let params = ["SessionToken": sessionTokenGlobal ?? "",
                      "StudentID": studentIdGlobal ?? 0,
                      "NotificationID": id,
                      "Action": action] as [String : Any]
        
        ServiceManager().postRequest(urlString, loader: false, parameters: params) { (status, jsonResponse) in
             
            if status {
                DispatchQueue.main.async {
                    self.getData()
                }
            }
        }
    
    }

}

