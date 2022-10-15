//
//  QuestionTCell.swift
//  Spedia
//
//  Created by Viraj Sharma on 16/06/2020.
//  Copyright © 2020 Viraj Sharma. All rights reserved.
//

import UIKit
import SwiftyJSON
import Kingfisher

protocol QuestionTCellDelegate {
    func didTapOnQuestionTCell(atIndex : Int)
}
  
class QuestionTCell: UITableViewCell {
    
    //Obj..
    var delegateObj : QuestionTCellDelegate?
    
    //Outlets...
    @IBOutlet weak var questionImgView: UIImageView!
    @IBOutlet weak var questionLbl: CustomLabel!
    @IBOutlet weak var questionViewHeightConts: NSLayoutConstraint!
    @IBOutlet weak var questionViewBottomConts: NSLayoutConstraint!
    
    
    //MARK: Number CollView
    //@IBOutlet weak var numberCollViewHieght: NSLayoutConstraint!
    //@IBOutlet weak var numberCollView: UICollectionView!
    var numberCollViewCount = 0
    var selectIndex = 0
    var cellWitdh = CGFloat()
    
    
    var dataJson = JSON()
    var isAnswerType = false
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        //cellWitdh = self.numberCollView.frame.width
        //cellWitdh = round(cellWitdh / 9)
        //cellWitdh = cellWitdh + 1
        //numberCollViewHieght.constant = cellWitdh
        
        /*
        let nibName = UINib(nibName: "NumberCollCell", bundle:nil)
        self.numberCollView.register(nibName, forCellWithReuseIdentifier: "numberCollCell")
        
        self.numberCollView.delegate = self
        self.numberCollView.dataSource = self
        */
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

    func loadCollectionView( data : JSON) {
        
        self.dataJson = data
        
        //1
        let htmlStr = L102Language.isCurrentLanguageArabic() ? data["QuesionsTextAr"].stringValue : data["QuesionsTextAr"].stringValue
        
        
        self.questionLbl.attributedText = htmlStr.convertToAttributedFromHTML(fontSize: 22.0)
        self.questionLbl.textAlignment = L102Language.isCurrentLanguageArabic() ? .right : .left
        
        
        //2
        let url = URL(string: data["QuestionImage"].stringValue)
        self.questionImgView.kf.setImage(with: url, placeholder: UIImage(named: "collBkg"))
        
        
        //Check Empty Image
        let imageUrlString = data["QuestionImage"].stringValue
        
        if imageUrlString.isEmpty || imageUrlString.count < 5 {
            self.questionViewHeightConts.constant = 0.0
            self.questionViewBottomConts.constant = 0.0
        } else {
            self.questionViewHeightConts.constant = 140.0
            self.questionViewBottomConts.constant = 20.0
        }
        
        //self.numberCollView.reloadData()
        
        
    }
}




/*
//MARK:================================================
//MARK: CollectionView (Custom TabBar View)
//MARK:================================================

extension QuestionTCell: UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
 
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.numberCollViewCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = numberCollView.dequeueReusableCell(withReuseIdentifier: "numberCollCell", for: indexPath) as? NumberCollCell
    
        cell?.numberLabel.text = "\(indexPath.row + 1)"
        cell?.numberLabel.layer.cornerRadius = cellWitdh / 2
        cell?.numberLabel.clipsToBounds = true
        
        if isAnswerType {
            
            if indexPath.row == selectIndex {
               
                cell?.numberLabel.textColor = Colors.APP_LIME_GREEN
                //cell?.numberLabel.layer.borderWidth = 1
                cell?.numberLabel.layer.borderColor = Colors.APP_LIME_GREEN?.cgColor
                cell?.numberLabel.backgroundColor = UIColor.clear
                
            } else {
                
                cell?.numberLabel.textColor = Colors.APP_RED
                //cell?.numberLabel.layer.borderWidth = 1
                cell?.numberLabel.layer.borderColor = Colors.APP_RED?.cgColor
                cell?.numberLabel.backgroundColor = Colors.APP_RED_WITH5
                
            }
            
        } else {
             
            if indexPath.row == selectIndex {
               
                cell?.numberLabel.textColor = Colors.APP_LIME_GREEN
                cell?.numberLabel.layer.borderColor = Colors.APP_LIME_GREEN?.cgColor
                //cell?.numberLabel.backgroundColor = UIColor.clear
                
            } else {
                
                cell?.numberLabel.textColor = .gray
                cell?.numberLabel.layer.borderColor = Colors.APP_BORDER_GRAY?.cgColor
                //cell?.numberLabel.backgroundColor = Colors.APP_RED_WITH5
                
            }
        }
        
        
        
        return cell ?? UICollectionViewCell()
    
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: cellWitdh, height: cellWitdh)
    }
     
 
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
          return 0
    }
      
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
          return 10
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //self.outOfLabel.text = L102Language.isCurrentLanguageArabic() ? "السؤال \(indexPath.row+1)/\(self.dataJson.count)" : "Question \(indexPath.row+1)/\(self.dataJson.count)"
        
        self.questionLbl.text = self.dataJson[indexPath.row]["QuesionsTextAr"].stringValue.html2String
        
        selectIndex = indexPath.row
        self.numberCollView.reloadData()
        
        //Reload PerentView...
        self.delegateObj?.didTapOnQuestionTCell(atIndex: selectIndex)
        
    }
    
    
}


*/
