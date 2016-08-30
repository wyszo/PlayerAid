import Foundation
import MGSpotyViewController

final class ProfileTabSwitcherFactory {
    typealias SetDataSourceType = (UITableViewDataSource)->()
    typealias PushUserProfileType = (User)->()
    typealias SetPushProfileOnCellSelectedType = (Bool)->()
    typealias IndexPathCallback = (NSIndexPath)->()
    typealias SetDeleteCellAtIndexPathType = (IndexPathCallback?->())
    
    typealias VoidBlock = ()->()
    
    func createNewProfileTabSwitcherViewController(viewModel: ProfileTabSwitcherViewModel, guidesTableViewDelegate: GuidesTableViewDelegate, reloadTableView: VoidBlock, setDataSource: SetDataSourceType, setPushProfileOnCellSelected: SetPushProfileOnCellSelectedType, setDeleteCellAtIndexPath: SetDeleteCellAtIndexPathType) -> ProfileTabSwitcherViewController {
        let tabSwitcher = ProfileTabSwitcherViewController()
        
        tabSwitcher.tutorialsTabSelectedBlock = {
            viewModel.ownGuidesDataSource.attachDataSourceAndDelegateToTableView()
            viewModel.ownGuidesDataSource.tutorialTableViewDelegate = guidesTableViewDelegate
            setPushProfileOnCellSelected(false) // required?
            
            reloadTableView()
            
//            setDeleteCellAtIndexPath({ indexPath in
//                viewModel.ownGuidesDataSource.deleteGuideAtIndexPath(indexPath)
//            })
        }
        tabSwitcher.likedTabSelectedBlock = {
            viewModel.likedGuidesDataSource.attachDataSourceAndDelegateToTableView()
            viewModel.likedGuidesDataSource.tutorialTableViewDelegate = guidesTableViewDelegate
            
            reloadTableView()
            
//            setPushProfileOnCellSelected(false)
//            setDeleteCellAtIndexPath(nil)
        }
        tabSwitcher.followingTabSelectedBlock = {
            viewModel.followingDataSource.attachDataSourceToTableView()
            viewModel.attachFollowingTableViewDelegate()
            
//            setRowHeight(Constants.FollowerRowHeight)
            reloadTableView()
            
//            setPushProfileOnCellSelected(true)
//            setDeleteCellAtIndexPath(nil)
        }
        tabSwitcher.followersTabSelectedBlock = {
            viewModel.followersDataSource.attachDataSourceToTableView()
            viewModel.attachFollowersTableViewDelegate()
            
            reloadTableView()
            
//            setPushProfileOnCellSelected(true)
//            setDeleteCellAtIndexPath(nil)
        }
        return tabSwitcher
    }
    
    struct Constants {
        static let FollowerRowHeight: CGFloat = 88.0
        static let GuidesRowHeight = TutorialCellHelper().cellHeightForCurrentScreenWidthWithBottomGapVisible(false)
    }
}
