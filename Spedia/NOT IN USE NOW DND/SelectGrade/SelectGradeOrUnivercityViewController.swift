//
//  SelectGradeOrUnivercityViewController.swift
//  Spedia
//
//  Created by Viraj Sharma on 08/07/2020.
//  Copyright © 2020 Viraj Sharma. All rights reserved.
//

import UIKit
import SwiftyJSON

class SelectGradeOrUnivercityViewController: UIViewController {

    var selectedJSon = JSON()
    var tempUserID = Int()
    @IBOutlet weak var finishButton: CustomButton!
    @IBOutlet weak var listView: UITableView!
    var selectdIndex = -1
    var isUniversity = false
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleLbl: CustomLabel!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.finishButton.isEnabled = false
        self.finishButton.alpha = 0.5
        // Do any additional setup after loading the view.
       
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        backButton.imageView?.transform =  L102Language.isCurrentLanguageArabic() ? CGAffineTransform(scaleX: -1.0, y: 1.0) : CGAffineTransform(scaleX: 1.0, y: -1.0)
        //1
        //self.setupView()
        if isUniversity {
            self.titleLbl.text = L102Language.isCurrentLanguageArabic() ? "اختيار الجامعة" : "Select University"
            let nibName2 = UINib(nibName: "UnivercityTCell", bundle:nil)
            self.listView.register(nibName2, forCellReuseIdentifier: "univercityTCell")
            
        } else {
            self.titleLbl.text = L102Language.isCurrentLanguageArabic() ? "اختيار الصف" : "Select Grade"
            let nibName2 = UINib(nibName: "GradeTableCell", bundle:nil)
            self.listView.register(nibName2, forCellReuseIdentifier: "gradeTableCell")
            
        }
        
        
        self.finishButton.setTitle(L102Language.isCurrentLanguageArabic() ? "انهاء" : "FINISH", for: .normal)
        
    }
    
    
    
    @IBAction func finishButtonAction(_ sender: Any) {
        /*
        
            
            
            //UserDefaults.standard.synchronize()
            
            let loginResponse = JSON.init(guestDummyData)
        
            UserDefaults.standard.set(loginResponse.object, forKey: UserDefaultKeys.\)

            loadUserData()
            
            setRootView(tabBarIndex: 0)
            
        } else {
            
            if let vc = OTPViewController.instantiate(fromAppStoryboard: .main) {
                vc.modalPresentationStyle = .fullScreen
                vc.tempUserID = self.tempUserID
                vc.classID = self.selectedJSon[selectdIndex]["ClassID"].intValue
                
                self.present(vc, animated: true, completion: nil)
                
            } }
        */
    }
    
    
}




extension SelectGradeOrUnivercityViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.selectedJSon.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if isUniversity {
          let cell = self.listView.dequeueReusableCell(withIdentifier: "univercityTCell") as? UnivercityTCell
                      
          cell?.selectionStyle = .none
          
          if selectdIndex == indexPath.row {
            cell?.containerVieww.layer.borderColor = Colors.APP_LIME_GREEN?.cgColor
          } else {
            cell?.containerVieww.layer.borderColor = Colors.APP_BORDER_GRAY?.cgColor
          }
          cell?.configureViewWith(data: self.selectedJSon[indexPath.row])
          return cell ?? UITableViewCell()
        
        } else {
            let cell = self.listView.dequeueReusableCell(withIdentifier: "gradeTableCell") as? GradeTableCell
                        
            cell?.selectionStyle = .none
            
            cell?.checkImageView.isHidden = true
            cell?.roundImageView.isHidden = false
            if selectdIndex == indexPath.row {
                cell?.checkImageView.isHidden = false
                cell?.roundImageView.isHidden = true
            }
            
            cell?.nameLbl.text = L102Language.isCurrentLanguageArabic() ? self.selectedJSon[indexPath.row]["ClassNameAr"].stringValue : self.selectedJSon[indexPath.row]["ClassNameEn"].stringValue
            
            return cell ?? UITableViewCell()
        }
    }
 

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.finishButton.isEnabled = true
        self.finishButton.alpha = 1.0
        self.selectdIndex = indexPath.row
        self.listView.reloadData()

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
