//
//  AppDelegate.swift
//  Spedia
//
//  Created by Viraj Sharma on 17/05/2020.
//  Copyright © 2020 Viraj Sharma. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import SVProgressHUD
import SwiftyJSON
import Firebase
import GoogleSignIn
import UserNotifications
import Siren
import JWPlayer_iOS_SDK
import Adjust
import SwiftyStoreKit

//Zoom Sdk:  1
import MobileRTC


//Push test

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {
    
    var window: UIWindow?
    var restrictRotation:UIInterfaceOrientationMask = .portrait
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
         
        //0
        L102Localizer.DoTheMagic()
        
        //let langCodeSet = UserDefaults.standard.string(forKey: "NEW_LANG_CODE_SET_IS_KEY") ?? "ar"
        //setSystemLangauge(code: langCodeSet, withAnimaiton: true)
        
        //1 Setup Loader View (SVHUD)
        self.setUpSVHUD()
        
        //2 FireBase Setup
        self.fireBaseSetup(app: application)
        
        //3 Call Setup
        self.zoomSDKSetup()
        
        //4 Check App Updates...
        let siren = Siren.shared
        siren.rulesManager = RulesManager(globalRules: .critical,
                                          showAlertAfterCurrentVersionHasBeenReleasedForDays: 0)
        siren.wail()
        
        
        //5 UI & Configatations Set Up...
        self.uiConfigataionAndDefualtSetting()
        

        //6 Adjust SDK Set UP
        self.setUpAdjustSDK()
        
        
        
        //7 JWPlayer SDK Set Up..
        JWPlayerController.setPlayerKey("MW+jaSTz1cwonb1t4A6+lptH2nTLVwUfV4NKypAAQoOegIVX")
        
        
        
        print("\n\n\n\n JWPlayerController----->",JWPlayerController.sdkVersion(), "\n\n")
        
        
        //MARK: Stop user from record videos or screen 1
        //Add Trigger 1
        UIScreen.main.addObserver(self, forKeyPath: "captured", options: .new, context: nil)
        
        
        //MARK: // IAP 1
        self.setUpInAppPurchasement()
        
        return true
        
    }
    
    
    //MARK: // IAP 2
    func setUpInAppPurchasement() {
        // see notes below for the meaning of Atomic / Non-Atomic
        SwiftyStoreKit.completeTransactions(atomically: false) { purchases in
            for purchase in purchases {
                switch purchase.transaction.transactionState {
                case .purchased, .restored:
                    if purchase.needsFinishTransaction {
                        // Deliver content from server, then:
                        SwiftyStoreKit.finishTransaction(purchase.transaction)
                    }
                // Unlock content
                case .failed, .purchasing, .deferred:
                    break // do nothing
                @unknown default:
                    print("\n\n\n\n 🚨 🚨 🚨 IAP Error Please check!!! 🚨 🚨 🚨\n\n\n")
                }
            }
        }
    }
    
    
   
    //MARK: Stop user from record videos or screen 3
    //Action of Trigger 3
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        
        if (keyPath == "captured") {
            
            let isCaptured = UIScreen.main.isCaptured

            if isCaptured && AppShared.object.isVideoOrZoomViewShowing {
              
                showRecordingError()
                
            } else {
                
            
            }
        }
    }
    
    
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
   
    func hyperCriticalRulesExample() {
        let siren = Siren.shared
        siren.rulesManager = RulesManager(globalRules: .critical,
                                          showAlertAfterCurrentVersionHasBeenReleasedForDays: 0)

        siren.wail { results in
            switch results {
            case .success(let updateResults):
                print("AlertAction ", updateResults.alertAction)
                print("Localization ", updateResults.localization)
                print("Model ", updateResults.model)
                print("UpdateType ", updateResults.updateType)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return self.restrictRotation
    }
    
    
    
    
    
    //MARK: - SetUp Adjust SDK
    func setUpAdjustSDK() {
        let yourAppToken = "s0tzgw3mwnpc" //OLF=> "8242moykko3k"
        let environment = ADJEnvironmentProduction
        //ADJEnvironmentSandbox ADJEnvironmentProduction
        let adjustConfig = ADJConfig(
            appToken: yourAppToken,
            environment: environment)
        
        //adjustConfig?.logLevel = ADJLogLevelDebug
        
        Adjust.appDidLaunch(adjustConfig)
        
    }
    
    
    
    // MARK: - setUpSVHUD
    func setUpSVHUD() {
        SVProgressHUD.setMaximumDismissTimeInterval(2.0)
        //SVProgressHUD.setInfoImage(#imageLiteral(resourceName: "icon_alert"))
        //SVProgressHUD.setImageViewSize(CGSize(width: 70, height: 70))
        //SVProgressHUD.setErrorImage(#imageLiteral(resourceName: "icon_alert"))

        SVProgressHUD.setFont(UIFont(name: "BOLD".localized(), size: 20) ??  UIFont.systemFont(ofSize: 26))

        SVProgressHUD.setBackgroundColor(UIColor.white)
        SVProgressHUD.setBorderColor(Colors.APP_LIME_GREEN ?? UIColor.black)
        SVProgressHUD.setForegroundColor(Colors.APP_LIME_GREEN ?? UIColor.black)
        SVProgressHUD.setBorderWidth(2.0)
    }
   
    
    
    
    // MARK: - ZoomSDKSetup
    
    //Zoom Sdk:  2
    func zoomSDKSetup() {
        
        let mainSDK = MobileRTCSDKInitContext()
        mainSDK.domain = "zoom.us"
        MobileRTC.shared().setLanguage("en")
        MobileRTC.shared().isSupportedCustomizeMeetingUI()
        MobileRTC.shared().initialize(mainSDK)
        let authService = MobileRTC.shared().getAuthService()
        //print("Current Verison IS: ", MobileRTC.shared().mobileRTCVersion())
        authService?.delegate = self as? MobileRTCAuthDelegate
        authService?.clientKey = ZoomConts.clientKey
        authService?.clientSecret = ZoomConts.clientSecret
        authService?.sdkAuth()
        
    }
    

    // MARK: - FireBaseSetup
    func fireBaseSetup(app: UIApplication) {
        
        //Init..
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        googleSignInSetup()
        
        
        //...
        if #available(iOS 10.0, *) {
            
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            app.registerUserNotificationSettings(settings)
        }
        
        app.registerForRemoteNotifications()
    }
    
    
    
    
    
    
    // MARK: - Google Sign In Setup
    
    func googleSignInSetup() {
        
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        GIDSignIn.sharedInstance().clientID = clientID
        
    }
    
    @available(iOS 9.0, *)
    func application(_ application: UIApplication, open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any])
      -> Bool {
        return GIDSignIn.sharedInstance().handle(url)
    }
    
    
    
    
    // MARK: - UI Configrations And Setup
    func uiConfigataionAndDefualtSetting() {
        
        IQKeyboardManager.shared.enable = true
        
        loadUserData()
        
        
        if isLoginGlobal ?? false {
            if isParentGlobal {
                setParentRootView()
                //setRootView(tabBarIndex: 0)
            } else {
                
                if startWithPage == StartWithPageType.universityHome {
                   setUniversityRootView(tabBarIndex: 0)
                } else {
                   setRootView(tabBarIndex: 0)
                }
                
            }
            
        } else {
            
            if !UserDefaults.standard.bool(forKey: "isOnboardingFirstTimeKey") {
                setOnboardingRoot()
            }
        }
        
    
    
         //For Dark Mode..
         if #available(iOS 13.0, *) {
             window!.overrideUserInterfaceStyle = .light
         } else {
             // Fallback on earlier versions...
         }
         
         //let code = Locale.autoupdatingCurrent.languageCode
         //let code2 = Locale.preferredLanguages[0]
         //print("\n\n\n\n Coming Coming------->", code ?? "NODATATATA")
         //print("\n\n\n\n Coming Coming2 ------->", code2 )
    
        //FIXME: LATER CRASHING THE APP
         //UI TAB BAR...
         /*let size = CGFloat(UIDevice.isPad ? 15.0 : 11.0)
         let appearance = UITabBarItem.appearance()
         let attributes = [NSAttributedString.Key.font:UIFont(name: "SEMIBOLD".localized(), size: size)]
         appearance.setTitleTextAttributes(attributes as [NSAttributedString.Key : Any], for: .normal)*/
        
        
        
        //Key Board
        
        
        //Segment Controller
        
        
        //UISegmentedControl.appearance().setTitleTextAttributes(attr as! [NSAttributedString.Key : Any], forState: .Normal)
        
    
        //UNUserNotificationCenter.current().requestAuthorization(options: .badge) { (granted, error) in
            //if error != nil {
                
            //}
        //}
        
        
    }
    
    
    
    
    
    
    // MARK: - Core Data stack
    /*
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Spedia")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    */
    
    
    
    /*
    func selectArAppDelegate() {
        
        //if L102Language.isCurrentLanguageArabic() == false {
            L012Localizer.DoTheSwizzling()
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
            L102Language.setAppleLAnguageTo(lang: "ar")
        //}
        
        UIView.appearance().semanticContentAttribute = L102Language.isCurrentLanguageArabic() ? .forceRightToLeft : .forceLeftToRight
    
    }
    

    func selectEnAppDelegate() {
        
        //if L102Language.isCurrentLanguageArabic() == false {
            L012Localizer.DoTheSwizzling()
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
            L102Language.setAppleLAnguageTo(lang: "en")
        //}
        
        UIView.appearance().semanticContentAttribute = L102Language.isCurrentLanguageArabic() ? .forceRightToLeft : .forceLeftToRight
    
    }
    */
    
}








