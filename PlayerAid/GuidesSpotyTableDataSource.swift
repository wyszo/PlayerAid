import Foundation
import MGSpotyViewController

/** 
 A wrapper for GuidesTableDataSource for where you need MGSpotyViewControllerDataSource protocol
 */
final class GuidesSpotyTableDataSource: NSObject, MGSpotyViewControllerDataSource {
    private let tableView: UITableView
    private let sectionIndexTransformer = MGSpotySectionIndexTransformer()
    let tableViewDataSource: GuidesTableDataSource
    
    init(tableView: UITableView) {
        self.tableView = tableView
        tableViewDataSource = GuidesTableDataSource(tableView: tableView)
    }
    
    func spotyViewController(spotyViewController: MGSpotyViewController, numberOfRowsInSection section: Int) -> Int {
        let sectionIndex: Int = sectionIndexTransformer.zeroBasedSectionIndex(section)
        return tableViewDataSource.numberOfRowsInSection(sectionIndex)
    }
    
    func spotyViewController(spotyViewController: MGSpotyViewController, tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let sectionIndex: Int = sectionIndexTransformer.zeroBasedSectionIndex(indexPath.section)
        let modifiedIndexPath = NSIndexPath(forRow: indexPath.row, inSection: sectionIndex)
        
        return tableViewDataSource.cellForRowAtIndexPath(modifiedIndexPath)!
    }
    
    func numberOfSectionsInSpotyViewController(spotyViewController: MGSpotyViewController) -> Int {
        let sections = tableViewDataSource.sectionsCount()
        assert(sections > 0)
        return sections
    }
}
