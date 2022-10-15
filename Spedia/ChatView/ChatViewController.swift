//
//  ChatViewController.swift
//  Spedia
//
//  Created by Viraj Sharma on 14/07/2020.
//  Copyright © 2020 Viraj Sharma. All rights reserved.
//

import UIKit
import WebKit
import SVProgressHUD

class ChatViewController: UIViewController {

    //Header Objects....
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerTitle: CustomLabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var noDataLbl: CustomLabel!
    
    //WebView...
    @IBOutlet weak var webviewContainer: UIView!
    var wkWebView:WKWebView!
    
    //Web Page URL
    var webPageURLStr = "https://tawk.to/chat/5f0d915b5b59f94722bab0b5/default"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addWebView()
               
    }
        
    override func viewWillDisappear(_ animated: Bool) {
        SVProgressHUD.dismiss()
    }
    
    
    @IBAction func backButtonAction(_ sender: Any) {
       self.webviewContainer.isHidden = true
       self.dismiss(animated: true, completion: nil)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
           
      //0
      self.headerTitle.text = "Chat".localized()
      self.noDataLbl.text = ""
      SVProgressHUD.show()
      
      //1
      self.backButton.imageView?.transform =  L102Language.isCurrentLanguageArabic() ? CGAffineTransform(scaleX: -1.0, y: 1.0) : CGAffineTransform(scaleX: 1.0, y: -1.0)
          
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
        //https://tawk.to/chat/59cf27014854b82732ff2c98/default
        //"https://tawk.to/chat/5f0d915b5b59f94722bab0b5/default"
        let urlString = webPageURLStr
        if let url = URL(string: urlString){
            print("\n*****\n\n URL to load : \(url.absoluteString) \n\n*****\n")
            var urlRequest = URLRequest(url: url)
            urlRequest.timeoutInterval = 15.0
            wkWebView.load(urlRequest)
        }
    }


}

        



//MARK: - WKWebViewNavigationDelegate
extension ChatViewController: WKNavigationDelegate {
     
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
    }
    
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        SVProgressHUD.dismiss()
    }
     
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        
        SVProgressHUD.dismiss()
        self.webviewContainer.isHidden = true
        self.noDataLbl.text = "no_data_found".localized()
        
        /*
        if error.localizedDescription.contains("timed out") { // TIMED OUT:
            

        } else if error.localizedDescription.contains("cannot be found") {
           
        } else if error.localizedDescription.contains("url not found") {
            
        }
        */
    }
    
    
    /*
    private func webView(webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: NSError) {

            if error.code == -1001 { // TIMED OUT:

                // CODE to handle TIMEOUT
                print("CODE to handle TIMEOUT 1001")

            } else if error.code == -1003 { // SERVER CANNOT BE FOUND

                // CODE to handle SERVER not found
                print("CODE to handle SERVER not found 1003")

            } else if error.code == -1100 { // URL NOT FOUND ON SERVER

                // CODE to handle URL not found
                print("CODE to handle URL not found 1100")

            }
        }
     */
    
}
