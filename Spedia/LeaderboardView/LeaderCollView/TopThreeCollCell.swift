//
//  TopThreeCollCell.swift
//  Spedia
//
//  Created by Viraj Sharma on 23/12/2020.
//  Copyright © 2020 Viraj Sharma. All rights reserved.
//

import UIKit
import SwiftyJSON

class TopThreeCollCell: UICollectionViewCell {
    
    //1 Cell Outlets.....
    @IBOutlet weak var containerVieww: UIView!
    
    @IBOutlet weak var crownImageIcon: UIImageView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var rankLabel: CustomLabel!
    @IBOutlet weak var pontsLabel: CustomLabel!
    @IBOutlet weak var nameLabel: CustomLabel!
    
    //2 Constratins For Responsive
    @IBOutlet weak var imgViewHeightConst: NSLayoutConstraint!
    
    @IBOutlet weak var circleImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //containerVieww.layer.cornerRadius = 10.0
        //containerVieww.layer.borderWidth = 1
        //containerVieww.layer.borderColor = UIColor.red.cgColor
        
        self.rotateView(targetView: self.circleImageView)
    }

    
    // Rotate <targetView> indefinitely
    private func rotateView(targetView: UIImageView, duration: Double = 5.0) {
        UIView.animate(withDuration: duration, delay: 0.0, options: .curveLinear, animations: {
            targetView.transform = targetView.transform.rotated(by: .pi)
        }) { finished in
            //self.rotateView(targetView: targetView, duration: duration)
        }
    }
    
    func reloadCellNow() {
        self.layoutIfNeeded()
        imgView.layer.cornerRadius = imgViewHeightConst.constant / 2
    }
    
    
    func configureCellWithData(data: JSON) {
    
        self.nameLabel.text = data["FullName"].stringValue
        self.pontsLabel.text = L102Language.isCurrentLanguageArabic() ?  data["Points"].stringValue + " " + "نقطة" : data["Points"].stringValue + " pts"
        
        self.rankLabel.text = "#" + data["Rank"].stringValue
        let url = URL(string: data["ProfilePicPath"].stringValue)
        self.imgView.kf.setImage(with: url, placeholder: UIImage.init(named: "profile_icon_placeholder"))
    
    }
    
}

