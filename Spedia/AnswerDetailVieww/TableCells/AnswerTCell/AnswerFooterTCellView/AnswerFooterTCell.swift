//
//  AnswerFooterTCell.swift
//  Spedia
//
//  Created by Viraj Sharma on 16/06/2020.
//  Copyright © 2020 Viraj Sharma. All rights reserved.
//

import UIKit
import SwiftyJSON

protocol AnswerFooterTCellDelegate {
    func didTabOnRelatedCollCell(data : JSON)
}

class AnswerFooterTCell: UITableViewCell {
    
    //Containers
    @IBOutlet weak var explainationContVieww: UIView!
    @IBOutlet weak var dowwnloadsContVieww: UIView!
    @IBOutlet weak var relatedVideosContVieww: UIView!
    
    //Download vieww
    @IBOutlet weak var fileLinkContVieww: UIView!
    @IBOutlet weak var imageLinkContVieww: UIView!
    @IBOutlet weak var fileLinkButton: UIButton!
    @IBOutlet weak var imageLinkButton: UIButton!
    
    
    //Obj..
    var delegateObj : AnswerFooterTCellDelegate?
    
    @IBOutlet weak var relatedCollView: UICollectionView!
    @IBOutlet weak var explanationPHLbl: CustomLabel!
    @IBOutlet weak var explanationLbl: CustomLabel!
    @IBOutlet weak var downloadedPHLbl: CustomLabel!
    @IBOutlet weak var filePHLbl: CustomLabel!
    @IBOutlet weak var imagePHLbl: CustomLabel!
    @IBOutlet weak var relatedVideoPHLbl: CustomLabel!
    
    //Data
    var selectIndex = 0
    var cellWitdh = CGFloat()
    var dataJson = JSON()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        let nibName = UINib(nibName: "AnswerRelatedCollCell", bundle:nil)
        self.relatedCollView.register(nibName, forCellWithReuseIdentifier: "answerRelatedCollCell")
        
        self.relatedCollView.delegate = self
        self.relatedCollView.dataSource = self
        
        
    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func loadViewWithData(data: JSON) {
        
        //HelpFile PictureFile SkillVideos QuesionsTextAr AnswerExplanation
        //1
        
        self.dataJson = data
        
        print("\n\nFooter Data------> \(data)\n\n")
        
        
        //MARK: 1st Explation of answerText
        let explanationStr = data["AnswerExplanation"].stringValue
        
        if explanationStr.isEmpty || explanationStr.count < 1 {
            
            self.explainationContVieww.isHidden = true
            
        } else {
            
            let htmlStr = explanationStr
            
            self.explanationLbl.attributedText = htmlStr.convertToAttributedFromHTML(fontSize: 12.0)
            self.explanationLbl.textAlignment = L102Language.isCurrentLanguageArabic() ? .right : .left
        }
        
        
        
        //MARK: 2nd Downloaded File's Name and Path's
        //HelpImageTextEn HelpFileTextAr  HelpImage HelpFile
        let fileLabelStr = data["HelpFileText" + Lang.code()].stringValue
        
        let imageLabelStr = data["HelpImageText" + Lang.code()].stringValue
        
        filePHLbl.text = fileLabelStr
        imagePHLbl.text = imageLabelStr
        
        
        let fileLinkStr = data["HelpFile"].stringValue
        let imageLinkStr = data["HelpImage"].stringValue
        self.dowwnloadsContVieww.isHidden = false
        if fileLinkStr.isEmpty && imageLinkStr.isEmpty {
            
            self.dowwnloadsContVieww.isHidden = true
            
        } else {
            
            if fileLinkStr.isEmpty {
                self.fileLinkContVieww.isHidden = true
            }
            
            if imageLinkStr.isEmpty {
                self.imageLinkContVieww.isHidden = true
            }
        }
        
        
        
        //MARK: 3rd Skills Video Or Related Videos
        let skillsVideos = data["SkillVideos"]
        
        if skillsVideos.count == 0 {
            self.relatedVideosContVieww.isHidden = true
        } else {
            self.relatedVideosContVieww.isHidden = false
            self.relatedCollView.reloadData()
        }
        
        
        
    }
    
}



//MARK:================================================
//MARK: CollectionView (Custom TabBar View)
//MARK:================================================

extension AnswerFooterTCell: UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
 
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataJson["SkillVideos"].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = self.relatedCollView.dequeueReusableCell(withReuseIdentifier: "answerRelatedCollCell", for: indexPath) as? AnswerRelatedCollCell

        cell?.answerTabButton.tag = indexPath.row
        cell?.answerTabButton.addTarget(self, action: #selector(didTapOnAnserButton(sender:)), for: .touchUpInside)
        
        cell?.configureViewWithDate(data: self.dataJson["SkillVideos"][indexPath.row])
        
        return cell ?? UICollectionViewCell()
    }
    
    
    
    @objc func didTapOnAnserButton(sender: UIButton) {
     
        let selectedModel = self.dataJson["SkillVideos"][sender.tag]

        self.delegateObj?.didTabOnRelatedCollCell(data : selectedModel)
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
          var witdh = self.relatedCollView.frame.width
        
          witdh = round(witdh / 2.4)
        
          //let height = //round(witdh / 0.8)
          
          return CGSize(width: witdh, height: 115)
        
    }
     
 
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
        
    }
      
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
          
        return 10
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //did select
     
        /*if let vc = VideoViewController.instantiate(fromAppStoryboard: .main) {
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }*/
        
    }
    
    
}
