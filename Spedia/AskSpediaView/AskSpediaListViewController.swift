//
//  AskSpediaListViewController.swift
//  Spedia
//
//  Created by Viraj Sharma on 01/08/2020.
//  Copyright © 2020 Viraj Sharma. All rights reserved.
//

import UIKit
import SwiftyJSON
import GSImageViewerController

class AskSpediaListViewController: UIViewController {

    //MARK: Object's and Outlet's
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var headerTitleLbl: CustomLabel!
    @IBOutlet weak var subTitleLbl: CustomLabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var listView: UITableView!
    
    
    //MARK: NoData Customer Support View
    @IBOutlet weak var noSupportDataView: NoDataCustomerSupportView!
    
    var dataJson = JSON()
    var whereFromCome = ""
    
    
    //MARK: LIFE CYCLE's
    
    //1
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //2
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setUpView()
        self.getData()
    }
    
    
    //3
    func setUpView() {
        
        self.containerView.isHidden = true
        self.noSupportDataView.isHidden = true
        
        self.headerTitleLbl.text = "ask_spedia".localized()
        self.subTitleLbl.text = "if_question".localized()
        self.backButton.imageView?.transform =  L102Language.isCurrentLanguageArabic() ? CGAffineTransform(scaleX: -1.0, y: 1.0) : CGAffineTransform(scaleX: 1.0, y: -1.0)
        
        //1
        let nibName = UINib(nibName: "AskListTableCell", bundle:nil)
        self.listView.register(nibName, forCellReuseIdentifier: "askListTableCell")
        
    }
    
    
    func getData() {
        
        let urlString = getAskSpediaReplies
         
        let params = ["SessionToken": sessionTokenGlobal ?? "",
                      "StudentID": studentIdGlobal ?? 0] as [String : Any]
        
        ServiceManager().postRequest(urlString, loader: true, parameters: params) { (status, jsonResponse) in
             
            if status {
                self.dataJson = JSON.init(jsonResponse ?? "NO DTA")
                self.listView.reloadData()
                
                if self.dataJson["ListItems"].count == 0 {
                    self.containerView.isHidden = true
                    self.noSupportDataView.isHidden = false
                    
                } else {
                    self.containerView.isHidden = false
                    self.noSupportDataView.isHidden = true
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
        
      } else {
        //self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
      }
        
    }
 
    
    @IBAction func newMsgButtonAction(_ sender: Any) {
        
        if let vc = AskSpediaViewController.instantiate(fromAppStoryboard: .main) {
            vc.modalPresentationStyle = .fullScreen
            vc.subjectList = self.dataJson["Subjects"]
            self.present(vc, animated: true, completion: nil)
        }
        
    }
     
    
}




extension AskSpediaListViewController : UITableViewDelegate, UITableViewDataSource, AskListTableCellDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataJson["ListItems"].count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.listView.dequeueReusableCell(withIdentifier: "askListTableCell") as? AskListTableCell
        
        cell?.selectionStyle = .none
        
        let index = indexPath.row
        
        cell?.dateAndTimeLbl.text = self.dataJson["ListItems"][index]["SentDate"].stringValue
        
        cell?.adminOrUserLbl.text = self.dataJson["ListItems"][index]["MessageBy"].stringValue
        
        cell?.msgLbl.text = self.dataJson["ListItems"][index]["Message"].stringValue
        
        cell?.moreButton.isHidden = false
        cell?.msgLbl.numberOfLines = 2
        cell?.constForMoreButtonHieght.constant = 20
        
        cell?.moreButton.tag = index
        cell?.moreButton.addTarget(self, action: #selector(moreButtonAction), for: .touchUpInside)
        
        cell?.delegateObj = self
        
        //let url = URL(string: self.dataJson["ListItems"][index]["Attachment"].stringValue)
        //cell?.cellImage.kf.setImage(with: url, placeholder: nil)
        
        
        return cell ?? UITableViewCell()
    
    }
 
    
    
    func didTapOnAskListTCell(cellSelectedImage : UIImage) {
        
        print("didTapOnAskListTCell", cellSelectedImage)
        
        let imageInfo = GSImageInfo(image: cellSelectedImage , imageMode: .aspectFit)
        let imageViewer = GSImageViewerController(imageInfo: imageInfo)
        present(imageViewer, animated: true)
        
    }
    
    
    
    @objc func moreButtonAction(sender: UIButton) {
      
        if let vc = ReplyViewController.instantiate(fromAppStoryboard: .main) {
               vc.modalPresentationStyle = .fullScreen
               vc.askSpediaID = self.dataJson["ListItems"][sender.tag]["AskSpediaID"].intValue
              self.present(vc, animated: true, completion: nil)
        }
        
    }
        
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 160
    
    }
    

}
