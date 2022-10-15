//
//  VideoDiscriptionTCell.swift
//  Spedia
//
//  Created by Viraj Sharma on 11/06/2020.
//  Copyright © 2020 Viraj Sharma. All rights reserved.
//

import UIKit
import SwiftyJSON
import SVProgressHUD

class VideoDiscriptionTCell: UITableViewCell {

    //Static
    @IBOutlet weak var quizLabel: CustomLabel!
    @IBOutlet weak var bookmarkLbl: CustomLabel!
    @IBOutlet weak var noteLbl: CustomLabel!
    @IBOutlet weak var questionLbl: CustomLabel!
    
    
    //Dynamic
    @IBOutlet weak var centerXPointValue: NSLayoutConstraint!
    @IBOutlet weak var noteSpacingCont: NSLayoutConstraint!
    @IBOutlet weak var bookmarkSpacingCont: NSLayoutConstraint!
    @IBOutlet weak var quizSpacingCont: NSLayoutConstraint!
    @IBOutlet weak var unitNameLabel: CustomLabel!
    @IBOutlet weak var chapterLbl: CustomLabel!
    @IBOutlet weak var addToCartButton: CustomButton!
    @IBOutlet weak var discriptionLbl: CustomLabel!
    @IBOutlet weak var videoTitleLbl: CustomLabel!
    
    //Action
    @IBOutlet weak var quizButton: UIButton!
    @IBOutlet weak var bookmarkButton: UIButton!
    @IBOutlet weak var noteButton: UIButton!
    @IBOutlet weak var questionButton: UIButton!
    
    //Const...
    @IBOutlet weak var addToCartButtonHeightConts: NSLayoutConstraint!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    
        self.quizLabel.text = L102Language.isCurrentLanguageArabic() ? "الاختبار" : "Quiz"
        self.bookmarkLbl.text = L102Language.isCurrentLanguageArabic() ? "حفظ" : "Save"
        self.noteLbl.text = L102Language.isCurrentLanguageArabic() ? "مذكرة" : "Note"
        self.questionLbl.text = L102Language.isCurrentLanguageArabic() ? "اسأل المعلم" : "Ask Teacher"
        
        
        self.addToCartButton.setTitle("subscribe_ph".localized(), for: .normal)
        self.addToCartButton.isHidden = true
        
        self.centerXPointValue.constant = L102Language.isCurrentLanguageArabic() ? -40 : 40
        
        self.checkQuizButtonStatus()
    
    }
    
    @IBAction func noteButtonAction(_ sender: Any) {
        
    }
    
    
    //MARK:Quiz Button Set-Up
    func checkQuizButtonStatus() {
        if AppShared.object.shouldShowQuizButton {
            self.quizButton.isEnabled = true
            self.quizButton.alpha = 1
        } else {
            self.quizButton.isEnabled = false
            self.quizButton.alpha = 0.5
        }
        
        
        if isGuestLoginGlobal {
            
            self.questionButton.isEnabled = false
            self.questionButton.alpha = 0.5
            
            self.bookmarkButton.isEnabled = false
            self.bookmarkButton.alpha = 0.5
        }
    }
    
    
    //VideosAvailableAr  UnitNameAr  UnitDescriptionAr   QuizID UnitDescriptionEn VideosAvailableEn
    
    func configureCellWithData(data:JSON) {
        
        //0
        self.videoTitleLbl.text = data[VideoListKey.IntroductoryVideo]["Title"].stringValue
         
        //1
        let unitName = L102Language.isCurrentLanguageArabic() ? data[VideoListKey.UnitNameAr].stringValue : data[VideoListKey.UnitNameEn].stringValue

        self.unitNameLabel.text = unitName
        
        //2
        let chaterStr = L102Language.isCurrentLanguageArabic() ? data[VideoListKey.VideosAvailableAr].stringValue : data[VideoListKey.VideosAvailableEn].stringValue

        self.chapterLbl.text = chaterStr
        
        //3
        let descripStr = L102Language.isCurrentLanguageArabic() ? data[VideoListKey.UnitDescriptionAr].stringValue : data[VideoListKey.UnitDescriptionEn].stringValue

        self.discriptionLbl.text = descripStr
        
        
        let hideOrNot = data["HideAddToCart"].boolValue
        
        self.addToCartButtonHeightConts.constant = hideOrNot ? 0.0 : 40.0
        self.addToCartButton.isHidden = hideOrNot
        
        //Check Note Lock
        if data["NoteFilePath"].stringValue.isEmpty {
            self.noteButton.isEnabled = false
            self.noteButton.alpha = 0.5
            //self.noteLbl.alpha = 0.5
        } else {
            self.noteButton.isEnabled = true
            self.noteButton.alpha = 1
            //self.noteLbl.alpha = 1
        }
            
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}



/*

 //SET
 //NotificationCenter.default.addObserver(self, selector: #selector(self.updateButtons(sentData:)), name: Notification.Name("videoPlayerisReadyNow"), object: nil)
 
 @objc func updateButtons(sentData: Notification) {
      
     if let isShowing = sentData.userInfo?["ShowQuiz"] as? Bool {
         print("\n\n\n videoPlayerisReadyNow------>\n",isShowing)
     
     }
 }
 
 
 //CAll
 //NotificationCenter.default.post(name: Notification.Name("videoPlayerisReadyNow"), object: checkValue, userInfo: ["ShowQuiz": checkValue])
 */
