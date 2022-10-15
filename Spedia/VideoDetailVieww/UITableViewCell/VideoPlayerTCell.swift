//
//  VideoPlayerTCell.swift
//  Spedia
//
//  Created by Viraj Sharma on 11/06/2020.
//  Copyright © 2020 Viraj Sharma. All rights reserved.
//

import UIKit
import WebKit

class VideoPlayerTCell: UITableViewCell, UIWebViewDelegate {

    
    @IBOutlet weak var playerHeightConst: NSLayoutConstraint!
    @IBOutlet weak var playerWitdhConst: NSLayoutConstraint!
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var fullScreenButton: UIButton!
    
    @IBOutlet var wevViewOLD : UIWebView!
    var urlStr = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //loadSpinner.hidesWhenStopped = true
        wevViewOLD.delegate = self
        loadAddress()
        //L012Localizer.DoTheSwizzling()
        
        //...
        //self.headerViewHeightConst.constant = topHeaderViewHieght
        //self.haderView.backgroundColor = getBgColorCode()
        
        backButton.imageView?.transform =  L102Language.isCurrentLanguageArabic() ? CGAffineTransform(scaleX: -1.0, y: 1.0) : CGAffineTransform(scaleX: 1.0, y: -1.0)
        
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func loadAddress() {
    
        wevViewOLD.delegate = self
        wevViewOLD.allowsInlineMediaPlayback = true
        wevViewOLD.scalesPageToFit = false
        
        let myURL = URL(string: "\(urlStr)?playsinline=1&is_subscribe=true".addingPercentEncoding(withAllowedCharacters:.urlQueryAllowed) ?? "")
        
        if myURL != nil {
          let myRequest = URLRequest(url: myURL!)
          wevViewOLD.loadRequest(myRequest)
        }
        
         
    }
         
    
    //public func webViewDidStartLoad(_ webView: UIWebView) {
      //  print("webViewDidStartLoad")
        //loadSpinner.isHidden = false
        //loadSpinner.startAnimating()
    //}
        
        
    //public func webViewDidFinishLoad(_ webView: UIWebView){
      //  print("webViewDidFinishLoad")
        //loadSpinner.stopAnimating()
        //loadSpinner.isHidden = true
    //}
        
        
    //public func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
      //  print("didFailLoadWithError")
        //loadSpinner.stopAnimating()
        //loadSpinner.isHidden = true
    //}
    
    
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebView.NavigationType) -> Bool {
        print("ABCd")
        return true
    }
    
   
}

