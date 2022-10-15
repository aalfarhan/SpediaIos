//
//  CustomTabBar.swift
//  Spedia
//
//  Created by Viraj Sharma on 28/08/2021.
//  Copyright © 2021 Viraj Sharma. All rights reserved.
//

import Foundation
import UIKit

class CustomTabBarForiPAD: UITabBar {
    
  @IBInspectable var height: CGFloat = 0.0

  override func sizeThatFits(_ size: CGSize) -> CGSize {
      var sizeThatFits = super.sizeThatFits(size)
      if height > 0.0 {
          sizeThatFits.height = height
      }
      return sizeThatFits
  }
    
  override var traitCollection: UITraitCollection {
    guard UIDevice.current.userInterfaceIdiom == .pad else {
      return super.traitCollection
    }

    return UITraitCollection(horizontalSizeClass: .compact)
  }
    
}
