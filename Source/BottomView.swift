//
//  BottomView.swift
//  ImagePicker
//
//  Created by Mats Becker on 10/20/16.
//  Copyright © 2016 Hyper Interaktiv AS. All rights reserved.
//

import UIKit


class BottomView: UIView {

  var doneButton = UIButton()
  var cancelButton = UIButton()
  var textLabel = UILabel()
  
  // MARK: - Initializers
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    
    self.backgroundColor = UIColor(red:0.09, green:0.10, blue:0.12, alpha:1.00)
    
//    textLabel.frame = CGRect(x: 100, y: 0, width: frame.size.width - 100, height: frame.height)
    textLabel.font = UIFont.preferredFont(forTextStyle: .body)
    textLabel.text = "Info"
    textLabel.textColor = UIColor.white
    textLabel.sizeToFit()
    textLabel.translatesAutoresizingMaskIntoConstraints = false
    
    cancelButton.setTitle("Cancel", for: UIControlState())
    cancelButton.setTitleColor(UIColor.white, for: UIControlState())
    cancelButton.backgroundColor = UIColor.clear
    cancelButton.translatesAutoresizingMaskIntoConstraints = false
    
    doneButton.setTitle("Upload", for: UIControlState())
    doneButton.setTitleColor(UIColor(red:0.10, green:0.71, blue:0.57, alpha:1.00), for: UIControlState())
    doneButton.backgroundColor = UIColor.clear
    doneButton.translatesAutoresizingMaskIntoConstraints = false
    
    let constraintVerticalLabel   = NSLayoutConstraint(item: textLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
    let constraintHorizontalLabel = NSLayoutConstraint(item: textLabel, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)
    
    let constraintHeightCancel    = NSLayoutConstraint(item: cancelButton, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 1, constant: 0)
    let constraintWidthCancel     = NSLayoutConstraint(item: cancelButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100)
    let constraintVerticalCancel  = NSLayoutConstraint(item: cancelButton, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
    
    let constraintHeightDone      = NSLayoutConstraint(item: doneButton, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 1, constant: 0)
    let constraintWidthDone       = NSLayoutConstraint(item: doneButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100)
    let constraintVerticalDone    = NSLayoutConstraint(item: doneButton, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
    let constraintRightDone       = NSLayoutConstraint(item: doneButton, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0)
    
    // Subviews
    
    self.addSubview(textLabel)
    self.addSubview(cancelButton)
    self.addSubview(doneButton)
    
    // Constraints
    
    self.addConstraint(constraintVerticalLabel)
    self.addConstraint(constraintHorizontalLabel)
    
    self.addConstraint(constraintHeightCancel)
    self.addConstraint(constraintWidthCancel)
    self.addConstraint(constraintVerticalCancel)
    
    self.addConstraint(constraintHeightDone)
    self.addConstraint(constraintWidthDone)
    self.addConstraint(constraintVerticalDone)
    self.addConstraint(constraintRightDone)
    
    
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
}

extension UIButton{
  
  func setImage(image: UIImage?, inFrame frame: CGRect?, forState state: UIControlState){
    self.setImage(image, for: state)
    
    if let frame = frame{
      self.imageEdgeInsets = UIEdgeInsets(
        top: frame.minY - self.frame.minY,
        left: frame.minX - self.frame.minX,
        bottom: self.frame.maxY - frame.maxY,
        right: self.frame.maxX - frame.maxX
      )
    }
  }
  
}