// MARK: - Notificaiton Delegate OR Redireciton Proccess

@available(iOS 10, *)
extension AppDelegate  {
    
    //1
    //=========================
    //IF APP IS OPEN WIL CALL
    //=========================
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        let userInfo = notification.request.content.userInfo
    
        print("\n\n Notificaiton Data====> \(userInfo)\n\n")

        
        let redirectTo = userInfo["page_type"] as? String ?? "NotificationPage" //nothing
        
        let meetingId = userInfo["liveClassMeetingID"] as? String ?? ""
        
        print("\n\n\n\nOpen Notfication Redirectional====> \(redirectTo)")
        
        if !redirectTo.isEmpty && redirectTo == "ReservedLiveClass" {

          whichLiveClassPageIndexGlobal = 2
            
          NotificationCenter.default.post(name: Notification.Name("liveClassNotificationIdentifier"), object: nil, userInfo: ["New":"Data"])
        
        }  else if redirectTo == "JoinLiveClassFromPopup" {
            
            if isLoginGlobal ?? false {
                if let topController = UIApplication.topViewController() {
                    
                    print("\n\n\n\n MeetingId ====> \(meetingId)")
                    
                    if let vc = JoinLiveClassPopUpViewController.instantiate(fromAppStoryboard: .main) {
                        vc.modalPresentationStyle = .overFullScreen
                        vc.meetingId = Int(meetingId) ?? 0
                        topController.present(vc, animated: true, completion: nil)
                        //topController.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            }
        }
        
        else if redirectTo == "ExpiryReminder" {
            
            let reminderID = userInfo["ReminderID"] as? Int ?? 0
            
            if reminderID > 0 {
                AppShared.object.getSubscriptionDataNow(reminderId: reminderID)
            }
            
        }
      
        completionHandler([.alert, .badge, .sound])
         
        
    }

    
    
    //2
    //=========================
    //IF APP IS OPEN WIL CALL
    //=========================
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let userInfo = response.notification.request.content.userInfo
       
        // Print full message.
        print(userInfo)
        
    
        completionHandler()
        
        //let state = UIApplication.shared.applicationState
        //if state == .active || state == .background {
        //timeValue = 1.0
        //}
        //timeValue = 1.0
        
        
        let redirectTo = userInfo["page_type"] as? String ?? "NotificationPage"
        
        let meetingId = userInfo["liveClassMeetingID"] as? String ?? ""
        
        print("\n\n\n\nNotfication Redirectional====> \(redirectTo)")
        
        if !redirectTo.isEmpty && redirectTo == "AskSpediaList" {
           
            setAskSpediaListAsRootView()
            
        } else if !redirectTo.isEmpty && redirectTo == "ReservedLiveClass" {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                
                whichLiveClassPageIndexGlobal = 2
                
                setLiveClassAsRootView()
            }
            
        } else if redirectTo == "JoinLiveClassFromPopup" { //JoinLiveClassFromPopup
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                if isLoginGlobal ?? false {
                    if let topController = UIApplication.topViewController() {
                        if let vc = JoinLiveClassPopUpViewController.instantiate(fromAppStoryboard: .main) {
                            vc.modalPresentationStyle = .overCurrentContext
                            vc.meetingId = Int(meetingId) ?? 0
                            topController.present(vc, animated: true, completion: nil)
                            //topController.navigationController?.pushViewController(vc, animated: true)
                        }
                    }
                }
                
            }
        
            
        } else if redirectTo == "ExpiryReminder" {
            
            /*let reminderID = userInfo["ReminderID"] as? Int ?? 0
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                if reminderID > 0 {
                    AppShared.object.getSubscriptionDataNow(reminderId: reminderID)
                }
            }
            */
        }
    
        else {
            
            setNotificationAsRootView()
        }
        
    }
    
    
    //3
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
      
        
      print("\n\n\n Firebase registration token: \(fcmToken)\n\n")

      //let dataDict:[String: String] = ["token": fcmToken]
      //NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
       
      if !fcmToken.isEmpty {
         UserDefaults.standard.set(fcmToken, forKey: "FCM_TOKEN_KEY")
      }
    
    }
    
    
}



