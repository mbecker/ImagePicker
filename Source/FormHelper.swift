//
//  FormHelper.swift
//  ImagePicker
//
//  Created by Mats Becker on 10/20/16.
//  Copyright © 2016 Hyper Interaktiv AS. All rights reserved.
//

import UIKit

extension UIImage {
  class func colorForNavBar(color: UIColor) -> UIImage {
    let rect = CGRect(x: 0, y: 0, width: 100, height: 5)
    UIGraphicsBeginImageContext(rect.size)
    let context = UIGraphicsGetCurrentContext()
    
    context!.setFillColor(color.cgColor)
    context!.fill(rect)
    
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return image!
  }
}

extension String {
  
  func range(from: Int, to: Int) -> String {
    let offset = to - self.characters.count
    let start = self.index(self.startIndex, offsetBy: from)
    let end = self.index(self.endIndex, offsetBy: offset)
    let range = start..<end
    return self[range]
  }
}
