import UIKit

final class ProfileOverscrollOverlay: UIViewController {
    @IBOutlet weak var playerName: UILabel?
    @IBOutlet weak var backButton: UIButton?
    
    var backButtonAction: (()->())!
    
    func setBackButtonHidden(_ hidden: Bool) {
        backButton!.isHidden = hidden
    }
    
    @IBAction func backButtonPressed(_ sender: AnyObject) {
        backButtonAction()
    }
}
