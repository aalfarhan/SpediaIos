//
//  SideMenuViewController.swift
//  Spedia
//
//  Created by Viraj Sharma on 29/05/2020.
//  Copyright © 2020 Viraj Sharma. All rights reserved.
//

import UIKit
import SVProgressHUD
import SwiftyJSON

struct MenuType {
    static let myProfile = "My Profile"
    static let askSpedia = "Ask Teacher"
    static let chat = "Chat"
    static let contactUs = "Contact Us"
    static let notificaiton = "Notification"
    static let homework = "Home Work"
    static let bookmark = "Saved Videos"
    static let terms = "Terms and Conditions"
    static let logout = "Logout"
    static let arabic = "العربية"
    static let english = "English"
    static let timeline = "Timeline"
    static let leaderboard = "Board of Honor"
    static let policy = "Privacy Policy"
    static let skills = "Skill Analysis"
    static let statistics = "Statistics"

}


class SideMenuViewController: UIViewController {

    
    @IBOutlet weak var headerTitleLbl: CustomLabel!
    @IBOutlet weak var listView: UITableView!
    @IBOutlet weak var shareOurAppButton: CustomLabel!
    
    //New Order
    var dataArrayEn = ["العربية", "My Profile", "Ask Teacher", "Home Work", "Saved Videos" , "Notification", "Statistics", "Timeline", "Board of Honor", "Chat", "Contact Us",  "Terms and Conditions", "Privacy Policy", "Logout"]
        
    //old
    //let dataArrayAr =  ["English" , "حسابي", "اسأل معلم", "الواجبات", "الفيديوهات المحفوظة", "الإشعارات", "الإحصائيات", "سجل النشاط" ,"لوحة الشرف", "مساعدة ", "اتصل بنا","الشروط والأحكام", "سياسة الخصوصية", "تسجيل خروج"]
    //new
    var dataArrayAr = ["English" , "حسابي", "اسأل المعلم", "الواجبات", "الفيديوهات المحفوظة", "الإشعارات", "الإحصائيات", "سجل النشاط" ,"لوحة الشرف", "مساعدة ", "اتصل بنا","الشروط والأحكام", "سياسة الخصوصية", "تسجيل خروج"]
    
    var dataJson = JSON()
    var oneTimeQuizTitle = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: true)
        getOneTimeQuizData()
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //1
        let nibName = UINib(nibName: "MoreTableCell", bundle:nil)
        self.listView.register(nibName, forCellReuseIdentifier: "moreTableCell")
        
        //2
        self.headerTitleLbl.text = "More".localized()
        
        //3
        self.shareOurAppButton.text = "share_our_app_ph".localized()
    
        //L102Language.currentAppleLanguage()
        //print("\n\n\n\n lang code is------>", L102Language.isCurrentLanguageArabic())
        
    }
    
    

    @IBAction func logoutAction(_ sender: Any) {
        
    }
    
    
    @IBAction func shareButtonAction(_ sender: Any) {
        
        let str = """
        لقد استفدت جدا باشتراكي في تطبيق سبيديا التعليمي و ها أنا أدعوك لخوض هذه التجربة الممتعة
        I can't wait to share with you this interesting & useful experience

        iOS : https://apps.apple.com/us/app/spedia/id1524345281

        Android : https://play.google.com/store/apps/details?id=com.kw.spedia
        """
        
        UIApplication.share(str)
    }
    
    
}




//===================================
//MARK: TABLE VIEW
//===================================

