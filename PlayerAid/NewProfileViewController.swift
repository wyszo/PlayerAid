import UIKit
import MGSpotyViewController
import ParallaxBlur

// TODO: restore tableView empty states


final class NewProfileViewController: JPBParallaxTableViewController {
    var viewModel: NewProfileViewModel!
    private let spotySectionIndexTransformer = MGSpotySectionIndexTransformer()
    
    private var profileDelegate: ProfileTableViewDelegate!
    private var tabSwitcherViewController: ProfileTabSwitcherViewController!
    private var tabSwitcherViewModel: ProfileTabSwitcherViewModel!
    private var profileOverscrollOverlay: ProfileOverscrollOverlay!
    private var playerInfoView: PlayerInfoView!
    private var lastSelectedGuide: Tutorial?
    
    override func viewDidLoad() {
        blurIterations = 10.0
        headerOverscrollBackgroundColor = ColorsHelper.userProfileHeaderOverscrollBackgroundColor()
        setupProfileOverscrollOverlay()
        
        setupViewModel()
        setupTabSwitcher()
        
        super.viewDidLoad()
        tabSwitcherViewController.didMoveToParentViewController(self)
        
        setupFollowersCells()
        setupBackgroundImage()
        setupHeaderOverlay()
        setupHeaderOverscrollOverlay()
        
        tabSwitcherViewController.tutorialsTabSelectedBlock()
    }
    
    private func setupProfileOverscrollOverlay() {
        profileOverscrollOverlay = ProfileOverscrollOverlay()
        profileOverscrollOverlay.backButtonAction = { [unowned self] in
            self.navigationController!.popViewControllerAnimated(true)
        }
    }
    
    private func setupViewModel() {
        if viewModel == nil {
            viewModel = NewProfileViewModel()
        }
    }
    
