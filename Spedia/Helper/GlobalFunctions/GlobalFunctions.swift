//
//  GlobalFunctions.swift
//  Spedia
//
//  Created by Viraj Sharma on 23/08/2021.
//  Copyright © 2021 Viraj Sharma. All rights reserved.
//

import Foundation
import GoogleSignIn
import SwiftyJSON
import AuthenticationServices
import Adjust
import SwiftyStoreKit
import SVProgressHUD

//import FirebaseUI FUIAuthDelegate

class GlobalFunctions: NSObject, GIDSignInDelegate, ASAuthorizationControllerPresentationContextProviding, ASAuthorizationControllerDelegate  {
    
    //ASAuthorizationControllerPresentationContextProviding
    //public class GlobalFunctions: UIViewController, GIDSignInDelegate {
    
    
    static let object: GlobalFunctions = GlobalFunctions()
    var topController = UIApplication.topViewController()
    
    func clickOnGoogleButton() {
        topController = UIApplication.topViewController()
        GIDSignIn.sharedInstance()?.presentingViewController = topController
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    
    func setAdjustEvent(eventName: String) {
        
        let event = ADJEvent(eventToken: eventName)
        Adjust.trackEvent(event)
        
    }
    
    
    
    //MARK:Google SignIn Delegate
    
    func signIn(_ signIn: GIDSignIn!,
                presentViewController viewController: UIViewController!) {
        topController?.present(viewController, animated: true, completion: nil)
    }
    
    func signIn(_ signIn: GIDSignIn!,
                dismissViewController viewController: UIViewController!) {
        topController?.dismiss(animated: true, completion: nil)
    }
    
    public func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
                     withError error: Error!) {
        if (error == nil) {
            // Perform any operations on signed in user here.
            let userId = user.userID                  // For client-side use only!
            //let idToken = user.authentication.idToken // Safe to send to the server
            let fullName = user.profile.name
            //let givenName = user.profile.givenName
            //let familyName = user.profile.familyName
            let email = user.profile.email
            
            // ...
            
            guard let userIdValue = userId else { return }
            
            self.loginWithSocailMediaId(socailMediaIdObj: userIdValue, socailMediaTypeObj: "google")
            
            fullNameGlobal = fullName ?? ""
            emailGlobal = email ?? ""
            
            
            print(userId ?? "")
            print(fullName ?? "")
            print(email ?? "")
            
        } else {
            print("\(error)")
        }
    }
    
    
    //MARK: Check Expired Subject With API
    func loginWithSocailMediaId(socailMediaIdObj: String, socailMediaTypeObj: String) {
        
        let urlString = socialMediaLogin
        
        let params = ["MediaID" : socailMediaIdObj] as [String : Any]
        
        ServiceManager().postRequest(urlString, loader: false, parameters: params) { (status, jsonResponse) in
            
            if status {
                
                var dataResponse = JSON.init(jsonResponse ?? "NO DTA")
                
                
                if dataResponse["IsRegistered"].boolValue {
                    
                    for item in dataResponse {
                        if item.1.type == .null {
                            print("key-->", item.0, "value--->",item.1)
                            dataResponse[item.0] = ""
                        }
                    }
                    
                    DispatchQueue.main.async {
                        self.parseDataNowGlobal(dataModel: dataResponse)
                    }
                    
                } else {
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        
                        if let topController = UIApplication.topViewController() {
                            if let vc = RegisterViewController.instantiate(fromAppStoryboard: .main) {
                                vc.modalPresentationStyle = .overFullScreen
                                vc.socailMediaId = socailMediaIdObj
                                vc.socailMediaType = socailMediaTypeObj
                                vc.isFromSocailMedia = true
                                topController.present(vc, animated: true, completion: nil)
                                //topController.navigationController?.pushViewController(vc, animated: true)
                            }
                        }
                        
                    }
                    
                }
                
                
                
                
            }
        }
        
    }
    
    
    func parseDataNowGlobal(dataModel: JSON) {
        
        UserDefaults.standard.set(dataModel.object, forKey: UserDefaultKeys.userPersonalDataKey)
        
        loadUserData()
        
        //Parent Check
        if isParentGlobal {
            setParentRootView()
            
        } else {
            
            if startWithPage == StartWithPageType.universityHome {
                setUniversityRootView(tabBarIndex: 0)
            } else {
                
                if startWithPage == StartWithPageType.liveClass {
                    setRootView(tabBarIndex: 2)
                } else {
                    setRootView(tabBarIndex: 0)
                }
                
            }
            
        }
        
        
    }
    
    
    
    //MARK: NEW FIREBASE UI SETUP
    /*
     func clickOnAppleSingInButton() {
     
     if let authUI = FUIAuth.defaultAuthUI() {
     authUI.providers = [FUIOAuth.appleAuthProvider()]
     authUI.delegate = self
     
     
     let authViewController = authUI.authViewController()
     topController?.present(authViewController, animated: true)
     }
     }
     
     
     //MARK: NEW FIREBASE UI SETUP
     func clickOnFacebookButton() {
     
     if let authUI = FUIAuth.defaultAuthUI() {
     authUI.providers = [FUIOAuth.appleAuthProvider()]
     authUI.delegate = self
     
     
     let authViewController = authUI.authViewController()
     topController?.present(authViewController, animated: true)
     }
     }
     
     
     func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
     
     if let user = authDataResult?.user {
     print("Nice you have signed in as \(user.uid), and you email \(user.email ?? "")")
     
     }
     }
     */
    
    
    
    //MARK:===================================
    //MARK: APPLE SIGN IN
    //MARK:===================================
    
    @available(iOS 13.0, *)
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return topController?.view.window ?? ((UIApplication.shared.delegate?.window)!)!
    }
    
    func clickOnAppleSingInButton() {
        
        /*let authorizationButton = ASAuthorizationAppleIDButton()
         authorizationButton.addTarget(self, action: #selector(handleAppleIdRequest), for: .touchUpInside)
         authorizationButton.cornerRadius = 10
         authorizationButton.frame = CGRect(x: 0, y: 0, width: self.appleSigninView.frame.width, height: self.appleSigninView.frame.height)
         authorizationButton.clipsToBounds = true
         authorizationButton.sizeToFit()
         //Add button on some view or stack
         self.appleSigninView.addSubview(authorizationButton)*/
        
        self.handleAppleIdRequest()
        
    }
    
    
    @objc func handleAppleIdRequest() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        if let appleIDCredential = authorization.credential as?  ASAuthorizationAppleIDCredential { //if success
            
            let userId = appleIDCredential.user
            let fullName = appleIDCredential.fullName?.familyName ?? ""
            let email = appleIDCredential.email ?? ""
            
            print("Apple user id=====>", userId)
            print("Apple fullname=====>", fullName)
            print("Apple email id=====>", email)
            
            if !userId.isEmpty {
                self.loginWithSocailMediaId(socailMediaIdObj: userId, socailMediaTypeObj: SocailMediaType.apple)
                
                fullNameGlobal = fullName
                emailGlobal = email
                
            }
        }
        
    }
    
    
    
    //MARK:===================================
    //MARK: APPLE Payment (IAP)
    //MARK:===================================
    
    // IAP 3
    func makeIAPNonAtomicPaymentNow(productIdStr: String) {
        
        win.isUserInteractionEnabled = false
        SVProgressHUD.show(withStatus: "please_wait_loading".localized())
        
        SwiftyStoreKit.purchaseProduct(productIdStr, quantity: 1, atomically: true) { result in
            switch result {
            case .success(let product):
                
                // fetch content from your server, then:
                if product.needsFinishTransaction {
                    SwiftyStoreKit.finishTransaction(product.transaction)
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.getTransactionRecieptNow()
                }
                
                
            case .error(let error):
                
                win.isUserInteractionEnabled = true
                SVProgressHUD.dismiss()
                if let topController = UIApplication.topViewController() {
                    topController.showAlert(alertText: "", alertMessage: "apple_payment_error".localized())
                }

                
                switch error.code {
                case .unknown: print("Unknown error. Please contact support")
                case .clientInvalid: print("Not allowed to make the payment")
                case .paymentCancelled: break
                case .paymentInvalid: print("The purchase identifier was invalid")
                case .paymentNotAllowed: print("The device is not allowed to make the payment")
                case .storeProductNotAvailable: print("The product is not available in the current storefront")
                case .cloudServicePermissionDenied: print("Access to cloud service information is not allowed")
                case .cloudServiceNetworkConnectionFailed: print("Could not connect to the network")
                case .cloudServiceRevoked: print("User has revoked permission to use this cloud service")
                default: print((error as NSError).localizedDescription)
                }
            }
        }
        
    }
    
    
    private func getTransactionRecieptNow() {
        
        SwiftyStoreKit.fetchReceipt(forceRefresh: true) { result in
            switch result {
            case .success(let receiptData):
                
                win.isUserInteractionEnabled = true
                SVProgressHUD.dismiss()
                
                let encryptedReceipt = receiptData.base64EncodedString(options: [])
                print("Fetch receipt success:\n\(encryptedReceipt)")
                
                self.applePaymentSuccessCallApiNow(recieptToken: encryptedReceipt, receiptDataObj: receiptData)
                
            case .error(let error):
                win.isUserInteractionEnabled = true
                SVProgressHUD.dismiss()
                
                if let topController = UIApplication.topViewController() {
                    topController.showAlert(alertText: "", alertMessage: "apple_payment_error".localized())
                }
                print("Fetch receipt failed: \(error)")
            }
        }
        
    }
    
    private func applePaymentSuccessCallApiNow(recieptToken: String, receiptDataObj: Data) {
        
        //MARK:Adjust Event Set 107 Apple Payment done: New
        self.setAdjustEvent(eventName: "r4yzmz")
            
        win.isUserInteractionEnabled = true
        SVProgressHUD.dismiss()
        
        let urlString = applePaymentDoneDirect
        
        let params = ["SessionToken" : sessionTokenGlobal ?? "",
                      "StudentID" : studentIdGlobal ?? 0,
                      "SubjectPriceID": globalSubjectPriceIdIAP,
                      "IsPrivateClassRequest": globalIsPrivateClassTypeIAP,
                      "CouponCode": "",
                      "ApplePayToken": recieptToken] as [String : Any]
        
        
        ServiceManager().postRequest(urlString, loader: false, parameters: params) { (status, jsonResponse) in
            
            if status {
                
                //let dataRes = JSON.init(jsonResponse ?? "NO DTA")
                
            }
            
        }
    }
    
    
    func guestCheckPopUp() {
        // Create the alert controller
        let alertController = UIAlertController(title: "", message: guestUserMsgGlobal, preferredStyle: .alert)
        
        // Create the actions
        let okAction = UIAlertAction(title: "YES".localized(), style: UIAlertAction.Style.default) {
            UIAlertAction in
            NSLog("OK Pressed")
            
            //if isParentGlobal {
                //setParentRootView()
            //} else {
             logoutNow()
            //}
        }
                
        let cancelAction = UIAlertAction(title: "NO".localized(), style: UIAlertAction.Style.cancel) {
            UIAlertAction in
            NSLog("Cancel Pressed")
        }
        
        // Add the actions
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        // Present the controller
        if let topView = UIApplication.topViewController() {
             
            topView.present(alertController, animated: true, completion: nil)

        }
        
    }
}
 

