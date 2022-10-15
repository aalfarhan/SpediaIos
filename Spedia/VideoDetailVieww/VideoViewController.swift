//
//  VideoViewController.swift
//  Spedia
//
//  Created by Viraj Sharma on 11/06/2020.
//  Copyright © 2020 Viraj Sharma. All rights reserved.
//


import UIKit
import SwiftyJSON
import SVProgressHUD
import VersaPlayer
import JWPlayer_iOS_SDK


protocol VideoViewControllerDelegate {
    func didAddToCartTapped()
}


//UIWebViewDelegate
class VideoViewController: UIViewController  {

    var urlStr = ""
    
    //0 Delegates...
    var delegateObj : VideoViewControllerDelegate?
    
    //MARK: JWPlayer Object's
    //1
    var jwPlayerObject: JWPlayerController? = nil
    @IBOutlet weak var jwForwordButton: UIButton!
    @IBOutlet weak var jwBackwordButton: UIButton!
    @IBOutlet weak var settingMenuButton: UIButton!
    
    //2
    @IBOutlet weak var playerContainerVieww: UIView!
    
    @IBOutlet weak var paymentPopUpVieww: SubscribtionPopUpView!

    @IBOutlet weak var noDataLbl: CustomLabel!
    
    @IBOutlet weak var listView: UITableView!
    
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var shareButton: UIButton!
    
    @IBOutlet weak var noDataBackButton: UIButton!
   
    
    var dataJson = JSON()
    var mainJson = JSON()
    var subjectId = Int()
    //var subjectPriceId = Int()
    var unitId = Int()
    var subSkillVideoIdStr = "0"
    var preRecSubSkillId = 0
    var isFullScreen = false
    var whereFromAmI = ""
    let totalHeight = DeviceSize.screenHeight
    let totalWitdh = DeviceSize.screenWidth
    
    var tableViewIntHeight = CGFloat()
    
    //NOTE WEBVIEW
    var isPdfLoading = false
    @IBOutlet weak var notePDFView: UIView!
    @IBOutlet weak var pdfContianerView: UIView!
    @IBOutlet weak var crossButton: UIButton!

    
    var isFirstTimeVideoLoaded = false
    var playerCurrentTime = Float()
    var isPlayerReady = false
    
    
    //For Bookmark:
    var bookmarkWatchedLength = 0
    

    //Custom Player...
    //var versaPlayerObj = VersaPlayer()
    @IBOutlet weak var customPlayer: VersaPlayerView!
    @IBOutlet weak var controls: VersaPlayerControls!
    @IBOutlet weak var fullScreenButton: UIButton!
    

    //Responsive
    @IBOutlet weak var videoPlayerMainPlayerWidthCont: NSLayoutConstraint!
    @IBOutlet weak var videoPlayerMainPlayerHeightCont: NSLayoutConstraint!
     

    var gameTimer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()
        

        self.listView.isHidden = true
        
        self.noDataLbl.text = L102Language.isCurrentLanguageArabic() ? "" : ""
        
        customPlayer.playbackDelegate = self
        
        //MARK: GET VIDEO API's CALL
        DispatchQueue.main.async {
          self.getVideoData()
        }
        
        self.setupView()
        
        gameTimer = Timer.scheduledTimer(timeInterval: 20, target: self, selector: #selector(updatePlaterTime), userInfo: nil, repeats: true)
        
        AppShared.object.shouldShowQuizButton = false
        
    }
    
    
    @objc func updatePlaterTime() {
        
        let mediaId = self.mainJson["\(VideoListKey.IntroductoryVideo)"]["MediaId"].stringValue
    
        if mediaId.isEmpty || mediaId.count < 4 { //show normal player
            
            playerCurrentTime = Float(CMTimeGetSeconds(self.customPlayer.player.currentTime()))
            
            self.videoEventWithAction(action: "watchedlength", videoId: self.mainJson["\(VideoListKey.IntroductoryVideo)"]["SubskillVideoID"].stringValue, lenght: playerCurrentTime)
            
        } else { //show jwplayer
        
            if isPlayerReady {
             self.videoEventWithAction(action: "watchedlength", videoId: self.mainJson["\(VideoListKey.IntroductoryVideo)"]["SubskillVideoID"].stringValue, lenght: playerCurrentTime)
            }
        }
        
        
    }

    
    func cmTimeToSeconds(_ time: CMTime) -> TimeInterval? {
        let seconds = CMTimeGetSeconds(time)
        if seconds.isNaN {
            return nil
        }
        return TimeInterval(seconds)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        isPdfDownloadedSuccessGlobal = false
        
        AppShared.object.isVideoOrZoomViewShowing = true
    
        self.checkForRecodingNow()
        
        (UIApplication.shared.delegate as! AppDelegate).restrictRotation = [.allButUpsideDown]
    
    }
      
    
    func checkForRecodingNow() {
        let isCaptured = UIScreen.main.isCaptured
        if isCaptured && AppShared.object.isVideoOrZoomViewShowing {
            showRecordingError()
        }
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        DispatchQueue.main.async {
          self.updatePlaterTime()
        }
        
        AppShared.object.isVideoOrZoomViewShowing = false
        
        (UIApplication.shared.delegate as! AppDelegate).restrictRotation = .portrait
        
        //MARK: Stop user from record videos or screen 2
        //Remove Trigger 2
        //UIScreen.main.removeObserver(self, forKeyPath: "captured")
        gameTimer?.invalidate()
    
    }
     
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.customPlayer.pause()
    
