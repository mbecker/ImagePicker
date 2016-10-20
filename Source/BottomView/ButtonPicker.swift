import UIKit

protocol ButtonPickerDelegate: class {

  func buttonDidPress()
}

class ButtonPicker: UIButton {
  
  var imagesSelectedLimit = false

  struct Dimensions {
    static let borderWidth: CGFloat = 2
    static let buttonSize: CGFloat = 58
    static let buttonBorderSize: CGFloat = 68
  }

  lazy var numberLabel: UILabel = { [unowned self] in
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = Configuration.numberLabelFont

    return label
    }()

  weak var delegate: ButtonPickerDelegate?

  // MARK: - Initializers

  override init(frame: CGRect) {
    super.init(frame: frame)

    addSubview(numberLabel)

    subscribe()
    setupButton()
    setupConstraints()
  }

  deinit {
    NotificationCenter.default.removeObserver(self)
  }

  func subscribe() {
    NotificationCenter.default.addObserver(self,
      selector: #selector(recalculatePhotosCount(_:)),
      name: NSNotification.Name(rawValue: ImageStack.Notifications.imageDidPush),
      object: nil)

    NotificationCenter.default.addObserver(self,
      selector: #selector(recalculatePhotosCount(_:)),
      name: NSNotification.Name(rawValue: ImageStack.Notifications.imageDidDrop),
      object: nil)

    NotificationCenter.default.addObserver(self,
      selector: #selector(recalculatePhotosCount(_:)),
      name: NSNotification.Name(rawValue: ImageStack.Notifications.stackDidReload),
      object: nil)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Configuration

  func setupButton() {
    backgroundColor = UIColor.white
    layer.cornerRadius = Dimensions.buttonSize / 2
    accessibilityLabel = "Take photo"
    addTarget(self, action: #selector(pickerButtonDidPress(_:)), for: .touchUpInside)
    addTarget(self, action: #selector(pickerButtonDidHighlight(_:)), for: .touchDown)
    addTarget(self, action: #selector(pickerButtonDidHighlight2(_:)), for: .touchUpOutside)
  }

  // MARK: - Actions

  func recalculatePhotosCount(_ notification: Notification) {
    guard let sender = notification.object as? ImageStack else { return }
    // Added by mbecker: Change user how many images are left to add
    if sender.assets.isEmpty {
        numberLabel.text = ""
    } else {
        numberLabel.text = Configuration.imageLimit == 0 ? String(sender.assets.count) : String(sender.assets.count) + "/" + String(Configuration.imageLimit)
    }
    
    if sender.assets.count == Configuration.imageLimit {
      self.imagesSelectedLimit = true
      backgroundColor = Configuration.pickerButtonDoneBackgroundColor
      numberLabel.textColor = UIColor.white
      numberLabel.text = Configuration.imageLimit == 0 ? String(sender.assets.count) : "Upload"
    } else {
      backgroundColor = UIColor.white
    }
  }

  func pickerButtonDidPress(_ button: UIButton) {
    backgroundColor = Configuration.pickerButtonTouchBackgroundColor
    numberLabel.textColor = UIColor.white
    numberLabel.sizeToFit()
    delegate?.buttonDidPress()
  }

  func pickerButtonDidHighlight(_ button: UIButton) {
    numberLabel.textColor = UIColor.white
    backgroundColor = Configuration.pickerButtonTouchBackgroundColor
  }
  
  func pickerButtonDidHighlight2(_ button: UIButton) {
    if imagesSelectedLimit {
      backgroundColor = Configuration.pickerButtonDoneBackgroundColor
    } else {
      backgroundColor = UIColor.white
    }
    numberLabel.textColor = UIColor.white
  }
}
