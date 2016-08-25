import Foundation
import TWCommonLib

final class ProfileTabSwitcherViewModel: NSObject {
    private let tableView: UITableView
    private let user: User
    private let userCellReuseIdentifier: String
    private let userAvatarOrNameSelected: (User)->()
    
    var ownGuidesDataSource: GuidesSpotyTableDataSource!
    var likedGuidesDataSource: GuidesSpotyTableDataSource!
    var followingDataSource: GuidesArraySpotyTableDataSource!
    var followersDataSource: GuidesArraySpotyTableDataSource!
    
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
        dataSource.tableViewDataSource.predicate = NSPredicate(format: "reportedByUser == 0 AND createdBy = %@", user)
        dataSource.tableViewDataSource.groupBy = "state"
        dataSource.tableViewDataSource.showSectionHeaders = false
        dataSource.tableViewDataSource.swipeToDeleteEnabled = true
        
        ownGuidesDataSource = dataSource
    }
    
    func setupLikedGuidesDataSource() {
        let dataSource = createGuidesTableDataSourceWithoutPredicate()
        dataSource.tableViewDataSource.predicate = NSPredicate(format: "reportedByUser == 0 AND %@ IN likedBy", self.user)
        
        likedGuidesDataSource = dataSource
    }
    
    func createGuidesTableDataSourceWithoutPredicate() -> GuidesSpotyTableDataSource {
        let dataSource = GuidesSpotyTableDataSource(tableView: tableView)
        dataSource.tableViewDataSource.userAvatarOrNameSelectedBlock = self.userAvatarOrNameSelected
        return dataSource
    }
    
    func setupFollowingDataSource() {
        followingDataSource = createUserCellDataSource(objects: Array(user.follows))
    }
    
    func setupFollowersDataSource() {
        followersDataSource = createUserCellDataSource(objects: Array(user.isFollowedBy))
    }
    
    func createUserCellDataSource(objects objects: [AnyObject]) -> GuidesArraySpotyTableDataSource {
        assert(objects.count >= 0)
        let arrayDataSource = TWArrayTableViewDataSource(array: objects, tableView: tableView, attachToTableView: false, cellDequeueIdentifier: self.userCellReuseIdentifier)
        
        arrayDataSource.configureCellBlock = { cell, indexPath in
            let userCell = cell as? FollowedUserTableViewCell
            assert(userCell != nil)
            
            assert(indexPath.row < arrayDataSource.objectCount())
            let user = arrayDataSource.objectAtIndexPath(indexPath) as? User
            assert(user != nil)
            
            if user != nil {
                userCell!.configureWithUser(user)
            }
        }
        return GuidesArraySpotyTableDataSource(tableView: tableView, arrayDataSource: arrayDataSource)
    }
}

//MARK: Auxiliary methods
private extension ProfileTabSwitcherViewModel {
    func publishedGuidesCount() -> Int {
        return self.ownGuidesDataSource.tableViewDataSource.numberOfRowsForSectionNamed("Published")
    }
}
