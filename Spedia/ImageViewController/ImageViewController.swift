//
//  ImageViewController.swift
//  Spedia
//
//  Created by mac on 13/10/22.
//  Copyright © 2022 Viraj Sharma. All rights reserved.
//

import UIKit
import SVProgressHUD
import WebKit

class ImageViewController: UIViewController {
    
    @IBOutlet weak var headerNavView : UIView!
    @IBOutlet weak var documentWebView : WKWebView!
    @IBOutlet weak var imgView : UIImageView!
    @IBOutlet weak var backBtn:UIButton!
    @IBOutlet weak var downloadButton: UIButton!
    
    var pdfString = String()
    var isCommingFromQuizzWithPdf = false
    
    
    //Download...
    var isFromHomeWorkDownload = false
    var homeWorkId = 0
    
    var isFromVideoPage = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imgView.isHidden = false
        documentWebView.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //SVProgressHUD.dismiss()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.downloadButton.isHidden = true
        
        //self.documentURL = URL(string: "\(self.pdfString)".addingPercentEncoding(withAllowedCharacters:.urlQueryAllowed) ?? "")
        self.backBtn.imageView?.transform =  L102Language.isCurrentLanguageArabic() ? CGAffineTransform(scaleX: -1.0, y: 1.0) : CGAffineTransform(scaleX: 1.0, y: -1.0)
        self.loadVideoPlayer()
    
        if !self.isFromVideoPage {
            isPdfDownloadedSuccessGlobal = false
        }
        
        self.headerNavView.isHidden = self.isFromVideoPage
    }
    
    func loadVideoPlayer() {
                
        if !self.isFromVideoPage {
            self.pdfString = "\(self.pdfString)".addingPercentEncoding(withAllowedCharacters:.urlQueryAllowed) ?? ""
        }
        
        ServiceManager().downloadImage("\(self.pdfString)") { (status, img) in
                
            if status {
                
                DispatchQueue.main.async {
                    self.imgView.image = img
                }
            }
        }
    
    }
    
    
    @IBAction func backButtonAction(_ sender: Any) {
       self.dismiss(animated: true, completion: nil)
    }
       
    @IBAction func shareDoc(_ sender: Any) {
        if let pdfFileUrlPath = downloadFilePathURLGlobal {
            self.shareFileWith(localFilePath: pdfFileUrlPath, sender: sender)
        } else {
            self.showAlert(alertText: "corrupt_file".localized(), alertMessage: "")
        }
    }
    
    func callDownloadAPINOW() {
        
        let urlString = downloadedHomeWork
        
        let params = ["SessionToken" : sessionTokenGlobal ?? "",
                      "StudentID" : studentIdGlobal ?? 0,
                      "HomeWorkID": self.homeWorkId] as [String : Any]
        
        
        ServiceManager().postRequest(urlString, loader: false, parameters: params) { (status, jsonResponse) in
            
            if status {
                
            }
        }
        
    }
    
}


extension ImageViewController:  WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        var action: WKNavigationActionPolicy?

        defer {
            decisionHandler(action ?? .allow)
        }

        guard let url = navigationAction.request.url else { return }

        print(url)

        if navigationAction.navigationType == .linkActivated, url.absoluteString.hasPrefix("\(self.pdfString)") {
            action = .cancel                  // Stop in WebView
            //UIApplication.shared.openURL(url) // Open in Safari
            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
        }
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print(String(describing: webView.url))
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        let nserror = error as NSError
        if nserror.code != NSURLErrorCancelled {
            webView.loadHTMLString("404 - Page Not Found", baseURL: URL(string: "\(self.pdfString)"))
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print(String(describing: webView.url))
    }
}