extension SideMenuViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArrayEn.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.listView.dequeueReusableCell(withIdentifier: "moreTableCell") as? MoreTableCell
        
        cell?.selectionStyle = .none
        
        cell?.titleLbl.text = L102Language.isCurrentLanguageArabic() ? dataArrayAr[indexPath.row] : dataArrayEn[indexPath.row]
        
        cell?.menuTabButton.tag = indexPath.row
        cell?.menuTabButton.addTarget(self, action: #selector(didTapOnMenuButton(sender:)), for: .touchUpInside)
                
        
        return cell ?? UITableViewCell()
        
    }
    
    
    
    @objc func didTapOnMenuButton(sender: UIButton) {
        
        let selectedStr = self.dataArrayEn[sender.tag]
        
        print("-------->", selectedStr)
        
        switch selectedStr {
        
        case MenuType.myProfile:
                        
            if isGuestLoginGlobal {
                GlobalFunctions.object.guestCheckPopUp()
            } else {

            if let vc = ProfileViewController.instantiate(fromAppStoryboard: .main) {
                vc.modalPresentationStyle = .fullScreen
                vc.hidesBottomBarWhenPushed = false
                self.navigationController?.pushViewController(vc, animated: true)
              }
            }
            
        case MenuType.askSpedia:
            if let vc = AskSpediaListViewController.instantiate(fromAppStoryboard: .main) {
                vc.modalPresentationStyle = .fullScreen
                //self.present(vc, animated: true, completion: nil)
                vc.hidesBottomBarWhenPushed = false
                self.navigationController?.pushViewController(vc, animated: true)
              
            }
        case MenuType.notificaiton:
            if let vc = NotificaitonViewController.instantiate(fromAppStoryboard: .main) {
                vc.modalPresentationStyle = .fullScreen
                vc.hidesBottomBarWhenPushed = false
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        case MenuType.chat:
            if let vc = ChatViewController.instantiate(fromAppStoryboard: .main) {
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            }
        case MenuType.contactUs:
            
            //ContactUsViewController
            if let vc = ContactUsViewController.instantiate(fromAppStoryboard: .main) {
                //vc.modalPresentationStyle = .overFullScreen
                vc.modalPresentationStyle = .fullScreen
                vc.hidesBottomBarWhenPushed = false
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        case MenuType.terms:
            if let vc = TermsAndPolicyViewController.instantiate(fromAppStoryboard: .main) {
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            }
            
        case MenuType.bookmark:
            
            if let vc = BookmarkViewController.instantiate(fromAppStoryboard: .main) {
                vc.modalPresentationStyle = .fullScreen
                vc.hidesBottomBarWhenPushed = false
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        case MenuType.homework:
            
            if let vc = HomeWorkNewViewController.instantiate(fromAppStoryboard: .main) {
                vc.modalPresentationStyle = .fullScreen
                vc.hidesBottomBarWhenPushed = false
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        case MenuType.timeline:
            if let vc = TimelineViewController.instantiate(fromAppStoryboard: .main) {
                vc.modalPresentationStyle = .fullScreen
                vc.hidesBottomBarWhenPushed = false
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        
            
        case MenuType.statistics:
            if let vc = StatisticsViewController.instantiate(fromAppStoryboard: .main) {
                vc.modalPresentationStyle = .fullScreen
                vc.hidesBottomBarWhenPushed = false
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
            
        case MenuType.policy :
          
            if let vc = TermsAndPolicyViewController.instantiate(fromAppStoryboard: .main) {
                    vc.modalPresentationStyle = .fullScreen
                    vc.webPageURLStr = ContactUs.privacyPolicyCommonLink
                    vc.type = "policy"
                    self.present(vc, animated: true, completion: nil)
                }
            
        
            
        case MenuType.leaderboard:
            if let vc = LeaderViewController.instantiate(fromAppStoryboard: .main) {
                vc.modalPresentationStyle = .fullScreen
                vc.hidesBottomBarWhenPushed = false
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        case MenuType.logout:
            self.showLogOutPopUp()
        case MenuType.arabic:
            self.showChangeLanguagePopUP()
        case MenuType.english:
            self.showChangeLanguagePopUP()
        default:
            
            if selectedStr == oneTimeQuizTitle {
                AppShared.object.quizIDGlobal = self.dataJson["OneTimeQuiz"][0]["QuizID"].intValue
                AppShared.object.quizStatusGloabl = self.dataJson["OneTimeQuiz"][0]["Pending"].stringValue
                if let vc = QuestionViewController.instantiate(fromAppStoryboard: .main) {
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true, completion: nil)
                }
            }
            
            break
        }
        
        
    }
    
    

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
        
    }
    
    
    
    func showLogOutPopUp() {
        // Create the alert controller
        let alertController = UIAlertController(title: "", message: "ARE_YOU_SURE".localized(), preferredStyle: .alert)
        
        // Create the actions
        let okAction = UIAlertAction(title: "YES".localized(), style: UIAlertAction.Style.default) {
            UIAlertAction in
            NSLog("OK Pressed")
            
            if isParentGlobal {
                setParentRootView()
            } else {
            logoutNow()
            }
        }
        let cancelAction = UIAlertAction(title: "NO".localized(), style: UIAlertAction.Style.cancel) {
            UIAlertAction in
            NSLog("Cancel Pressed")
        }
        
        // Add the actions
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        // Present the controller
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    
    func showChangeLanguagePopUP() {
        // Create the alert controller
        
        let alertController = UIAlertController(title: "select_lang".localized(), message: "", preferredStyle: .alert)
        
        // Create the actions
        let okAction = UIAlertAction(title: "lang_yes_pop".localized(), style: UIAlertAction.Style.default) {
            UIAlertAction in
            NSLog("OK Pressed")
            
            if L102Language.isCurrentLanguageArabic() {
                //self.onClickEnglish()
                AppShared.object.updateLangNow(didSetRoot: true, isStaticSetEnAr: "en")
            } else {
                //self.onClickAr()
                AppShared.object.updateLangNow(didSetRoot: true, isStaticSetEnAr: "ar")
            }
        
        }
        
        
        let cancelAction = UIAlertAction(title: "lang_no_pop".localized(), style: UIAlertAction.Style.cancel) {
            UIAlertAction in
            NSLog("Cancel Pressed")
        }
        
        // Add the actions
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        // Present the controller
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    @IBAction func onClickEnglish() {
        
        L102Language.setAppleLAnguageTo(lang: "en")
        UIView.appearance().semanticContentAttribute = .forceLeftToRight

        if startWithPage == StartWithPageType.universityHome {
           setUniversityRootView(tabBarIndex: 0)
        } else {
           
           if startWithPage == StartWithPageType.liveClass {
               setRootView(tabBarIndex: 2)
           } else {
               setRootView(tabBarIndex: 0)
           }
           
        }
        
        let mainwindow = (UIApplication.shared.delegate?.window!)!
        mainwindow.backgroundColor = UIColor(hue: 0.6477, saturation: 0.6314, brightness: 0.6077, alpha: 0.8)
        UIView.transition(with: mainwindow, duration: 0.55001, options: .transitionFlipFromLeft, animations: { () -> Void in
        }) { (finished) -> Void in
            
        }
        
        L102Language.setAppleLAnguageTo(lang: "en")
        UIView.appearance().semanticContentAttribute = .forceLeftToRight
        
        //FIXME: LATER CRASHING THE APP
        //UI TAB BAR...
        /*let size = CGFloat(UIDevice.isPad ? 15.0 : 13.0)
        let appearance = UITabBarItem.appearance()
        let attributes = [NSAttributedString.Key.font:UIFont(name: "SEMIBOLD".localized(), size: size)]
        appearance.setTitleTextAttributes(attributes as [NSAttributedString.Key : Any], for: .normal)*/
        
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
    }
     
    
    
    @IBAction func onClickAr() {
        
    
        L102Language.setAppleLAnguageTo(lang: "ar")
        UIView.appearance().semanticContentAttribute = .forceRightToLeft

        
        if startWithPage == StartWithPageType.universityHome {
           setUniversityRootView(tabBarIndex: 0)
        } else {
           
           if startWithPage == StartWithPageType.liveClass {
               setRootView(tabBarIndex: 2)
           } else {
               setRootView(tabBarIndex: 0)
           }
           
        }
        
        
        let mainwindow = (UIApplication.shared.delegate?.window!)!
        mainwindow.backgroundColor = UIColor(hue: 0.6477, saturation: 0.6314, brightness: 0.6077, alpha: 0.8)
        UIView.transition(with: mainwindow, duration: 0.55001, options: .transitionFlipFromLeft, animations: { () -> Void in
        }) { (finished) -> Void in
            
        }
        
        L102Language.setAppleLAnguageTo(lang: "ar")
        UIView.appearance().semanticContentAttribute = .forceRightToLeft
        
        //FIXME: LATER CRASHING THE APP
        //UI TAB BAR...
        /*let size = CGFloat(UIDevice.isPad ? 15.0 : 13.0)
        let appearance = UITabBarItem.appearance()
        let attributes = [NSAttributedString.Key.font:UIFont(name: "SEMIBOLD".localized(), size: size)]
        appearance.setTitleTextAttributes(attributes as [NSAttributedString.Key : Any], for: .normal)*/
        
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
    }
    

    
}




extension UIApplication {
    class var topViewController: UIViewController? { return getTopViewController() }
    private class func getTopViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController { return getTopViewController(base: nav.visibleViewController) }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController { return getTopViewController(base: selected) }
        }
        if let presented = base?.presentedViewController { return getTopViewController(base: presented) }
        return base
    }

    private class func _share(_ data: [Any],
                              applicationActivities: [UIActivity]?,
                              setupViewControllerCompletion: ((UIActivityViewController) -> Void)?) {
        let activityViewController = UIActivityViewController(activityItems: data, applicationActivities: nil)
        setupViewControllerCompletion?(activityViewController)
        UIApplication.topViewController?.present(activityViewController, animated: true, completion: nil)
    }

    class func share(_ data: Any...,
                     applicationActivities: [UIActivity]? = nil,
                     setupViewControllerCompletion: ((UIActivityViewController) -> Void)? = nil) {
        _share(data, applicationActivities: applicationActivities, setupViewControllerCompletion: setupViewControllerCompletion)
    }
    class func share(_ data: [Any],
                     applicationActivities: [UIActivity]? = nil,
                     setupViewControllerCompletion: ((UIActivityViewController) -> Void)? = nil) {
        _share(data, applicationActivities: applicationActivities, setupViewControllerCompletion: setupViewControllerCompletion)
    }
}

extension SideMenuViewController {
    
    func getOneTimeQuizData() {
                
        let urlString = getOneTimeQuizApi
          
        let params = ["SessionToken" : sessionTokenGlobal ?? "",
                      "ClassID" : classIdGlobal ?? "",
                      "StudentID" : studentIdGlobal ?? 0] as [String : Any]
        
    
        ServiceManager().postRequest(urlString, loader: true, parameters: params) { (status, jsonResponse) in
             
            if status {
                
                self.dataJson = JSON.init(jsonResponse ?? "NO DTA")
                if self.dataJson.count > 0 && self.dataJson["ShowOneTimeQuiz"].boolValue {
                    self.oneTimeQuizTitle = self.dataJson["OneTimeQuizButtonEn"].stringValue
                    self.dataArrayEn.insert(self.dataJson["OneTimeQuizButtonEn"].stringValue, at: 2)
                    self.dataArrayAr.insert(self.dataJson["OneTimeQuizButtonAr"].stringValue, at: 2)
                    self.listView.reloadData()
                } else {
                    self.oneTimeQuizTitle = ""
                }
            }
        }
        
        
    }
}
