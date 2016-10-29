//
//  FormTableViewController.swift
//  ImagePicker
//
//  Created by Mats Becker on 10/25/16.
//  Copyright © 2016 Hyper Interaktiv AS. All rights reserved.
//

import UIKit



class FormTableViewController: UITableViewController, ExpandingTransitionPresentingViewController {
  
  var selectedIndexPath: IndexPath?
  
  let transition = ExpandingCellTransition(type: .Presenting)
  
  let buttonFont = UIFont(name: "HelveticaNeue", size: 23)
  let buttonSelectedFont = UIFont(name: "HelveticaNeue", size: 23)
  let buttonSeperatorFont = UIFont(name: "HelveticaNeue-Thin", size: 23)
  let buttonSelectedColor = UIColor(red:0.09, green:0.59, blue:0.48, alpha:1.00) // Dark Mint
  let buttonColor = UIColor(red:0.24, green:0.24, blue:0.24, alpha:1.00).withAlphaComponent(0.6) // Baltic sea
  
  var selectedName = String()
  var selectedItems = [IndexPath]()
  var whatTitle = String()
  var whatTyp: whatTypes = .Animal
  let whatTypes = ["Animal", "Attraction"]
  let whatTitles = ["Select animals", "Select type"]
  let descriptionText = "Click to select"
  
  
  /**
   * CELLS
   */
  let cellName: FormTableViewCell = FormTableViewCell()
  let cellWhere = FormTableLabelCell(style: .default, reuseIdentifier: nil, heading: "Where?", detail: "-10.255, 80.658", description: "Near to Gorah Elephant Camp")
  let cellWhat = FormTableLabelCell(style: .default, reuseIdentifier: nil, heading: "What?", detail: "Select animals", description: "")
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.view.backgroundColor = UIColor.white
    self.navigationController?.delegate = self
    self.edgesForExtendedLayout = .top
    
    
    // Uncomment the following line to preserve selection between presentations
    self.clearsSelectionOnViewWillAppear = true
    
    self.tableView.register(FormTableViewCell.self, forCellReuseIdentifier: "cell")
    self.tableView.rowHeight = 90
    self.tableView.estimatedRowHeight = 90
    self.tableView.tableHeaderView = headerView
    self.tableView.tableFooterView = UIView()
    
    /**
    * INITILIZATION
    */
    self.animalButton.isSelected = true
    self.whatTitle = self.whatTitles[0]
    self.whatTyp = .Animal
    
    
    /**
     * Buttons
     */
    let doneButton = SaveCancelButton(title: "Done", position: .Right, type: .Reverted)
    let clearButton = SaveCancelButton(title: "Back", position: .Left, type: .Reverted)
    
    self.navigationController?.view.addSubview(doneButton)
    self.navigationController?.view.addSubview(clearButton)
    
    /**
     * CELLS
     */
    
