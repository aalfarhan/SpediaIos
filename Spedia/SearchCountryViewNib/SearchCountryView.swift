//
//  SearchCountryView.swift
//  Spedia
//
//  Created by Viraj Sharma on 08/02/2021.
//  Copyright © 2021 Viraj Sharma. All rights reserved.
//

import UIKit
import SwiftyJSON

protocol SearchCountryViewDelegate {
    func didCountrySelect(countryData : JSON)
}


class SearchCountryView: UIView, UITextFieldDelegate {
    
    //0 Delegates...
    var delegateObj : SearchCountryViewDelegate?
    
    //1 Objects...
    @IBOutlet var topTitleLbl: CustomLabel!
    @IBOutlet var searchTFT: CustomTFT!
    @IBOutlet var containerVieww: UIView!
    @IBOutlet var tftContainerView: UIView!
    @IBOutlet var listView: UITableView!
    
    //2 Data.........
    var dataJson = JSON()
    var dataJsonCopy = JSON()
    var isFacultyType = false
    
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
        
        Bundle.main.loadNibNamed("SearchCountryView", owner: self, options: nil)
        addSubview(containerVieww)
        
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        
        self.containerVieww.frame = self.bounds
        self.containerVieww.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.containerVieww.layer.cornerRadius = 10
        self.containerVieww.clipsToBounds = true
        
        self.tftContainerView.layer.cornerRadius = self.tftContainerView.bounds.height / 2
        self.tftContainerView.layer.borderWidth = 1
        self.tftContainerView.layer.borderColor = Colors.APP_BORDER_GRAY?.cgColor
        self.tftContainerView.backgroundColor = .clear
        
        self.setUpView()
        
    }
    
    
    
    private func setUpView() {
        //0
        //self.leftPeddingConst.constant = UIDevice.isPad ? 50 : 16
        //self.rightPeddingConst.constant = UIDevice.isPad ? 50 : 16
        
        //1
        self.searchTFT.placeholder = "search_placeholder".localized()
        
        /*if isFacultyType {
            self.topTitleLbl.text = "pick_faculty".localized()
        } else {
            self.topTitleLbl.text = "pick_country".localized()
        }
        */
        
        //2
        let tableCellNib = UINib(nibName: "CountryNameTCell", bundle:nil)
        self.listView.register(tableCellNib, forCellReuseIdentifier: "countryNameTCell")
        
        self.listView.delegate = self
        self.listView.dataSource = self
        
        //3
        self.searchTFT.delegate = self
        self.searchTFT.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        
    }
    
    
}




//MARK:================================================
//MARK: TableView Extension
//MARK:================================================

extension SearchCountryView : UITableViewDelegate, UITableViewDataSource {
    
    //ROW...
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataJson.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.listView.dequeueReusableCell(withIdentifier: "countryNameTCell") as? CountryNameTCell
        
        cell?.selectionStyle = .none
        
        var valueKey = L102Language.isCurrentLanguageArabic() ? "CountryNameAr" : "CountryNameEn"
        
        if isFacultyType {
            valueKey = L102Language.isCurrentLanguageArabic() ? "NameAr" : "NameEn"
        }
        
        let nameStr = self.dataJson[indexPath.row]["\(valueKey)"].stringValue
        let codeStr = self.dataJson[indexPath.row]["CountryCode"].string ?? ""
        
        cell?.countryNameLbl.text = nameStr
        cell?.countryCodeLbl.text = isFacultyType ? "" : "+" + codeStr
        
        if(indexPath.row % 2 == 0) {
            cell?.containerVieww.backgroundColor = Colors.APP_BORDER_GRAY
        } else {
            cell?.containerVieww.backgroundColor = UIColor.white
        }
        
        cell?.tabButton.tag = indexPath.row
        cell?.tabButton.addTarget(self, action: #selector(tabButtonAction), for: .touchUpInside)
        
        return cell ?? UITableViewCell()
        
    }
 
    
    
    @objc func tabButtonAction(sender: UIButton) {
        
        //print("tabButtonAction", self.dataJson[sender.tag])
        
        let selectedData = self.dataJson[sender.tag]
        self.delegateObj?.didCountrySelect(countryData : selectedData)
    
    }
        
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      //do nothing for now
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
     }
    
    
    
    //===============================================
    //MARK: Auto Fill & Searching With TFT
    //===============================================
    
    //1
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        let searchText = textField.text ?? ""
        
        print("Typing...", searchText)
        
        
        if searchText.isEmpty {
            
            self.dataJson = self.dataJsonCopy
            self.listView.reloadData()
            
        } else {
            
            var valueKey = L102Language.isCurrentLanguageArabic() ? "CountryNameAr" : "CountryNameEn"
            
            if isFacultyType {
                valueKey = L102Language.isCurrentLanguageArabic() ? "NameAr" : "NameEn"
            }
            
            let searchPredicate = NSPredicate(format: "(\(valueKey) contains[c] %@) OR (CountryCode contains[c] %@)", searchText, searchText)
            
            if let array = self.dataJsonCopy.arrayObject {
                
                let foundItems = JSON(array.filter { searchPredicate.evaluate(with: $0) })
                self.dataJson = foundItems
                
                self.listView.reloadData()
            }
            
        }
        
    }
     
    
}

