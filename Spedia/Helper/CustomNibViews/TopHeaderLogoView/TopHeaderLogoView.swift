//
//  TopHeaderLogoView.swift
//  Spedia
//
//  Created by Rahul Sharma on 22/01/22.
//  Copyright © 2022 Viraj Sharma. All rights reserved.
//

import UIKit
import SwiftyJSON
import Kingfisher

//protocol TopHeaderLogoViewDelegate {
    
//}


class TopHeaderLogoView: UIView {
    
    //0 Delegates...
    //var delegateObj : TopHeaderLogoViewDelegate?
    
    //1 Objects...
    @IBOutlet var containerVieww: UIView!
    @IBOutlet var appMainLogoImageView: UIImageView!
    @IBOutlet var scanQRCodeButton: UIButton!
    @IBOutlet var chatButton: UIButton!
    @IBOutlet var notificationButton: UIButton!
    
    //2 Points View
    @IBOutlet weak var pointsView: UIView!
    @IBOutlet weak var pointsPHLbl: CustomLabel!
    @IBOutlet weak var pointCountLbl: CustomLabel!
    @IBOutlet weak var profileContView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    
    
    //3 No Data View
    @IBOutlet var noDataView: UIView!
    @IBOutlet var noDataLbl: CustomLabel!
    @IBOutlet var noDataImageView: UIImageView!
    @IBOutlet var refreshButton: CustomButton!

    
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
    
    
    //2.1
    @IBAction func backButtonAction(_ sender: Any) {
        
        if let topController = UIApplication.topViewController() {
            topController.dismiss(animated: true, completion: nil)
        }
        
    }

    
    //2.2
    @IBAction func logoButtonAction(_ sender: Any) {
        //setRootView(tabBarIndex: 1)
    }
    
    @IBAction func refreshButtonAction(_ sender: Any) {
        setRootView(tabBarIndex: 0)
    }
    
    //2.3
    @IBAction func chatButtonAction(_ sender: Any) {
        
        if let topController = UIApplication.topViewController() {
            if let vc = ChatViewController.instantiate(fromAppStoryboard: .main) {
               vc.modalPresentationStyle = .fullScreen
               topController.present(vc, animated: true, completion: nil)
               //topController.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
    }
    
    
    //2.4
    @IBAction func notificationButtonAction(_ sender: Any) {
        
        if let topController = UIApplication.topViewController() {
            if let vc = NotificaitonViewController.instantiate(fromAppStoryboard: .main) {
               vc.modalPresentationStyle = .fullScreen
                vc.whereFromCome = WhereFromAmIKeys.bellIcon
               topController.present(vc, animated: true, completion: nil)
               //topController.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
    }
     
    
    //2.5
    @IBAction func qrCodeButtonAction(_ sender: Any) {
        
        if let topController = UIApplication.topViewController() {
            if let vc = ScannerViewController.instantiate(fromAppStoryboard: .main) {
               vc.modalPresentationStyle = .fullScreen
               topController.present(vc, animated: true, completion: nil)
               //topController.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
    }
    
    //3
    private func commonInit() {
                
        Bundle.main.loadNibNamed("TopHeaderLogoView", owner: self, options: nil)
        addSubview(containerVieww)
        
        self.layer.cornerRadius = 0
        self.clipsToBounds = true
        
        self.containerVieww.frame = self.bounds
        self.containerVieww.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.containerVieww.layer.cornerRadius = 0
        self.containerVieww.clipsToBounds = true
    
        //Set Up Done
        self.setUpView()
        self.refreshButton.isHidden = true
    }
    
    func setupForMyCourseView() {
        self.noDataLbl.text = "mycourse_no_data_found".localized()
        self.refreshButton.setTitle("go_home_ph".localized(), for: .normal)
        self.refreshButton.isHidden = false
        self.noDataImageView.image = UIImage.init(named: "my_course_no_data__pdf_bkg")
    }
    
    func setUpView() {
        self.noDataLbl.text = "no_data_found".localized()
        
        //Points View
        self.pointsView.layer.cornerRadius = self.pointsView.frame.height/2
        self.pointsView.clipsToBounds = true
        
        self.profileContView.layer.cornerRadius = self.profileContView.frame.height/2
        self.profileContView.clipsToBounds = true
        
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.height/2
        self.profileImageView.clipsToBounds = true
        
        let profileCacheImage = UserDefaults.standard.imageForKey(key: "profle_image_key")
        self.profileImageView.image = profileCacheImage
    
        self.pointsView.isHidden = true
    }
    
    
    func setupProfileViewNow(imageUrl: String, pointsObj: String) {
        self.pointsView.isHidden = true
        let url = URL(string: imageUrl)
        let profileCacheImage = UserDefaults.standard.imageForKey(key: "profle_image_key")
        self.profileImageView.kf.setImage(with: url, placeholder: profileCacheImage)
        UserDefaults.standard.setImage(image: self.profileImageView.image, forKey: "profle_image_key")
        
        let pointCache = UserDefaults.standard.string(forKey: "points_count_key")
        self.pointCountLbl.text = pointsObj.isEmpty ? pointCache : pointsObj
        UserDefaults.standard.set(pointsObj, forKey: "points_count_key")
        self.pointsPHLbl.text = "points_ph".localized()
        
        UIView.transition(with: self.pointsView, duration: 0.60,
                          options: .transitionCrossDissolve,
                          animations: {
            self.pointsView.isHidden = false
        })
        
    }
    
    
    @IBAction func profileButtonTapped(_ sender: Any) {
        if let topController = UIApplication.topViewController() {
            if let vc = ProfileViewController.instantiate(fromAppStoryboard: .main) {
               vc.modalPresentationStyle = .fullScreen
               //topController.present(vc, animated: true, completion: nil)
               topController.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
}


