//
//  HomeHeaderTCell.swift
//  Spedia
//
//  Created by Viraj Sharma on 31/05/2020.
//  Copyright © 2020 Viraj Sharma. All rights reserved.
//

import UIKit
import Kingfisher

protocol HomeHeaderTCellDelegate {
    func didTapOnCategoryButton(index : Int)
}


class HomeHeaderTCell: UITableViewCell {
    
    var delegateObj : HomeHeaderTCellDelegate?
    
    @IBOutlet weak var categoryButtonOne: CustomButton!
    @IBOutlet weak var categoryButtonTwo: CustomButton!
    
    
    @IBOutlet weak var profileTopButton: UIButton!
    //Only for Profile refresh
    @IBOutlet weak var profilePic: UIImageView!
    
    //Bell ICON
    //@IBOutlet weak var bellIconButton: BellIconButton!
    
    
    /*@IBOutlet weak var borderView: UIView!
    @IBOutlet weak var chartButton: UIButton!
    @IBOutlet weak var LevelVieww: UIView!
    @IBOutlet weak var lblLevel: CustomLabel!
    //@IBOutlet weak var lblClass: CustomLabel!
    @IBOutlet weak var lblPoints: CustomLabel!
    @IBOutlet weak var levelViewWitdhConst: NSLayoutConstraint!
    */
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        /*self.levelViewWitdhConst.constant = (self.borderView.bounds.width / 2) + 30
        borderView.layer.cornerRadius = 20
        borderView.layer.borderWidth = 1
        borderView.layer.borderColor = Colors.APP_LIGHT_GREEN?.cgColor
        borderView.backgroundColor = UIColor.clear
        LevelVieww.layer.cornerRadius = 20
        LevelVieww.layer.borderWidth = 0
        LevelVieww.layer.borderColor = UIColor.clear.cgColor
        LevelVieww.backgroundColor = Colors.APP_LIGHT_GREEN
        */
        
        self.whichButtonActive(tag: 1)
        
    }
    
    
    func reloadBellIcon() {
        //self.bellIconButton.updateBellCount(color: Colors.APP_LIGHT_GREEN ?? .cyan)
    }
    
    @IBAction func categoryButtonsAction(_ sender: UIButton) {
        self.whichButtonActive(tag: sender.tag)
    }
    
    
    func whichButtonActive(tag : Int) {
        
        //UIView.animate(withDuration: 0.50) {
            
        if tag == 1 { //Category One List
            
            self.delegateObj?.didTapOnCategoryButton(index : 1)
            self.categoryButtonOne.backgroundColor = Colors.APP_LIGHT_GREEN
            self.categoryButtonOne.setTitleColor(.white, for: .normal)
            
            self.categoryButtonTwo.backgroundColor = .clear
            self.categoryButtonTwo.setTitleColor(Colors.APP_LIGHT_GREEN, for: .normal)
            
        } else { //Category Two List
            
            self.delegateObj?.didTapOnCategoryButton(index : 2)
            self.categoryButtonOne.backgroundColor = .clear
            self.categoryButtonOne.setTitleColor(Colors.APP_LIGHT_GREEN, for: .normal)
                       
            self.categoryButtonTwo.backgroundColor = Colors.APP_LIGHT_GREEN
            self.categoryButtonTwo.setTitleColor(.white, for: .normal)
        
        }
         
        // self.layoutIfNeeded()
        
        //}
    
    }
    
    
    //MARK: Refresh Profile Pic...
    /*
    func loadProfileImage(imageUrl : String) {
        
        //Profile Pic Image.... ProfilePic
        let url = URL(string: imageUrl)
        
        self.profilePic.kf.setImage(with: url, placeholder: UIImage(named: "profile_icon_placeholder"), options: [.forceRefresh], completionHandler:  { result in
             switch result {
             case .success(let value):
                
                 //print("Image: \(value.image). Got from: \(value.cacheType)")
                 
                 
                 //let button2 = ProfileButton()
                 //print(button2)
                 
             case .failure(let error):
                 print("Error: \(error)")
             }
         })
    }
    */
    
}
