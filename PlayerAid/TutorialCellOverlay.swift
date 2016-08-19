import Foundation
import TWCommonLib

class TutorialCellOverlay: UIView {

    @IBOutlet var view: UIView!
    @IBOutlet private weak var backgroundView: UIView!
    @IBOutlet private weak var overlayView: UIView!
    @IBOutlet private weak var label: UILabel!
  
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        view = NSBundle.mainBundle().loadNibNamed("TutorialCellOverlay", owner: self, options: nil)[0] as! UIView
        self.addSubview(view!)
        view!.frame = self.bounds
        
        self.backgroundColor = UIColor.clearColor()
    }
  
    var text: String = "" {
        didSet {
            label.text = text
        }
    }
  
    override func awakeFromNib() {
        super.awakeFromNib()
        overlayView.tw_setCornerRadius(overlayView.frame.size.height / 2)
    }
    
    func setLabelBackgroundColor(backgroundColor: UIColor) {
        overlayView.backgroundColor = backgroundColor
    }
    
    func setOverlayBackgroundColor(backgroundColor: UIColor) {
        backgroundView.backgroundColor = backgroundColor
    }
    
    func setOverlayBackgroundAlpha(alpha: CGFloat) {
        backgroundView.alpha = alpha
    }
    
    //MARK: Touch events
    
    override func pointInside(point: CGPoint, withEvent event: UIEvent?) -> Bool {
        return false // Passing all touches to the next view in hierarchy
    }
}
