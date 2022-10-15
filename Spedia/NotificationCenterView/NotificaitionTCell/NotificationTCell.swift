//
//  NotificationTCell.swift
//  Spedia
//
//  Created by Viraj Sharma on 16/09/22.
//  Copyright © 2022 Viraj Sharma. All rights reserved.
//

import UIKit
import SwiftyJSON

class NotificationTCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var dateLabel: CustomLabel!
    @IBOutlet weak var headerTitleLbl: CustomLabel!
    @IBOutlet weak var detailLbl: CustomLabel!
    @IBOutlet weak var deleteButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        //1
        self.containerView.clipsToBounds = true
        self.containerView.layer.cornerRadius = 8.0
        self.containerView.backgroundColor = UIColor.init(hexaRGB: "EDEDED")
        
        //2
        self.headerTitleLbl.alpha = 1.0
        self.detailLbl.alpha = 1.0
        

    }

    /*override func prepareForReuse() {
        super.prepareForReuse()
        self.containerView.backgroundColor = UIColor.init(hexaRGB: "EDEDED")
        
        //2
        self.headerTitleLbl.alpha = 1.0
        self.detailLbl.alpha = 1.0
    }*/
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureNotificaitonCell(dataModel: JSON, isRead: Bool) {
        
        //1
        //self.dateLabel.text = dataModel["SendDate"].stringValue
        //self.headerTitleLbl.text = dataModel["notificaitonTitle"].stringValue
        //self.dateLabel.text = dataModel["notificationMsg"].stringValue
    
        //2 Check
        if isRead {
            self.containerView.backgroundColor = UIColor.init(hexaRGB: "FAFAFA")
            self.headerTitleLbl.alpha = 0.40
            self.detailLbl.alpha = 0.60
        } else {
            self.containerView.backgroundColor = UIColor.init(hexaRGB: "EDEDED")
            self.headerTitleLbl.alpha = 1.0
            self.detailLbl.alpha = 1.0
        }
    }
    
}
