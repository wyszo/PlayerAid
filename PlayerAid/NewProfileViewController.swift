import UIKit
import MGSpotyViewController

final class NewProfileViewController: MGSpotyViewController {
    var viewModel: NewProfileViewModel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        let transparentStub = UIImage(named: "transparent")
        setupWithMainImage(transparentStub, tableScrollingType: .Normal)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = NewProfileViewModel()
        blurRadius = Constants.BlurRadius
        self.tintColor = Constants.TintColor
        
        viewModel.fetchProfileImage { [unowned self] (image) in
            self.setMainImage(image)
        }
        setupPlayerInfoOverlay()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    //MARK: private setup
    
    private func setupPlayerInfoOverlay() {
        let screenWidth = view.bounds.size.width
        
        let playerInfoView = PlayerInfoView(frame: CGRectMake(0, 0, screenWidth, screenWidth))
        
        if let user = viewModel.user {
            playerInfoView.user = user
            
            playerInfoView.editButtonPressed = { [unowned self] in
                ApplicationViewHierarchyHelper.presentEditProfileViewControllerFromViewController(self, withUser: user, didUpdateProfileBlock: {
                    self.viewModel.reloadUser()
                    playerInfoView.user = self.viewModel.user
                })
            }
        }
        self.overView = playerInfoView
    }
}

private struct Constants {
    static let TintColor = ColorsHelper.userProfileBackgroundTintColor()
    static let BlurRadius: CGFloat = 5.0
}
