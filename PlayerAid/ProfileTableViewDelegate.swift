import UIKit
import MGSpotyViewController

final class ProfileTableViewDelegate: NSObject {
    private let headerSize: CGSize
    private let headerView: UIView
    private var addHeaderCallbackFired = false
    var rowHeight: CGFloat!
    var didAddHeader: ((header: UIView, section: Int)->())?
    var cellSelected: ((NSIndexPath)->())?
    
    var shouldPushProfileOnCellSelected: Bool = false
    var indexPathToUserTransformation: ((NSIndexPath)->(User?))?

    init(headerSize: CGSize, headerView: UIView) {
        self.headerSize = headerSize
        self.headerView = headerView
    }
    
    // MARK: Constants
    
    private struct Constants {
        static let FirstRealSectionIndex = 1
    }
}

//MARK: MGSpotyViewControllerDelegate
extension ProfileTableViewDelegate: MGSpotyViewControllerDelegate {
    //MARK: Header
    
    func spotyViewController(spotyViewController: MGSpotyViewController, viewForHeaderInSection section: Int) -> UIView? {
        if section == Constants.FirstRealSectionIndex {
            headerView.frame = CGRectMake(0, 0, headerSize.width, headerSize.height)
            return headerView
        }
        return nil
    }
    
    func spotyViewController(spotyViewController: MGSpotyViewController, heightForHeaderInSection section: Int) -> CGFloat {
        if section == Constants.FirstRealSectionIndex {
            return headerSize.height
        }
        return 0
    }
    
    func spotyViewController(spotyViewController: MGSpotyViewController, willDisplayHeaderView header: UIView, forSection section: Int) {
        
        if section == Constants.FirstRealSectionIndex && addHeaderCallbackFired == false {
            didAddHeader?(header: header, section: section)
            addHeaderCallbackFired = true
        }
    }
    
    //MARK: Cells
    
    func spotyViewController(spotyViewController: MGSpotyViewController, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        // TODO: remove a gap after the last guide!
        return rowHeight
    }
    
    func spotyViewController(spotyViewController: MGSpotyViewController, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        cellSelected?(indexPath)
    }
}
