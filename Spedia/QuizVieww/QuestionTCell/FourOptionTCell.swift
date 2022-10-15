//
//  FourOptionTCell.swift
//  Spedia
//
//  Created by Viraj Sharma on 16/06/2020.
//  Copyright © 2020 Viraj Sharma. All rights reserved.
//

import UIKit
import SwiftyJSON


class FourOptionTCell: UITableViewCell {

    @IBOutlet weak var containerVieww: UIView!
    @IBOutlet weak var optionsLabel: CustomLabel!
    @IBOutlet weak var checkedImgView: UIImageView!
    @IBOutlet weak var fourOptionTapButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.containerVieww.layer.cornerRadius = 10
        self.containerVieww.layer.borderWidth = 1
        self.containerVieww.layer.borderColor = Colors.APP_BORDER_GRAY?.cgColor
        self.containerVieww.backgroundColor = .clear
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func loadOptionTextView( data : JSON) {
        
        //1
        let htmlStr = L102Language.isCurrentLanguageArabic() ? data["OptionText"].stringValue : data["OptionText"].stringValue
        
        
        self.optionsLabel.attributedText = htmlStr.convertToAttributedFromHTML(fontSize: 15.0)
        self.optionsLabel.textAlignment = L102Language.isCurrentLanguageArabic() ? .right : .left
        
        
    }
    
    
    func selectionViewSetUp(isCheck: Bool) {
        if isCheck {
            
            self.containerVieww.backgroundColor = Colors.APP_BORDER_GRAY
            self.checkedImgView.isHidden = false
            
        } else {
            
            self.containerVieww.backgroundColor = .clear
            self.checkedImgView.isHidden = true
        }
    }
    
    
    func selectionViewSetUpAnswer(isCheck: Bool, isCorrect: Bool) {
        
        if !isCheck {
         self.containerVieww.backgroundColor = Colors.APP_BORDER_GRAY
         self.checkedImgView.isHidden = true
        }
        
        if isCorrect {
            
            self.containerVieww.backgroundColor = Colors.APP_LIME_GREEN?.withAlphaComponent(0.20)
            self.checkedImgView.isHidden = false
            self.checkedImgView.image = #imageLiteral(resourceName: "icon_check_green_24pt")
        }
        
        if isCheck && !isCorrect {
            
            self.containerVieww.backgroundColor = Colors.APP_RED?.withAlphaComponent(0.20)
            self.checkedImgView.isHidden = false
            self.checkedImgView.image = #imageLiteral(resourceName: "icon_cross_red_24pt")
            
        }
    }
    
    
}



/*
func isHideWebview(isHide: Bool, cell: ExamAnswerTableViewCell) {
        cell.answerWebView.isHidden = isHide
        cell.radioButtonImg.isHidden = isHide
        //   cell.answerWebViewHeight.constant = isHide ? 0 : cell.answerWebView.scrollView.contentSize.height
    }
    
    func isHideInputText(isHide: Bool, cell:ExamAnswerTableViewCell, type: QuestionType) {
        cell.answerTextField.isHidden = isHide
        //cell.answerViewNumber.isHidden = isHide
        cell.viewTextField.isHidden = isHide
        cell.viewTextView.isHidden = true
        cell.answerTextField.textAlignment = .right
        cell.answerTextView.textAlignment = .right
        
        if (type == .shortAnswer ) {
            cell.viewTextView.isHidden = false
            cell.viewTextField.isHidden = true
            return
        }
        
        if (type == .shortAnswerWithChoice ) {
            cell.viewTextView.isHidden = false
            cell.viewTextField.isHidden = true
            return
        }
        
        if (type == .comprehension || type == .written ) {
            cell.viewTextField.isHidden = true
            cell.viewTextView.isHidden = false
            return
        }
    }
    
    func setWebViewData(cell: ExamAnswerTableViewCell, optionText: String) {
//        let decodedString = decodeString(string: optionText)
//        let htmlString = Utilities.getHtmlStringByAdding(string: decodedString)
        
        let htmlString = getHtmlStringByAdding(string: optionText, isLtr: false)
        cell.answerWebView.loadHTMLString(htmlString, baseURL: nil)
//        print("content\(htmlString)")
    }
*/
