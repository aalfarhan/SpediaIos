//
//  AnswerTCell.swift
//  Spedia
//
//  Created by Viraj Sharma on 16/06/2020.
//  Copyright © 2020 Viraj Sharma. All rights reserved.
//

import UIKit
import SwiftyJSON
import Kingfisher
import Cosmos

protocol AnswerTCellDelegate {
    func didTapOnAnswerTCell(atIndex : Int)
}


class AnswerTCell: UITableViewCell {

    //Obj..
    var delegateObj : AnswerTCellDelegate?
    
    @IBOutlet weak var ratingTimeView: UIView!
    @IBOutlet weak var timeViewWitdh: NSLayoutConstraint!
    @IBOutlet weak var ratingViewWitdh: NSLayoutConstraint!
    @IBOutlet weak var numberCollView: UICollectionView!
    
    
    //Middle
    @IBOutlet weak var gradeLabel: CustomLabel!
    @IBOutlet weak var markLabel: CustomLabel!
    @IBOutlet weak var minLabel: CustomLabel!
    var rattingCount = 0
    @IBOutlet weak var timeSpentPHLabel: CustomLabel!
    @IBOutlet weak var resultScorePHLabel: CustomLabel!
    @IBOutlet weak var gradeImageView: UIImageView!
    
    @IBOutlet weak var rattingView: CosmosView!
    
    @IBOutlet weak var questionLbl: CustomLabel!
    @IBOutlet weak var outOfLabel: CustomLabel!
    
    var mainJson = JSON()
    
    var questionTotalCount = 0
    
    
    var selectIndex = 0
    var cellWitdh = CGFloat()
    @IBOutlet weak var numberCollViewHieght: NSLayoutConstraint!
    
    //Responsive
    @IBOutlet weak var numberCollViewLeftConst: NSLayoutConstraint!
    @IBOutlet weak var numberCollViewRightConst: NSLayoutConstraint!
    
 
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //...
        // Initialization code
        
        if UIDevice.isPad {
            
            ratingViewWitdh.constant = 350.0
            timeViewWitdh.constant = 350.0
            
            numberCollViewLeftConst.constant = 100.0
            numberCollViewRightConst.constant = 100.0
        
            cellWitdh = self.numberCollView.frame.width
            cellWitdh = round(cellWitdh / 9)
            cellWitdh = cellWitdh + 1
            numberCollViewHieght.constant = cellWitdh
            
        } else {
            
            cellWitdh = self.numberCollView.frame.width
            cellWitdh = round(cellWitdh / 9)
            cellWitdh = cellWitdh + 1
            numberCollViewHieght.constant = cellWitdh
        }
        
        
        
        let nibName = UINib(nibName: "NumberCollCell", bundle:nil)
        self.numberCollView.register(nibName, forCellWithReuseIdentifier: "numberCollCell")
        
        self.numberCollView.delegate = self
        self.numberCollView.dataSource = self
        
        
        //MARK: Ratting View Setup
        rattingView.settings.updateOnTouch = false
        rattingView.settings.fillMode = .half // Other fill modes: .half, .precise
        rattingView.settings.starSize = 15
        rattingView.settings.starMargin = 5
        
       
        //Set up
        self.timeSpentPHLabel.text = "time_spent_ph".localized()
        self.resultScorePHLabel.text = "results_score_ph".localized()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func loadCollectionView( data : JSON) {
        
        //1
        let htmlStr = L102Language.isCurrentLanguageArabic() ? data["QuesionsTextAr"].stringValue : data["QuesionsTextAr"].stringValue
        
        
        self.questionLbl.attributedText = htmlStr.convertToAttributedFromHTML(fontSize: 22.0)
        self.questionLbl.textAlignment = L102Language.isCurrentLanguageArabic() ? .right : .left
        
        //2
        //let url = URL(string: data["QuestionImage"].stringValue)
        //self.questionImgView.kf.setImage(with: url, placeholder: UIImage(named: "collBkg"))
     
        self.numberCollView.reloadData()
    
    }
    
    
    
