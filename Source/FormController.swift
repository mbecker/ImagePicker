//
//  FormController.swift
//  ImagePicker
//
//  Created by Mats Becker on 10/20/16.
//  Copyright © 2016 Hyper Interaktiv AS. All rights reserved.
//

import Eureka
import CoreLocation
import MapKit

@objc public protocol FormControllerDelegate: class {
  
  func formDone(original: [UIImage], images: [UIImage])
  func formCancel()
  
}

class FormController: FormViewController, CLLocationManagerDelegate {
  
  open weak var delegate: FormControllerDelegate?
  var originalImage = UIImage()
  var resizedImage = UIImage()
  let locationManager = CLLocationManager()
  var location = CLLocation(latitude: 0, longitude: 0)
  
  let locationRow = LocationRow(){
    $0.tag = "locationRow"
  $0.title = "LocationRow"
  $0.value = CLLocation(latitude: 0, longitude: 0)
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    print(":: FORM LOCATION MANGER - UPDATE LOCATION ::")
    self.location = locations.last!
    print(self.location)
    self.locationRow.value = self.location
    self.form.rowBy(tag: "locationRow")?.updateCell()
  }
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print(":: ERROR MAP ::")
    print(error)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let bottomContainer = BottomView(frame: CGRect(x: 0, y: view.frame.height - 101, width: view.frame.width, height: 101))
    bottomContainer.cancelButton.addTarget(self, action: #selector(self.didTapCancel(_:)), for: .touchUpInside)
    bottomContainer.doneButton.addTarget(self, action: #selector(self.didTapDone(_:)), for: .touchUpInside)
    
    self.view.addSubview(bottomContainer)
    
    form = Section("Spot information")
      <<< TextRow(){ row in
        row.title = "Name"
        row.placeholder = "Enter name here"
      }
      <<< MultipleSelectorRow<Emoji>() {
        $0.title = "Select animals of the spot"
        $0.options = [💁🏻, 🍐, 👦🏼, 🐗, 🐼, 🐻]
        $0.value = [👦🏼, 🍐, 🐗]
        }
        .onPresent { from, to in
//          to.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: from, action: #selector(self.multipleSelectorDone(_:)))
          
          let bottomContainerTo = BottomView(frame: CGRect(x: 0, y: self.view.frame.height - 101, width: self.view.frame.width, height: 101))
          bottomContainerTo.doneButton.addTarget(self, action: #selector(self.multipleSelectorDone(_:)), for: .touchUpInside)
          bottomContainerTo.doneButton.setTitle("Done", for: UIControlState())
          bottomContainerTo.cancelButton.removeFromSuperview()
          to.view.addSubview(bottomContainerTo)
      }
      +++ Section("Location")
        <<< locationRow
    .onPresent { from, to in
      
    }
    
    
    // Ask for Authorisation from the User.
    self.locationManager.requestAlwaysAuthorization()
    // For use in foreground
    self.locationManager.requestWhenInUseAuthorization()
    
    if CLLocationManager.locationServicesEnabled() {
      locationManager.delegate = self
      //      locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
      locationManager.desiredAccuracy = kCLLocationAccuracyBest
      if #available(iOS 9.0, *) {
        locationManager.requestLocation()
      } else {
        // Fallback on earlier versions
        locationManager.startUpdatingLocation()
      }
    }
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func multipleSelectorDone(_ item:UIButton) {
    dismiss(animated: true, completion: nil)
  }
  
  
  // MARK: - didTapCancel: dismiss view
  @objc fileprivate func didTapCancel(_ item:UIButton){
//    self.navigationController?.popViewController(animated: false)
    self.delegate?.formCancel()
  }
  
  // MARK: - didTapDone: Delegate formDone
  @objc fileprivate func didTapDone(_ item:UIButton){
    self.delegate?.formDone(original: [originalImage], images: [resizedImage])
  }
  
}

//MARK: Emoji

typealias Emoji = String
let 👦🏼 = "👦🏼", 🍐 = "🍐", 💁🏻 = "💁🏻", 🐗 = "🐗", 🐼 = "🐼", 🐻 = "🐻", 🐖 = "🐖", 🐡 = "🐡"

public final class LocationRow : SelectorRow<PushSelectorCell<CLLocation>, MapViewController>, RowType {
  public required init(tag: String?) {
    super.init(tag: tag)
    presentationMode = .show(controllerProvider: ControllerProvider.callback { return MapViewController(){ _ in } }, onDismiss: { vc in _ = vc.navigationController?.popViewController(animated: true) })
    
    displayValueFor = {
      guard let location = $0 else { return "" }
      let fmt = NumberFormatter()
      fmt.maximumFractionDigits = 4
      fmt.minimumFractionDigits = 4
      let latitude = fmt.string(from: NSNumber(value: location.coordinate.latitude))!
      let longitude = fmt.string(from: NSNumber(value: location.coordinate.longitude))!
      return  "\(latitude), \(longitude)"
    }
  }
}

public class MapViewController : UIViewController, TypedRowControllerType, MKMapViewDelegate, CLLocationManagerDelegate {
  
  public var row: RowOf<CLLocation>!
  public var onDismissCallback: ((UIViewController) -> ())?
  
  lazy var mapView : MKMapView = { [unowned self] in
    let v = MKMapView(frame: self.view.bounds)
    v.autoresizingMask = UIViewAutoresizing.flexibleWidth.union(.flexibleHeight)
    return v
    }()
  
  lazy var pinView: UIImageView = { [unowned self] in
    let v = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    v.image = UIImage(named: "map_pin", in: Bundle(for: MapViewController.self), compatibleWith: nil)
    v.image = v.image?.withRenderingMode(.alwaysTemplate)
    v.tintColor = self.view.tintColor
    v.backgroundColor = .clear
    v.clipsToBounds = true
    v.contentMode = .scaleAspectFit
    v.isUserInteractionEnabled = false
    return v
    }()
  
  let width: CGFloat = 18.0
  let height: CGFloat = 18.0
  
  lazy var ellipse: UIBezierPath = { [unowned self] in
    let ellipse = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: self.width, height: self.height))
    return ellipse
    }()
  
