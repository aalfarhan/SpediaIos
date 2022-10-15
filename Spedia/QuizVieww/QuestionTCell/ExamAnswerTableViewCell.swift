//
//  ExamAnswerTableViewCell.swift
//  ZIDNEI
//
//  Created by Xpertcube on 12/04/17.
//  Copyright © 2017 Xpertcube. All rights reserved.
//

import UIKit


protocol FormTableViewCellDelegate: class {
    func fieldValueChanged(cell: UITableViewCell, textField: UITextField)
}

class ExamAnswerTableViewCell: UITableViewCell {
    
    weak var delegate: FormTableViewCellDelegate?
    
    @IBOutlet weak var answerWebView:UIWebView!
    
    @IBOutlet weak var radioButtonImg:UIImageView!
    
    @IBOutlet weak var subjectNameLbl:UILabel!
    
    //@IBOutlet weak var answerViewNumber: XCUIView!
    
    @IBOutlet weak var answerLabelNumber: UILabel!
    //quizzHistory
    @IBOutlet weak var quizzNameLbl: UILabel!
    @IBOutlet weak var quizzAvgMarksLbl: UILabel!
    @IBOutlet weak var quizzPerformanceStatusLbl: UILabel!
    @IBOutlet weak var quizzDateLbl: UILabel!

    @IBOutlet weak var widthRadioButton: NSLayoutConstraint!
    
    @IBOutlet weak var answerTextField: UITextField!
    
    @IBOutlet weak var viewTextView: UIView!
    @IBOutlet weak var viewTextField: UIView!
    
    @IBOutlet weak var answerTextView: UITextView!
    
    @IBOutlet weak var answerWebViewHeight: NSLayoutConstraint!
    @IBOutlet weak var lblMachingAnswer: UILabel!
    
    @IBOutlet weak var heightTextField: NSLayoutConstraint!
    
    @IBOutlet weak var webViewMatching: UIWebView!
    
    
    @IBOutlet weak var lblCompSubQuestion: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    

    @IBAction func editingChange(_ sender: UITextField) {
        delegate?.fieldValueChanged(cell: self, textField: sender)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
