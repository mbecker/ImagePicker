import UIKit

public struct Configuration {
    
    // MARK: Colors
    
    public static var backgroundColor = UIColor(red: 0.15, green: 0.19, blue: 0.24, alpha: 1)
    public static var mainColor = UIColor(red: 0.09, green: 0.11, blue: 0.13, alpha: 1)
    public static var noImagesColor = UIColor(red: 0.86, green: 0.86, blue: 0.86, alpha: 1)
    public static var noCameraColor = UIColor(red: 0.86, green: 0.86, blue: 0.86, alpha: 1)
    public static var settingsColor = UIColor.white
    // Added by mbecker: Let the backgorund color for the pressed picker button be configurable
    public static var pickerButtonTouchBackgroundColor = UIColor(red:0.18, green:0.55, blue:0.84, alpha:1.00) // Flat Sky Blue
    public static var pickerButtonDoneBackgroundColor = UIColor(red:0.10, green:0.71, blue:0.57, alpha:1.00) // Flat Mint
    public static var doneButtonColor = UIColor(red:1.00, green:0.78, blue:0.02, alpha:1.00)
    public static var cancelButtonColor = UIColor(red:0.93, green:0.40, blue:0.44, alpha:1.00)
    
    // MARK: Fonts
    
    public static var numberLabelFont = UIFont(name: "HelveticaNeue-Bold", size: 16)!
    public static var doneButton = UIFont(name: "HelveticaNeue-Medium", size: 16)!
    public static var flashButton = UIFont(name: "HelveticaNeue-Medium", size: 12)!
    public static var noImagesFont = UIFont(name: "HelveticaNeue-Medium", size: 18)!
    public static var noCameraFont = UIFont(name: "HelveticaNeue-Medium", size: 18)!
    public static var settingsFont = UIFont(name: "HelveticaNeue-Medium", size: 16)!
    
    // MARK: Titles
    
    public static var OKButtonTitle = "OK"
    public static var cancelButtonTitle = "Cancel"
    public static var doneButtonTitle = "Done"
    public static var noImagesTitle = "No images available"
    public static var noCameraTitle = "Camera is not available"
    public static var settingsTitle = "Settings"
    public static var requestPermissionTitle = "Permission denied"
    public static var requestPermissionMessage = "Please, allow the application to access to your photo library."
    
    // MARK: Dimensions
    
    public static var cellSpacing: CGFloat = 2
    public static var indicatorWidth: CGFloat = 41
    public static var indicatorHeight: CGFloat = 8
    
    // MARK: Custom behaviour
    
    public static var canRotateCamera = true
    public static var collapseCollectionViewWhileShot = true
    public static var recordLocation = true
    // Added by mbecker: Movide imageLimit to global config (only used to show string "2/5" images in camera touch button)
    public static var imageLimit = 0
    
    // MARK: Images
    
    public static var indicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white.withAlphaComponent(0.6)
        view.layer.cornerRadius = 4
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
}
