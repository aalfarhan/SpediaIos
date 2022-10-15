//
//  QuizRemainPopView.swift
//  Spedia
//
//  Created by Viraj Sharma on 10/07/2021.
//  Copyright © 2021 Viraj Sharma. All rights reserved.
//

import UIKit

protocol QuizRemainPopViewDelegate {
    func didConfirmButtonClicked()
    func didCancelButtonClicked()
}


class QuizRemainPopView: UIView {
    
    //0 Delegates...
    var delegateObj : QuizRemainPopViewDelegate?
    
    //1 Objects...
    @IBOutlet var containerVieww: UIView!
    
    @IBOutlet var totalAnswerLbl: CustomLabel!
    @IBOutlet var totalSkipedLbl: CustomLabel!
    @IBOutlet var totalAnswerCountLbl: CustomLabel!
    @IBOutlet var totalSkipedCountLbl: CustomLabel!
    
    @IBOutlet var confirmButton: CustomButton!
    @IBOutlet var cancelButton: CustomButton!
    
    
    //2 Data.........
    var totalAnswerCount = 0
    var totalSkippedCount = 0
    
    
    //1
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    
    }
    
    //2
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    
    
    //3
    private func commonInit() {
        
        Bundle.main.loadNibNamed("QuizRemainPopView", owner: self, options: nil)
        addSubview(containerVieww)
        
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        
        self.containerVieww.frame = self.bounds
        self.containerVieww.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.containerVieww.layer.cornerRadius = 10
        self.containerVieww.clipsToBounds = true
        
        self.setUpView()
    }
    
    
    
    private func setUpView() {
        
        //0
        //self.leftPeddingConst.constant = UIDevice.isPad ? 50 : 16
        //self.rightPeddingConst.constant = UIDevice.isPad ? 50 : 16
        
        //1
        self.totalAnswerLbl.text = "total_answer_ph".localized()
        self.totalSkipedLbl.text = "total_skiped_ph".localized()
        
        self.confirmButton.setTitle("confirm_ph".localized(), for: .normal)
        self.cancelButton.setTitle("cancel_ph".localized(), for: .normal)
         
    }
    
    
    
    func loadDataWith(totalAnserValue: String, totalSkipValue : String)  {
         
        self.totalAnswerCountLbl.text = totalAnserValue
        self.totalSkipedCountLbl.text = totalSkipValue
        
    }
    
    
    @IBAction func confirmButtonAction(_ sender: Any) {
        self.delegateObj?.didConfirmButtonClicked()
    }
    
    
    @IBAction func cancelButtonAction(_ sender: Any) {
        self.delegateObj?.didCancelButtonClicked()
    }
    
}



