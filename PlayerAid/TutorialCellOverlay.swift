import Foundation
import TWCommonLib

class TutorialCellOverlay: UIView {

    @IBOutlet var view: UIView!
    @IBOutlet fileprivate weak var backgroundView: UIView!
    @IBOutlet fileprivate weak var overlayView: UIView!
    @IBOutlet fileprivate weak var label: UILabel!
  
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        view = Bundle.main.loadNibNamed("TutorialCellOverlay", owner: self, options: nil)?[0] as! UIView
        self.addSubview(view!)
        view!.frame = self.bounds
        
        self.backgroundColor = UIColor.clear
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
    
    func setLabelBackgroundColor(_ backgroundColor: UIColor) {
        overlayView.backgroundColor = backgroundColor
    }
    
    func setOverlayBackgroundColor(_ backgroundColor: UIColor) {
        backgroundView.backgroundColor = backgroundColor
    }
    
    func setOverlayBackgroundAlpha(_ alpha: CGFloat) {
        backgroundView.alpha = alpha
    }
    
    //MARK: Touch events
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return false // Passing all touches to the next view in hierarchy
    }
}