  lazy var cirlce: UIBezierPath = { [unowned self] in
    let circle = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: self.width, height: self.height))
    return circle
    }()
  
  
  lazy var ellipsisLayer: CAShapeLayer = { [unowned self] in
    let layer = CAShapeLayer()
    layer.bounds = CGRect(x: 0, y: 0, width: self.width, height: self.height)
    layer.path = self.ellipse.cgPath
    layer.fillColor = UIColor(red:1.00, green:0.31, blue:0.33, alpha:1.00).cgColor
    layer.fillRule = kCAFillRuleNonZero
    layer.lineCap = kCALineCapButt
    layer.lineDashPattern = nil
    layer.lineDashPhase = 0.0
    layer.lineJoin = kCALineJoinMiter
    layer.lineWidth = 4.0
    layer.miterLimit = 10.0
    layer.strokeColor = UIColor.white.cgColor
    return layer
    }()
  
  
  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nil, bundle: nil)
  }
  
  convenience public init(_ callback: ((UIViewController) -> ())?){
    self.init(nibName: nil, bundle: nil)
    onDismissCallback = callback
  }
  
  var bottomContainer = BottomView()
  let locationManager = CLLocationManager()
  var location = CLLocationCoordinate2D(latitude: 0, longitude: 0)
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(mapView)
    
    mapView.delegate = self
    mapView.userTrackingMode = .follow
    mapView.addSubview(pinView)
    mapView.layer.insertSublayer(ellipsisLayer, below: pinView.layer)
    
    let button = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(MapViewController.tappedDone(_:)))
    button.title = "Done"
    navigationItem.rightBarButtonItem = button
    
    if let value = row.value {
      let region = MKCoordinateRegionMakeWithDistance(value.coordinate, 400, 400)
      mapView.setRegion(region, animated: true)
    }
    else{
      mapView.showsUserLocation = true
    }
    
    bottomContainer.frame = CGRect(x: 0, y: self.view.frame.height - 101, width: self.view.frame.width, height: 101)
    bottomContainer.doneButton.addTarget(self, action: #selector(self.multipleSelectorDone(_:)), for: .touchUpInside)
    bottomContainer.doneButton.setTitle("Done", for: UIControlState())
    
    bottomContainer.cancelButton.setTitleColor(UIColor(red:0.18, green:0.55, blue:0.84, alpha:1.00), for: UIControlState())
    bottomContainer.cancelButton.setTitle("", for: UIControlState())
    bottomContainer.cancelButton.setImage(AssetManager.getImage("ic_my_location_white_36pt_3x"), for: UIControlState())
    bottomContainer.cancelButton.imageEdgeInsets = UIEdgeInsets(top: 35, left: 35, bottom: 35, right: 35)
    bottomContainer.cancelButton.addTarget(self, action: #selector(self.getLocation(_:)), for: .touchUpInside)
    
    view.addSubview(bottomContainer)
    
    // Ask for Authorisation from the User.
    self.locationManager.requestAlwaysAuthorization()
    // For use in foreground
    self.locationManager.requestWhenInUseAuthorization()
    
    if CLLocationManager.locationServicesEnabled() {
      locationManager.delegate = self
//      locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
      locationManager.desiredAccuracy = kCLLocationAccuracyBest
      locationManager.startUpdatingLocation()
    }
    
    updateTitle()
    
  }
  
  public override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    let center = mapView.convert(mapView.centerCoordinate, toPointTo: pinView)
    pinView.center = CGPoint(x: center.x, y: center.y - (pinView.bounds.height/2))
    ellipsisLayer.position = center
  }
  
  
  func tappedDone(_ sender: UIBarButtonItem){
    let target = mapView.convert(ellipsisLayer.position, toCoordinateFrom: mapView)
    row.value = CLLocation(latitude: target.latitude, longitude: target.longitude)
    onDismissCallback?(self)
  }
  
  func updateTitle(){
    let fmt = NumberFormatter()
    fmt.maximumFractionDigits = 4
    fmt.minimumFractionDigits = 4
    let latitude = fmt.string(from: NSNumber(value: mapView.centerCoordinate.latitude))!
    let longitude = fmt.string(from: NSNumber(value: mapView.centerCoordinate.longitude))!
    title = "\(latitude), \(longitude)"
    
    bottomContainer.textLabel.text = "\(latitude), \(longitude)"
    
  }
  
  public func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
    ellipsisLayer.transform = CATransform3DMakeScale(0.5, 0.5, 1)
    UIView.animate(withDuration: 0.2, animations: { [weak self] in
      self?.pinView.center = CGPoint(x: self!.pinView.center.x, y: self!.pinView.center.y - 10)
      })
  }
  
  public func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
    ellipsisLayer.transform = CATransform3DIdentity
    UIView.animate(withDuration: 0.2, animations: { [weak self] in
      self?.pinView.center = CGPoint(x: self!.pinView.center.x, y: self!.pinView.center.y + 10)
      })
    updateTitle()
  }
  
  func multipleSelectorDone(_ item:UIButton) {
    let target = mapView.convert(ellipsisLayer.position, toCoordinateFrom: mapView)
    row.value = CLLocation(latitude: target.latitude, longitude: target.longitude)
//    onDismissCallback?(self)
    dismiss(animated: true, completion: nil)
  }
  
  func getLocation(_ item:UIButton) {
    
    let region = MKCoordinateRegion(center: self.location, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
    
    self.mapView.setRegion(region, animated: true)
  }
  
  public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    self.location = manager.location!.coordinate
    
  }
}
