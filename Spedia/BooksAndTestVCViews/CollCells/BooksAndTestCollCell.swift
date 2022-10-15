//
//  BooksAndTestCollCell.swift
//  Spedia
//
//  Created by Viraj Sharma on 10/06/2020.
//  Copyright © 2020 Viraj Sharma. All rights reserved.
//

import UIKit
import SVProgressHUD
import SwiftyJSON

class BooksAndTestCollCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLbl: CustomLabel!
    @IBOutlet weak var subTitleLbl: CustomLabel!
    @IBOutlet weak var containerVieww: UIView!
    //@IBOutlet weak var downloadWithOutAns: CustomButton!
    //@IBOutlet weak var downloadWithAns: CustomButton!
    @IBOutlet weak var downloadPdfLbl: CustomLabel!
    @IBOutlet weak var bkgImageView: UIImageView!
    
    //Three Button
    @IBOutlet weak var withOutAnswerButton: CustomButton!
    @IBOutlet weak var withAnswerButton: CustomButton!
    @IBOutlet weak var answerButton: CustomButton!
    
    //Lock View
    @IBOutlet weak var lockView: UIView!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        // Initialization code
        containerVieww.layer.cornerRadius = 10
        containerVieww.layer.borderWidth = 1
        containerVieww.layer.borderColor = Colors.APP_BORDER_GRAY?.cgColor
        containerVieww.backgroundColor = UIColor.clear
        
        
        self.downloadPdfLbl.text = L102Language.isCurrentLanguageArabic() ? "تحميل الملفات بصيغة PDF" : "Download results in PDF files:"
        
        
        /*
        let withOutAnswerTitle = L102Language.isCurrentLanguageArabic() ? "بدون إجابة" : " Without Answer "
        let withAnswerTitle = L102Language.isCurrentLanguageArabic() ? "مع إجابة" : " With Answer "
        let answerTitle = L102Language.isCurrentLanguageArabic() ? "إجابة" : " Answer "
        
        let downloadIconWhiteImage = #imageLiteral(resourceName: "icon_download_white")
        let downloadIconGreenImage = #imageLiteral(resourceName: "icon_download_green")
        
        self.withOutAnswerButton.setAttributedTextWithImagePrefix(image: downloadIconGreenImage, text: withOutAnswerTitle, for: .normal)
        
        self.withAnswerButton.setAttributedTextWithImagePrefix(image: downloadIconWhiteImage, text: withAnswerTitle, for: .normal)
        
        self.answerButton.setAttributedTextWithImagePrefix(image: downloadIconGreenImage, text: answerTitle, for: .normal)
        */
    }
    
    func configureBookTCell(dataModel: JSON) {
        //Lock View
        self.lockView.isHidden = dataModel[QuestionAnswerKey.isLock].boolValue ? false : true
        
        self.withOutAnswerButton.isHidden = !dataModel["WithoutAnswerShow"].boolValue
        self.withAnswerButton.isHidden = !dataModel["WithAnswerShow"].boolValue
        self.answerButton.isHidden = !dataModel["AnswerShow"].boolValue
        
        let withOutAnswerTitle = " \(dataModel["WithoutAnswerTitle"+Lang.code()].stringValue) "
        let withAnswerTitle = " \(dataModel["WithAnswerTitle"+Lang.code()].stringValue) "
        let answerTitle = " \(dataModel["AnswerTitle"+Lang.code()].stringValue) "
        
        let downloadIconWhiteImage = #imageLiteral(resourceName: "icon_download_white")
        let downloadIconGreenImage = #imageLiteral(resourceName: "icon_download_green")
        
        self.withOutAnswerButton.setAttributedTextWithImagePrefix(image: downloadIconGreenImage, text: withOutAnswerTitle, for: .normal)
        self.withAnswerButton.setAttributedTextWithImagePrefix(image: downloadIconWhiteImage, text: withAnswerTitle, for: .normal)
        self.answerButton.setAttributedTextWithImagePrefix(image: downloadIconGreenImage, text: answerTitle, for: .normal)

    }

}