    private func setupBackgroundImage() {
        // TODO: poczatkowo widac czarne tlo - nie powinno byc czarne!! (ani widoczne!)
        let transparentStub = UIImage(named: "transparent")
        setHeaderImage(transparentStub)
        
        setHeaderTintColor(Constants.TintColor)
        
        viewModel.fetchProfileImage { [unowned self] image in
            self.setHeaderImage(image)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        TabBarBadgeHelper().hideProfileTabBarItemBadge()
        updateBackButtons()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        tabSwitcherViewController.updateGuidesCountLabels()
        updateNavigationBarVisibility()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
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
//        delegate = profileDelegate!
        
        profileDelegate.cellSelected = { [unowned self] oneBasedIndexPath in
            let sectionIndex = self.spotySectionIndexTransformer.zeroBasedSectionIndex(oneBasedIndexPath.section)
            let indexPath = NSIndexPath(forRow: oneBasedIndexPath.row, inSection: sectionIndex)
            
            if self.profileDelegate.shouldPushProfileOnCellSelected {
                if let user = self.profileDelegate.indexPathToUserTransformation?(indexPath) {
                    self.pushProfile(user)
                }
            } else {
                if let guide = self.profileDelegate.indexPathToGuideTransformation?(indexPath) {
//                    self.didSelectRowWithGuide(guide)
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
        
        tabSwitcherViewController = ProfileTabSwitcherFactory().createNewProfileTabSwitcherViewController(tabSwitcherViewModel, guidesTableViewDelegate: self, reloadTableView: { [unowned self] in
                self.tableView.reloadData()
                self.recalculateHeight()
            }, setDataSource: { [unowned self] dataSource in
//            self.dataSource = dataSource
            self.tableView.reloadData()
        }, setPushProfileOnCellSelected: { [unowned self] shouldPush in
//            self.profileDelegate.shouldPushProfileOnCellSelected = shouldPush
        }, setDeleteCellAtIndexPath: { [unowned self] deleteCallback in
            self.setupAllowCellDeletion(deleteCallback != nil, cellDeletionBlock:deleteCallback)
        })
        tabSwitcherViewController.collectionView?.backgroundColor = ColorsHelper.tutorialsUnselectedFilterBackgroundColor()
        tabSwitcherViewController.viewModel = tabSwitcherViewModel
        
        addChildViewController(tabSwitcherViewController)
//        dataSource = tabSwitcherViewModel.ownGuidesDataSource
    }
    
    private func setupAllowCellDeletion(allowDeletion: Bool, cellDeletionBlock:((NSIndexPath)->())?) {
        if allowDeletion {
//            self.deleteCellOnSwipeBlock = { [unowned self] oneBasedIndexPath in
//                let indexPath = self.spotySectionIndexTransformer.zeroBasedIndexPath(oneBasedIndexPath)
//                cellDeletionBlock?(indexPath)
//            }
        } else {
//            self.deleteCellOnSwipeBlock = nil
        }
    }
    
    private func setupHeaderOverlay() {
        let screenWidth = view.bounds.size.width
        
        playerInfoView = PlayerInfoView(frame: CGRectMake(0, 0, screenWidth, screenWidth))
        
        if let user = viewModel.user {
            playerInfoView.user = user
            
            playerInfoView.backButtonPressed = { [unowned self] in
                self.navigationController!.popViewControllerAnimated(true)
            }
            
            playerInfoView.editButtonPressed = { [unowned self] in
                ApplicationViewHierarchyHelper.presentEditProfileViewControllerFromViewController(self, withUser: user, didUpdateProfileBlock: {
                    self.viewModel.reloadUser()
                    self.playerInfoView.user = self.viewModel.user
                })
            }
            updateProfileOverscrollOverlay()
        }
        addHeaderOverlayView(playerInfoView)
    }
    
    private func updateProfileOverscrollOverlay() {
        profileOverscrollOverlay.playerName?.text = viewModel.user!.name
    }
    
    private func setupHeaderOverscrollOverlay() {
        assert(profileOverscrollOverlay != nil)
        
        let overlay = overscrollOverlayWithFrame(CGRectZero)
        setOverscrollOverlay(overlay)
        updateProfileOverscrollOverlay()
    }
    
    //MARK: private
    
    private func updateNavigationBarVisibility() {
        let isOnlyViewControllerOnStack = (self.navigationController?.viewControllers.count == 1)
        if (isOnlyViewControllerOnStack) {
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        }
    }
    
    private func isOnlyViewControllerOnNavigationStack() -> Bool {
        return (self.navigationController!.viewControllers.count == 1)
    }
    
    private func updateBackButtons() {
        let hidden = isOnlyViewControllerOnNavigationStack()
        profileOverscrollOverlay.setBackButtonHidden(hidden)
        playerInfoView.setBackButtonHidden(hidden)
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
        static let TabSwitcherHeight: CGFloat = 54.0
        static let UserCellIdentifier = "UserCellIdentifier"
        static let UserCellNibName = "FollowedUser"
    }
}

//MARK: GuidesTableViewDelegate
extension NewProfileViewController: GuidesTableViewDelegate {
    
    @objc func numberOfRowsDidChange(numberOfRows: Int) {
//        [self.tableViewOverlayBehaviour updateTableViewScrollingAndOverlayViewVisibility];
//        [self updateTabSwitcherGuidesCount];
        
        self.recalculateHeight() // to powinno byc zawolane dopiero po zakonczeniu animacji z FRB, inaczej nie ma sensu!
    }

    @objc func didSelectRowWithGuide(guide: Tutorial) {
        lastSelectedGuide = guide
        
        if guide.isDraft {
            ApplicationViewHierarchyHelper.presentCreateTutorialViewControllerForTutorial(guide, isEditingDraft: true)
        } else {
            TutorialDetailsHelper().performTutorialDetailsSegueFromViewController(self)
            self.navigationController?.setNavigationBarHidden(false, animated: true)
        }
    }
    
    func recalculateHeight() 
    {
        self.setNeedsScrollViewAppearanceUpdate()
    }
}

//MARK: JPBParallaxTableViewController overrides
extension NewProfileViewController {
    override func subHeaderView() -> UIView {
        assert(tabSwitcherViewController != nil)
        
        let subHeaderView = tabSwitcherViewController.view
        subHeaderView.frame = CGRectMake(0, 0, CGRectGetWidth(view.frame), subHeaderHeight())
        subHeaderView.autoresizingMask = .FlexibleWidth
        return subHeaderView
    }
    
    override func subHeaderHeight() -> CGFloat {
        return Constants.TabSwitcherHeight
    }
    
    func offsetHeight() -> CGFloat {
        return 65.0 // folded profile height from screen top to tabSelection bar
    }
    
    override func overscrollOverlayWithFrame(frame: CGRect) -> UIView! {
        profileOverscrollOverlay.view.frame = frame
        profileOverscrollOverlay.view.backgroundColor = ColorsHelper.userProfileHeaderOverscrollBackgroundColor()
        return profileOverscrollOverlay.view
    }
}
