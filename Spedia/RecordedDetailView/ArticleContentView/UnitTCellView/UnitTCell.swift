//
//  UnitTCell.swift
//  Spedia
//
//  Created by Viraj Sharma on 03/02/22.
//  Copyright © 2022 Viraj Sharma. All rights reserved.
//

import UIKit
import SwiftyJSON

protocol UnitTCellDelegate {
    func didTapOnPlayButton(dataModel: JSON)
}

class UnitTCell: UITableViewCell {

    //Obj..
    var delegateObj : UnitTCellDelegate?
     
    @IBOutlet weak var articleTitleLbl: CustomLabel!
    
    @IBOutlet weak var containerVieww: UIView!
    
    @IBOutlet weak var borderContainerVieww: UIView!
    
    @IBOutlet weak var titleLbl: CustomLabel!
    
    @IBOutlet weak var downArrowImage: UIImageView!
    
    @IBOutlet weak var expandTabButton: UIButton!
    
    //Responsive..
    @IBOutlet weak var articleTitleHeightConst: NSLayoutConstraint!
    
    @IBOutlet weak var listView: UITableView!
    var dataJson = JSON()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.borderContainerVieww.layer.cornerRadius = 5.0
        self.borderContainerVieww.clipsToBounds = true
        self.borderContainerVieww.layer.borderColor = Colors.APP_LIGHT_GREEN?.cgColor
        self.borderContainerVieww.layer.borderWidth = 1.5
        
        self.registerTableViewCell()
        
    }

  
    func registerTableViewCell() {
        
        self.listView.register(UINib(nibName : "SubUnitSectionHCell", bundle: nil), forCellReuseIdentifier: "subUnitSectionHCell")
        
        self.listView.register(UINib(nibName : "ChapterTCell", bundle: nil), forCellReuseIdentifier: "chapterTCell")
        
        self.listView.dataSource = self
        self.listView.delegate = self
        
    }
    
    func configureViewWithData(data: JSON, atIndex: Int) {
        
        //1
        let titleText = data["Title" + Lang.code()].stringValue
        self.titleLbl.text = titleText
        
        //2 Arrow Animation
        self.downArrowImage?.transform = CGAffineTransform(rotationAngle: data["Expand"].boolValue ? .pi : 0)
    
        //4 Hide Show only first index
        self.articleTitleHeightConst.constant = atIndex == 0 ? 40.0 : 0.0
        
        self.listView.reloadData()
        self.layoutIfNeeded()
    }
    
}



//===========================
//MARK: LIST VIEW
//===========================

extension UnitTCell : UITableViewDelegate, UITableViewDataSource {
    
    //MARK: Section View
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.dataJson["skills"].count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let cell = self.listView.dequeueReusableCell(withIdentifier: "subUnitSectionHCell") as? SubUnitSectionHCell
        
        cell?.selectionStyle = .none
        
        let sectionNameStr = self.dataJson["skills"][section]["Title" + Lang.code()].stringValue
        cell?.sectionLbl.text = sectionNameStr
        cell?.lockIconImageView.isHidden = self.dataJson["skills"][section]["IsLocked"].boolValue ? false : true
        return cell ?? UITableViewCell()
        
    }
    
    
    //MARK: Table ROW's
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataJson["skills"][section]["subskill"].count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.listView.dequeueReusableCell(withIdentifier: "chapterTCell") as? ChapterTCell
        
        cell?.selectionStyle = .none
        
        let chaptterNameStr = self.dataJson["skills"][indexPath.section]["subskill"][indexPath.row]["SubSkillText" + Lang.code()].stringValue
        
        cell?.chapterNameLbl.text = chaptterNameStr
        
        cell?.playTabButton.layer.shadowOffset.width = CGFloat(indexPath.section)
        cell?.playTabButton.tag = indexPath.row
        cell?.playTabButton.addTarget(self, action: #selector(playCellButtonAction(sender:)), for: .touchUpInside)
        
        //New VideoCount
        let videoCount = self.dataJson["skills"][indexPath.section]["subskill"][indexPath.row]["VideoCount"].stringValue
        cell?.countLabel.text = " \(videoCount) "
        
        let hasQuizIcon = self.dataJson["skills"][indexPath.section]["subskill"][indexPath.row]["HasQuiz"].boolValue
        let hasBookIcon = self.dataJson["skills"][indexPath.section]["subskill"][indexPath.row]["HasGuideLine"].boolValue
        
        cell?.bookIconImage.isHidden = !hasBookIcon
        cell?.quizIconImage.isHidden = !hasQuizIcon
        
        
        return cell ?? UITableViewCell()
        
    }
    
    
    @objc func playCellButtonAction(sender: UIButton) {

        let sectionInt = Int(sender.layer.shadowOffset.width)
        let rowInt = sender.tag
        
        print("\n\nYour Tag is: \(sectionInt)")
        print("\nYour Tag is: \(rowInt)")
        
        self.delegateObj?.didTapOnPlayButton(dataModel: self.dataJson["skills"][sectionInt]["subskill"][rowInt])
    }
 
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension //Will come static 50.0 size
    }

}
