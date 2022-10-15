//
//  VideoChaprerTCell.swift
//  Spedia
//
//  Created by Viraj Sharma on 12/06/2020.
//  Copyright © 2020 Viraj Sharma. All rights reserved.
//

import UIKit
import SwiftyJSON
import UICircularProgressRing

class VideoChaprerTCell: UITableViewCell {
    
    @IBOutlet weak var chapterNameLbl: CustomLabel!
    
    @IBOutlet weak var chapterMinLbl: CustomLabel!
    
    @IBOutlet weak var completedLbl: CustomLabel!
    
    @IBOutlet weak var chapterFlagImageView: UIImageView!
    
    @IBOutlet weak var chapterCountLbl: CustomLabel!
    
    @IBOutlet weak var tapCellButton: UIButton!
    
    @IBOutlet weak var alphaView: UIView!
    
    //MARK: UICircularProgressRing
    @IBOutlet var progressContainerView: UIView!
    @IBOutlet var circularProgressView: UICircularProgressRing!
    @IBOutlet weak var percentLabel: CustomLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    
    func configureCellWithData(data:JSON) {
        
        //1
        let titleStr = L102Language.isCurrentLanguageArabic() ? data[VideoListKey.Title].stringValue : data[VideoListKey.Title].stringValue
        
        self.chapterNameLbl.text = titleStr
        
        self.chapterNameLbl.textAlignment = L102Language.isCurrentLanguageArabic() ? .right : .left
        
        //2
        let minStr = L102Language.isCurrentLanguageArabic() ? data[VideoListKey.videoMinAr].stringValue : data[VideoListKey.videoMinEn].stringValue
        
        self.chapterMinLbl.text = minStr
        
        //3
        self.alphaView.backgroundColor = UIColor.clear
        let isCompleted = data[VideoListKey.IsCompleted].boolValue
        let isLock = data[VideoListKey.isLock].boolValue
        let watchedCount = data[VideoListKey.WatchedCount].intValue
        
    
        self.chapterFlagImageView.isHidden = false
        self.progressContainerView.isHidden = true
        
        if isLock {
            
            self.alphaView.backgroundColor = UIColor.white.withAlphaComponent(0.5)
            self.completedLbl.text = ""
            self.chapterFlagImageView.image = UIImage.init(named: "lock_gray_circle_pdf_icon")
           
        } else {
            
            if watchedCount > 0 && !isCompleted {
                
                //New
                self.circularProgressView.value = CGFloat(data["WatchedPerc"].floatValue)
                self.chapterFlagImageView.isHidden = true
                self.progressContainerView.isHidden = false
                self.percentLabel.text = "\(data["WatchedPerc"].intValue)%"
                
                self.completedLbl.text = ""
            }
            
            else if isCompleted {
                
                self.completedLbl.text = L102Language.isCurrentLanguageArabic() ? "مكتمل" : "Completed"
                //self.chapterFlagImageView.image = UIImage.init(named: "icon_greenRightCircle")
                
                //New
                self.circularProgressView.value = CGFloat(data["WatchedPerc"].floatValue)
                self.chapterFlagImageView.isHidden = true
                self.progressContainerView.isHidden = false
                self.percentLabel.text = "\(data["WatchedPerc"].intValue)%"
                
            } else {
                
                self.completedLbl.text = ""
                self.chapterFlagImageView.image = UIImage.init(named: "icon_play_active")
            }
            
        }
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
