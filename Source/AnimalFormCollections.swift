//
//  AnimalFormViewController.swift
//  ImagePicker
//
//  Created by Mats Becker on 10/27/16.
//  Copyright © 2016 Hyper Interaktiv AS. All rights reserved.
//

import UIKit

protocol AnimalFormCollectionDelegate: class {
  
  func saveItems(index: [IndexPath], items: [String])
}

class AnimalFormCollections: UIViewController {
  var navigationBarSnapshot: UIView!
  var navigationBarHeight: CGFloat = 0
  let collectionViewLayout = UICollectionViewFlowLayout()
  var collectionView: UICollectionView!
  let kCellReuse : String = "AnimalCell"
  let kHeaderReuse = "HeaderCell"
  weak var delegate: AnimalFormCollectionDelegate?
  let animals = [
    "Alligator-66.png",
    "Bat-66.png",
    "Bear-66.png",
    "Chicken-66.png",
    "Deer-66.png",
    "Dinosaur-66.png",
    "Dolphin-66.png",
    "Duck-66.png",
    "Elephant_64.png",
    "Falcon-66.png",
    "Flamingo-66.png",
    "Frog-66.png",
    "Giraffe-66.png",
    "Gorilla-66.png",
    "Hummingbird-66.png",
    "Ladybird-66.png",
    "Lion-66.png",
    "Owl-66.png",
    "Pelican-66.png",
    "Pinguin-66.png",
    "Rhinoceros-66.png",
    "Running Rabbit-66.png",
    "Stork-66.png",
    "Turtle-66.png",
    "Twitter-66.png",
    "Year of Tiger-66.png",
    "buffalo.png",
    "butterfly-with-a-heart-on-frontal-wing-on-side-view.png",
    "goat.png",
    "sheep.png",
    "snake66.png",
    "unicorn.png"
  ]
  
  let attractions = [
    "Creek-66.png",
    "Forest-66.png",
    "Fountain-66.png",
    "Park Bench-66.png",
    "Parking-66.png",
    "Treehouse-66.png",
    "backpacker.png",
    "bicycle-parking.png",
    "bonfire.png",
    "church.png",
    "cutlery.png",
    "panel.png",
    "tent.png"
  ]
  
  let collectionViewData : [String]
  
  let navBarTitle: String
  var selectedItems: [IndexPath]
  
  
  init(title: String, type: whatTypes, selectedItems: [IndexPath]) {
    self.navBarTitle = title
    
    switch type {
    case .Animal:
      self.collectionViewData = self.animals
      break
    case .Attraction:
      self.collectionViewData = self.attractions
      break
    default:
      self.collectionViewData = self.animals
    }
    
    self.selectedItems = selectedItems
    
    
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.view.backgroundColor = UIColor(red:0.10, green:0.71, blue:0.57, alpha:1.00)
    
    /**
     * Buttons
     */
    let saveButton = SaveCancelButton(title: "Save", position: .Right, type: .Normal)
    let clearButton = SaveCancelButton(title: "Clear", position: .Left, type: .Normal)
    saveButton.addTarget(self, action: #selector(self.save), for: UIControlEvents.touchUpInside)
    clearButton.addTarget(self, action: #selector(self.clearItems), for: UIControlEvents.touchUpInside)
    
    
    /**
     * Collection View
     */
    
    self.collectionViewLayout.scrollDirection = .vertical
    self.collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: self.collectionViewLayout)
    
    self.collectionView.delegate = self
    self.collectionView.dataSource = self
    
    self.collectionView.backgroundColor = UIColor.clear
    self.collectionView.isScrollEnabled = true
    self.collectionView.allowsMultipleSelection = true
    self.collectionView.register(AnimalCellHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: kHeaderReuse)
    self.collectionView.register(AnimalCell.self, forCellWithReuseIdentifier: kCellReuse)
    for index in self.selectedItems {
      self.collectionView.selectItem(at: index, animated: true, scrollPosition: .top)
    }
    
    self.view.addSubview(self.collectionView)
    self.view.addSubview(saveButton)
    self.view.addSubview(clearButton)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
//    self.navigationController?.navigationBar.isHidden = false
//    self.navigationController?.navigationBar.setBackgroundImage(UIImage.colorForNavBar(color: UIColor(red:0.10, green:0.71, blue:0.57, alpha:1.00)), for: .any, barMetrics: .default)
    
  }
  
  override func viewWillLayoutSubviews() {
    self.collectionView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
    self.collectionView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 64, right: 0)
  }
  
