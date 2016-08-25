import Foundation
import MGSpotyViewController

final class ProfileTabSwitcherFactory {
    typealias SetDataSourceType = (MGSpotyViewControllerDataSource)->()
    typealias SetRowHeightType = (CGFloat)->()
    typealias PushUserProfileType = (User)->()
    typealias SetPushProfileOnCellSelectedType = (Bool)->()
    typealias IndexPathToUserType = (NSIndexPath)->(User?)
    typealias SetIndexPathToUserTransformationType = (IndexPathToUserType -> ())
    
    func createNewProfileTabSwitcherViewController(viewModel: ProfileTabSwitcherViewModel, setDataSource: SetDataSourceType, setRowHeight: SetRowHeightType, setPushProfileOnCellSelected: SetPushProfileOnCellSelectedType, setIndexPathToUserTransformation: SetIndexPathToUserTransformationType) -> ProfileTabSwitcherViewController {
        let tabSwitcher = ProfileTabSwitcherViewController()
        
        tabSwitcher.tutorialsTabSelectedBlock = {
            setDataSource(viewModel.ownGuidesDataSource)
            setRowHeight(Constants.GuidesRowHeight)
            setPushProfileOnCellSelected(false)
        }
        tabSwitcher.likedTabSelectedBlock = {
            setDataSource(viewModel.likedGuidesDataSource)
            setRowHeight(Constants.GuidesRowHeight)
            setPushProfileOnCellSelected(false)
        }
        tabSwitcher.followingTabSelectedBlock = {
            setDataSource(viewModel.followingDataSource)
            setRowHeight(Constants.FollowerRowHeight)
            setPushProfileOnCellSelected(true)
            
            setIndexPathToUserTransformation({ indexPath in
                return viewModel.followingDataSource.tableViewDataSource.objectAtIndexPath(indexPath) as? User
            })
        }
        tabSwitcher.followersTabSelectedBlock = {
            setDataSource(viewModel.followersDataSource)
            setRowHeight(Constants.FollowerRowHeight)
            setPushProfileOnCellSelected(true)
            
            setIndexPathToUserTransformation({ indexPath in
                return viewModel.followersDataSource.tableViewDataSource.objectAtIndexPath(indexPath) as? User
            })
        }
        return tabSwitcher
    }
    
    struct Constants {
        static let FollowerRowHeight: CGFloat = 88.0
        static let GuidesRowHeight = TutorialCellHelper().cellHeightForCurrentScreenWidthWithBottomGapVisible(false)
    }
}
