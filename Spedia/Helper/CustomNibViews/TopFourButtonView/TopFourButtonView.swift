//
//  TopFourButtonView.swift
//  Spedia
//
//  Created by Viraj Sharma on 16/08/22.
//  Copyright © 2022 Viraj Sharma. All rights reserved.
//

import UIKit
import SwiftyJSON


protocol TopFourButtonViewDelegate {
    func fourButtonsTappedWithTag(tagValue: Int)
}

class TopFourButtonView: UIView {
    
    //0 Delegates...
    var delegateObj : TopFourButtonViewDelegate?
    
    //1 Objects...
    @IBOutlet var containerVieww: UIView!
    @IBOutlet var backButton: UIButton!
    @IBOutlet var headerTitle: CustomLabel!
    
    //2 Four Buttons Collection View
    @IBOutlet var buttonCollectionView: UICollectionView!
    var buttonCollData = [String]()
    
    //3 No Data View
    @IBOutlet var noDataView: UIView!
    @IBOutlet var noDataLbl: CustomLabel!
    @IBOutlet var refreshButton: CustomButton!
    
    //4 Data Objects
    var headerTitleStr = ""
    var navigationType = ""
    var selectedIndex = 0
    var dontLoadButtonText = false
    
    
    //5 Responsive...
    @IBOutlet weak var fourButtonCollViewHeight: NSLayoutConstraint!
    @IBOutlet weak var leftPeddingConst: NSLayoutConstraint!
    @IBOutlet weak var rightPeddingConst: NSLayoutConstraint!
    
    
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
    @IBAction func backButtonAction(_ sender: Any) {
        
        if navigationType == NavigationType.navigationType  {
            
            if let topController = UIApplication.topViewController() {
                topController.navigationController?.popViewController(animated: true)
            }
            
        } else {
            if let topController = UIApplication.topViewController() {
                topController.dismiss(animated: true, completion: nil)
            }
        }
        
    }
    
    //4
    private func commonInit() {
        
        //self.leftPeddingConst.constant = UIDevice.isPad ? 50.0 : 16.0
        //self.rightPeddingConst.constant = UIDevice.isPad ? 50.0 : 16.0
        
        Bundle.main.loadNibNamed("TopFourButtonView", owner: self, options: nil)
        addSubview(containerVieww)
        
        self.layer.cornerRadius = 0
        self.clipsToBounds = true
        
        self.containerVieww.frame = self.bounds
        self.containerVieww.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.containerVieww.layer.cornerRadius = 0
        self.containerVieww.clipsToBounds = true
        
        //Set Up Done
        self.setUpView()
        
        
        self.refreshButton.layer.cornerRadius = 20.0
        self.refreshButton.clipsToBounds = true
        
        //1
        let collNibName = UINib(nibName: "ButtonCollCell", bundle:nil)
        self.buttonCollectionView.register(collNibName, forCellWithReuseIdentifier: "buttonCollCell")
        
        //2
        self.buttonCollectionView.delegate = self
        self.buttonCollectionView.dataSource = self
        self.buttonCollectionView.semanticContentAttribute = L102Language.isCurrentLanguageArabic() ? UISemanticContentAttribute.forceRightToLeft : UISemanticContentAttribute.forceLeftToRight
        
        //3
        self.headerTitle.text = self.headerTitleStr
        self.reloadCollectionViewWithData(dataModel: ["videos_button_ph".localized(), "notes_button_ph".localized(), "book_solution_button_ph".localized(), "previous_exam_button_ph".localized()])
    
    }
    
