import UIKit
import MGSpotyViewController

// TODO: reapply new guide badges logic
// TODO: update navbar visibility

// TODO: move this out of here
final class UIComponentsFactory {
    func createNewProfileTabSwitcherViewController() -> ProfileTabSwitcherViewController {
        let tabSwitcherVC = ProfileTabSwitcherViewController()
        //        tabSwitcherVC.tutorialsTabSelectedBlock =
        //        tabSwitcherVC.likedTabSelectedBlock =
        //        tabSwitcherVC.followingTabSelectedBlock =
        //        tabSwitcherVC.followersTabSelectedBlock =
        return tabSwitcherVC
    }
}


final class NewProfileViewController: MGSpotyViewController {
    private var viewModel: NewProfileViewModel!
    private var profileDelegate: ProfileTableViewDelegate!
    private var tabSwitcherViewController: ProfileTabSwitcherViewController!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        let transparentStub = UIImage(named: "transparent")
        setupWithMainImage(transparentStub, tableScrollingType: .Normal)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = NewProfileViewModel()
        setupDelegate()
        
        blurRadius = Constants.BlurRadius
        tintColor = Constants.TintColor
        view.backgroundColor = UIColor.whiteColor()
        
        viewModel.fetchProfileImage { [unowned self] (image) in
            self.setMainImage(image)
        }
        setupPlayerInfoOverlay()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        updateTabSwitcherGuidesCount()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    //MARK: setup
    
    private func setupDelegate() {
        setupTabSwitcher()
        let tabSwitcherSize = CGSize(width: view.bounds.size.width, height: Constants.TabSwitcherHeight)
        
        profileDelegate = ProfileTableViewDelegate(headerSize: tabSwitcherSize, headerView: tabSwitcherViewController.collectionView!)
        delegate = profileDelegate!
        
        profileDelegate.didAddHeader = { [unowned self] _, section in
            let FirstNonHeaderSectionIndex = 1
            assert(section == FirstNonHeaderSectionIndex)
            self.tabSwitcherViewController.didMoveToParentViewController(self)
        }
    }
    
    private func setupTabSwitcher() {
        tabSwitcherViewController = UIComponentsFactory().createNewProfileTabSwitcherViewController()
        tabSwitcherViewController.collectionView?.backgroundColor = ColorsHelper.tutorialsUnselectedFilterButtonColor()
        
        self.addChildViewController(tabSwitcherViewController)
        
        let tabSwitcherViewModel = ProfileTabSwitcherViewModel(tableView: tableView, user: viewModel.user!)
        tabSwitcherViewController.viewModel = tabSwitcherViewModel
        dataSource = tabSwitcherViewModel.ownGuidesDataSource
    }
    
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
    
    //MARK: private
    
    private func updateTabSwitcherGuidesCount() {
        self.tabSwitcherViewController.tutorialsCount = viewModel.guidesCount
        self.tabSwitcherViewController.likedTutorialsCount = viewModel.likedGuidesCount
        self.tabSwitcherViewController.followingCount = viewModel.followingCount
        self.tabSwitcherViewController.followersCount = viewModel.followersCount
    }

    private struct Constants {
        static let TintColor = ColorsHelper.userProfileBackgroundTintColor()
        static let BlurRadius: CGFloat = 5.0
        static let HeaderToFirstGuideDistance: CGFloat = 18.0
        static let TabSwitcherHeight: CGFloat = 54.0 + HeaderToFirstGuideDistance
    }
}
