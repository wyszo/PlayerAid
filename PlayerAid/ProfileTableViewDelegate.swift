import UIKit
import MGSpotyViewController

final class ProfileTableViewDelegate: NSObject, MGSpotyViewControllerDelegate {
    private let headerSize: CGSize
    private let headerView: UIView
    private var addHeaderCallbackFired = false
    var didAddHeader: ((header: UIView, section: Int)->())?

    init(headerSize: CGSize, headerView: UIView) {
        self.headerSize = headerSize
        self.headerView = headerView
    }

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
    
    //MARK: private helpers
    
    private struct Constants {
        static let FirstRealSectionIndex = 1
    }
}
