import Foundation

final class FloatingSelectionOverlay: NSObject {
    let selectionOverlay: UIView
    
    init(color: UIColor, superview: UIView) {
        selectionOverlay = UIView()
        selectionOverlay.backgroundColor = color;
        
        superview.addSubview(selectionOverlay)
    }
    
    func setFrame(_ frame: CGRect, animated: Bool = true) {
        if (animated) {
            UIView.animate(withDuration: Constants.AnimationDuration, animations: { 
                self.selectionOverlay.frame = frame;
            })
        } else {
            selectionOverlay.frame = frame;
        }
    }
}

private struct Constants {
    static let AnimationDuration = 0.2
}