    let selectedBackgroundView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.width, height: self.tableView.rowHeight))
    selectedBackgroundView.backgroundColor = UIColor(red:0.10, green:0.71, blue:0.57, alpha:1.00).withAlphaComponent(0.2)

    self.cellName.headingLabel.text = "Name"
    self.cellName.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    self.cellName.selectionStyle = .none

    self.cellWhat.selectionStyle = .default
    self.cellWhat.selectedBackgroundView = selectedBackgroundView
    self.cellWhat.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    self.cellWhat.detailLabel.text = self.whatTitle
    self.cellWhat.descriptionLabel.text = self.descriptionText
    
    self.cellWhere.selectionStyle = .default
    self.cellWhere.selectedBackgroundView = selectedBackgroundView
    self.cellWhere.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    self.navigationController?.navigationBar.isHidden = true
    self.tableView.allowsSelectionDuringEditing = false
    
    // Deselect rows
    
    self.tableView.deselectRow(at: IndexPath(row: 1, section: 0), animated: false)
    self.tableView.deselectRow(at: IndexPath(row: 2, section: 0), animated: false)
  }
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .default
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // MARK: - Table view data source
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    // #warning Incomplete implementation, return the number of sections
    return 1
  }
  
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // #warning Incomplete implementation, return the number of rows
    return 3
  }
  
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    print("indexpath: \(indexPath)")
    switch indexPath.row {
    case 0:
      return self.cellName
    case 1:
      return self.cellWhat
    default:
      return self.cellWhere
    }
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    print(":: FORM TABLE VIEW CONTROLLER - DID SELECT")
    // End editing textfield
    self.view.endEditing(true)
    
    self.selectedIndexPath = indexPath
    
    switch indexPath.row {
    case 1:
      let controller = AnimalFormCollections(title: self.whatTitle, type: self.whatTyp, selectedItems: self.selectedItems)
      controller.delegate = self
      controller.modalPresentationStyle = .custom
      controller.modalPresentationCapturesStatusBarAppearance = true
      self.navigationController?.pushViewController(controller, animated: true)
    default:
      let mapFormViewController = MapFormViewController()
      mapFormViewController.modalPresentationStyle = .custom
      mapFormViewController.modalPresentationCapturesStatusBarAppearance = true
      self.navigationController?.pushViewController(mapFormViewController, animated: true)
    }
    

  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    print("prepare")
    
  }
  
  
  /**
   *varlled when the user click on the view (outside the UITextField).
   */
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.view.endEditing(true)
  }
  
  override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    self.view.endEditing(true)
  }
  
  
  // Switch button
  func headerButtonPressed(_ button: UIButton) {
    
    switch button {
    case self.animalButton:
      // Select animalButton
      self.animalButton.isSelected = true
      self.attractionButton.isSelected = false
      
      self.selectedItems = []
      
      self.whatTitle = self.whatTitles[0]
      self.whatTyp = .Animal
      self.cellWhat.detailLabel.text = self.whatTitles[0]
      self.cellWhat.descriptionLabel.text = self.descriptionText
      
      break
    case self.attractionButton:
      self.animalButton.isSelected = false
      self.attractionButton.isSelected = true
      
      self.selectedItems = []
      
      self.whatTitle = self.whatTitles[1]
      self.whatTyp = .Attraction
      self.cellWhat.detailLabel.text = self.whatTitles[0]
      self.cellWhat.descriptionLabel.text = self.descriptionText
      
      break
    default:
      break
    }
    
  }
  
  let animalButton = UIButton()
  let attractionButton = UIButton()
  
  
  lazy var headerView: UIView = {
    let view = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.bounds.size.width, height: 90))
    view.backgroundColor = UIColor.white
    
    self.animalButton.setAttributedTitle(NSAttributedString(
      string: "Animal" + self.selectedName,
      attributes: [
        NSFontAttributeName: self.buttonFont!,
        NSForegroundColorAttributeName: self.buttonColor,
        NSBackgroundColorAttributeName: UIColor.clear,
        NSKernAttributeName: 0.4,
        ]), for: .normal) // Aztec Black
    self.animalButton.setAttributedTitle(NSAttributedString(
      string: "Animal",
      attributes: [
        NSFontAttributeName: self.buttonSelectedFont!,
        NSForegroundColorAttributeName: self.buttonSelectedColor,
        NSBackgroundColorAttributeName: UIColor.clear,
        NSKernAttributeName: 0.4,
        ]), for: .highlighted) // Dark Mint
    self.animalButton.setAttributedTitle(NSAttributedString(
      string: "Animal",
      attributes: [
        NSFontAttributeName: self.buttonSelectedFont!,
        NSForegroundColorAttributeName: self.buttonSelectedColor,
        NSBackgroundColorAttributeName: UIColor.clear,
        NSKernAttributeName: 0.4,
        ]), for: .selected) // Dark Mint
    self.animalButton.setBackgroundColor(color: UIColor.white, forState: .normal)
    self.animalButton.setBackgroundColor(color: UIColor.white, forState: .highlighted)
    self.animalButton.addTarget(self, action: #selector(self.headerButtonPressed(_:)), for: .touchUpInside)
    self.animalButton.translatesAutoresizingMaskIntoConstraints = false
    
    
    self.attractionButton.setAttributedTitle(NSAttributedString(
      string: "Attraction",
      attributes: [
        NSFontAttributeName: self.buttonFont!,
        NSForegroundColorAttributeName: self.buttonColor,
        NSBackgroundColorAttributeName: UIColor.clear,
        NSKernAttributeName: 0.4,
        ]), for: .normal) // Aztec Black
    self.attractionButton.setAttributedTitle(NSAttributedString(
      string: "Attraction",
      attributes: [
        NSFontAttributeName: self.buttonSelectedFont!,
        NSForegroundColorAttributeName: self.buttonSelectedColor,
        NSBackgroundColorAttributeName: UIColor.clear,
        NSKernAttributeName: 0.4,
        ]), for: .highlighted) // Dark Mint
    self.attractionButton.setAttributedTitle(NSAttributedString(
      string: "Attraction",
      attributes: [
        NSFontAttributeName: self.buttonSelectedFont!,
        NSForegroundColorAttributeName: self.buttonSelectedColor,
        NSBackgroundColorAttributeName: UIColor.clear,
        NSKernAttributeName: 0.4,
        ]), for: .selected) // Dark Mint
    self.attractionButton.setBackgroundColor(color: UIColor.white, forState: .normal)
    self.attractionButton.setBackgroundColor(color: UIColor.white, forState: .highlighted)
    self.attractionButton.addTarget(self, action: #selector(self.headerButtonPressed(_:)), for: .touchUpInside)
    self.attractionButton.translatesAutoresizingMaskIntoConstraints = false
    
    let headingLabel = UILabel()
    headingLabel.attributedText = NSAttributedString(
      string: "/",
      attributes: [
        NSFontAttributeName: self.buttonSeperatorFont!,
        NSForegroundColorAttributeName: self.buttonColor,
        NSBackgroundColorAttributeName: UIColor.clear,
        NSKernAttributeName: 0.4,
        ])
    headingLabel.translatesAutoresizingMaskIntoConstraints = false
    
    let seperator = UIView()
    seperator.backgroundColor = UIColor(red:0.84, green:0.84, blue:0.84, alpha:1.00)
    seperator.translatesAutoresizingMaskIntoConstraints = false
    
    view.addSubview(self.animalButton)
    view.addSubview(headingLabel)
    view.addSubview(self.attractionButton)
    view.addSubview(seperator)
    
 
    let constraintLeftAnimalButton = NSLayoutConstraint(item: self.animalButton, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: 20)
    let constraintCenterYAnimalButton = NSLayoutConstraint(item: self.animalButton, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 10)
    let constraintHeightAnimalButton = NSLayoutConstraint(item: self.animalButton, attribute: .height, relatedBy: .equal, toItem: view, attribute: .height, multiplier: 1, constant: 1)
    
    let constraintLeftHeadingLabel = NSLayoutConstraint(item: headingLabel, attribute: .left, relatedBy: .equal, toItem: self.animalButton, attribute: .right, multiplier: 1, constant: 5)
    let constraintCenterYHeadingLabel = NSLayoutConstraint(item: headingLabel, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 10)
    
    let constraintLeftAttractionButton = NSLayoutConstraint(item: self.attractionButton, attribute: .left, relatedBy: .equal, toItem: headingLabel, attribute: .right, multiplier: 1, constant: 5)
    let constraintCenterYAttractionButton = NSLayoutConstraint(item: self.attractionButton, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 10)
    let constraintHeightAttractionButton = NSLayoutConstraint(item: self.attractionButton, attribute: .height, relatedBy: .equal, toItem: view, attribute: .height, multiplier: 1, constant: 1)
    
    let constraintLeftSeperator = NSLayoutConstraint(item: seperator, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: 20)
    let constraintBottomSeperator = NSLayoutConstraint(item: seperator, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
    let constraintWidthSeperator = NSLayoutConstraint(item: seperator, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 80)
    let constraintHeightSeperator = NSLayoutConstraint(item: seperator, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 1)
    
    view.addConstraint(constraintLeftAnimalButton)
    view.addConstraint(constraintCenterYAnimalButton)
    view.addConstraint(constraintHeightAnimalButton)
    
    view.addConstraint(constraintLeftHeadingLabel)
    view.addConstraint(constraintCenterYHeadingLabel)
    
    view.addConstraint(constraintLeftAttractionButton)
    view.addConstraint(constraintCenterYAttractionButton)
    view.addConstraint(constraintHeightAttractionButton)
    
    view.addConstraint(constraintLeftSeperator)
    view.addConstraint(constraintBottomSeperator)
    view.addConstraint(constraintWidthSeperator)
    view.addConstraint(constraintHeightSeperator)
    
    return view
  }()
  
  // MARK: ExpandingTransitionPresentingViewController
  public func expandingTransitionTargetViewForTransition(transition: ExpandingCellTransition) -> UIView! {
    if let indexPath = self.selectedIndexPath {
      return tableView.cellForRow(at: indexPath)
    }
    else {
      return nil
    }
  }
  
}

extension FormTableViewController : AnimalFormCollectionDelegate {
  
  public func saveItems(index: [IndexPath], items: [String]) {
    var plural = String()
    var type = String()
    
    if items.count > 1 {
      plural = "s"
    }
    if self.whatTyp == .Animal {
      type = self.whatTypes[0] + plural
      self.cellWhat.detailLabel.text = self.whatTitles[0]
    } else {
      type = self.whatTypes[1] + plural
      self.cellWhat.detailLabel.text = self.whatTitles[1]
    }
    
    if items.count > 1 {
      self.cellWhat.detailLabel.text = String(items.count) + " " + type
      self.cellWhat.descriptionLabel.text = items.joined(separator: ", ")
    } else if items.count == 1 {
      self.cellWhat.detailLabel.text = String(items.count) + " " + type
      self.cellWhat.descriptionLabel.text = items[0]
    } else {      
      self.cellWhat.descriptionLabel.text = self.descriptionText
    }
    
    
    
    self.tableView.setNeedsDisplay()
    
    self.selectedItems = index
    
    self.navigationController?.popViewController(animated: true)
  }
  
}

extension FormTableViewController : UINavigationControllerDelegate {
  public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return self.transition
  }
  
  public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return self.transition
  }
  
  public func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    if fromVC is FormTableViewController {
      transition.type = .Presenting
    } else {
      transition.type = .Dismissing
    }
    return self.transition
  }
  
}
