import UIKit
import MGSpotyViewController

/**
 A wrapper for TWArrayTableViewDataSource for where you need MGSpotyViewControllerDataSource protocol
 */
final class GuidesArraySpotyTableDataSource: NSObject, MGSpotyViewControllerDataSource {
    private let tableView: UITableView
    private let sectionIndexTransformer = MGSpotySectionIndexTransformer()
    let tableViewDataSource: TWArrayTableViewDataSource
    
    init(tableView: UITableView, arrayDataSource: TWArrayTableViewDataSource) {
        self.tableView = tableView
        self.tableViewDataSource = arrayDataSource
    }
    
    func spotyViewController(spotyViewController: MGSpotyViewController, numberOfRowsInSection section: Int) -> Int {
        return tableViewDataSource.objectCount()
    }
    
    func spotyViewController(spotyViewController: MGSpotyViewController, tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let zeroBasedIndexPath = sectionIndexTransformer.zeroBasedIndexPath(indexPath)
        return tableViewDataSource.cellForRowAtIndexPath(zeroBasedIndexPath)
    }
    
    func numberOfSectionsInSpotyViewController(spotyViewController: MGSpotyViewController) -> Int {
        return 1
    }
}
