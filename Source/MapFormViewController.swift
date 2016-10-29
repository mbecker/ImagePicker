//
//  MapFormViewController.swift
//  ImagePicker
//
//  Created by Mats Becker on 10/26/16.
//  Copyright © 2016 Hyper Interaktiv AS. All rights reserved.
//

import UIKit
import MapKit

class MapFormViewController: UIViewController, MKMapViewDelegate {
  
  var navigationBarSnapshot: UIView!
  var navigationBarHeight: CGFloat = 0
  
  init() {
    super.init(nibName: nil, bundle: nil)
    print(":: INIT ::")
    showTitle(title: "Map")
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    showTitle(title: "Map")
    
    //create a new button
    let button: UIButton = UIButton(type: .custom)
    //set image for button
    button.setImage(AssetManager.getImage("cancel32.png"), for: UIControlState.normal)
    //add function for button
    button.addTarget(self, action: #selector(self.popBack), for: UIControlEvents.touchUpInside)
    //set frame
    button.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
    
    let barButton = UIBarButtonItem(customView: button)
    self.navigationItem.leftBarButtonItem = barButton
    
    let mapView = MKMapView()
    
    mapView.frame = self.view.frame
    
    mapView.mapType = MKMapType.standard
    mapView.isZoomEnabled = true
    mapView.isScrollEnabled = true
    
    // Or, if needed, we can position map in the center of the view
    mapView.center = view.center
    
    self.view.addSubview(mapView)
  }
  
  func popBack(){
    self.navigationController?.popViewController(animated: true)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    super.viewDidAppear(animated)
    self.navigationController?.navigationBar.isHidden = false
    self.navigationController?.navigationBar.setBackgroundImage(UIImage.colorForNavBar(color: UIColor.white), for: .any, barMetrics: .default)
    showTitle(title: "Map")
  }
  
  func showTitle(title: String){
    let navLabel = UILabel()
    navLabel.attributedText = NSAttributedString(
      string: title,
      attributes: [
        NSFontAttributeName: UIFont(name: "HelveticaNeue-Thin", size: 23)!,
        NSForegroundColorAttributeName: UIColor(red:0.24, green:0.24, blue:0.24, alpha:1.00),
        NSKernAttributeName: 0.6,
        ])
    navLabel.sizeToFit()
    self.navigationItem.titleView = navLabel
  }

}

// MARK: ExpandingTransitionPresentedViewController
extension MapFormViewController : ExpandingTransitionPresentedViewController {
  
  func expandingTransition(transition: ExpandingCellTransition, navigationBarSnapshot: UIView) {
    self.navigationBarSnapshot = navigationBarSnapshot
    self.navigationBarHeight = navigationBarSnapshot.frame.height
  }
  
}
