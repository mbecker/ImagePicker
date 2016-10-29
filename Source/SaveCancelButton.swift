//
//  SaveCancelButton.swift
//  ImagePicker
//
//  Created by Mats Becker on 10/29/16.
//  Copyright © 2016 Hyper Interaktiv AS. All rights reserved.
//

import UIKit

enum SaveCancelButtonPosition {
  case Right
  case Left
  case None
}

enum SaveCancelButtonColorType {
  case Normal
  case Reverted
}

class SaveCancelButton: UIButton {
  
  let darkmint = UIColor(red:0.09, green:0.59, blue:0.48, alpha:1.00) // Dark Mint
  let aztecblack = UIColor(red:0.09, green:0.10, blue:0.12, alpha:1.00) // Aztec black
  let background = UIColor.white
  
  
  init(title: String, position: SaveCancelButtonPosition, type: SaveCancelButtonColorType) {
    
    var textColor: UIColor
    var selectedTextColor: UIColor
    var backgroundColor: UIColor
    
    switch type {
    case .Reverted:
      textColor = background
      selectedTextColor = aztecblack
      backgroundColor = darkmint
    default:
      textColor = darkmint
      selectedTextColor = aztecblack.withAlphaComponent(0.6)
      backgroundColor = background
    }
    
    
    super.init(frame: CGRect.zero)
    let attribues = NSAttributedString(
      string: title,
      attributes: [
        NSFontAttributeName: UIFont(name: "HelveticaNeue", size: 19)!,
        NSForegroundColorAttributeName: textColor,
        NSKernAttributeName: 0.6,
        ])
    let attribuesSelected = NSAttributedString(
      string: title,
      attributes: [
        NSFontAttributeName: UIFont(name: "HelveticaNeue", size: 19)!,
        NSForegroundColorAttributeName: selectedTextColor,
        NSKernAttributeName: 0.6,
        ])
    //set image for button
    self.setAttributedTitle(attribues, for: .normal)
    self.setAttributedTitle(attribuesSelected, for: .highlighted)
    self.backgroundColor = backgroundColor
    
    self.layer.borderWidth = 1
    self.layer.borderColor = backgroundColor.cgColor
    
    let buttonsize = attribues.size()
    let buttonwidth = buttonsize.width + 86
    let buttonheight = buttonsize.height + 24
    self.layer.cornerRadius = buttonheight / 2
    
    let posy = UIScreen.main.bounds.size.height - buttonheight - 16
    
    switch position {
    case .Right:
      self.setImage(AssetManager.getImage("ic_chevron_right_36pt").withRenderingMode(.alwaysTemplate), for: UIControlState())
      self.imageView?.tintColor = textColor
      self.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
      self.titleLabel?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
      self.imageView?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
      self.frame = CGRect(x: UIScreen.main.bounds.size.width - buttonwidth - 32, y: UIScreen.main.bounds.size.height - buttonheight - 16, width: buttonwidth, height: buttonheight)
      break
    case .Left:
      self.frame = CGRect(x: 32, y: posy, width: buttonwidth, height: buttonheight)
    default:
      // Right
      self.frame = CGRect(x: UIScreen.main.bounds.size.width - buttonwidth - 32, y: posy, width: buttonwidth, height: buttonheight)
    }
    

  }
  
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
