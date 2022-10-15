//
//  ExpandedCollCell.swift
//  Spedia
//
//  Created by Viraj Sharma on 24/06/2020.
//  Copyright © 2020 Viraj Sharma. All rights reserved.
//

import UIKit
import SwiftyJSON


protocol ExpandedCollCellDelegate {
    func didTapOnExpandedCell (model : JSON)
}

class ExpandedCollCell: UICollectionViewCell {

    var delegateObj : ExpandedCollCellDelegate?
    
    @IBOutlet weak var containerVieww: UIView!
    @IBOutlet weak var greenishView: UIView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var unitNameLbl: CustomLabel!
    @IBOutlet weak var chappterLbl: CustomLabel!
    @IBOutlet weak var coursesLbl: CustomLabel!
    @IBOutlet weak var arrowButton: UIButton!
    @IBOutlet weak var listView: UITableView!
    
    @IBOutlet weak var guidelineCountLbl: CustomLabel!
    @IBOutlet weak var quizCountLbl: CustomLabel!
    
    
    //
    @IBOutlet weak var quizRightPaddingConts: NSLayoutConstraint!
    @IBOutlet weak var notesRightPaddingConts: NSLayoutConstraint!
     
    
    var subUnitData = JSON()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let nibName = UINib(nibName: "ExpandShowTCell", bundle:nil)
        self.listView.register(nibName, forCellReuseIdentifier: "expandShowTCell")
        
        self.listView.delegate = self
        self.listView.dataSource = self
        
        self.containerVieww.layer.cornerRadius = 15.0
        self.containerVieww.layer.borderColor = Colors.APP_LIGHT_GREEN?.cgColor
        self.containerVieww.layer.borderWidth = 0.5
       
        
        if UIDevice.isPad {
            self.quizRightPaddingConts.constant = 300
            self.notesRightPaddingConts.constant = 300
        }
    }
    
    func configureCellWithData(data:JSON) {
    
      //1
      var titleStr = L102Language.isCurrentLanguageArabic() ? data[UnitDetailKey.NameAr].stringValue : data[UnitDetailKey.NameEn].stringValue

      if titleStr.isEmpty {
          titleStr = "An Introduction to Ecology"
      }
      
      self.unitNameLbl.text = titleStr
      
      //2
      let counrseCountStr = L102Language.isCurrentLanguageArabic() ? data[UnitDetailKey.CoursesCountAr].stringValue : data[UnitDetailKey.CoursesCountEn].stringValue

      self.coursesLbl.text = counrseCountStr
      
      //3
      
      let chapterCountStr = L102Language.isCurrentLanguageArabic() ? data[UnitDetailKey.ChaptersCountAr].stringValue : data[UnitDetailKey.ChaptersCountEn].stringValue

      self.chappterLbl.text = chapterCountStr
       
        
      //3.1
      let quizCountStr = " \(data["QuizCount"].stringValue) "
        
        self.quizCountLbl.text = quizCountStr + "quiz_count_ph".localized()
        //L102Language.isCurrentLanguageArabic() ? quizCountStr + "quiz_count_ph".localized() : "quiz_count_ph".localized() + quizCountStr
        
    
      //3.2
      let guidelineCountStr = " \(data["GuidelineCount"].stringValue) "
        
      self.guidelineCountLbl.text = guidelineCountStr + "note_count_ph".localized()
      //L102Language.isCurrentLanguageArabic() ? guidelineCountStr + "note_count_ph".localized() : "note_count_ph".localized() + guidelineCountStr
      

        
      //4
      
      let url = URL(string: data[UnitDetailKey.Image].stringValue)
      self.imgView.kf.setImage(with: url, placeholder: UIImage(named: "collBkg"))
      
      self.subUnitData = data["SubUnits"]
      
      self.listView.reloadData()
        
    }
    

}





extension ExpandedCollCell : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.subUnitData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.listView.dequeueReusableCell(withIdentifier: "expandShowTCell") as? ExpandShowTCell
                        
        cell?.selectionStyle = .none
            
        let titleStr = L102Language.isCurrentLanguageArabic() ? self.subUnitData[indexPath.row]["NameAr"].stringValue : self.subUnitData[indexPath.row]["NameEn"].stringValue

        
        cell?.titleLbl.text = titleStr
        
        cell?.cellTapButton.tag = indexPath.row
        cell?.cellTapButton.addTarget(self, action: #selector(didTapCellAction(sender:)), for: .touchUpInside)
         
        //cell?.containerVieww.layer.borderWidth = 1
        //cell?.containerVieww.layer.borderColor = UIColor.clear.cgColor
        //cell?.containerVieww.backgroundColor = Colors.APP_RED_WITH5
        
        return cell ?? UITableViewCell()
    
    }
 
    
    
    //XLR8 - Status Change Action...
    @objc func didTapCellAction(sender: UIButton) {
    
        let data = self.subUnitData[sender.tag]
        self.delegateObj?.didTapOnExpandedCell(model: data)
        
    }
        
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 65 //UITableView.automaticDimension
    
    }
    
}
