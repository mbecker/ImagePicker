import UIKit

protocol BottomContainerViewDelegate: class {

  func pickerButtonDidPress()
  func doneButtonDidPress()
  func cancelButtonDidPress()
  // UPdate bey mbecker: Not necessary
  //  func imageStackViewDidPress()
}

open class BottomContainerView: UIView {

  struct Dimensions {
    static let height: CGFloat = 101
  }

  lazy var pickerButton: ButtonPicker = { [unowned self] in
    let pickerButton = ButtonPicker()
    pickerButton.setTitleColor(UIColor.white, for: UIControlState())
    pickerButton.delegate = self

    return pickerButton
    }()

  lazy var borderPickerButton: UIView = {
    let view = UIView()
    view.backgroundColor = UIColor.clear
    // Added by mbecker: Update border color to Configuration
    view.layer.borderColor = Configuration.pickerBackgroundColor.cgColor
    view.layer.borderWidth = ButtonPicker.Dimensions.borderWidth
    view.layer.cornerRadius = ButtonPicker.Dimensions.buttonBorderSize / 2

    return view
    }()

  open lazy var doneButton: UIButton = { [unowned self] in
    let button = UIButton()
    // Added by mbecker: Change background to clear
    button.backgroundColor = UIColor.clear
    button.setTitle(Configuration.doneButtonTitle, for: UIControlState())
    // Added by mbecker: Change color of cancel button to Configuration
    button.setTitleColor(Configuration.doneButtonColor, for: UIControlState())
    button.titleLabel?.font = Configuration.doneButton
    button.addTarget(self, action: #selector(doneButtonDidPress(_:)), for: .touchUpInside)
    
    // Addey by mbecker: Set image chevron right
    button.setImage(AssetManager.getImage("ic_chevron_right_36pt"), for: UIControlState())
    print(":: BUTOM IMAGE VIEW - \(-(button.imageView?.frame.size.width)!)")
    button.titleEdgeInsets = UIEdgeInsetsMake(0, -60, 0, (button.imageView?.frame.size.width)!);
    button.imageEdgeInsets = UIEdgeInsetsMake(0, (button.titleLabel?.frame.size.width)!, 0, -(button.titleLabel?.frame.size.width)!);
  

    return button
    }()
  
  open lazy var cancelButton: UIButton = { [unowned self] in
    let button = UIButton()
    // Added by mbecker: Change background to clear
    button.backgroundColor = UIColor.clear
    button.setTitle(Configuration.cancelButtonTitle, for: UIControlState())
    // Added by mbecker: Change color of cancel button to Configuration
    button.setTitleColor(Configuration.cancelButtonColor, for: UIControlState())
    button.titleLabel?.font = Configuration.doneButton
    button.addTarget(self, action: #selector(cancelButtonDidPress(_:)), for: .touchUpInside)
    
    return button
    }()
  
  // UPdate by mbecker. NO stackview anymore
  //  lazy var stackView = ImageStackView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))

  lazy var topSeparator: UIView = { [unowned self] in
    let view = UIView()
    view.backgroundColor = Configuration.seperatorColor

    return view
    }()

  // Update by mbecker: NOt necessary beacuse no imagestackview
//  lazy var tapGestureRecognizer: UITapGestureRecognizer = { [unowned self] in
//    let gesture = UITapGestureRecognizer()
//    gesture.addTarget(self, action: #selector(handleTapGestureRecognizer(_:)))
//
//    return gesture
//    }()

  weak var delegate: BottomContainerViewDelegate?
  var pastCount = 0

  // MARK: Initializers

  public override init(frame: CGRect) {
    super.init(frame: frame)
    
    [borderPickerButton, pickerButton, doneButton, cancelButton, topSeparator].forEach {
      addSubview($0)
      $0.translatesAutoresizingMaskIntoConstraints = false
    }

    backgroundColor = Configuration.backgroundColor
    
    // Update by mbecker: No imagestackview anymore
//    stackView.accessibilityLabel = "Image stack"
//    stackView.addGestureRecognizer(tapGestureRecognizer)

    setupConstraints()
  }

  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Action methods

  func doneButtonDidPress(_ button: UIButton) {
//    if button.currentTitle == Configuration.cancelButtonTitle {
//      delegate?.cancelButtonDidPress()
//    } else {
//      delegate?.doneButtonDidPress()
//    }
    
    // Update by mbecker: Only buttonDidPress
    delegate?.doneButtonDidPress()
  }
  
  // Addey by mbecker
  func cancelButtonDidPress(_ button: UIButton) {
    delegate?.cancelButtonDidPress()
  }

  // Update by mbecker: NO protocol imagestackviewdidpress anymore
//  func handleTapGestureRecognizer(_ recognizer: UITapGestureRecognizer) {
//    delegate?.imageStackViewDidPress()
//  }

  fileprivate func animateImageView(_ imageView: UIImageView) {
    imageView.transform = CGAffineTransform(scaleX: 0, y: 0)

    UIView.animate(withDuration: 0.3, animations: {
      imageView.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
      }, completion: { _ in
        UIView.animate(withDuration: 0.2, animations: { _ in
          imageView.transform = CGAffineTransform.identity
        }) 
    }) 
  }
}

// MARK: - ButtonPickerDelegate methods

extension BottomContainerView: ButtonPickerDelegate {

  func buttonDidPress() {
    delegate?.pickerButtonDidPress()
  }
}