        guard let player = self.jwPlayerObject else { return }
    
        switch player.state {
        case .playing:
            player.pause()
        case .complete, .idle, .paused:
            //player.play()
            print("reaydt for play")
        default:
            break
        }
        
    }
    
    
    func stopAllVideoPlayerNowForceFully() {
        
        self.customPlayer.pause()
    
        guard let player = self.jwPlayerObject else { return }
    
        switch player.state {
        case .playing:
            player.pause()
        case .complete, .idle, .paused:
            player.stop()
            print("reaydt for play")
        default:
            break
        }
    }
    
    
    @IBAction func backButtonAction(_ sender: Any) {
       print("Back button hitzzz......")
        
        if self.whereFromAmI == WhereFromAmIKeys.bookmark || self.whereFromAmI == WhereFromAmIKeys.answerDetail || self.whereFromAmI == WhereFromAmIKeys.preRecoredPage  {
            self.dismiss(animated: true, completion: nil)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
       
    }
       

    
    func setupView() {
        //1
        //let nibName = UINib(nibName: "VideoPlayerTCell", bundle:nil)
        //self.listView.register(nibName, forCellReuseIdentifier: "videoPlayerTCell")
        
        //2
        let nibName2 = UINib(nibName: "VideoDiscriptionTCell", bundle:nil)
        self.listView.register(nibName2, forCellReuseIdentifier: "videoDiscriptionTCell")
        
        //3
        let nibName3 = UINib(nibName: "VideoChaprerTCell", bundle:nil)
        self.listView.register(nibName3, forCellReuseIdentifier: "videoChaprerTCell")
          
        //4
        let nibName4 = UINib(nibName: "VideoFooterCell", bundle:nil)
        self.listView.register(nibName4, forCellReuseIdentifier: "videoFooterCell")
           
        //5 For Versa Player
        self.backButton.transform = L102Language.isCurrentLanguageArabic() ? CGAffineTransform(scaleX: -1.0, y: 1.0) : CGAffineTransform(scaleX: 1.0, y: -1.0)
        
        //6 For JWplayer
        self.noDataBackButton.imageView?.transform =  L102Language.isCurrentLanguageArabic() ? CGAffineTransform(scaleX: -1.0, y: 1.0) : CGAffineTransform(scaleX: 1.0, y: -1.0)
        
       //7
       jwForwordButton.transform =  L102Language.isCurrentLanguageArabic() ? CGAffineTransform(scaleX: -1.0, y: 1.0) : CGAffineTransform(scaleX: -1.0, y: 1.0)
        
       jwBackwordButton.transform =  L102Language.isCurrentLanguageArabic() ? CGAffineTransform(scaleX: -1.0, y: 1.0) : CGAffineTransform(scaleX: -1.0, y: 1.0)
        
        
      //8
      self.tableViewIntHeight = self.listView.frame.height
        
        
      //9
      controls.skipBackwardButton?.imageView?.transform =  L102Language.isCurrentLanguageArabic() ? CGAffineTransform(scaleX: -1.0, y: 1.0) : CGAffineTransform(scaleX: 1.0, y: 1.0)
      
      controls.skipForwardButton?.imageView?.transform =  L102Language.isCurrentLanguageArabic() ? CGAffineTransform(scaleX: -1.0, y: 1.0) : CGAffineTransform(scaleX: 1.0, y: 1.0)
      
      
      controls.seekbarSlider?.transform =  L102Language.isCurrentLanguageArabic() ? CGAffineTransform(scaleX: -1.0, y: 1.0) : CGAffineTransform(scaleX: -1.0, y: 1.0)
      
      
      controls.skipSize = 10.0
      customPlayer.use(controls: controls)
        
      
       self.jwForwordButton.isHidden = true
       self.jwBackwordButton.isHidden = true
       self.settingMenuButton.isHidden = true
        
    }
    
    
    
    func getVideoData() {
        
        let urlString = getSubSkillVideo
        let params = ["SessionToken" : sessionTokenGlobal ?? "",
                      "StudentID" : studentIdGlobal ?? 0,
                      "SubjectID" : self.subjectId,
                      "UnitID" : self.unitId,
                      "SubSkillID" : self.preRecSubSkillId,
                      "DeviceTypeID" : DeviceType.iPhone,
                      "SubSkillVideoID" : self.subSkillVideoIdStr] as [String : Any]
        
        
        ServiceManager().postRequest(urlString, loader: true, parameters: params) { (status, jsonResponse) in
            
            if status {
                
                self.dataJson = JSON.init(jsonResponse ?? "NO DTA")
                self.mainJson = JSON.init(jsonResponse ?? "NO DTA")
                self.dataJson = self.dataJson["\(VideoListKey.VideoList)"]
                
                
                
                //For Quiz:
                AppShared.object.quizIDGlobal = self.mainJson[VideoListKey.QuizID].intValue
                AppShared.object.quizStatusGloabl = self.mainJson[VideoListKey.QuizStatus].stringValue
                
                
                //MARK: DND
                
                //self.playerView.isHidden = false
                self.noDataBackButton.isHidden = true
                self.noDataLbl.text = ""
                self.noDataBackButton.backgroundColor = .clear
                
                
                //MARK: Call For Perticuler Video Index
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    
                    if self.subSkillVideoIdStr == "0" {
                        
                        self.listView.reloadData()
                        self.loadCustomAVPlayeer()
                        
                    } else {
                        
                        self.findIndexOfPerticulerKey(dataObject: self.dataJson, matchingKey: self.subSkillVideoIdStr)
                    }
                    
                    
                    self.listView.isHidden = false
                }
                
                
            } else {
                
                self.noDataBackButton.isHidden = false
                self.listView.isHidden = true
                //self.playerView.isHidden = true
                self.noDataLbl.text = L102Language.isCurrentLanguageArabic() ? "لا توجد مقاطع فيديو متاحة الآن" : "No Videos Available Now"
                
                self.noDataBackButton.backgroundColor = UIColor.black.withAlphaComponent(0.20)
                
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.tabBarController?.tabBar.isHidden = false
                self.view.layoutIfNeeded()
            }
        }
        
    }
    
    
    
    //MARK: =============================================
    //MARK: Call For Perticuler Video Index
    //MARK: =============================================
    
    func findIndexOfPerticulerKey(dataObject: JSON, matchingKey: String) {
        
        let searchPredicate = NSPredicate(format: "(SubskillVideoID contains[c] %@) OR (SubskillVideoID contains[c] %@)", matchingKey, matchingKey)
    
        if let array = dataObject.arrayObject {
            
            let foundItems = JSON(array.filter { searchPredicate.evaluate(with: $0) })
            
            if foundItems.count == 1 {
                
                print("\n\n\n\n Perticuler Video Fetch Is: ", foundItems)
                
                let isLock = foundItems[0]["isLock"].boolValue
                
                if isLock {
                    
                   let msg =  L102Language.isCurrentLanguageArabic() ? "برجاء الاشتراك لعرض المذكرة" : "Please subscribe to unlock"
                   
                   SVProgressHUD.showInfo(withStatus: msg)
                    let indexIs = foundItems[0]["Index"].intValue
                    self.startFromParticulerVideoNow(atIndex: indexIs)
                    
                } else {
                    
                    let indexIs = foundItems[0]["Index"].intValue
                    self.startFromParticulerVideoNow(atIndex: indexIs)
                    
                }
            }
        }
    }
        
    func startFromParticulerVideoNow(atIndex: Int) {
        
        print("\n\n\n\n Index For Video Is: ", atIndex)
        
        self.isFirstTimeVideoLoaded = false
        self.mainJson["\(VideoListKey.IntroductoryVideo)"]["VideoPathWithoutMediaPlayer"].stringValue = self.dataJson[atIndex][VideoListKey.VideoPathWithoutMediaPlayer].stringValue
        self.mainJson["\(VideoListKey.IntroductoryVideo)"] = self.dataJson[atIndex]
        //MARK: DND
        self.loadCustomAVPlayeer()
        self.listView.reloadData()
    }
    
    
    
    
    
    //MARK: - Video Player: OnRotation...
    
    func setPlayerUI() {
        
        if UIDevice.current.orientation.isLandscape {
          self.isFullScreen = true
          self.fullScreenButton.isSelected = true
          
          ///self.playerWitdhConst.constant = totalHeight
          ///self.playerHeightConst.constant = totalWitdh
            
          //controlsHieghtConst.constant = totalWitdh
          //controlsWitdhConst.constant = totalHeight
            
          //self.view.layoutIfNeeded()
          //customPlayer.layoutIfNeeded()
          //controls.layoutIfNeeded()
          //self.listView.isScrollEnabled = false
          //self.loadViewIfNeeded()
          
         } else {
             
            // self.playerWitdhConst.constant = totalWitdh
            // self.playerHeightConst.constant = 211
             //self.listView.isScrollEnabled = true
            
             //controlsHieghtConst.constant = 211
             //controlsWitdhConst.constant = totalWitdh
            
             self.fullScreenButton.isSelected = false
             //self.view.layoutIfNeeded()
             //customPlayer.layoutIfNeeded()
             //controls.layoutIfNeeded()
             //self.loadViewIfNeeded()
            
        }
        
    }
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        super.viewWillTransition(to: size, with: coordinator)
           
        if UIDevice.current.orientation.isLandscape {
            
            self.backButton.isHidden = true
            self.fullScreenButton.isSelected = true
            self.tabBarController?.tabBar.isHidden = true
            
            if UIDevice.isPad {
              
                self.videoPlayerMainPlayerWidthCont.constant = DeviceSize.screenWidth
                self.videoPlayerMainPlayerHeightCont.constant = DeviceSize.screenHeight
 
            }
          
        } else {
            
            self.backButton.isHidden = false
            self.fullScreenButton.isSelected = false
            self.tabBarController?.tabBar.isHidden = false
            
             if UIDevice.isPad {
                
               //MARK: RATIO CALCULATOR
               //16:9 Ratio Formula
               let ratioHeight = (DeviceSize.screenWidth / 16) * 9
                
               self.videoPlayerMainPlayerWidthCont.constant = DeviceSize.screenWidth
               self.videoPlayerMainPlayerHeightCont.constant = ratioHeight
               
             }
            
        }
        
        self.view.layoutIfNeeded()
        self.view.setNeedsUpdateConstraints()
        self.checkForRecodingNow()
        
    }
    
    
    
    @IBAction func fullScreenButtonAction(_ sender: Any) {
        
        if !isFullScreen {
            
            self.isFullScreen = true
            let value = UIInterfaceOrientation.landscapeLeft.rawValue
            UIDevice.current.setValue(value, forKey: "orientation")
            
            //self.playerWitdhConst.constant = totalHeight
            //self.playerHeightConst.constant = totalWitdh
            //self.listViewHieghtConst.constant = 0
            
            //self.listView.isScrollEnabled = false
            //self.backButton.isHidden = true
            //self.fullScreenButton.isSelected = true
            //self.loadViewIfNeeded()
            
            if let fullscreenView = UIApplication.shared.windows.filter({$0.isKeyWindow}).first {
                self.addRewindForwordButton(subView: fullscreenView)
            }
            
            
        } else {
            
            self.isFullScreen = false
            let value = UIInterfaceOrientation.portrait.rawValue
            UIDevice.current.setValue(value, forKey: "orientation")
            
            //self.playerWitdhConst.constant = totalWitdh
            //self.listViewHieghtConst.constant = totalHeight - 211
            //self.playerHeightConst.constant = 211
            //self.backButton.isHidden = false
            //self.fullScreenButton.isSelected = false
            //self.loadViewIfNeeded()
            
            self.addRewindForwordButton(subView: self.playerContainerVieww)
        }
        
        
        
    }
    
    

    func loadCustomAVPlayeer() {
        
        //Check Media ID is there or not
        
        var mediaId = self.mainJson["\(VideoListKey.IntroductoryVideo)"]["MediaId"].stringValue
        
        if self.mainJson["\(VideoListKey.IntroductoryVideo)"]["isLock"].boolValue {
            mediaId = ""
        }
        
        print("\n\nMedia ID=======>\(mediaId)\n\n")
         
        
        if mediaId.isEmpty || mediaId.count < 4 {
            
            self.controls.isHidden = false
            self.customPlayer.isHidden = false
            self.removeJWPlayerNow()
            
            self.urlStr = self.mainJson["\(VideoListKey.IntroductoryVideo)"]["VideoPathWithoutMediaPlayer"].stringValue
            
            let myURL = URL(string: "\(urlStr)".addingPercentEncoding(withAllowedCharacters:.urlQueryAllowed) ?? "")
            
            if myURL != nil {
                self.controls.behaviour.show()
                let item = VersaPlayerItem(url: myURL!)
                self.customPlayer.set(item: item)
                self.setPlayerUI()
            }
            
            
        } else { //YOU CAN SHOW JWPLAYER NOW!
            
            self.controls.isHidden = true
            self.customPlayer.isHidden = true
            self.customPlayer.pause()
            self.setUpJWPlayerNow()
            
        }
        
        
    }
    
    
    
    
    
    
    //============================================
    //MARK: NOTE PDF WEBVIEW SETUP START FROM HERE
    //============================================

    func showPDFViewNow() {
        
        if isPdfDownloadedSuccessGlobal == false {
            
            self.notePDFView.isHidden = false
            isPdfLoadingGlobal = true
            if let vc = DocumentViewController.instantiate(fromAppStoryboard: .main) {
                vc.modalPresentationStyle = .fullScreen
                vc.isFromVideoPage = true
                vc.pdfString = self.mainJson["NoteFilePath"].stringValue
                
                self.addChildViewNow(vc, inView: self.pdfContianerView)
            }
        } else {
            self.notePDFView.isHidden = false
        }
    }
     
    
    @IBAction func shareOrDownloadButtonAction(_ sender: Any) {
        
        if let pdfFileUrlPath = downloadFilePathURLGlobal {
         self.shareFileWith(localFilePath: pdfFileUrlPath, sender: sender)
        } else {
            self.showAlert(alertText: "corrupt_file".localized(), alertMessage: "")
        }
      
        
    }
    

}