    func reloadCollectionViewWithData(dataModel: [String]) {
        
        self.buttonCollData = dataModel
        
        DispatchQueue.main.async {
         self.buttonCollectionView.reloadData()
        }
        if UIDevice.isPad {
            self.buttonCollectionView.layoutIfNeeded()
            DispatchQueue.main.async {
                print(self.buttonCollectionView.contentSize)
                let difference = (DeviceSize.screenWidth - self.buttonCollectionView.contentSize.width) / 2
                self.leftPeddingConst.constant = difference
                self.rightPeddingConst.constant = difference
            }
        }
    }
    
    
    func setUpView() {
        
        //1
        self.headerTitle.text = self.headerTitleStr
        self.backButton.imageView?.transform =  L102Language.isCurrentLanguageArabic() ? CGAffineTransform(scaleX: -1.0, y: 1.0) : CGAffineTransform(scaleX: 1.0, y: -1.0)
        
        self.noDataLbl.text = "no_data_found".localized()
        
        self.refreshButton.setTitle("refresh_button_ph".localized(), for: .normal)
    
    }
    
    
    //MARK: ======================================================
    //MARK: NO DATA SETUP
    //MARK: ======================================================
    func showNoDataView(showing: Bool) {
        if showing {
            self.noDataLbl.text = "no_data_found".localized()
            self.noDataView.isHidden = false
        } else {
            self.noDataView.isHidden = true
        }
    }
    
    @IBAction func refreshButtonAction(_ sender: Any) {
        print("refreshButtonAction")
    }
    
}



//MARK:================================================
//MARK: UICollectionView
//MARK:================================================

extension TopFourButtonView: UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
 
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return self.buttonCollData.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = self.buttonCollectionView.dequeueReusableCell(withReuseIdentifier: "buttonCollCell", for: indexPath) as? ButtonCollCell
        
        cell?.tapButton.tag = indexPath.row
        cell?.tapButton.addTarget(self, action: #selector(titleButtonCellButtonAction(sender:)), for: .touchUpInside)
        cell?.cellSelectedIndex = selectedIndex
        
        cell?.titleLabel.text = self.buttonCollData[indexPath.row]
    
        cell?.whiceButtonActiveWithTag(index: indexPath.row)
        
        return cell ?? UICollectionViewCell()
      
    }
    
    
    @objc func titleButtonCellButtonAction(sender: UIButton) {
        self.selectedIndex = sender.tag
        DispatchQueue.main.async {
         self.buttonCollectionView.reloadData()
        }
        self.delegateObj?.fourButtonsTappedWithTag(tagValue: sender.tag)
    }
    
    
    //MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.buttonCollData[indexPath.item].size(withAttributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17)]).width + 25, height: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
      
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
          return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if UIDevice.isPad {
            return UIEdgeInsets (top: 0, left: 50, bottom: 0, right: 50)
        } else {
            return UIEdgeInsets (top: 0, left: 16, bottom: 0, right: 16)
        }
    }

    
}



/*class FlowLayout: UICollectionViewFlowLayout {

    required init(minimumInteritemSpacing: CGFloat = 0, minimumLineSpacing: CGFloat = 0, sectionInset: UIEdgeInsets = .zero) {
        super.init()

        estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        self.minimumInteritemSpacing = minimumInteritemSpacing
        self.minimumLineSpacing = minimumLineSpacing
        self.sectionInset = sectionInset
        sectionInsetReference = .fromSafeArea
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let layoutAttributes = super.layoutAttributesForElements(in: rect)!.map { $0.copy() as! UICollectionViewLayoutAttributes }
        guard scrollDirection == .vertical else { return layoutAttributes }

        // Filter attributes to compute only cell attributes
        let cellAttributes = layoutAttributes.filter({ $0.representedElementCategory == .cell })

        // Group cell attributes by row (cells with same vertical center) and loop on those groups
        for (_, attributes) in Dictionary(grouping: cellAttributes, by: { ($0.center.y / 10).rounded(.up) * 10 }) {
            // Get the total width of the cells on the same row
            let cellsTotalWidth = attributes.reduce(CGFloat(0)) { (partialWidth, attribute) -> CGFloat in
                partialWidth + attribute.size.width
            }

            // Calculate the initial left inset
            let totalInset = collectionView!.safeAreaLayoutGuide.layoutFrame.width - cellsTotalWidth - sectionInset.left - sectionInset.right - minimumInteritemSpacing * CGFloat(attributes.count - 1)
            var leftInset = (totalInset / 2 * 10).rounded(.down) / 10 + sectionInset.left

            // Loop on cells to adjust each cell's origin and prepare leftInset for the next cell
            for attribute in attributes {
                attribute.frame.origin.x = leftInset
                leftInset = attribute.frame.maxX + minimumInteritemSpacing
            }
        }

        return layoutAttributes
    }

}*/
