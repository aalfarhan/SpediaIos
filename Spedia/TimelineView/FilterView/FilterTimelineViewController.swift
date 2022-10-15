//
//  FilterTimelineViewController.swift
//  Spedia
//
//  Created by Viraj Sharma on 16/06/2021.
//  Copyright © 2021 Viraj Sharma. All rights reserved.
//

import UIKit
import SwiftyJSON

class FilterTimelineViewController: UIViewController {


    //0.1 Custom Outlets
    
    //0.11 Placeholders
    @IBOutlet weak var headerTitleLbl: CustomLabel!
    @IBOutlet weak var headerSubTitleLbl: CustomLabel!
    @IBOutlet weak var subjectPHLabel: CustomLabel!
    @IBOutlet weak var typePHLabel: CustomLabel!
    @IBOutlet weak var dateFromPHLabel: CustomLabel!
    @IBOutlet weak var dateToPHLabel: CustomLabel!
    @IBOutlet weak var findPHButton: CustomButton!
    
    //0.22 TFT's
    @IBOutlet weak var subjectTFT: DataPickerTextField!
    @IBOutlet weak var typeTFT: DataPickerTextField!
    @IBOutlet weak var chooseDateFromTFT: DateTimePickerTextField!
    @IBOutlet weak var chooseDateToTFT: DateTimePickerTextField!
    
    //UIButtons
    @IBOutlet weak var backButton: UIButton!
    
    
    //Data
    var dataJson = JSON()
    
    //1
    override func viewDidLoad() {
        super.viewDidLoad()
    
        //3 Picker Type
        self.chooseDateFromTFT.pickerMode = .date
        self.chooseDateToTFT.pickerMode = .date
        

    }
    

    //2
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        self.setUpView()
        
        subjectTFT.items = self.dataJson["Subjects"].arrayValue
        typeTFT.items = self.dataJson["Types"].arrayValue

        
        
        print(subjectTFT.items)
        print(typeTFT.items)
        
        
    }
   
    
    //3
    func setUpView() {
        
        //1 timeline my_recent_activities
        self.headerTitleLbl.text = "filter_ph".localized()
        self.headerSubTitleLbl.text = "timeline".localized()
        
        self.subjectPHLabel.text = "subject_ph".localized()
        self.typePHLabel.text = "type_ph".localized()
        self.dateFromPHLabel.text = "date_from_ph".localized()
        self.dateToPHLabel.text = "date_to_ph".localized()
        self.findPHButton.setTitle("find_ph".localized(), for: .normal)
        
        self.subjectTFT.placeholder = "select_subject_ph".localized()
        self.typeTFT.placeholder = "type_subject_ph".localized()
        self.chooseDateFromTFT.placeholder = "choose_date_ph".localized()
        self.chooseDateToTFT.placeholder = "choose_date_ph".localized()
         
        
        //2
        self.backButton.imageView?.transform =  L102Language.isCurrentLanguageArabic() ? CGAffineTransform(scaleX: -1.0, y: 1.0) : CGAffineTransform(scaleX: 1.0, y: -1.0)
    
    }
    
    
    
    @IBAction func backButtonAction(_ sender: Any) {
       self.dismiss(animated: true, completion: nil)
       //self.navigationController?.popViewController(animated: true)
    }
    
    


    //MARK: Apply Filter or Find Button Action
    @IBAction func findOrApplyButtonAction(_ sender: Any) {
        
        
        let subjectStr = subjectTFT.text ?? ""
        let typeStr = typeTFT.text ?? ""
        
        if !subjectStr.isEmpty {
        
            AppShared.object.timelineSelectedSubjectId = self.dataJson["Subjects"][self.subjectTFT.index ?? 0]["ID"].intValue
            
        } else {
            AppShared.object.timelineSelectedSubjectId = 0
        }
        
        if !typeStr.isEmpty {
        
            AppShared.object.timelineSelectedTypeInt = self.dataJson["Types"][self.typeTFT.index ?? 0]["ID"].intValue
        } else {
            AppShared.object.timelineSelectedTypeInt = 0
        }
        
        
        AppShared.object.timelineSelectedFromDateStr = self.chooseDateFromTFT.returnedDate
        AppShared.object.timelineSelectedToDateStr = self.chooseDateToTFT.returnedDate
       
        self.backButtonAction(self)
        
    }
    
    
}
