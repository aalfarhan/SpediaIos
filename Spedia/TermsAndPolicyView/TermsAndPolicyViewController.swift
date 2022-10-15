//
//  TermsAndPolicyViewController.swift
//  Spedia
//
//  Created by Viraj Sharma on 15/07/2020.
//  Copyright © 2020 Viraj Sharma. All rights reserved.
//


import UIKit
import WebKit
import SVProgressHUD

class TermsAndPolicyViewController: UIViewController {

    //Header Objects....
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerTitle: CustomLabel!
    @IBOutlet weak var backButton: UIButton!
    
    //WebView...
    @IBOutlet weak var webviewContainer: UIView!
    var wkWebView:WKWebView!
    
    //Web Page URL
    var webPageURLStr = ContactUs.termsConditionCommonLink
    var type = ""
    var titleStr = ""
    
    //Other's
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addWebView()
    }
        
   
    @IBAction func backButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
      
    
    override func viewWillAppear(_ animated: Bool) {
            
      //1
      self.backButton.imageView?.transform =  L102Language.isCurrentLanguageArabic() ? CGAffineTransform(scaleX: -1.0, y: 1.0) : CGAffineTransform(scaleX: 1.0, y: -1.0)
    
      //2
      self.headerTitle.text = "terms_and_condition".localized()
        
      //3 Come's from others Views
      if !titleStr.isEmpty {
         self.headerTitle.text = titleStr
         //L102Language.isCurrentLanguageArabic() ? "Socail AR" : "Socail Media"
      }
      
        if type == "policy" {
            self.headerTitle.text = "privacy_policy".localized()

        }
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        SVProgressHUD.dismiss()
    }
    
    
    
    func addWebView() {
        
        wkWebView = WKWebView()
        wkWebView.navigationDelegate = self
        webviewContainer.addSubview(wkWebView)
        
        //add constraints
        wkWebView.translatesAutoresizingMaskIntoConstraints = false
        wkWebView.leadingAnchor.constraint(equalTo: webviewContainer.leadingAnchor, constant: 0).isActive = true
        wkWebView.trailingAnchor.constraint(equalTo: webviewContainer.trailingAnchor, constant: 0).isActive = true
        wkWebView.topAnchor.constraint(equalTo: webviewContainer.topAnchor, constant: 0).isActive = true
        wkWebView.bottomAnchor.constraint(equalTo: webviewContainer.bottomAnchor, constant: 0).isActive = true
        
        loadUrlInWebView()
    }
     
    
    
    func loadUrlInWebView() {
        let urlString = webPageURLStr
        if let url = URL(string: urlString){
            print("\n*****\n\n URL to load : \(url.absoluteString) \n\n*****\n")
            var urlRequest = URLRequest(url: url)
            urlRequest.timeoutInterval = 5.0
            wkWebView.load(urlRequest)
        }
    }

    
    
    
    

}

        



//MARK: - WKWebViewNavigationDelegate
extension TermsAndPolicyViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        SVProgressHUD.show()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        SVProgressHUD.dismiss()
    }
    
}

