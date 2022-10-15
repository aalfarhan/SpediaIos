//
//  OnboardingCollCell.swift
//  Spedia
//
//  Created by Viraj Sharma on 03/07/2021.
//  Copyright © 2021 Viraj Sharma. All rights reserved.
//

import UIKit
import SwiftyJSON
import Kingfisher
import AVKit

class OnboardingCollCell: UICollectionViewCell {
    
    //1 Outlets.......
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleLabel: CustomLabel!
    @IBOutlet weak var subTitleLabel: CustomLabel!
    @IBOutlet weak var cellBkgImage: UIImageView!
    
    //NEW
    @IBOutlet var borderWhiteView: UIView!
    @IBOutlet var playerContainerVieww: UIView!
    //var player: AVPlayer!
    var avpController = AVPlayerViewController()
    var observer: NSKeyValueObservation?
    var isPlayerSetupDone = false
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if UIDevice.isPad {
            self.cellBkgImage.isHidden = true
        }
        
        self.playSetUpStory()
    }
    
   
    func playSetUpStory() {
    
        self.avpController.view.frame.size.height = self.playerContainerVieww.frame.size.height

        self.avpController.view.frame.size.width = self.playerContainerVieww.frame.size.width
        self.avpController.videoGravity = .resize //.resizeAspectFill
        self.avpController.view.backgroundColor = .clear
        //self.avpController.view.clipsToBounds = true
        self.avpController.showsPlaybackControls = true
        
        self.playerContainerVieww.addSubview(self.avpController.view)
    }
    
    
    
    //MARK: FOR IMAGEs
    func configureCellForImageWithData(data: JSON) {
        
        self.titleLabel.text = L102Language.isCurrentLanguageArabic() ?  data["TitleAr"].stringValue : data["TitleEn"].stringValue
        
        self.subTitleLabel.text = L102Language.isCurrentLanguageArabic() ?  data["SubTitleAr"].stringValue : data["SubTitleAr"].stringValue
        
        //Image
        let url = URL(string: data["Image"].stringValue)
        self.imgView.kf.setImage(with: url, placeholder: UIImage.init(named: ""))
        
        self.playerContainerVieww.isHidden = true
        self.imgView.isHidden = false
        self.borderWhiteView.isHidden = true
    }
    
    
    
    //MARK: FOR VIDEOs
    func configureCellForVideoWithData(data: JSON) {
    
        self.titleLabel.text = L102Language.isCurrentLanguageArabic() ?  data["TitleAr"].stringValue : data["TitleEn"].stringValue
        
        self.subTitleLabel.text = L102Language.isCurrentLanguageArabic() ?  data["SubTitleAr"].stringValue : data["SubTitleAr"].stringValue
        
        //Video URL
        let videoLinkStr =  data["Video"].stringValue
        
        let myURL = URL(string: videoLinkStr.addingPercentEncoding(withAllowedCharacters:.urlQueryAllowed) ?? "")
        
        DispatchQueue.main.async {
            if myURL != nil {
                let player = AVPlayer(url: myURL!)
                self.avpController.player = player
            }
        }
        
    
        self.borderWhiteView.isHidden = false
        self.playerContainerVieww.isHidden = false
        self.imgView.isHidden = true
    }
    
    
}
