import UIKit
import MGSpotyViewController

// TODO: reapply new guide badges logic
// TODO: update navbar visibility
// TODO: restore tableView empty states
// TODO: fix following & followers tabs


final class NewProfileViewController: MGSpotyViewController {
    var viewModel: NewProfileViewModel!
    
    private var profileDelegate: ProfileTableViewDelegate!
    private var tabSwitcherViewController: ProfileTabSwitcherViewController!
    private var tabSwitcherViewModel: ProfileTabSwitcherViewModel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        let transparentStub = UIImage(named: "transparent")
        setupWithMainImage(transparentStub, tableScrollingType: .Normal)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFollowersCells()
        
        if viewModel == nil {
            viewModel = NewProfileViewModel()
        }
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
        tabSwitcherViewController.updateGuidesCountLabels()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    //MARK: setup
    
    private func setupFollowersCells() {
        let nib = UINib(nibName: Constants.UserCellNibName, bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: Constants.UserCellIdentifier)
    }
    
    private func setupDelegate() {
        setupTabSwitcher()
        let tabSwitcherSize = CGSize(width: view.bounds.size.width, height: Constants.TabSwitcherHeight)
        
        profileDelegate = ProfileTableViewDelegate(headerSize: tabSwitcherSize, headerView: tabSwitcherViewController.collectionView!)
        profileDelegate.rowHeight = ProfileTabSwitcherFactory.Constants.GuidesRowHeight
        delegate = profileDelegate!
        
        profileDelegate.didAddHeader = { [unowned self] _, section in
            let FirstNonHeaderSectionIndex = 1
            assert(section == FirstNonHeaderSectionIndex)
            self.tabSwitcherViewController.didMoveToParentViewController(self)
        }
        
        profileDelegate.cellSelected = { [unowned self] indexPath in
            if self.profileDelegate.shouldPushProfileOnCellSelected {
                if let user = self.profileDelegate.indexPathToUserTransformation?(indexPath) {
                    self.pushProfile(user)
                }
            }
        }
    }
    
    private func pushProfile(user: User) {
        let userPushBlock = ApplicationViewHierarchyHelper.pushProfileVCFromNavigationController(self.navigationController, allowPushingLoggedInUser: true)
        userPushBlock(user)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    private func setupTabSwitcher() {
        tabSwitcherViewModel = ProfileTabSwitcherViewModel(tableView: tableView, user: viewModel.user!, userCellReuseIdentifier: Constants.UserCellIdentifier, userAvatarOrNameSelected: { [unowned self] user in
            self.pushProfile(user)
        })
        
        tabSwitcherViewController = ProfileTabSwitcherFactory().createNewProfileTabSwitcherViewController(tabSwitcherViewModel, setDataSource: { [unowned self] dataSource in
            self.dataSource = dataSource
            self.tableView.reloadData() 
        }, setRowHeight: { [unowned self] rowHeight in
            self.profileDelegate.rowHeight = rowHeight
        }, setPushProfileOnCellSelected: { shouldPush in
            self.profileDelegate.shouldPushProfileOnCellSelected = shouldPush
        }, setIndexPathToUserTransformation: { transformation in
            self.profileDelegate.indexPathToUserTransformation = transformation
        })
        tabSwitcherViewController.collectionView?.backgroundColor = ColorsHelper.tutorialsUnselectedFilterButtonColor()
        tabSwitcherViewController.viewModel = tabSwitcherViewModel
        
        addChildViewController(tabSwitcherViewController)
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

    private struct Constants {
        static let TintColor = ColorsHelper.userProfileBackgroundTintColor()
        static let BlurRadius: CGFloat = 5.0
        static let HeaderToFirstGuideDistance: CGFloat = 18.0
        static let TabSwitcherHeight: CGFloat = 54.0 + HeaderToFirstGuideDistance
        static let UserCellIdentifier = "UserCellIdentifier"
        static let UserCellNibName = "FollowedUser"
    }
}
