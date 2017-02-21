import Foundation
import TWCommonLib
import DZNEmptyDataSet

final class ProfileTabSwitcherViewModel: NSObject {
    fileprivate let tableView: UITableView
    fileprivate let user: User
    fileprivate let userCellReuseIdentifier: String
    fileprivate let userAvatarOrNameSelected: (User)->()
    
    var ownGuidesDataSource: GuidesTableDataSource!
    var likedGuidesDataSource: GuidesTableDataSource!
    var followingDataSource: UsersTableViewDataSource!
    var followersDataSource: UsersTableViewDataSource!
    
    let emptyDataSetSource = EmptyDataSetSource()
    var emptyDataSetDelegate: DZNEmptyDataSetDelegate {
        return emptyDataSetSource
    }
    
    fileprivate var followingTableViewDelegate: FollowedUserTableViewDelegate!
    fileprivate var followersTableViewDelegate: FollowedUserTableViewDelegate!
    
    var guidesCount: Int {
        return publishedGuidesCount()
    }
    
    var likedGuidesCount: Int {
        return user.likes.count ?? 0
    }
    
    var followingCount: Int {
        return user.follows.count ?? 0
    }
    
    var followersCount: Int {
        return user.isFollowedBy.count ?? 0
    }
    
    init(tableView: UITableView, user: User, userCellReuseIdentifier: String, userAvatarOrNameSelected: @escaping (User)->()) {
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
    
    func setEmptyState(_ title: String, imageName: String) {
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
    
    func setupFollowingTableViewDelegate(_ userSelected: @escaping (User)->()) {
        followingTableViewDelegate = followedUserTableViewDelegate(followingDataSource, userSelected: userSelected)
    }
    
    func setupFollowersTableViewDelegate(_ userSelected: @escaping (User)->()) {
        followersTableViewDelegate = followedUserTableViewDelegate(followersDataSource, userSelected: userSelected)
    }
    
    func followedUserTableViewDelegate(_ dataSource: TWObjectAtIndexPathProtocol, userSelected: @escaping (User)->()) -> FollowedUserTableViewDelegate {
        let delegate = FollowedUserTableViewDelegate()
        
        delegate.cellSelectedBlock = { indexPath in
            let user = dataSource.object(at: indexPath!) as! User
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
        dataSource.predicate = NSPredicate(format: "reportedByUser == 0 AND %@ IN likedBy", user)
        dataSource.indexPathTransformBlock = { indexPath in
            return IndexPath(row: (indexPath?.row)!, section: (indexPath?.section)! + 1)
        }
        
        likedGuidesDataSource = dataSource
    }
    
    func createGuidesTableDataSourceWithoutPredicate() -> GuidesTableDataSource {
        let dataSource = GuidesTableDataSource(tableView: tableView)
        dataSource.userAvatarOrNameSelectedBlock = userAvatarOrNameSelected
        return dataSource
    }
    
    func setupFollowingDataSource() {
        followingDataSource = UsersTableViewDataSource(tableView: tableView)
        followingDataSource.predicate = NSPredicate(format: "%@ IN isFollowedBy", user)
    }
    
    func setupFollowersDataSource() {
        followersDataSource = UsersTableViewDataSource(tableView: tableView)
        followersDataSource.predicate = NSPredicate(format: "%@ IN follows", user)
    }
}

//MARK: Auxiliary methods
private extension ProfileTabSwitcherViewModel {
    func publishedGuidesCount() -> Int {
        return ownGuidesDataSource.numberOfRows(forSectionNamed: "Published")
    }
}

private struct Constants {
    static let EmptyStateOverlayOffset: CGFloat = -150.0
}
