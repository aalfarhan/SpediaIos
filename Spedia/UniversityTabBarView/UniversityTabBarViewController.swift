//
//  UniversityTabBarViewController.swift
//  Spedia
//
//  Created by Viraj Sharma on 19/08/2021.
//  Copyright © 2021 Viraj Sharma. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class UniversityTabBarViewController: UITabBarController,UITabBarControllerDelegate {
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.tabBar.isHidden = true
        self.view.backgroundColor = UIColor.white
        
        //FIXME: LATER CRASHING THE APP
        //MARK: OVERRIDE: UI TAB BAR...
        /*let size = CGFloat(UIDevice.isPad ? 15.0 : 13.0)
        let appearance = UITabBarItem.appearance()
        let attributes = [NSAttributedString.Key.font:UIFont(name: "SEMIBOLD".localized(), size: size)]
        appearance.setTitleTextAttributes(attributes as [NSAttributedString.Key : Any], for: .normal)*/
        
        
        self.tabBarController?.delegate = self
        
        if isParentGlobal {
            var vcs = self.viewControllers
            vcs?.remove(at: 3)
            // No Need To ADD 4th Side Menu will be 3rd
            self.setViewControllers(vcs, animated: true)
        }
        
        self.setupView()
        
        self.getDataFromInitializeApp()
        
        
    }
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
        
    }
    
    
    
    private func getDataFromInitializeApp() {
        
        /*
        let urlString = initializeAppApi
        
        ServiceManager().getRequest(urlString, loader: false, parameters: [:]) { (status, jsonResponse) in
            
            
            if status {
                
                let dataJson = JSON.init(jsonResponse ?? "NO DATA")
                
                let baseURL = dataJson["BaseURL"].stringValue
            
                UserDefaults.standard.setValue(baseURL, forKey: "BASE_URL_KEY")
                UserDefaults.standard.synchronize()
            }
            
        }
        */
        
    }
    
    
    
    
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        let selectedTag = tabBar.selectedItem?.tag ?? 0
        print("\n\n\n\n Current Selected Tab Tag----> \(selectedTag)")
        
        if selectedTag == 1 { //Home Page
            setRootView(tabBarIndex: 0)
        }
        
        else if selectedTag == 3 { //Live Class Selectin
            whichLiveClassPageIndexGlobal = 1
        }
        
        else if selectedTag == 4 { //RPC Selectin
            whichRPCPageIndexGlobal = 2
        }
        
    }
    
    
    func selectedTabBarIndex(index : Int) {
        self.tabBarController?.selectedIndex = index
    }
    
    
    //Title Setup....
    private func setupView() {
        
        var i = 0
        
        let tabBarVCS = viewControllers
        
        for vcs in tabBarVCS ?? [] {
            
            if i == 0 {
                
                vcs.tabBarItem.image = #imageLiteral(resourceName: "icon_home_pdf")
                vcs.title = TabBarTitleStr().home
                
            }
            
            
            /*if i == 1 {
                
                vcs.title = TabBarTitleStr().profile
                
                vcs.tabBarItem.image = #imageLiteral(resourceName: "icon_profile_pdf")
                
            }*/
            
            
            if i == 1 {
            
                vcs.title = TabBarTitleStr().requestPrivate
                vcs.tabBarItem.image = #imageLiteral(resourceName: "icon_traning_pdf")
           
            }
            
            if i == 2 {
                
                if isParentGlobal {
                    
                    vcs.title = TabBarTitleStr().more
                    
                    vcs.tabBarItem.image = #imageLiteral(resourceName: "icon_menu_pdf")
                    
                } else {
                    
                    vcs.title = TabBarTitleStr().liveClass
                    
                    vcs.tabBarItem.image = #imageLiteral(resourceName: "icon_chat_pdf")
                    
                }
                
            }
            
            if i == 3 {
                
                vcs.title = TabBarTitleStr().more
                vcs.tabBarItem.image = #imageLiteral(resourceName: "icon_menu_pdf")
            }
            
            i = i + 1
            
            
            if UIDevice.isPad {
                
                vcs.tabBarItem.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                vcs.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -10)
                
            } else {
                
                if DeviceSize.statusBarHeight > 20 {
                    vcs.tabBarItem.imageInsets = UIEdgeInsets(top: 10, left: 0, bottom: -10, right: 0)
                    vcs.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 10)
                    
                } else {
                    vcs.tabBarItem.imageInsets = UIEdgeInsets(top: 2, left: 0, bottom: 2, right: 0)
                    vcs.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -7)
                    
                }
                
            }
            
        }
        
        self.tabBar.isHidden = false
        
    }
    
    
    /*
    func configureUINow() {
        
    
        if UIDevice.isPad {
            
            self.tabBarController?.tabBarItem.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            self.tabBarController?.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -10)
            
        } else {
            
            if DeviceSize.statusBarHeight > 20 {
                self.tabBarController?.tabBarItem.imageInsets = UIEdgeInsets(top: 10, left: 0, bottom: -10, right: 0)
                self.tabBarController?.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 10)
                
            } else {
                self.tabBarController?.tabBarItem.imageInsets = UIEdgeInsets(top: 2, left: 0, bottom: 2, right: 0)
                self.tabBarController?.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -7)
                
            }
            
        }
        
        self.setViewControllers(self.viewControllers, animated: true)
        self.tabBar.isHidden = false
    }
    */
    
    
}


/*
struct UniversityTitleStr {
    let library = "Library".localized()
    let cart = "My Cart".localized()
    let requestPrivate =  "rp_ph".localized()
    let more = "More".localized()
    let liveClass = "Live Class Tab".localized()
    let profile = "Profile".localized()
    let tabLeaderboard = "leaderboards".localized()
}
*/





