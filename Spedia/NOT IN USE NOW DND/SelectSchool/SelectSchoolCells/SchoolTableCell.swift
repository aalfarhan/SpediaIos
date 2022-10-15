//
//  SchoolTableCell.swift
//  Spedia
//
//  Created by Viraj Sharma on 08/07/2020.
//  Copyright © 2020 Viraj Sharma. All rights reserved.
//

import UIKit
import SwiftyJSON

class SchoolTableCell: UITableViewCell {

    @IBOutlet weak var dashBorderView: CustomDashedView!
    @IBOutlet weak var schoolNameLbl: CustomLabel!
    @IBOutlet weak var checkedImgView: UIImageView!
    @IBOutlet weak var fromLbl: CustomLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //self.dashBorderView.addDashBorder()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func configureViewWith( data : JSON) {
        
        let nameStr = L102Language.isCurrentLanguageArabic() ? data["NameAr"].stringValue : data["NameEn"].stringValue
        schoolNameLbl.text = nameStr
        
        let fromStr = L102Language.isCurrentLanguageArabic() ? data["DecriptionAr"].stringValue : data["DecriptionEn"].stringValue
        fromLbl.text = fromStr
        
        //self.setNeedsLayout()
        //self.setNeedsDisplay()
    }
    
    
    
}



class CustomDashedView: UIView {
     
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    @IBInspectable var dashWidth: CGFloat = 0
    @IBInspectable var dashColor: UIColor = .clear
    @IBInspectable var dashLength: CGFloat = 0
    @IBInspectable var betweenDashesSpace: CGFloat = 0

    var dashBorder: CAShapeLayer?

    override func layoutSubviews() {
        super.layoutSubviews()
        dashBorder?.removeFromSuperlayer()
        let dashBorder = CAShapeLayer()
        dashBorder.lineWidth = dashWidth
        dashBorder.strokeColor = dashColor.cgColor
        dashBorder.lineDashPattern = [dashLength, betweenDashesSpace] as [NSNumber]
        dashBorder.frame = bounds
        dashBorder.fillColor = nil
        if cornerRadius > 0 {
            dashBorder.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
        } else {
            dashBorder.path = UIBezierPath(rect: bounds).cgPath
        }
        layer.addSublayer(dashBorder)
        self.dashBorder = dashBorder
    }
}



extension UIView {
    
    func addDashedVerticalLine(strokeColor: UIColor, lineWidth: CGFloat) {
        backgroundColor = .clear
        let shapeLayer = CAShapeLayer()
        shapeLayer.name = "DashedTopLine"
        shapeLayer.bounds = bounds
        shapeLayer.position = CGPoint(x: frame.width / 2, y: frame.height / 2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = strokeColor.cgColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        shapeLayer.lineDashPattern = [4, 4]
        
        let path = CGMutablePath()
        path.move(to: CGPoint.zero)
        path.addLine(to: CGPoint(x: 0, y: frame.height))
        shapeLayer.path = path
        
        layer.addSublayer(shapeLayer)
    }
    
}
