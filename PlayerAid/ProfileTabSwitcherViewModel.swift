import Foundation

final class ProfileTabSwitcherViewModel: NSObject {
    private let tableView: UITableView
    private let user: User
    var ownGuidesDataSource: GuidesSpotyTableDataSource!
    
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
    
    init(tableView: UITableView, user: User) {
        self.tableView = tableView
        self.user = user
        super.init()
        
        setupOwnGuidesDataSource()
    }
    
    //MARK: private
    
    private func setupOwnGuidesDataSource() {
        ownGuidesDataSource = createGuidesTableDataSourceWithoutPredicate()
        ownGuidesDataSource.tableViewDataSource.predicate = NSPredicate(format: "reportedByUser == 0 AND createdBy = %@", user)
        ownGuidesDataSource.tableViewDataSource.groupBy = "state"
        ownGuidesDataSource.tableViewDataSource.showSectionHeaders = false
        ownGuidesDataSource.tableViewDataSource.swipeToDeleteEnabled = true
    }
    
    private func createGuidesTableDataSourceWithoutPredicate() -> GuidesSpotyTableDataSource {
        let dataSource = GuidesSpotyTableDataSource(tableView: tableView)
//        dataSource.delegate = // TODO
//        dataSource.userAvatarOrNameSelectedBlock = // TODO
        return dataSource
    }
    
    private func publishedGuidesCount() -> Int {
        return self.ownGuidesDataSource.tableViewDataSource.numberOfRowsForSectionNamed("Published")
    }
}