  /**
   * Custom methods
   */
  
  func popBack(){
    self.navigationController?.popViewController(animated: true)
  }
  
  func save(){
    let selectedCells = self.collectionView.indexPathsForSelectedItems
    var selectedItems = [String]()
    if (selectedCells?.count)! > 0 {
      for item in selectedCells! {
        let animal = self.collectionViewData[item.row]
        selectedItems.append(animal.range(from: 0, to: animal.characters.count - 7))
        print(animal)
      }
      self.delegate?.saveItems(index: selectedCells!, items: selectedItems)
    } else {
      self.delegate?.saveItems(index: selectedCells!, items: selectedItems)
    }
    
  }
  
  func clearItems(){
    for index in self.collectionView.indexPathsForSelectedItems! {
      self.collectionView.deselectItem(at: index, animated: true)
    }
    
    self.selectedItems = []
    
  }
  
  func showTitle(title: String){
    let navLabel = UILabel()
    navLabel.attributedText = NSAttributedString(
      string: title,
      attributes: [
        NSFontAttributeName: UIFont(name: "HelveticaNeue-Light", size: 23)!,
        NSForegroundColorAttributeName: UIColor.white,
        NSKernAttributeName: 0.6,
        ])
    navLabel.sizeToFit()
    self.navigationItem.titleView = navLabel
  }
  
}

// MARK: ExpandingTransitionPresentedViewController
extension AnimalFormCollections : ExpandingTransitionPresentedViewController {
  
  func expandingTransition(transition: ExpandingCellTransition, navigationBarSnapshot: UIView) {
    self.navigationBarSnapshot = navigationBarSnapshot
    self.navigationBarHeight = navigationBarSnapshot.frame.height
  }
  
}

// MARK: UICollectionViewDataSource
extension AnimalFormCollections : UICollectionViewDataSource {
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.collectionViewData.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.kCellReuse, for: indexPath) as! AnimalCell
    
    DispatchQueue.global(qos: .userInitiated).async {
      let image = AssetManager.getImage(self.collectionViewData[indexPath.row]).withRenderingMode(.alwaysTemplate)
      // Bounce back to the main thread to update the UI
      DispatchQueue.main.async {
        cell.imageView.image = image
        if cell.isSelected {
          cell.backgroundColor = UIColor.white
          cell.imageView.tintColor = UIColor(red:0.24, green:0.24, blue:0.24, alpha:1.00)
        } else {
          cell.backgroundColor = UIColor.clear
          cell.imageView.tintColor = UIColor.white
        }
        
      }

    }
    cell.layer.borderColor = UIColor(red:0.97, green:0.97, blue:0.98, alpha:1.00).cgColor
    cell.layer.borderWidth = 2
    cell.layer.cornerRadius = 90 / 2
    
    return cell // Create UICollectionViewCell
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
    return CGSize(width: UIScreen.main.bounds.width, height: 64)
  }
  
  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    if kind == UICollectionElementKindSectionHeader {
      let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: self.kHeaderReuse, for: indexPath) as! AnimalCellHeader
      view.backgroundColor = UIColor.clear
      view.delegate = self
      view.textLabel.attributedText = NSAttributedString(
        string: self.navBarTitle,
        attributes: [
          NSFontAttributeName: UIFont(name: "HelveticaNeue", size: 23)!,
          NSForegroundColorAttributeName: UIColor.white,
          NSKernAttributeName: 0.6,
          ])

      return view
    }
    return UIView() as! UICollectionReusableView
  }
  
}

extension AnimalFormCollections : UICollectionViewDelegate {
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    // didSelect
  }
  
  func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
    //
  }
  
}

extension AnimalFormCollections : UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: 90, height: 90)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    let frame : CGRect = self.view.frame
    let margin = (frame.width - 90 * 3) / 6.0
    print(":: MARGIN -- \(margin)")
    return UIEdgeInsetsMake(10, margin, 10, margin) // margin between cells
  }
}

extension AnimalFormCollections : AnimalCellDelegate {
  func headerButtonPressed() {
    self.navigationController?.popViewController(animated: true)
  }
}
