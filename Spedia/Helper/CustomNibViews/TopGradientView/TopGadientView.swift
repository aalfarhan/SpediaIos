//
//  TopGadientView.swift
//  Spedia
//
//  Created by Viraj Sharma on 27/01/22.
//  Copyright © 2022 Viraj Sharma. All rights reserved.
//

import UIKit

protocol TopGadientViewDelegate {
    func leftRightButtonDidTapped(tagValue: Int)
}

class TopGadientView: UIView {
    
    //0 Delegates...
    var delegateObj : TopGadientViewDelegate?
    
    //1 Objects...
    @IBOutlet var containerVieww: UIView!
    @IBOutlet var backButton: UIButton!
    @IBOutlet var headerTitle: CustomLabel!
    
    //2 Left-Right Buttons
    @IBOutlet var buttonsStackView: UIStackView!
    @IBOutlet var leftSideButton: CustomButton!
    @IBOutlet var rightSideButton: CustomButton!
    @IBOutlet weak var buttonsStackViewWitdhConst: NSLayoutConstraint!
    
    //3 No Data View
    @IBOutlet var noDataView: UIView!
    @IBOutlet var noDataLbl: CustomLabel!
    @IBOutlet var refreshButton: CustomButton!
    
    //4 Data Objects
    var headerTitleStr = ""
    var whereFrom = ""
    
    
    //Responsive..
    @IBOutlet weak var heightConst: NSLayoutConstraint!
    @IBOutlet weak var headerTitleTopConst: NSLayoutConstraint!
    @IBOutlet weak var refreshButtonHeight: NSLayoutConstraint!
    
    //1
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    //2
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    //3
    @IBAction func backButtonAction(_ sender: Any) {
        
        if whereFrom == WhereFromAmIKeys.navigationBottomBar  {
            
            if let topController = UIApplication.topViewController() {
                topController.navigationController?.popViewController(animated: true)
            }
            
        } else {
            if let topController = UIApplication.topViewController() {
                topController.dismiss(animated: true, completion: nil)
            }
        }
        
    }

    //4
    private func commonInit() {
                
        Bundle.main.loadNibNamed("TopGadientView", owner: self, options: nil)
        addSubview(containerVieww)
        
        self.layer.cornerRadius = 0
        self.clipsToBounds = true
        
        self.containerVieww.frame = self.bounds
        self.containerVieww.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.containerVieww.layer.cornerRadius = 0
        self.containerVieww.clipsToBounds = true
    
        //Set Up Done
        self.setUpView()
        
        
        self.refreshButton.layer.cornerRadius = 20.0
        self.refreshButton.clipsToBounds = true
    }
    
    
    func setUpView() {
        
        //0
        // For Defualt
        self.heightConst.constant = 70.0
        self.buttonsStackView.isHidden = true
        self.buttonsStackViewWitdhConst.constant = 325
        
        //1
        self.headerTitle.text = self.headerTitleStr
        
        //Note: 15px is top space
        //self.headerTitleTopConst.constant = CGFloat(15 / self.headerTitle.numberOfLines)
        //self.heightConst.constant = self.headerTitle.numberOfLines > 1 ? 120 : 70
        
        self.backButton.imageView?.transform =  L102Language.isCurrentLanguageArabic() ? CGAffineTransform(scaleX: -1.0, y: 1.0) : CGAffineTransform(scaleX: 1.0, y: -1.0)

        self.noDataLbl.text = "no_data_found".localized()
        
    }
    
    
    //MARK: ======================================================
    //MARK: LEFT_RIGHT BUTTON SETUP
    //MARK: ======================================================
    //1
    @IBAction func leftButtonAction(_ sender: Any) {
        self.whiceButtonActiveWithTag(tag: 1)
    }
    
    //2
    @IBAction func rightButtonAction(_ sender: Any) {
        self.whiceButtonActiveWithTag(tag: 2)
    }
    
    
    //3
    func isForLiveClassHeader() {
        
        self.backButton.isHidden = true
        //1 Increase Height Of Green Area First
        self.heightConst.constant = UIDevice.isPhone ? 120 : 130 //figma
        self.buttonsStackViewWitdhConst.constant = UIDevice.isPhone ? 325 : 450 //figma
        self.buttonsStackView.isHidden = false
        
        //2 Give Button Title's
        self.leftSideButton.setTitle("active_classes".localized(), for: .normal)
        self.rightSideButton.setTitle("reserved_classes".localized(), for: .normal)
        
        //3 Active Button
        self.whiceButtonActiveWithTag(tag: whichLiveClassPageIndexGlobal)
        
        self.refreshButton.setTitle("refresh_button_ph".localized(), for: .normal)
    }
    

    //4
    func whiceButtonActiveWithTag (tag : Int) {
        
        //print("\n\nWhiceButtonActiveWithTag--->\(tag)\n")
        self.delegateObj?.leftRightButtonDidTapped(tagValue: tag)
        
        //MARK: Left Side Button 1st
        if tag == 1 {
           
            whichLiveClassPageIndexGlobal = 1
            self.leftSideButton.backgroundColor = .white
            self.leftSideButton.setTitleColor(Colors.APP_LIGHT_GREEN, for: .normal)
            
            self.rightSideButton.backgroundColor = .clear
            self.rightSideButton.setTitleColor(.white, for: .normal)
            
        //MARK: Right Side Button
        } else {
            
            whichLiveClassPageIndexGlobal = 2
            self.leftSideButton.backgroundColor = .clear
            self.leftSideButton.setTitleColor(.white, for: .normal)
                       
            self.rightSideButton.backgroundColor = .white
            self.rightSideButton.setTitleColor(Colors.APP_LIGHT_GREEN, for: .normal)
        
        }
    }
    
    
    //MARK: ======================================================
    //MARK: NO DATA SETUP
    //MARK: ======================================================
    func showNoDataView(showing: Bool) {
        if showing {
            self.noDataLbl.text = "no_data_found".localized()
            self.noDataView.isHidden = false
        } else {
            self.noDataView.isHidden = true
        }
    }
     
    @IBAction func refreshButtonAction(_ sender: Any) {
        self.leftButtonAction(self)
    }
    
    
}



/*
 func showNoDataView(showing: Bool) {
     
     if showing {
         self.noDataLbl.text = "page_not_found_try_later".localized()
         self.noDataView.isHidden = false
     } else {
         self.noDataView.isHidden = true
     }
     
 }
 */
