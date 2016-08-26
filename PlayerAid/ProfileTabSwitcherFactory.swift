import Foundation
import MGSpotyViewController

final class ProfileTabSwitcherFactory {
    typealias SetDataSourceType = (MGSpotyViewControllerDataSource)->()
    typealias SetRowHeightType = (CGFloat)->()
    typealias PushUserProfileType = (User)->()
    typealias SetPushProfileOnCellSelectedType = (Bool)->()
    typealias IndexPathCallback = (NSIndexPath)->()
    typealias SetDeleteCellAtIndexPathType = (IndexPathCallback?->())
    
    typealias IndexPathToUserType = (NSIndexPath)->(User?)
    typealias SetIndexPathToUserTransformationType = (IndexPathToUserType -> ())
    typealias IndexPathToGuideType = (NSIndexPath)->(Tutorial?)
    typealias SetIndexPathToGuideTransformationType = (IndexPathToGuideType -> ())
    
    func createNewProfileTabSwitcherViewController(viewModel: ProfileTabSwitcherViewModel, setDataSource: SetDataSourceType, setRowHeight: SetRowHeightType, setPushProfileOnCellSelected: SetPushProfileOnCellSelectedType, setDeleteCellAtIndexPath: SetDeleteCellAtIndexPathType, setIndexPathToUserTransformation: SetIndexPathToUserTransformationType, setIndexPathToGuideTransformation: SetIndexPathToGuideTransformationType) -> ProfileTabSwitcherViewController {
        let tabSwitcher = ProfileTabSwitcherViewController()
        
        tabSwitcher.tutorialsTabSelectedBlock = {
            setDataSource(viewModel.ownGuidesDataSource)
            setRowHeight(Constants.GuidesRowHeight)
            setPushProfileOnCellSelected(false)
            
            setDeleteCellAtIndexPath({ indexPath in
                viewModel.ownGuidesDataSource.tableViewDataSource.deleteGuideAtIndexPath(indexPath)
            })
            
            setIndexPathToGuideTransformation({ indexPath in
                return viewModel.ownGuidesDataSource.tableViewDataSource.tutorialAtIndexPath(indexPath)
            })
        }
        tabSwitcher.likedTabSelectedBlock = {
            setDataSource(viewModel.likedGuidesDataSource)
            setRowHeight(Constants.GuidesRowHeight)
            setPushProfileOnCellSelected(false)
            setDeleteCellAtIndexPath(nil)
            
            setIndexPathToGuideTransformation({ indexPath in
                return viewModel.likedGuidesDataSource.tableViewDataSource.tutorialAtIndexPath(indexPath)
            })
        }
        tabSwitcher.followingTabSelectedBlock = {
            setDataSource(viewModel.followingDataSource)
            setRowHeight(Constants.FollowerRowHeight)
            setPushProfileOnCellSelected(true)
            setDeleteCellAtIndexPath(nil)
            
            setIndexPathToUserTransformation({ indexPath in
                return viewModel.followingDataSource.tableViewDataSource.objectAtIndexPath(indexPath) as? User
            })
        }
        tabSwitcher.followersTabSelectedBlock = {
            setDataSource(viewModel.followersDataSource)
            setRowHeight(Constants.FollowerRowHeight)
            setPushProfileOnCellSelected(true)
            setDeleteCellAtIndexPath(nil)
            
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
