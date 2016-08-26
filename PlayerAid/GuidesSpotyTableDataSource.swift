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
    
        // z tym jest problem po tym jak dostaniemy callback od FRCBindera
        if section > tableViewDataSource.sectionsCount() {
            return 0
        }
    
        let sectionIndex: Int = sectionIndexTransformer.zeroBasedSectionIndex(section)
        return tableViewDataSource.numberOfRowsInSection(sectionIndex)
    }
    
    func spotyViewController(spotyViewController: MGSpotyViewController, tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let zeroBasedIndexPath = sectionIndexTransformer.zeroBasedIndexPath(indexPath)
        return tableViewDataSource.cellForRowAtIndexPath(zeroBasedIndexPath)!
    }
    
    func numberOfSectionsInSpotyViewController(spotyViewController: MGSpotyViewController) -> Int {
    
        let sections = tableViewDataSource.sectionsCount()
        
        // z tym jest problem po tym jak dostaniemy callback od FRCBindera
        if sections == 0 {
            return 1 // for tabSwitcher
        }
        
        return sections
    }
}