extension VideoViewController : UITableViewDelegate, UITableViewDataSource {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataJson.count+2
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        //0 Last Cell Footer View
        let lastSectionIndex = tableView.numberOfSections - 1
        // last row
        let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
        
        if indexPath.row == lastRowIndex {
               
            let cell = self.listView.dequeueReusableCell(withIdentifier: "videoFooterCell") as? VideoFooterCell
          
            cell?.selectionStyle = .none
          
        
            return cell ?? UITableViewCell()
           
        
        
        //1 Video Cell
        
        } /*else if indexPath.row == 0 {
            
        let cell = self.listView.dequeueReusableCell(withIdentifier: "videoPlayerTCell") as? VideoPlayerTCell
        
        cell?.selectionStyle = .none
        
        //cell?.urlStr = "https://test.zidnei.com/spediaApp/Media/?videourl=https://test.zidnei.com:443/Uploads/SkillVideos/physics12b/P12M2C01S001.mp4"
        
        //cell?.backButton.addTarget(self, action: #selector(backButtonCliked(sender:)), for: .touchUpInside)
        
        //cell?.fullScreenButton.addTarget(self, action: #selector(fullscreenButtonAction(sender:)), for: .touchUpInside)
            
        return cell ?? UITableViewCell()
        
         
        //2 //Video Description Cell
            
        }*/ else if indexPath.row == 0 {
            
        let cell = self.listView.dequeueReusableCell(withIdentifier: "videoDiscriptionTCell") as? VideoDiscriptionTCell
        
        cell?.selectionStyle = .none
        
        let value = round(self.view.frame.width / 18.75) + 5
        cell?.noteSpacingCont.constant = value
        cell?.bookmarkSpacingCont.constant = value
        cell?.quizSpacingCont.constant = value
        
        cell?.quizButton.addTarget(self, action: #selector(quizButtonAction(sender:)), for: .touchUpInside)
        cell?.bookmarkButton.addTarget(self, action: #selector(bookmarkButtonAction(sender:)), for: .touchUpInside)
        cell?.noteButton.addTarget(self, action: #selector(noteButtonAction(sender:)), for: .touchUpInside)
        cell?.questionButton.addTarget(self, action: #selector(questionButtonAction(sender:)), for: .touchUpInside)
        
        cell?.addToCartButton.addTarget(self, action: #selector(addToCartButtonAction(sender:)), for: .touchUpInside)
            
        cell?.configureCellWithData(data: self.mainJson)
        
        cell?.checkQuizButtonStatus()
            
        return cell ?? UITableViewCell()
        
        
        //3 Video Chaptters Cell
        
        } else {
            
            let cell = self.listView.dequeueReusableCell(withIdentifier: "videoChaprerTCell") as? VideoChaprerTCell
            
            cell?.selectionStyle = .none
            
            cell?.chapterCountLbl.text = String(format: "%02d", indexPath.row)
            
            cell?.tapCellButton.tag = indexPath.row-1
            cell?.tapCellButton.addTarget(self, action: #selector(cellButtonAction(sender:)), for: .touchUpInside)
            
            cell?.configureCellWithData(data: self.dataJson[indexPath.row-1])
            //cell.delegateObj = self
            //cell.featureModel = featuredList[indexPath.section]
            //cell?.loadCollectionView()
            return cell ?? UITableViewCell()
            
        }
        
    }
  
    
    //0
    //=================================================
    //MARK: ACTION
    //=================================================
    
    @objc func addToCartButtonAction(sender: UIButton) {
        
        // IAP 6
        let subscriptionMsg = L102Language.isCurrentLanguageArabic() ? self.mainJson["SubcribeMessageAr"].stringValue : self.mainJson["SubcribeMessageEn"].stringValue
        
        globalProductIdStrIAP = self.mainJson["AppleProductID"].stringValue
        globalSubjectPriceIdIAP = self.mainJson["SubjectPriceID"].intValue
        globalIsPrivateClassTypeIAP = false
        globalResumePaymentMsgIAP = subscriptionMsg

        //showCustomInAppPurchaseBox(title: subscriptionMsg, subTitle: "", buttonType: "subscribe_now", imageName: "addToCartSuccess", textColor: UIColor.black)
        
        
         
        
        self.paymentPopUpVieww.delegateObj = self
        self.paymentPopUpVieww.dataJson = self.mainJson["PriceDetail"]
        self.paymentPopUpVieww.reloadDataNow()
        self.paymentPopUpVieww.isHidden = false

        
        self.delegateObj?.didAddToCartTapped()
        
        //self.mainJson[VideoListKey.HideAddToCart].boolValue = true
        self.listView.reloadData()
        
        
    }
     
     
     
    
    //1
    @objc func quizButtonAction(sender: UIButton) {
        
        if isParentGlobal {
            
            SVProgressHUD.showInfo(withStatus: "you_cant_see_questions".localized())
            
        } else {
            self.stopAllVideoPlayerNowForceFully()
            
            if let vc = QuestionViewController.instantiate(fromAppStoryboard: .main) {
                vc.modalPresentationStyle = .fullScreen
                
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
    
    
    
    //2
    @objc func bookmarkButtonAction(sender: UIButton) {
         
         //print("bookmarkButtonAction")
         SVProgressHUD.showInfo(withStatus: "bookmark_saved".localized())
        
        self.videoEventWithAction(action: "bookmark", videoId: self.mainJson["\(VideoListKey.IntroductoryVideo)"]["SubskillVideoID"].stringValue, lenght: playerCurrentTime)
    }
    
    //3
    @objc func noteButtonAction(sender: UIButton) {
        print("noteButtonAction")
        
        if self.mainJson["NoteIsLocked"].boolValue {
            
            let msg =  L102Language.isCurrentLanguageArabic() ? "برجاء الاشتراك لعرض المذكرة" : "Please subscribe to unlock"
        
            SVProgressHUD.showInfo(withStatus:  msg)
            
            
        } else {
            
            self.showPDFViewNow()
            
        }
        
    }
     
    
    //3.1
    @IBAction func crossButtonAction(_ sender: Any) {
        self.notePDFView.isHidden = true
    }
    
    
    //4
    @objc func questionButtonAction(sender: UIButton) {
    
        //SVProgressHUD.showInfo(withStatus: "coming_soon".localized())
        if let vc = AskSpediaViewController.instantiate(fromAppStoryboard: .main) {
            vc.modalPresentationStyle = .fullScreen
            vc.subjectIdObj = subjectId
            vc.subjectNameObj = L102Language.isCurrentLanguageArabic() ? self.mainJson["SubjectNameAr"].stringValue : self.mainJson["SubjectNameEn"].stringValue
            
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    
    //XLR8 - Status Change Action...
    @objc func cellButtonAction(sender: UIButton) {
        
        print("Back button hitzzz......", sender.tag)
        
        let isAddToCart = self.mainJson[VideoListKey.HideAddToCart].boolValue
        
        let isLock = self.dataJson[sender.tag][VideoListKey.isLock].boolValue
        
        
        if isLock && !isAddToCart {
            
            self.addToCartButtonAction(sender: sender)
            
        } else if isLock {
            
           
           let msg =  L102Language.isCurrentLanguageArabic() ? "برجاء الاشتراك لعرض المذكرة" : "Please subscribe to unlock"
           
           SVProgressHUD.showInfo(withStatus: msg)
             
        } else {
            
           self.isFirstTimeVideoLoaded = false
           self.mainJson["\(VideoListKey.IntroductoryVideo)"]["VideoPathWithoutMediaPlayer"].stringValue = self.dataJson[sender.tag][VideoListKey.VideoPathWithoutMediaPlayer].stringValue
        
           self.mainJson["\(VideoListKey.IntroductoryVideo)"] = self.dataJson[sender.tag]
           
          
           //MARK: DND
           self.loadCustomAVPlayeer()
           self.listView.reloadData()
        
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension //136
    
    }
    
    
    //MARK: EMPTY FOOTER IN TABLEVIEW

    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
            return "Section \(section)"
    }
        
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
            let vw = UIView()
            vw.backgroundColor = UIColor.clear
            
            return vw
    }
        
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 70.0
    }
    
    
    
}





//=================================================
//MARK: VersaPlayerPlaybackDelegate
//=================================================
      
extension VideoViewController : VersaPlayerPlaybackDelegate {
    
    //1 Init
    func playbackDidBegin(player: VersaPlayer) {
       
        /*if !isFirstTimeVideoLoaded {
            
            print(player.startTime())
            
            //watchedlength
            if !isParentGlobal {
             self.videoEventWithAction(action: "play", videoId: self.mainJson["\(VideoListKey.IntroductoryVideo)"]["SubskillVideoID"].stringValue, lenght: 0.0)
            }
            
            isFirstTimeVideoLoaded = true
        }*/
        
        
        //watchedlength
        if !isParentGlobal {
         self.videoEventWithAction(action: "play", videoId: self.mainJson["\(VideoListKey.IntroductoryVideo)"]["SubskillVideoID"].stringValue, lenght: 0.0)
        }
        
    }
    
    
    //2 Call Video Event Api now
    func videoEventWithAction(action: String, videoId : String, lenght : Float) {
        
        if isPdfLoadingGlobal == false {
            guard !(lenght.isNaN || lenght.isInfinite) else {
                return // or do some error handling
            }
            
            let urlString = videoEvents
            let params = ["SessionToken" : sessionTokenGlobal ?? "",
                          "StudentID" : studentIdGlobal ?? 0,
                          "VideoID" : videoId,
                          "Actions" : action,
                          "Length" : Int(lenght)] as [String : Any]
            
            
            ServiceManager().postRequest(urlString, loader: false, parameters: params) { (status, jsonResponse) in
                
                if status {
                    print("\n\n Video Event \(action) Called Successfully \n\n")
                }
            }
        }
    }
    
    
}



//MARK:===================================
//MARK: JWPlayer Setup & Delegates
//MARK:===================================

extension VideoViewController:  JWPlayerDelegate {
    
    //drmDataSource
    func setUpJWPlayerNow() {
        // Instance JWPlayerController object
        createPlayer()
        
        if let playerView = jwPlayerObject?.view {
            
            //playerView.tag = 777
            self.playerContainerVieww.addSubview(playerView)
            // Turn off translatesAutoresizingMaskIntoConstraints property to use Auto Layout to dynamically calculate the size and position
            playerView.translatesAutoresizingMaskIntoConstraints = false
            // Add constraints to center the playerView
            
            playerView.leadingAnchor.constraint(equalTo: playerContainerVieww.leadingAnchor).isActive = true
            playerView.trailingAnchor.constraint(equalTo: playerContainerVieww.trailingAnchor).isActive = true
            playerView.topAnchor.constraint(equalTo: playerContainerVieww.topAnchor).isActive = true
            playerView.bottomAnchor.constraint(equalTo: playerContainerVieww.bottomAnchor).isActive = true
            //playerView.heightAnchor.constraint(equalToConstant: 300).isActive = true
            
         }
        
         
        self.addRewindForwordButton(subView: self.playerContainerVieww)
        
        
        
    }
    

    
    func removeJWPlayerNow() {
        self.noDataBackButton.isHidden = true
        self.jwPlayerObject?.view?.isHidden = true
        self.jwPlayerObject?.stop()
    }
    
    
    
    @IBAction func jwForwordButtonAction(_ sender: Any) {
        
        guard let player = self.jwPlayerObject else { return }
        
        let newPosition = Int(player.position) + 10
        player.seek(newPosition)
    
    }
    
    
    //=================================================
    //MARK: SEEK TO BOOKMARK ACTION
    //=================================================
    
    func skippiedToBookmarked(onWatchLength : Int) {
        
        guard let player = self.jwPlayerObject else { return }
        
        let newPosition = onWatchLength
        player.seek(newPosition)
    
    }
    
    
    @IBAction func jwBackwordButtonAction(_ sender: Any) {
        
        guard let player = self.jwPlayerObject else { return }
        
        // max function used to avoid negative values
        let newPosition = max(0, Int(player.position) - 10)
        player.seek(newPosition)
       
    }
    
    
    @IBAction func settingMenuButtonAction(_ sender: Any) {
             
            guard let player = self.jwPlayerObject else { return }
            
            // Create the alert controller
            let alertController = UIAlertController(title: "playback_speed".localized(), message: "", preferredStyle: .alert)
            
            
            //1 Speed 0.5
            let lowMinSpeedAction = UIAlertAction(title: "0.25", style: UIAlertAction.Style.default) {
                UIAlertAction in
                
                player.playbackRate = 0.25
            }
            
            //2 Speed 0.5
            let lowMidSpeedAction = UIAlertAction(title: "0.5", style: UIAlertAction.Style.default) {
                UIAlertAction in
                
                player.playbackRate = 0.5
                
            }
            
            //3 Normal
            let normalSpeedAction = UIAlertAction(title: "normal_ph".localized(), style: UIAlertAction.Style.default) {
                UIAlertAction in
                
                player.playbackRate = 1.0
                
            }
        
            //4 Speed 1.5
            let highMinSpeedAction = UIAlertAction(title: "1.5", style: UIAlertAction.Style.default) {
                UIAlertAction in
                
                player.playbackRate = 1.5
                
            }
            
            //5 Speed 2.0
            let highMidSpeedAction = UIAlertAction(title: "2.0", style: UIAlertAction.Style.default) {
                UIAlertAction in
                
                player.playbackRate = 2.0
                
            }
            
            //6 Cancel
            let cancelAction = UIAlertAction(title: "CANCEL".localized(), style: UIAlertAction.Style.destructive) {
                UIAlertAction in
                
            }
            
            //Last Assign
            alertController.addAction(lowMinSpeedAction)
            alertController.addAction(lowMidSpeedAction)
            alertController.addAction(normalSpeedAction)
            alertController.addAction(highMinSpeedAction)
            alertController.addAction(highMidSpeedAction)
            alertController.addAction(cancelAction)
            
            // Present the controller
            if let topController = UIApplication.topViewController() {
             topController.present(alertController, animated: true, completion: nil)
            }
            
            
     }
    
    
    //MARK: Create JWPlayer OR JWPlayer SetUp.........goku323
    
    func createPlayer() {
        if let player = JWPlayerController(config: createConfig(), delegate: self) {
            // Force fullscreen on landscape and vice versa
            player.forceFullScreenOnLandscape = true
            player.forceLandscapeOnFullScreen = true
        
            self.jwPlayerObject = player
            self.jwPlayerObject?.delegate = self
        }
    }
    
    
    
    func createConfig() -> JWConfig {
        
        let mediaId = self.mainJson["\(VideoListKey.IntroductoryVideo)"]["MediaId"].stringValue
        
        // Instance JWConfig object to setup the video
        let config = JWConfig.init(contentUrl: JWPlayerConstance.videoBaseURL + "\(mediaId)" + JWPlayerConstance.videoExtension)
        
        //config.image = thumbnailUrl
        config.skin = getSkin()
        config.autostart = true
        config.repeat = false
        config.playbackRateControls = false
        
        return config
    }
    
    
    
    //Custom Skin Styling......................................
    func getSkin() -> JWSkinStyling {
        
        let skin = JWSkinStyling()
        //skin.url  = "http://live.spediaapp.com/css/spedia_jwplayer_custom.css"
        skin.url = "https://live.spediaapp.com/css/spediajwskinios.css?v=1"
        skin.name = "spediajwskin"
        return skin
    }
    
    
    func onTime(_ event: JWEvent & JWTimeEvent) {
        
        //print("Duration======>",event.duration)
        //print("Position======>",event.position)
        
        if event.position > 5 {
          self.isPlayerReady = true
          self.playerCurrentTime = Float(event.position)
        }
        
    }
    
    
    func onPlay(_ event: JWEvent & JWStateChangeEvent) {
       
        if !isParentGlobal {
         self.videoEventWithAction(action: "play", videoId: self.mainJson["\(VideoListKey.IntroductoryVideo)"]["SubskillVideoID"].stringValue, lenght: 0.0)
        }
        
        
        if self.whereFromAmI == WhereFromAmIKeys.bookmark {
            
            self.skippiedToBookmarked(onWatchLength: bookmarkWatchedLength)
            
        }
        
        AppShared.object.shouldShowQuizButton = self.mainJson["ShowQuiz"].boolValue
        
        
        self.listView.reloadData()
        
    }

    
    func onControls(_ event: JWEvent & JWControlsEvent) {
        
        print("onControls======>",event.controls)
        
        print("onControls======>",event.controls.toggle())
        
        
    }
    
    func onFullscreen(_ event: JWEvent & JWFullscreenEvent) {
        
        print("onFullscreen")
        self.fullScreenButtonAction(self)
    
    }
    
    
    
    func addRewindForwordButton(subView : UIView) {
        
        jwForwordButton.removeFromSuperview()
        jwBackwordButton.removeFromSuperview()
        
        settingMenuButton.removeFromSuperview()
        
        subView.addSubview(jwForwordButton)
        subView.addSubview(jwBackwordButton)
       
        subView.addSubview(settingMenuButton)
        
        
        //Forword Button
        jwBackwordButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            jwBackwordButton.centerXAnchor.constraint(equalTo: subView.centerXAnchor, constant: 120),
            jwBackwordButton.centerYAnchor.constraint(equalTo: subView.centerYAnchor),
            jwBackwordButton.widthAnchor.constraint(equalToConstant: 48),
            jwBackwordButton.heightAnchor.constraint(equalToConstant: 48),
        ])
        
        
        //Backword Button
       
        jwForwordButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            jwForwordButton.centerXAnchor.constraint(equalTo: subView.centerXAnchor, constant: -120),
            jwForwordButton.centerYAnchor.constraint(equalTo: subView.centerYAnchor),
            jwForwordButton.widthAnchor.constraint(equalToConstant: 48),
            jwForwordButton.heightAnchor.constraint(equalToConstant: 48),
        ])
        
        
        //Setting Button
       
        settingMenuButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            settingMenuButton.trailingAnchor.constraint(equalTo: subView.trailingAnchor, constant: -16),
            settingMenuButton.topAnchor.constraint(equalTo: subView.topAnchor, constant: 16),
            settingMenuButton.widthAnchor.constraint(equalToConstant: 35),
            settingMenuButton.heightAnchor.constraint(equalToConstant: 35),
        ])
        
        
        subView.layoutIfNeeded()
        subView.setNeedsUpdateConstraints()
        self.view.layoutIfNeeded()
        self.view.setNeedsUpdateConstraints()
        
    }
    
    
   
    
    
    func onDisplayClick() {
        
        //print("onDisplayClick")
    }
    
    func onControlBarVisible(_ event: JWEvent & JWControlsEvent) {
        print("onControlBarVisible", event.controls)
        
        self.jwForwordButton.isHidden = !event.controls
        self.jwBackwordButton.isHidden = !event.controls
        self.noDataBackButton.isHidden = !event.controls
        self.settingMenuButton.isHidden = !event.controls
        
    }
    
    func onViewable(_ event: JWEvent & JWViewabilityEvent) {
        print("onViewable", event.viewable)
    }
}





// MARK: - Helper method

extension UIView {
    
    
   
    
    
    public func constraintToSuperview() {
        translatesAutoresizingMaskIntoConstraints = false
        let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|[thisView]|",
                                                                   options: [],
                                                                   metrics: nil,
                                                                   views: ["thisView": self])
        
        let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|[thisView]|",
                                                                   options: [],
                                                                   metrics: nil,
                                                                   views: ["thisView": self])
        
        NSLayoutConstraint.activate(horizontalConstraints + verticalConstraints)
    }
    
    
    public func constraintToCenter() {
        translatesAutoresizingMaskIntoConstraints = false
        let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|[thisView]|",
                                                                   options: [.alignAllCenterX],
                                                                   metrics: nil,
                                                                   views: ["thisView": self])
        
        let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|[thisView]|",
                                                                   options: [.alignAllCenterY],
                                                                   metrics: nil,
                                                                   views: ["thisView": self])
        
        NSLayoutConstraint.activate(horizontalConstraints + verticalConstraints)
    }
    
    
    public func constraintToFlexibleBottom() {
        translatesAutoresizingMaskIntoConstraints = false
        let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|[thisView]|",
                                                                   options: [],
                                                                   metrics: nil,
                                                                   views: ["thisView" : self])
        
        let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:[thisView]|",
                                                                   options: [.alignAllBottom],
                                                                   metrics: nil,
                                                                   views: ["thisView" : self])

        NSLayoutConstraint.activate(horizontalConstraints + verticalConstraints)
    }
    
}



//MARK:================================================
//MARK: Payment Pop Deletegate
//MARK:================================================


extension VideoViewController: SubscribtionPopUpViewDelegate {
    func crossButtonClick() {
        self.paymentPopUpVieww.isHidden = true
    }

}
