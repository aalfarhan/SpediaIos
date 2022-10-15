//
//  AskListTableCell.swift
//  Spedia
//
//  Created by Viraj Sharma on 01/08/2020.
//  Copyright © 2020 Viraj Sharma. All rights reserved.
//

import UIKit

protocol AskListTableCellDelegate {
    func didTapOnAskListTCell(cellSelectedImage : UIImage)
}


class AskListTableCell: UITableViewCell {
    
    @IBOutlet weak var dateAndTimeLbl: CustomLabel!
    @IBOutlet weak var adminOrUserLbl: CustomLabel!
    @IBOutlet weak var msgLbl: CustomLabel!
    @IBOutlet weak var containerVieww: UIView!
    @IBOutlet weak var moreButton: CustomButton!
    //@IBOutlet weak var constForContViewwHieght: NSLayoutConstraint!
    @IBOutlet weak var constForMoreButtonHieght: NSLayoutConstraint!
    
    //@IBOutlet weak var cellImage: UIImageView!
    
    var fullScreenView = UIView()
    
    //Obj..
    @IBOutlet weak var imageButton: UIButton!
    var delegateObj : AskListTableCellDelegate?
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        containerVieww.layer.cornerRadius = 10
        containerVieww.layer.borderWidth = 1
        containerVieww.layer.borderColor = Colors.APP_BORDER_GRAY?.cgColor
        //containerVieww.backgroundColor = UIColor.clear
        
        //cellImage.layer.cornerRadius = 10
        
        
        self.moreButton.setTitle("read_more".localized(), for: .normal)
    }

    
    @IBAction func imageTapped(sender: UITapGestureRecognizer) {
        
        
        
        
        // Show the ImageViewer with the first item
        //self.presentImageGallery(GalleryViewController(startIndex: 0, itemsDataSource: self))

        
        /*
        self.fullScreenView.removeFromSuperview()
        fullScreenView.frame = topMostController()?.view.frame as! CGRect
        
        let newImageView = UIImageView(image: cellImage.image)
        newImageView.removeFromSuperview()
        newImageView.frame = fullScreenView.frame
        newImageView.backgroundColor = UIColor.black.withAlphaComponent(1.0)
        newImageView.contentMode = .scaleAspectFit
        newImageView.isUserInteractionEnabled = false
        
        //let tap = UITapGestureRecognizer(target: self, action: Selector(("dismissFullscreenImage:")))
        //newImageView.addGestureRecognizer(tap)
        
        fullScreenView.addSubview(newImageView)
        
        //icon_Cross
        let crossButton = UIButton()
        crossButton.removeFromSuperview()
        crossButton.setImage(UIImage.init(named: "icon_Cross"), for: .normal)
        crossButton.frame = CGRect(x: 20, y: 20, width: 40, height: 40)
        crossButton.addTarget(self, action: #selector(crossButtonAciton), for: .touchUpInside)
        crossButton.bringSubviewToFront(fullScreenView)
        fullScreenView.addSubview(crossButton)
        
        fullScreenView.bringSubviewToFront((topMostController()?.view!)!)
        topMostController()?.view.addSubview(fullScreenView)
        */
        
    }
    
    
    /*
    @objc func crossButtonAciton(sender: UIButton!) {
       print("Button tapped")
       
        fullScreenView.removeFromSuperview()
         
    } */
    
    
    
    
    /*
    func dismissFullscreenImage(sender: UITapGestureRecognizer) {
        topMostController()?.navigationController?.isNavigationBarHidden = false
        topMostController()?.tabBarController?.tabBar.isHidden = false
        sender.view?.removeFromSuperview()
    }*/
    
    
    
    @IBAction func imageButtonAction(_ sender: Any) {
        //self.delegateObj?.didTapOnAskListTCell(cellSelectedImage : cellImage.image ?? UIImage())
    }
    
    
           

   
    
   
    


}
