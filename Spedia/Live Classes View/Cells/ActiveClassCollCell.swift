//
//  ActiveClassCollCell.swift
//  Spedia
//
//  Created by Viraj Sharma on 13/07/2020.
//  Copyright © 2020 Viraj Sharma. All rights reserved.
//

import UIKit
import SwiftyJSON

protocol ActiveClassCollCellDelegate {
    func didTapOnJoinButton (model : JSON)
}


class ActiveClassCollCell: UICollectionViewCell {

    //1 Outlets...
    @IBOutlet weak var courseNameLbl: CustomLabel!
    @IBOutlet weak var timeAndDateLbl: CustomLabel!
    @IBOutlet weak var containerVieww: UIView!
    @IBOutlet weak var closeOpenButton: CustomButton!
    @IBOutlet weak var addToCartButton: UIButton!
    
    @IBOutlet weak var actualPriceLbl: CustomLabel!
    
    
    @IBOutlet weak var listView: UITableView!
    @IBOutlet weak var courseImageView: UIImageView!
    //@IBOutlet weak var subjectIconIV: UIImageView!
    
    @IBOutlet weak var closseOnlyIconButton: UIButton!
    
    @IBOutlet weak var downloadButton: CustomButton!
    @IBOutlet weak var seatAvaibleView: UIView!
    @IBOutlet weak var availableLbl: CustomLabel!
    @IBOutlet weak var reservedLbl: CustomLabel!
    @IBOutlet weak var soldOutLbl: CustomLabel!
    @IBOutlet weak var moreButton: CustomButton!
    
    @IBOutlet weak var soldOutViewHeight: NSLayoutConstraint!
    @IBOutlet weak var constForCourseIVHeight: NSLayoutConstraint!
    
    @IBOutlet weak var constForAddToCartBottom: NSLayoutConstraint!
    
    
    //2 Data
    var subListData = JSON()
    var delegateObj : ActiveClassCollCellDelegate?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        containerVieww.layer.cornerRadius = 10
        containerVieww.layer.borderWidth = 1
        containerVieww.layer.borderColor = Colors.APP_BORDER_GRAY?.cgColor
        containerVieww.backgroundColor = UIColor.clear
        constForCourseIVHeight.constant = UIDevice.isPad ? 130 : 100
        constForAddToCartBottom.constant = UIDevice.isPad ? 20 : 10
        
        //1
        let nibName = UINib(nibName: "JoinClassCell", bundle:nil)
        self.listView.register(nibName, forCellReuseIdentifier: "joinClassCell")
        self.listView.dataSource = self
        self.listView.delegate = self
        
        
        self.addToCartButton.setTitle("buy_now_ph".localized(), for: .normal)
        self.soldOutLbl.text = "sold_out".localized()
        self.moreButton.setTitle("read_more".localized(), for: .normal)
        self.moreButton.setTitle("read_less".localized(), for: .selected)
        
    }
    
    
    func configureCellWithData(data:JSON) {
         
        //0
        self.subListData = data["SubList"]
        
        //0.1
        self.moreButton.isHidden = self.subListData.count > 3 ? false : true
        
        //1
        let nameStr = L102Language.isCurrentLanguageArabic() ? data["CourseNameAr"].stringValue : data["CourseNameEn"].stringValue

        self.courseNameLbl.text = nameStr
        
        //1.1
        let timeStr = L102Language.isCurrentLanguageArabic() ? data["CourseTimeAr"].stringValue : data["CourseTimeEn"].stringValue

        self.timeAndDateLbl.text = "  " + timeStr + "  "
        
        //1.2
        let availableSeatsStr = "available".localized() + data["AvailableSeats"].stringValue
        self.availableLbl.text = availableSeatsStr
        
        
        //1.2
        let reservedSeatsStr = "reserved".localized() + data["ReservedSeats"].stringValue
        self.reservedLbl.text = reservedSeatsStr
        
        
        //1.3
        
        availableLbl.isHidden = true
        reservedLbl.isHidden = true
        soldOutLbl.isHidden = true
        seatAvaibleView.isHidden = true
        
        
        if data["SoldOut"].boolValue {
         soldOutLbl.isHidden = false
         seatAvaibleView.isHidden = false
         //seatAvaibleView.backgroundColor = Colors.APP_RED
        }
        
        
        //2
        
        //2.1 Get Values...
        
        let actualPriceStr = data["ActualPriceText"].stringValue
        self.actualPriceLbl.text = actualPriceStr
        
    
        
        //3
        //let subjectNameStr = L102Language.isCurrentLanguageArabic() ? data["SubjectNameAr"].stringValue : data["SubjectNameEn"].stringValue
        
        self.downloadButton.setTitle("download".localized(), for: .normal)
         
        
        //4
        //let subjectIconUrl = URL(string: data["SubjectIcon"].stringValue)
        //self.subjectIconIV.kf.setImage(with: subjectIconUrl, placeholder: UIImage(named: ""))
        
        //5
        let courseImageUrl = URL(string: data["Courseimage"].stringValue)
        self.courseImageView.kf.setImage(with: courseImageUrl, placeholder: nil)
        
        //6
        //let subjectColorCode = data["SubjectColour"].stringValue
        
        //self.subjectNameButton.backgroundColor = UIColor.init(hexaRGB: "\(subjectColorCode)")
        
        //7
        self.listView.reloadData()
        
    }

    
}



extension ActiveClassCollCell : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.subListData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.listView.dequeueReusableCell(withIdentifier: "joinClassCell") as? JoinClassCell
                    
        cell?.selectionStyle = .none
        
        let titleStr = L102Language.isCurrentLanguageArabic() ? self.subListData[indexPath.row]["TitleAr"].stringValue : self.subListData[indexPath.row]["TitleEn"].stringValue
        
        let subTitleStr = L102Language.isCurrentLanguageArabic() ? self.subListData[indexPath.row]["ClassTimeAr"].stringValue : self.subListData[indexPath.row]["ClassTimeEn"].stringValue
        
        cell?.classTitleLbl.text = titleStr
        cell?.classTimeLbl.text = subTitleStr
        
        
        cell?.joinButton.tag = indexPath.row
        cell?.joinButton.addTarget(self, action: #selector(joinButtonTapped(sender:)), for: .touchUpInside)
        
        if self.subListData[indexPath.row]["IsLive"].boolValue {
          cell?.joinButton.isHidden = false
        } else {
          cell?.joinButton.isHidden = true
        }
        
        return cell ?? UITableViewCell()
    }
 
    
    
    //XLR8 - Status Change Action...
    @objc func joinButtonTapped(sender: UIButton) {
      
      let data = self.subListData[sender.tag]
      print("\n\n Selected Data------> \(data)\n\n")
      self.delegateObj?.didTapOnJoinButton(model: data)
    
    }
        
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 60
    
    }
    

    //func didTapOnQuestionTCell(atIndex : Int) {
    //}
    
}
