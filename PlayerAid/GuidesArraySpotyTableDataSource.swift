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
        
        let sectionIndex: Int = sectionIndexTransformer.zeroBasedSectionIndex(indexPath.section)
        let modifiedIndexPath = NSIndexPath(forRow: indexPath.row, inSection: sectionIndex)
        
        return tableViewDataSource.cellForRowAtIndexPath(modifiedIndexPath)
    }
    
    func numberOfSectionsInSpotyViewController(spotyViewController: MGSpotyViewController) -> Int {
        return 1
    }
}
