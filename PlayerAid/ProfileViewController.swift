import UIKit
import ParallaxBlur
import DZNEmptyDataSet

final class ProfileViewController: JPBParallaxTableViewController {
    var viewModel: ProfileViewModel!
    
    fileprivate var tabSwitcherViewController: ProfileTabSwitcherViewController!
    fileprivate var tabSwitcherViewModel: ProfileTabSwitcherViewModel!
    
    fileprivate var profileOverscrollOverlay: ProfileOverscrollOverlay!
    fileprivate var playerInfoView: PlayerInfoView!
    
    fileprivate var lastSelectedGuide: Tutorial?
    
    override func viewDidLoad() {
        blurIterations = Constants.BlurIterations
        headerOverscrollBackgroundColor = ColorsHelper.userProfileHeaderOverscrollBackgroundColor()
        setupProfileOverscrollOverlay()
        
        setupViewModel()
        setupTabSwitcher()
        
        super.viewDidLoad()
        tabSwitcherViewController.didMove(toParentViewController: self)
        self.view.backgroundColor = UIColor.white
        
        setupFollowersCells()
        setupBackgroundImage()
        setupHeaderOverlay()
        setupHeaderOverscrollOverlay()
        setupEmptyTableViewOverlays()
        setupTableViewHeaderAndFooter()
        tableView.isScrollEnabled = false
        
        tabSwitcherViewController.tutorialsTabSelectedBlock()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        TabBarBadgeHelper().hideProfileTabBarItemBadge()
        updateBackButtons()
        navigationController?.setNavigationBarHidden(true, animated: true)
        enableSwipeBackGesture()
        adjustTableViewContentSize()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tabSwitcherViewController.updateGuidesCountLabels()
    }
    
    //MARK: statusbar

    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK: setup
    
    fileprivate func setupTableViewHeaderAndFooter() {
        let gapHeight = Constants.TableViewHeaderFooterGapHeight
        tableView.tableHeaderView = CommonViews.tableHeaderOrFooterView(withHeight: gapHeight)
        tableView.tableFooterView = CommonViews.tableHeaderOrFooterView(withHeight: gapHeight)
    }
    
    fileprivate func setupEmptyTableViewOverlays() {
        tableView.emptyDataSetSource = tabSwitcherViewModel.emptyDataSetSource
        tableView.emptyDataSetDelegate = tabSwitcherViewModel.emptyDataSetDelegate
    }
    
    fileprivate func setupProfileOverscrollOverlay() {
        profileOverscrollOverlay = ProfileOverscrollOverlay()
        profileOverscrollOverlay.backButtonAction = { [unowned self] in
            self.navigationController!.popViewController(animated: true)
        }
    }
    
    fileprivate func setupViewModel() {
        if viewModel == nil {
            viewModel = ProfileViewModel()
        }
    }
    
    fileprivate func setupBackgroundImage() {
        self.headerImageViewBackgroundColor = ColorsHelper.userProfileDefaultBackgroundColor()
        setHeaderTintColor(Constants.TintColor)
        
        viewModel.fetchProfileImage { [unowned self] image in
            self.setHeaderImage(image)
        }
    }
    
    fileprivate func setupFollowersCells() {
        let nib = UINib(nibName: Constants.UserCellNibName, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: Constants.UserCellIdentifier)
    }
    
    fileprivate func pushOtherUserProfile(_ user: User) {
        let userPushBlock = ApplicationViewHierarchyHelper.pushProfileVC(from: self.navigationController, allowPushingLoggedInUser: false, denyPushing: viewModel.user)
        userPushBlock!(user)
    }
    
    fileprivate func setupTabSwitcher() {
        tabSwitcherViewModel = ProfileTabSwitcherViewModel(tableView: tableView, user: viewModel.user!, userCellReuseIdentifier: Constants.UserCellIdentifier, userAvatarOrNameSelected: { [unowned self] user in
            self.pushOtherUserProfile(user)
        })
        
        tabSwitcherViewController = ProfileTabSwitcherFactory().createNewProfileTabSwitcherViewController(tabSwitcherViewModel, guidesTableViewDelegate: self, usersTableViewDelegate: self, reloadTableView: { [unowned self] in
                self.tableView.contentOffset = CGPoint.zero // empty view overlay position is incorrect if we reload when contentOffset.y != 0
            
                UIView.transition(with: self.tableView, duration:Constants.TabSwitchingCrossDissolveAnimationDuration, options: UIViewAnimationOptions.transitionCrossDissolve, animations: {
                    self.tableView.reloadData()
                }, completion: nil)
            
                UIView.animate(withDuration: Constants.ProfileHeaderResizeAnimationDuration, animations: {
                    self.recalculateHeight()
                })
            
                if self.isViewLoadedAndInViewHierarchy() {
                    self.tabSwitcherViewController.updateGuidesCountLabels() // this is just masking a bug that tab numbers don't update dynamically on core data change
                }
            })
        tabSwitcherViewController.collectionView?.backgroundColor = ColorsHelper.tutorialsUnselectedFilterBackgroundColor()
        tabSwitcherViewController.viewModel = tabSwitcherViewModel
        
        addChildViewController(tabSwitcherViewController)
    }
    
