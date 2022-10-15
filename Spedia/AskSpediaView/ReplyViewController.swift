//
//  ReplyViewController.swift
//  Spedia
//
//  Created by Viraj Sharma on 05/08/2020.
//  Copyright © 2020 Viraj Sharma. All rights reserved.
//

import UIKit
import SwiftyJSON
import GSImageViewerController

class ReplyViewController: UIViewController, UITextViewDelegate {

    //MARK: Object's and Outlet's
    @IBOutlet weak var headerTitleLbl: CustomLabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var listView: UITableView!
    @IBOutlet weak var popUpViewHieght: NSLayoutConstraint!
    @IBOutlet weak var typeYourTextView: UITextView!
    @IBOutlet weak var replyButton: CustomButton!

    var dataJson = JSON()
    var askSpediaID = Int()
    
    

    //MARK: LIFE CYCLE's
    
    //1
    override func viewDidLoad() {
        super.viewDidLoad()
        self.typeYourTextView.delegate = self
    }
    
    //2
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setUpView()
        self.getData()
    }
    
    //2.1
    func textViewDidEndEditing(_ textView: UITextView) {
         
    }
    
    
    //3
    func setUpView() {
        
        self.headerTitleLbl.text = "ask_spedia".localized()
        self.backButton.imageView?.transform =  L102Language.isCurrentLanguageArabic() ? CGAffineTransform(scaleX: -1.0, y: 1.0) : CGAffineTransform(scaleX: 1.0, y: -1.0)
        
        //1
        let nibName = UINib(nibName: "AskListTableCell", bundle:nil)
        self.listView.register(nibName, forCellReuseIdentifier: "askListTableCell")
        
        //2
        self.popUpViewHieght.constant = 0.0
        
    }
    
    //4
    @IBAction func backButtonAction(_ sender: Any) {
         self.dismiss(animated: true, completion: nil)
    }
    
    
    //5 Get List Data
    func getData() {
           
           let urlString = getAskSpediaHistory
            
           let params = ["SessionToken": sessionTokenGlobal ?? "",
                         "AskSpediaID": askSpediaID ] as [String : Any]
           
           ServiceManager().postRequest(urlString, loader: true, parameters: params) { (status, jsonResponse) in
                
               if status {
                
                   self.dataJson = JSON.init(jsonResponse ?? "NO DTA")
                   self.listView.reloadData()
                   
                   if self.dataJson["ListItems"].count == 0 {
                       self.listView.isHidden = true
                   } else {
                       self.listView.isHidden = false
                       self.listView.scrollToRow(at: IndexPath(row: self.dataJson["ListItems"].count - 1, section: 0), at: .bottom, animated: false)
                   }
               }
           }
       
       }
    
       
       //6
    
    @IBAction func replyButtonAction(_ sender: Any) {
        
        if popUpViewHieght.constant == 0.0 {
            self.popUpViewHieght.constant = 180.0
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
                self.listView.scrollToRow(at: IndexPath(row: self.dataJson["ListItems"].count - 1, section: 0), at: .bottom, animated: false)
            }
            
        } else {
             
            let typeQuestionStr = typeYourTextView.text ?? ""
            if typeQuestionStr.isEmpty {
                self.hidePopUpView()
            } else {
                
                let urlString = askSpedia
                     
                let params = ["Message" :"\(typeQuestionStr)",
                              "SessionToken" : sessionTokenGlobal ?? "",
                              "SubjectID" : "",
                              "StudentID" : studentIdGlobal ?? 0,
                              "AskSpediaID" : askSpediaID ] as [String : Any]
                    
                    ServiceManager().postRequest(urlString, loader: true, parameters: params) { (status, jsonResponse) in
                         
                        if status {
                            self.hidePopUpView()
                            self.typeYourTextView.text = ""
                            self.getData()
                        }
                    }
            }
            
        }
        
    }
    
    
    //7
    @IBAction func crossButtonAction(_ sender: Any) {
        self.hidePopUpView()
    }
    
    
    func hidePopUpView()  {
        
        self.popUpViewHieght.constant = 0.0
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
            self.listView.scrollToRow(at: IndexPath(row: self.dataJson["ListItems"].count - 1, section: 0), at: .bottom, animated: false)
        }
    }
    
}




//===========================
//MARK: LIST VIEW
//===========================

extension ReplyViewController : UITableViewDelegate, UITableViewDataSource, AskListTableCellDelegate {
    
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
        
        cell?.moreButton.isHidden = true
        cell?.msgLbl.numberOfLines = 0
        //cell?.removeConstraint(cell?.constForContViewwHieght ?? NSLayoutConstraint())
        cell?.constForMoreButtonHieght.constant = 0
        
        cell?.delegateObj = self
        
        //let url = URL(string: self.dataJson["ListItems"][index]["Attachment"].stringValue)
        //cell?.cellImage.kf.setImage(with: url, placeholder: nil)
        
        
        return cell ?? UITableViewCell()
    
    }
 

    func didTapOnAskListTCell(cellSelectedImage : UIImage) {
        
        let imageInfo = GSImageInfo(image: cellSelectedImage , imageMode: .aspectFit)
        let imageViewer = GSImageViewerController(imageInfo: imageInfo)
        present(imageViewer, animated: true)
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    
    }
    

}

