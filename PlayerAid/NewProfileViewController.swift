import UIKit
import MGSpotyViewController

// TODO: reapply new guide badges logic
// TODO: restore tableView empty states


final class NewProfileViewController: MGSpotyViewController {
    var viewModel: NewProfileViewModel!
    private let spotySectionIndexTransformer = MGSpotySectionIndexTransformer()
    
    private var profileDelegate: ProfileTableViewDelegate!
    private var tabSwitcherViewController: ProfileTabSwitcherViewController!
    private var tabSwitcherViewModel: ProfileTabSwitcherViewModel!
    private var lastSelectedGuide: Tutorial?

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
        tabSwitcherViewController.tutorialsTabSelectedBlock()
        
        blurRadius = Constants.BlurRadius
        tintColor = Constants.TintColor
        view.backgroundColor = UIColor.whiteColor()
        
        viewModel.fetchProfileImage { [unowned self] (image) in
            self.setMainImage(image)
        }
        setupPlayerInfoOverlay()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        TabBarBadgeHelper().hideProfileTabBarItemBadge()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        tabSwitcherViewController.updateGuidesCountLabels()
        updateNavigationBarVisibility()
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
            let TabSwitcherSectionIndex = 1 
            assert(section == TabSwitcherSectionIndex)
            self.tabSwitcherViewController.didMoveToParentViewController(self)
        }
        
        profileDelegate.cellSelected = { [unowned self] oneBasedIndexPath in
            let sectionIndex = self.spotySectionIndexTransformer.zeroBasedSectionIndex(oneBasedIndexPath.section)
            let indexPath = NSIndexPath(forRow: oneBasedIndexPath.row, inSection: sectionIndex)
            
            if self.profileDelegate.shouldPushProfileOnCellSelected {
                if let user = self.profileDelegate.indexPathToUserTransformation?(indexPath) {
                    self.pushProfile(user)
                }
            } else {
                if let guide = self.profileDelegate.indexPathToGuideTransformation?(indexPath) {
                    self.didSelectRowWithGuide(guide)
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
        }, setPushProfileOnCellSelected: { [unowned self] shouldPush in
            self.profileDelegate.shouldPushProfileOnCellSelected = shouldPush
        }, setDeleteCellAtIndexPath: { [unowned self] deleteCallback in
            self.setupAllowCellDeletion(deleteCallback != nil, cellDeletionBlock:deleteCallback)
        }, setIndexPathToUserTransformation: { [unowned self] transformation in
            self.profileDelegate.indexPathToUserTransformation = transformation
        }, setIndexPathToGuideTransformation: { [unowned self] transformation in
            self.profileDelegate.indexPathToGuideTransformation = transformation
        })
        tabSwitcherViewController.collectionView?.backgroundColor = ColorsHelper.tutorialsUnselectedFilterButtonColor()
        tabSwitcherViewController.viewModel = tabSwitcherViewModel
        
        addChildViewController(tabSwitcherViewController)
        dataSource = tabSwitcherViewModel.ownGuidesDataSource
    }
    
    private func setupAllowCellDeletion(allowDeletion: Bool, cellDeletionBlock:((NSIndexPath)->())?) {
        if allowDeletion {
            self.deleteCellOnSwipeBlock = { [unowned self] oneBasedIndexPath in
                let indexPath = self.spotySectionIndexTransformer.zeroBasedIndexPath(oneBasedIndexPath)
                cellDeletionBlock?(indexPath)
            }
        } else {
            self.deleteCellOnSwipeBlock = nil
        }
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
    
    private func updateNavigationBarVisibility() {
        let isOnlyViewControllerOnStack = (self.navigationController?.viewControllers.count == 1)
        if (isOnlyViewControllerOnStack) {
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        }
    }
    
    private func didSelectRowWithGuide(guide: Tutorial) {
        lastSelectedGuide = guide
    
        if guide.isDraft {
            ApplicationViewHierarchyHelper.presentCreateTutorialViewControllerForTutorial(guide, isEditingDraft: true)
        } else {
            TutorialDetailsHelper().performTutorialDetailsSegueFromViewController(self)
            self.navigationController?.setNavigationBarHidden(false, animated: true)
        }
    }
    
    //MARK: Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        TutorialDetailsHelper().prepareForTutorialDetailsSegue(segue, pushingTutorial: lastSelectedGuide)
    }

    private struct Constants {
        static let TintColor = ColorsHelper.userProfileBackgroundTintColor()
        static let BlurRadius: CGFloat = 5.0
        static let HeaderToFirstGuideDistance: CGFloat = 18.0
        static let TabSwitcherHeight: CGFloat = 54.0 + HeaderToFirstGuideDistance
        static let UserCellIdentifier = "UserCellIdentifier"
        static let UserCellNibName = "FollowedUser"
    }
}