    fileprivate func isViewLoadedAndInViewHierarchy() -> Bool {
        return isViewLoaded && view.window != nil;
    }

    //MARK: header overlay
    
    fileprivate func setupHeaderOverlay() {
        let screenWidth = view.bounds.size.width
        
        playerInfoView = PlayerInfoView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenWidth))
        
        if let user = viewModel.user {
            playerInfoView.user = user
            
            playerInfoView.backButtonPressed = { [unowned self] in
                self.navigationController!.popViewController(animated: true)
            }
            
            playerInfoView.editButtonPressed = { [unowned self] in
                ApplicationViewHierarchyHelper.presentEditProfileViewController(from: self, with: user, didUpdateProfileBlock: { [unowned self] in
                    self.viewModel.reloadUser()
                    self.playerInfoView.user = self.viewModel.user
                    
                    self.viewModel.fetchProfileImage({ (image) in
                        assert(image != nil);
                        
                        if image != nil {
                            DispatchSyncOnMainThread({
                                self.setHeaderImage(image)
                            })
                        }
                    })
                })
            }
            updateProfileOverscrollOverlay()
        }
        addHeaderOverlayView(playerInfoView)
    }
    
    fileprivate func updateProfileOverscrollOverlay() {
        profileOverscrollOverlay.playerName?.text = viewModel.user!.name
    }
    
    fileprivate func setupHeaderOverscrollOverlay() {
        assert(profileOverscrollOverlay != nil)
        
        let overlay = overscrollOverlayWithFrame(CGRect.zero)
        setOverscrollOverlay(overlay)
        updateProfileOverscrollOverlay()
    }
    
    fileprivate func overscrollOverlayWithFrame(_ frame: CGRect) -> UIView! {
        profileOverscrollOverlay.view.frame = frame
        profileOverscrollOverlay.view.backgroundColor = ColorsHelper.userProfileHeaderOverscrollBackgroundColor()
        return profileOverscrollOverlay.view
    }
    
    //MARK: private
    
    fileprivate func isOnlyViewControllerOnNavigationStack() -> Bool {
        return (self.navigationController!.viewControllers.count == 1)
    }
    
    fileprivate func updateBackButtons() {
        let hidden = isOnlyViewControllerOnNavigationStack()
        profileOverscrollOverlay.setBackButtonHidden(hidden)
        playerInfoView.setBackButtonHidden(hidden)
    }
    
    //MARK: TableView size adjustments
    
    func adjustTableViewContentSize() {
        let headersHeight = self.headerHeight() + self.subHeaderHeight()
        assert(headersHeight > 0)
        
        let viewHeight = self.view.frame.height
        assert(viewHeight > 0)
        
        setMinimumTableViewHeight(viewHeight - headersHeight)
    }
    
    func setMinimumTableViewHeight(_ height: CGFloat) {
        var frame = tableView.frame
        frame.size.height = max(tableView.contentSize.height, height)
        tableView.frame = frame
    }
    
    //MARK: Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        TutorialDetailsHelper().prepare(forTutorialDetailsSegue: segue, pushing: lastSelectedGuide)
    }
}

//MARK: Guides/Users TableViewDelegate
extension ProfileViewController: GuidesTableViewDelegate, UsersTableViewDelegate {
    
    @objc func numberOfRowsDidChange_(ofRowsDidChange numberOfRows: Int) {
        DispatchAsyncOnMainThread { 
            self.tabSwitcherViewController.updateGuidesCountLabels()
            
            DispatchAfter(0.5, closure: { // horrible workaround for now callback!
                self.recalculateHeight() // this needs to be called only AFTER finishing rows animations, otherwise doesn't make sense...
            })
        }
    }

    @objc func didSelectRow(withGuide guide: Tutorial) {
        lastSelectedGuide = guide
        
        if guide.isDraft {
            ApplicationViewHierarchyHelper.presentCreateTutorialViewController(for: guide, isEditingDraft: true)
        } else {
            TutorialDetailsHelper().performTutorialDetailsSegue(from: self)
        }
    }
    
    func recalculateHeight() {
        self.adjustTableViewContentSize()
        self.setNeedsScrollViewAppearanceUpdate()
    }
}

//MARK: JPBParallaxTableViewController overrides
extension ProfileViewController {
    override func subHeaderView() -> UIView {
        assert(tabSwitcherViewController != nil)
        
        let subHeaderView = tabSwitcherViewController.view
        subHeaderView?.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: subHeaderHeight())
        subHeaderView?.autoresizingMask = .flexibleWidth
        return subHeaderView!
    }
    
    override func subHeaderHeight() -> CGFloat {
        return Constants.TabSwitcherHeight
    }
    
    func offsetHeight() -> CGFloat {
        // folded profile height from screen top to tabSelection bar
        return 65.0
    }
}

// Swipe back navigation gesture
extension ProfileViewController: UIGestureRecognizerDelegate  {
    func enableSwipeBackGesture() {
        // required when NavigationBar hidden with animation
        navigationController?.interactivePopGestureRecognizer?.delegate = self
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
    
    static let TabSwitchingCrossDissolveAnimationDuration: TimeInterval = 0.25
    static let ProfileHeaderResizeAnimationDuration: TimeInterval = 0.3
}
