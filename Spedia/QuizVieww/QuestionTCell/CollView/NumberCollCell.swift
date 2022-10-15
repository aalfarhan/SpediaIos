//
//  NumberCollCell.swift
//  Spedia
//
//  Created by Viraj Sharma on 16/06/2020.
//  Copyright © 2020 Viraj Sharma. All rights reserved.
//

import UIKit

class NumberCollCell: UICollectionViewCell {
     
    @IBOutlet weak var numberLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.numberLabel.textColor = .darkGray
        self.numberLabel.layer.borderWidth = 1
        self.numberLabel.layer.borderColor = Colors.APP_BORDER_GRAY?.cgColor
        self.numberLabel.backgroundColor = UIColor.clear
        
    }

    
    func setNumberColors(isUnAttend: Bool, isCorrect: Bool) {
        
        print(numberLabel.text ?? "",":-", "isAttend--> \(isUnAttend)", "isCorrect--> \(isCorrect)")
        
        
        if isUnAttend == false { //Means Attend The Quiz
            
            if isCorrect {
                
                self.numberLabel.backgroundColor = .clear
                self.numberLabel.textColor = Colors.APP_LIME_GREEN
                self.numberLabel.layer.borderColor = Colors.APP_LIME_GREEN?.cgColor
                
            } else {
                
                self.numberLabel.backgroundColor = Colors.APP_RED?.withAlphaComponent(0.20)
                self.numberLabel.textColor = Colors.APP_RED
                self.numberLabel.layer.borderColor = Colors.APP_RED?.cgColor
                
            }
            
            
        } else {
        
            self.numberLabel.backgroundColor = .clear
            self.numberLabel.textColor = .darkGray
            self.numberLabel.layer.borderColor = Colors.APP_BORDER_GRAY?.cgColor
       
            
        }
        
    }
    
}
