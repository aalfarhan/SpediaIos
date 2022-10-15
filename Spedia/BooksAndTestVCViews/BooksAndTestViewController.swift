//
//  BooksAndTestViewController.swift
//  Spedia
//
//  Created by Viraj Sharma on 09/06/2020.
//  Copyright © 2020 Viraj Sharma. All rights reserved.
//

import UIKit
import SwiftyJSON

class BooksAndTestViewController: UIViewController {

    @IBOutlet weak var collView: UICollectionView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var noDataLbl: UILabel!
    
    
    var isBooks = false
    var subjectID = Int()
    var dataJson = JSON()
    var apiName = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        backButton.imageView?.transform =  L102Language.isCurrentLanguageArabic() ? CGAffineTransform(scaleX: -1.0, y: 1.0) : CGAffineTransform(scaleX: 1.0, y: -1.0)
        
        getData()
        
    }

    
    @IBAction func backButtonAction(_ sender: Any) {
         self.dismiss(animated: true, completion: nil)
     }
    
    
    
    func getData() {
        
        //let apiName = isBooks ? getSelectWorkBook : getSelectQuestionPaperArchive
        
        let urlString = self.apiName
         
        
        let params = ["SessionToken" : sessionTokenGlobal ?? "",
                      "SubjectID" : subjectID,
                      "StudentID" : studentIdGlobal ?? 0] as [String : Any]
        
    
        ServiceManager().postRequest(urlString, loader: true, parameters: params) { (status, jsonResponse) in
             
            if status {
                
                self.dataJson = JSON.init(jsonResponse ?? "NO DTA")
                self.dataJson = self.dataJson["\(QuestionAnswerKey.ListItems)"]
                self.collView.reloadData()
                
                if self.dataJson.count == 0 {
                    self.collView.isHidden = true
                    self.noDataLbl.text = "no_data_found".localized()
                } else {
                    self.noDataLbl.text = ""
                    self.collView.isHidden = false
                }
                
                
            }
        }
        
        
    }

}




//MARK:================================================
//MARK: CollectionView (Custom TabBar View)
//MARK:================================================

extension BooksAndTestViewController: UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.dataJson.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = self.collView.dequeueReusableCell(withReuseIdentifier: "booksAndTestCollCell", for: indexPath) as? BooksAndTestCollCell
        
        //1
        cell?.titleLbl.text = self.dataJson[indexPath.row][QuestionAnswerKey.Title].stringValue
        cell?.subTitleLbl.text = self.dataJson[indexPath.row][QuestionAnswerKey.SubTitle].stringValue
        
        //2
        let url = URL(string: self.dataJson[indexPath.row][QuestionAnswerKey.ImagePath].string ?? "")
        
        
        cell?.bkgImageView.kf.setImage(with: url, placeholder: UIImage(named: "collBkg"))
        
        
        //3
        
        cell?.withOutAnswerButton.tag = indexPath.row
        cell?.withOutAnswerButton.addTarget(self, action: #selector(withOutAnsAction), for: .touchUpInside)
        
        cell?.withAnswerButton.tag = indexPath.row
        cell?.withAnswerButton.addTarget(self, action: #selector(withAnsAction), for: .touchUpInside)
        
        cell?.answerButton.tag = indexPath.row
        cell?.answerButton.addTarget(self, action: #selector(onlyAnswerAction), for: .touchUpInside)
        
        
        
        
        cell?.configureBookTCell(dataModel: self.dataJson[indexPath.row])
        
        //For Only Answer Button
        //cell?.answerButton.isHidden = !isBooks //Commented by kundan
        
        return cell ?? UICollectionViewCell()
        
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        if UIDevice.isPad {
            
            let witdh = (self.collView.frame.width / 2) - 14
            
            return CGSize(width: witdh, height: 230)
            
        } else {
            let witdh = self.collView.frame.width
            return CGSize(width: witdh, height: 230)
        }
        
        
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return UIDevice.isPad ? 28 : 0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 28
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //did select
        
    }
    
    
    @objc func withOutAnsAction(sender: UIButton) {
        
        if let vc = DocumentViewController.instantiate(fromAppStoryboard: .main) {
            vc.modalPresentationStyle = .fullScreen
            vc.isCommingFromQuizzWithPdf = isBooks
            vc.pdfString = self.dataJson[sender.tag]["WithoutAnswerPath"].stringValue
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    
    @objc func withAnsAction(sender: UIButton) {
        
        if let vc = DocumentViewController.instantiate(fromAppStoryboard: .main) {
            vc.modalPresentationStyle = .fullScreen
            vc.isCommingFromQuizzWithPdf = isBooks
            vc.pdfString = self.dataJson[sender.tag]["WithAnswerPath"].stringValue
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    
    @objc func onlyAnswerAction(sender: UIButton) {
        
        if let vc = DocumentViewController.instantiate(fromAppStoryboard: .main) {
            vc.modalPresentationStyle = .fullScreen
            vc.isCommingFromQuizzWithPdf = isBooks
            vc.pdfString = self.dataJson[sender.tag]["AnswerPath"].stringValue
            self.present(vc, animated: true, completion: nil)
        }
    }
}
