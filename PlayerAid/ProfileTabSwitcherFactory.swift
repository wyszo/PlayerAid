import Foundation

final class ProfileTabSwitcherFactory {
    typealias VoidBlock = ()->()
    
    func createNewProfileTabSwitcherViewController(viewModel: ProfileTabSwitcherViewModel, guidesTableViewDelegate: GuidesTableViewDelegate, reloadTableView: VoidBlock) -> ProfileTabSwitcherViewController {
        let tabSwitcher = ProfileTabSwitcherViewController()
        
        tabSwitcher.tutorialsTabSelectedBlock = {
            viewModel.ownGuidesDataSource.attachDataSourceAndDelegateToTableView()
            viewModel.ownGuidesDataSource.tutorialTableViewDelegate = guidesTableViewDelegate
            viewModel.setEmptyState("No guides made", imageName: "emptystate-tutorial-ic")
            
            reloadTableView()
        }
        tabSwitcher.likedTabSelectedBlock = {
            viewModel.likedGuidesDataSource.attachDataSourceAndDelegateToTableView()
            viewModel.likedGuidesDataSource.tutorialTableViewDelegate = guidesTableViewDelegate
            viewModel.setEmptyState("No liked guides", imageName: "emptystate-liked-ic")
            
            reloadTableView()
        }
        tabSwitcher.followingTabSelectedBlock = {
            viewModel.followingDataSource.attachDataSourceToTableView()
            viewModel.attachFollowingTableViewDelegate()
            viewModel.setEmptyState("Not following anyone yet", imageName: "emptystate-followers-ic")
            
            reloadTableView()
        }
        tabSwitcher.followersTabSelectedBlock = {
            viewModel.followersDataSource.attachDataSourceToTableView()
            viewModel.attachFollowersTableViewDelegate()
            viewModel.setEmptyState("No followers yet", imageName: "emptystate-followers-ic")
            
            reloadTableView()
        }
        return tabSwitcher
    }
}