    func loadMiddleView( data : JSON) {
        
        //1
        let timeStr = L102Language.isCurrentLanguageArabic() ? data["TimeTakenAr"].stringValue : data["TimeTakenEn"].stringValue
        
        let gradeStr = L102Language.isCurrentLanguageArabic() ? data["GradeTextAr"].stringValue : data["GradeTextEn"].stringValue
        
        let markStr = data["Mark"].stringValue
        
        let rattingCount = data["Rating"].doubleValue
        rattingView.rating = rattingCount
        
        
        //Fill
        self.minLabel.text = timeStr
        self.gradeLabel.text = gradeStr
        self.markLabel.text = markStr
        //self.minLabel.text = timeStr
        
        //Image
        let url = URL(string: data["GradeIcon"].stringValue)
        self.gradeImageView.kf.setImage(with: url, placeholder: UIImage.init(named: "collBkg"))
        
    }
    
    
    
}




//MARK:================================================
//MARK: CollectionView (Custom TabBar View)
//MARK:================================================

extension AnswerTCell: UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
 
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.questionTotalCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = numberCollView.dequeueReusableCell(withReuseIdentifier: "numberCollCell", for: indexPath) as? NumberCollCell
    
        cell?.numberLabel.text = "\(indexPath.row + 1)"
        cell?.numberLabel.layer.cornerRadius = cellWitdh / 2
        cell?.numberLabel.clipsToBounds = true
        
        let isUnAttendedBool = self.mainJson[indexPath.row]["UnAttended"].boolValue
        let isCorrectBool = self.mainJson[indexPath.row]["IsCorrect"].boolValue
        
        cell?.setNumberColors(isUnAttend: isUnAttendedBool, isCorrect: isCorrectBool)
        
        /*
        if indexPath.row == 0 {
            isAttendedBool = false
            isCorrectBool = false
        }
        
        if indexPath.row == 1 {
            isAttendedBool = true
            isCorrectBool = false
        }
        
        if indexPath.row == 2 {
            isAttendedBool = false
            isCorrectBool = true
        }
        
        if indexPath.row == 3 {
            isAttendedBool = true
            isCorrectBool = true
        }
        
        if indexPath.row == 4 {
            isAttendedBool = false
            isCorrectBool = false
        }
        */
        
        
        
        
        /*
        if self.mainJson[indexPath.row]["IsCorrect"].boolValue {
           
            cell?.numberLabel.textColor = Colors.APP_LIME_GREEN
            cell?.numberLabel.layer.borderWidth = 1
            cell?.numberLabel.layer.borderColor = Colors.APP_LIME_GREEN?.cgColor
            cell?.numberLabel.backgroundColor = UIColor.clear
            
        } else {
            
            cell?.numberLabel.textColor = Colors.APP_RED
            cell?.numberLabel.layer.borderWidth = 1
            cell?.numberLabel.layer.borderColor = Colors.APP_RED?.cgColor
            cell?.numberLabel.backgroundColor = Colors.APP_RED_WITH5
            
        }
        */
        self.outOfLabel.text = L102Language.isCurrentLanguageArabic() ? "السؤال \(selectIndex+1)/\(questionTotalCount)" : "Question \(selectIndex+1)/\(questionTotalCount)"
        
        return cell ?? UICollectionViewCell()
    
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: cellWitdh, height: cellWitdh)
    }
     
 
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
          return 0
    }
      
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
          return 8
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        selectIndex = indexPath.row
        
        //self.outOfLabel.text = L102Language.isCurrentLanguageArabic() ? "السؤال \(selectIndex+1)/\(questionTotalCount)" : "Question \(selectIndex+1)/\(questionTotalCount)"
        
        self.questionLbl.text = self.mainJson[selectIndex]["QuesionsTextAr"].stringValue.html2String
        
        
        self.numberCollView.reloadData()
        
        //Reload PerentView...
        self.delegateObj?.didTapOnAnswerTCell(atIndex: selectIndex)
        
    }
    
    
}
