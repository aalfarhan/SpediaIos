//
//  VideoStatsTableCell.swift
//  Spedia
//
//  Created by Viraj Sharma on 30/12/2020.
//  Copyright © 2020 Viraj Sharma. All rights reserved.
//

import UIKit
import SwiftyJSON

class VideoStatsTableCell: UITableViewCell {

    
    //Outlets.....
    @IBOutlet weak var containerVieww: UIView!
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var subjectNameLabel: CustomLabel!
    @IBOutlet weak var percentLabel: CustomLabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var tabCellButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        containerVieww.layer.cornerRadius = 10.0
        containerVieww.layer.borderWidth = 1
        containerVieww.layer.borderColor = Colors.APP_BORDER_GRAY?.cgColor
        
        
        colorView.layer.cornerRadius = 10.0
        
    }

    
    //Configration...
    func configureCellWithData(data : JSON) {
        
        //0
        let colorCode = data["ColourCode"].stringValue
        
        //1
        self.subjectNameLabel.text = L102Language.isCurrentLanguageArabic() ? data["SubjectNameAr"].stringValue : data["SubjectNameEn"].stringValue
        
        //2
        self.colorView.backgroundColor = UIColor.init(hexaRGB: "\(colorCode)")?.withAlphaComponent(0.10)
        
        
        //3
        self.percentLabel.text = data["WatchedVideosPerc"].stringValue + " %"
        
        //4
        self.progressBar.progress = data["WatchedVideosPerc"].floatValue /  100.0
        
        self.progressBar.progressTintColor = UIColor.init(hexaRGB: "\(colorCode)")
        
        
        //5
        let url = URL(string: data["IconPath"].stringValue)
        
        self.iconImageView.kf.setImage(
            with: url,
            placeholder: UIImage(named: "placeholderImage"),
            options: [], completionHandler:  {
                result in
                switch result {
                case .success(let value):
                    print("Task done for: \(value.source.url?.absoluteString ?? "")")
                    self.iconImageView.image = self.iconImageView.image?.imageWithColor(color1: UIColor.init(hexaRGB: "\(colorCode)") ?? UIColor.white)
                    
                case .failure(let error):
                    print("Job failed: \(error.localizedDescription)")
                }
            })
        
    }
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
