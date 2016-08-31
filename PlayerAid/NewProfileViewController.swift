import UIKit
import ParallaxBlur
import DZNEmptyDataSet

final class NewProfileViewController: JPBParallaxTableViewController {
    var viewModel: NewProfileViewModel!
    
    private var tabSwitcherViewController: ProfileTabSwitcherViewController!
    private var tabSwitcherViewModel: ProfileTabSwitcherViewModel!
    
    private var profileOverscrollOverlay: ProfileOverscrollOverlay!
    private var playerInfoView: PlayerInfoView!
    
    private var lastSelectedGuide: Tutorial?
    
    override func viewDidLoad() {
        blurIterations = Constants.BlurIterations
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
        setupEmptyTableViewOverlays()
        setupTableViewHeaderAndFooter()
        
        tabSwitcherViewController.tutorialsTabSelectedBlock()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        TabBarBadgeHelper().hideProfileTabBarItemBadge()
        updateBackButtons()
        updateNavigationBarVisibility()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        tabSwitcherViewController.updateGuidesCountLabels()
    }
    
    //MARK: statusbar
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    //MARK: setup
    
    private func setupTableViewHeaderAndFooter() {
        let gapHeight = Constants.TableViewHeaderFooterGapHeight
        tableView.tableHeaderView = CommonViews.tableHeaderOrFooterViewWithHeight(gapHeight)
        tableView.tableFooterView = CommonViews.tableHeaderOrFooterViewWithHeight(gapHeight)
    }
    
    private func setupEmptyTableViewOverlays() {
        tableView.emptyDataSetSource = tabSwitcherViewModel.emptyDataSetSource
        tableView.emptyDataSetDelegate = tabSwitcherViewModel.emptyDataSetDelegate
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
        self.headerImageViewBackgroundColor = ColorsHelper.userProfileDefaultBackgroundColor()
        setHeaderTintColor(Constants.TintColor)
        
        viewModel.fetchProfileImage { [unowned self] image in
            self.setHeaderImage(image)
        }
    }
    
    private func setupFollowersCells() {
        let nib = UINib(nibName: Constants.UserCellNibName, bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: Constants.UserCellIdentifier)
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
            })
        tabSwitcherViewController.collectionView?.backgroundColor = ColorsHelper.tutorialsUnselectedFilterBackgroundColor()
        tabSwitcherViewController.viewModel = tabSwitcherViewModel
        
        addChildViewController(tabSwitcherViewController)
    }
    
    //MARK: header overlay
    
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
    
    private func overscrollOverlayWithFrame(frame: CGRect) -> UIView! {
        profileOverscrollOverlay.view.frame = frame
        profileOverscrollOverlay.view.backgroundColor = ColorsHelper.userProfileHeaderOverscrollBackgroundColor()
        return profileOverscrollOverlay.view
    }
    
    //MARK: private
    
    private func updateNavigationBarVisibility() {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
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
}

//MARK: GuidesTableViewDelegate
extension NewProfileViewController: GuidesTableViewDelegate {
    
    @objc func numberOfRowsDidChange(numberOfRows: Int) {
        // [self.tableViewOverlayBehaviour updateTableViewScrollingAndOverlayViewVisibility];
        
        tabSwitcherViewController.updateGuidesCountLabels()
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
    
    func recalculateHeight() {
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
        // folded profile height from screen top to tabSelection bar
        return 65.0
    }
}

private struct Constants {
    static let TintColor = ColorsHelper.userProfileBackgroundTintColor()
    static let BlurRadius: CGFloat = 5.0
    static let BlurIterations: CGFloat = 10.0
    static let HeaderToFirstGuideDistance: CGFloat = 18.0
    static let TabSwitcherHeight: CGFloat = 54.0
    static let UserCellIdentifier = "UserCellIdentifier"
    static let UserCellNibName = "FollowedUser"
    static let TableViewHeaderFooterGapHeight: CGFloat = 18.0
}