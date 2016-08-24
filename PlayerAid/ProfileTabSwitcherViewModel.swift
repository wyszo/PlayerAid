import Foundation

final class ProfileTabSwitcherViewModel {
    private let tableView: UITableView
    private let user: User
    var ownGuidesDataSource: GuidesSpotyTableDataSource!
    
    init(tableView: UITableView, user: User) {
        self.tableView = tableView
        self.user = user
        
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
}
