//
//  PerentProfileViewController.swift
//  Spedia
//
//  Created by Viraj Sharma on 07/11/2020.
//  Copyright © 2020 Viraj Sharma. All rights reserved.
//

import UIKit

class PerentProfileViewController: UIViewController {
    
    @IBOutlet weak var parentNameLbl: CustomLabel!
    @IBOutlet weak var parentUsernameLbl: CustomLabel!
    @IBOutlet weak var parentPhoneNumberLbl: CustomLabel!
    
    @IBOutlet weak var backButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        //self.getLiveClassData()
        self.setUpViews()
        
        parentNameLbl.text = fullNameGlobal
        parentUsernameLbl.text = emailIdGlobal
        parentPhoneNumberLbl.text = mobileNoGlobal
        
    }
    
    
    @IBAction func backButtonAction(_ sender: Any) {
           self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func editButtonAction(_ sender: Any) {
        if let vc = EditParentProfileViewController.instantiate(fromAppStoryboard: .main) {
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    
    //MARK: UI & View SETUP
    func setUpViews() {
        
        //back button
        self.backButton.imageView?.transform =  L102Language.isCurrentLanguageArabic() ? CGAffineTransform(scaleX: -1.0, y: 1.0) : CGAffineTransform(scaleX: 1.0, y: -1.0)
        
        //...
        //self.gradeButton.setTitle("reserve_now".localized(), for: .normal)
        //self.headerTitleLbl.text = "no_reserved_data".localized()
        //self.headerSubTitleLbl.text = "no_reserved_data".localized()
        
    }
}
