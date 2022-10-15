//
//  TestTableViewController.swift
//  Spedia
//
//  Created by Viraj Sharma on 08/09/22.
//  Copyright © 2022 Viraj Sharma. All rights reserved.
//

import UIKit
import SwiftyJSON

class TestTableViewController: UIViewController {

    @IBOutlet weak var listView: UITableView!
    var mainDataJson = JSON()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.registerTableViewCells()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.reloadTableViewNow()
    }
    
    
    @IBAction func backButtonAction(_ sender: Any) {
      self.dismiss(animated: true, completion: nil)
      //self.navigationController?.popViewController(animated: true)
    }
}


