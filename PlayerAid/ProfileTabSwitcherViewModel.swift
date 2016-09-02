import Foundation
import TWCommonLib
import DZNEmptyDataSet

final class ProfileTabSwitcherViewModel: NSObject {
    private let tableView: UITableView
    private let user: User
    private let userCellReuseIdentifier: String
    private let userAvatarOrNameSelected: (User)->()
    
    var ownGuidesDataSource: GuidesTableDataSource!
    var likedGuidesDataSource: GuidesTableDataSource!
    var followingDataSource: UsersTableViewDataSource!
    var followersDataSource: UsersTableViewDataSource!
    
    let emptyDataSetSource = EmptyDataSetSource()
    var emptyDataSetDelegate: DZNEmptyDataSetDelegate {
        return emptyDataSetSource
    }
    
    private var followingTableViewDelegate: FollowedUserTableViewDelegate!
    private var followersTableViewDelegate: FollowedUserTableViewDelegate!
    
    var guidesCount: Int {
        return self.publishedGuidesCount()
    }
    
    var likedGuidesCount: Int {
        return self.user.likes.count ?? 0
    }
    
    var followingCount: Int {
        return self.user.follows.count ?? 0
    }
    
    var followersCount: Int {
        return self.user.isFollowedBy.count ?? 0
    }
    
    init(tableView: UITableView, user: User, userCellReuseIdentifier: String, userAvatarOrNameSelected: (User)->()) {
        self.tableView = tableView
        self.user = user
        self.userCellReuseIdentifier = userCellReuseIdentifier
        self.userAvatarOrNameSelected = userAvatarOrNameSelected
        
        super.init()
        
        setupDataSources()
        setupDelegates()
    }
    
    func attachFollowingTableViewDelegate() {
        tableView.delegate = followingTableViewDelegate
    }
    
    func attachFollowersTableViewDelegate() {
        tableView.delegate = followersTableViewDelegate
    }
    
    func setEmptyState(title: String, imageName: String) {
        emptyDataSetSource.title = title
        emptyDataSetSource.image = UIImage(named: imageName)
    }
}

//MARK: delegates setup
private extension ProfileTabSwitcherViewModel {
    
    func setupDelegates() {
        setupFollowingTableViewDelegate(userAvatarOrNameSelected)
        setupFollowersTableViewDelegate(userAvatarOrNameSelected)
    }
    
    func setupFollowingTableViewDelegate(userSelected: (User)->()) {
        self.followingTableViewDelegate = followedUserTableViewDelegate(self.followingDataSource, userSelected: userSelected)
    }
    
    func setupFollowersTableViewDelegate(userSelected: (User)->()) {
        self.followersTableViewDelegate = followedUserTableViewDelegate(self.followersDataSource, userSelected: userSelected)
    }
    
    func followedUserTableViewDelegate(dataSource: TWObjectAtIndexPathProtocol, userSelected: (User)->()) -> FollowedUserTableViewDelegate {
        let delegate = FollowedUserTableViewDelegate()
        
        delegate.cellSelectedBlock = { indexPath in
            let user = dataSource.objectAtIndexPath(indexPath) as! User
            userSelected(user)
        }
        return delegate
    }
}

//MARK: dataSources setup
private extension ProfileTabSwitcherViewModel {
    func setupDataSources() {
        setupOwnGuidesDataSource()
        setupLikedGuidesDataSource()
        setupFollowingDataSource()
        setupFollowersDataSource()
    }

    func setupOwnGuidesDataSource() {
        let dataSource = createGuidesTableDataSourceWithoutPredicate()
        dataSource.predicate = NSPredicate(format: "reportedByUser == 0 AND createdBy = %@", user)
        dataSource.groupBy = "state"
        dataSource.showSectionHeaders = false
        dataSource.swipeToDeleteEnabled = true
        
        ownGuidesDataSource = dataSource
    }
    
    func setupLikedGuidesDataSource() {
        let dataSource = createGuidesTableDataSourceWithoutPredicate()
        dataSource.predicate = NSPredicate(format: "reportedByUser == 0 AND %@ IN likedBy", self.user)
        dataSource.indexPathTransformBlock = { indexPath in
            return NSIndexPath(forRow: indexPath.row, inSection: indexPath.section + 1)
        }
        
        likedGuidesDataSource = dataSource
    }
    
    func createGuidesTableDataSourceWithoutPredicate() -> GuidesTableDataSource {
        let dataSource = GuidesTableDataSource(tableView: tableView)
        dataSource.userAvatarOrNameSelectedBlock = self.userAvatarOrNameSelected
        return dataSource
    }
    
    func setupFollowingDataSource() {
        followingDataSource = UsersTableViewDataSource(tableView: tableView)
        followingDataSource.predicate = NSPredicate(format: "%@ IN isFollowedBy", self.user)
    }
    
    func setupFollowersDataSource() {
        followersDataSource = UsersTableViewDataSource(tableView: tableView)
        followersDataSource.predicate = NSPredicate(format: "%@ IN follows", self.user)
    }
}

//MARK: Auxiliary methods
private extension ProfileTabSwitcherViewModel {
    func publishedGuidesCount() -> Int {
        return self.ownGuidesDataSource.numberOfRowsForSectionNamed("Published")
    }
}

private struct Constants {
    static let EmptyStateOverlayOffset: CGFloat = -150.0
}
