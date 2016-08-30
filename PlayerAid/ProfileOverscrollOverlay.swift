import UIKit

final class ProfileOverscrollOverlay: UIViewController {
    @IBOutlet weak var playerName: UILabel?
    @IBOutlet weak var backButton: UIButton?
    
    var backButtonAction: (()->())!
    
    func setBackButtonHidden(hidden: Bool) {
        backButton!.hidden = hidden
    }
    
    @IBAction func backButtonPressed(sender: AnyObject) {
        backButtonAction()
    }
}
