//
//  SubjectTableCell.swift
//  Spedia
//
//  Created by Viraj Sharma on 31/05/2020.
//  Copyright © 2020 Viraj Sharma. All rights reserved.
//

import UIKit
import SwiftyJSON
import Kingfisher


protocol SubjectTableCellDelegate {
    func didTapOnCell (model : JSON)
}


class SubjectTableCell: UITableViewCell {

    
    var delegateObj : SubjectTableCellDelegate?
    
    @IBOutlet weak var subjectCollView: UICollectionView!
    @IBOutlet weak var buttonTempo: UIButton!
    
    
    
    var dataJson = JSON()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func configureViewWithData(data:JSON) {
        self.dataJson = data
        self.subjectCollView.reloadData()
        homePageSubjectViewHeight = Double(self.subjectCollView.contentSize.height)
    }
    
    func loadCollectionView() {
        self.subjectCollView.reloadData()
        
        
    }

}


//MARK:================================================
//MARK: CollectionView (Custom TabBar View)
//MARK:================================================

extension SubjectTableCell: UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
 
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataJson.count
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = subjectCollView.dequeueReusableCell(withReuseIdentifier: "subjectCollCell", for: indexPath) as? SubjectCollCell
        
        cell?.containerView.layer.cornerRadius = 20
        
        //cell?.tapCellButton.tag = indexPath.row
        
        //cell?.tapCellButton.addTarget(self, action: #selector(cellButtonAction), for: .touchUpInside)
    
        
        //Data...
        //1
        cell?.subjectNameLable.text = L102Language.isCurrentLanguageArabic() ? self.dataJson[indexPath.item][SubjectsKey.SubjectNameAr].stringValue : self.dataJson[indexPath.item][SubjectsKey.SubjectNameEn].stringValue
        
        //2
        let colorCode = self.dataJson[indexPath.item][SubjectsKey.ColourCode].stringValue
        
        //Colors.Cell_Bkg_Blue
        //cell?.containerView.backgroundColor = UIColor.init(hexaRGB: "\(colorCode)")?.withAlphaComponent(0.10)
     
        
        //2.1 VideoCount
        cell?.videosCountsView.backgroundColor = UIColor.init(hexaRGB: "\(colorCode)")?.withAlphaComponent(1.0)
        cell?.videoCountsLabel.text = self.dataJson[indexPath.item]["VideoCount"].stringValue
        
        
        //3
        let url = URL(string: self.dataJson[indexPath.item][SubjectsKey.IconPath].stringValue)
        
        cell?.subjectImageView.kf.setImage(
            with: url,
            placeholder: UIImage(named: "placeholderImage"),
            options: []) {
            result in
            switch result {
            case .success(let value):
                print("Task done for: \(value.source.url?.absoluteString ?? "")")
                cell?.subjectImageView.image = cell?.subjectImageView.image?.imageWithColor(color1: UIColor.init(hexaRGB: "\(colorCode)") ?? UIColor.white)
                
            case .failure(let error):
                print("Job failed: \(error.localizedDescription)")
            }
        }
         
        return cell ?? UICollectionViewCell()
    
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if UIDevice.isPad {
            let witdh = (self.subjectCollView.frame.width / 2) - 15
            let height = CGFloat(185.0)
            return CGSize(width: witdh, height: height)
        
        } else {
            
            let witdh = (self.subjectCollView.frame.width / 2) - 10
            let height = CGFloat(115.0)
            return CGSize(width: witdh, height: height)
            
        }
        
        
        
        /*
        //Grid Parition For iPhone = 2 and For iPad = 4
        let gridPart = 2 //UIDevice.isPad ? 4 : 2
        
        //left-right space (for iPhone -30-table-30-) = 60 Total Space
        //left-right space (for iPhone -0-30-0-) = 30 Total Space
        let spaceBtw = CGFloat(UIDevice.isPad ? 60 : 60)
        
        
        var witdh = self.subjectCollView.frame.width - spaceBtw
        
        witdh = witdh / CGFloat(gridPart)
        
        let height = round((witdh) - (witdh / 3.5))
        
        print("Home Cell Size's--->", witdh,height, self.subjectCollView.frame.width)
    
        return CGSize(width: witdh, height: UIDevice.isPad ? height+10 : height)
        */
        
        
    }
     
 
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
          return UIDevice.isPad ? 0 : 0
    }
      
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
          return UIDevice.isPad ? 30 : 20
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //print("data clecik")
        //did select
        self.delegateObj?.didTapOnCell(model: self.dataJson[indexPath.item])
        
    }
    
    
}
