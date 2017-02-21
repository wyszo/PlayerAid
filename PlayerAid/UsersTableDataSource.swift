import Foundation
import TWCommonLib
import MagicalRecord

final class UsersTableViewDataSource: NSObject {
    fileprivate let tableView: UITableView
    fileprivate var tableViewDataSource: TWCoreDataTableViewDataSource<NSManagedObject>!
    fileprivate var fetchedResultsControllerBinder: TWTableViewFetchedResultsControllerBinder!
    var usersTableViewDelegate: UsersTableViewDelegate!
    var predicate: NSPredicate!

    init(tableView: UITableView) {
        self.tableView = tableView
        super.init()
        
        setupTableViewDataSource()
        setupFetchedResultsControllerBinder()
    }
    
    //MARK: private setup
    
    fileprivate func setupFollowersCells() {
        let nib = UINib(nibName: Constants.UserCellNibName, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: Constants.UserCellReuseIdentifier)
    }
    
    fileprivate func setupTableViewDataSource() {
        tableViewDataSource = TWCoreDataTableViewDataSource(cellReuseIdentifier: Constants.UserCellReuseIdentifier, configureCellBlock: self.configureUserCellBlock())
        tableViewDataSource.fetchedResultsControllerLazyInitializationBlock = self.fetchedResultsControllerLazyInitializationBlock()
    }
    
    fileprivate func fetchedResultsControllerLazyInitializationBlock() -> ()->(NSFetchedResultsController<NSFetchRequestResult>) {
        return { [unowned self] in
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
            fetchRequest.predicate = self.predicate
            fetchRequest.sortDescriptors = [ NSSortDescriptor(key: "name", ascending: true) ]
            
            let context = NSManagedObjectContext.mr_contextForCurrentThread()
            
            let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            fetchedResultsController.delegate = self.fetchedResultsControllerBinder
            
            fetchedResultsController.tw_performFetchAssertResults()
            return fetchedResultsController
        }
    }
    
    fileprivate func setupFetchedResultsControllerBinder() {
        
        fetchedResultsControllerBinder = TWTableViewFetchedResultsControllerBinder(tableView: tableView, configureCellBlock:configureUserCellBlock())
        fetchedResultsControllerBinder.numberOfObjectsChangedBlock = { [unowned self] objectCount in
            self.usersTableViewDelegate.numberOfRowsDidChange?(objectCount)
        }
    }
    
    //MARK: Auxiliary methods
    
    func configureUserCellBlock() -> CellAtIndexPathBlock {
        return { [unowned self] cell, indexPath in
            let userCell = cell as? FollowedUserTableViewCell
            assert(userCell != nil)
            
            assert((indexPath?.row)! < self.tableViewDataSource.objectCount())
            let user = self.tableViewDataSource.object(at: indexPath!) as? User
            assert(user != nil)
            
            if user != nil {
                userCell!.configure(with: user)
            }
        }
    }
    
    //MARK: public interface
    
    func attachDataSourceToTableView() {
        tableView.dataSource = tableViewDataSource
        fetchedResultsControllerBinder.disabled = false
    }
    
    func detachFromTableView() {
        fetchedResultsControllerBinder.disabled = true
    }
}

extension UsersTableViewDataSource: TWObjectAtIndexPathProtocol {
    func object(at indexPath: IndexPath) -> Any? {
        return tableViewDataSource.object(at: indexPath)
    }
}

private struct Constants {
    static let UserCellReuseIdentifier = "UserCellIdentifier"
    static let UserCellNibName = "FollowedUser"
}
