//
//  AddressListViewController.swift
//  Spedia
//
//  Created by Viraj Sharma on 23/08/2021.
//  Copyright © 2021 Viraj Sharma. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class AddressListViewController: UIViewController {

    //1 Outlets.......
    @IBOutlet weak var whiteBoxView: UIView!
    
    @IBOutlet weak var titleLbl: CustomLabel!
    @IBOutlet weak var subTitleLbl: CustomLabel!
    
    @IBOutlet weak var collView: UICollectionView!
    
    @IBOutlet weak var crossButton: UIButton!
    @IBOutlet weak var selectAddressButton: UIButton!

    var selectedAddressIndex = -1

    var dataJson = JSON.init([
        [
            "Name" : "Rahul Sharma",
            "MobileNumber" : "9589919369",
            "PinCode" : "452010",
            "FlatNo" : "HK 585",
            "Street" : "Vikas Nagar",
            "Landmark" : "Near Hospital",
            "City" : "Bhopal",
            "State": "Kuwait",
            "FinalAddress" : "4th floor, sahya building opposite grand mosque, Kuwait city, Kuwait 000 986", 
            "IsSelected" : false
        ], [
            "Name" : "Rahul Sharma 2",
            "MobileNumber" : "9589919369",
            "PinCode" : "452010",
            "FlatNo" : "HK 585",
            "Street" : "Vikas Nagar",
            "Landmark" : "Near Hospital",
            "City" : "Bhopal",
            "State": "Kuwait",
            "FinalAddress" : "4th floor, sahya building opposite grand mosque, Kuwait city, Kuwait 000 986",
            "IsSelected" : false
        ], [
            "Name" : "Rahul Sharma 3",
            "MobileNumber" : "9589919369",
            "PinCode" : "452010",
            "FlatNo" : "HK 585",
            "Street" : "Vikas Nagar",
            "Landmark" : "Near Hospital",
            "City" : "Bhopal",
            "State": "Kuwait",
            "FinalAddress" : "4th floor, sahya building opposite grand mosque, Kuwait city, Kuwait 000 986",
            "IsSelected" : false
        ]
    ])
     
    
    //1
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nibName = UINib(nibName: "AddressListCollCell", bundle:nil)
        self.collView.register(nibName, forCellWithReuseIdentifier: "addressListCollCell")
        
        self.collView.delegate = self
        self.collView.dataSource = self
    }
    
    
    //2
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setUpView()
        //self.getAddressListDataNow()
   }
   
    
    //3
    func setUpView() {
        
        self.titleLbl.text = "did_you_like_class_ph".localized()
        self.subTitleLbl.text = "let_us_know_what_ph".localized()
        self.selectAddressButton.setTitle("send_comment_ph".localized(), for: .normal)
    
    }
    
    
    @IBAction func crossButtonAction(_ sender: Any) {
       self.dismiss(animated: true, completion: nil)
       //self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func selectAddressButton(_ sender: Any) {
         
    }
    
    

    //MARK: Call Rating Api for Give Ended Class Rating Or Teacher Rating
    
    func getAddressListDataNow() {
        
        let urlString = saveLiveClassRating
        
        let params = ["SessionToken" : sessionTokenGlobal ?? "",
                      "StudentID" : studentIdGlobal ?? 0] as [String : Any]
        
        ServiceManager().postRequest(urlString, loader: true, parameters: params) { (status, jsonResponse) in
             
            if status {
                
                //let dataRes = JSON.init(jsonResponse ?? "NO DTA")
                
            }
        }
        
    }
}



//MARK:================================================
//MARK: CollectionView (Address's Coll View)
//MARK:================================================

extension AddressListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.dataJson.count
    
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = self.collView.dequeueReusableCell(withReuseIdentifier: "addressListCollCell", for: indexPath) as? AddressListCollCell
        
        let indexValue = indexPath.row
        
        cell?.addressTabButton.tag = indexValue
        cell?.addressTabButton.addTarget(self, action: #selector(didAddressTabButton(sender:)), for: .touchUpInside)
        
        cell?.editAddressButton.tag = indexValue
        cell?.editAddressButton.addTarget(self, action: #selector(editAddressTabButton(sender:)), for: .touchUpInside)
        
        let isSelectedBool = self.selectedAddressIndex == indexValue ? true : false
        cell?.configureCellWith(data: self.dataJson[indexPath.row], isSelectedValue: isSelectedBool)
        
        
        return cell ?? UICollectionViewCell()
            
    }
    
    
    @objc func didAddressTabButton(sender: UIButton) {
        
        self.selectedAddressIndex = sender.tag
        self.collView.reloadData()
        //self.dataJson[self.selectedAddressIndex]["IsSelected"].boolValue = true
        //for row in 0..<checkArray.count { }
        
        
    }
    
    @objc func editAddressTabButton(sender: UIButton) {
        
    }
    
            
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: (self.collView.frame.width / 2.3), height: self.collView.frame.height)
        
    }
    

    
}
