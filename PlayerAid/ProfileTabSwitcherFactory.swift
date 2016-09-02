import Foundation

final class ProfileTabSwitcherFactory {
    typealias VoidBlock = ()->()
    
    func createNewProfileTabSwitcherViewController(viewModel: ProfileTabSwitcherViewModel, guidesTableViewDelegate: GuidesTableViewDelegate, usersTableViewDelegate: UsersTableViewDelegate, reloadTableView: VoidBlock) -> ProfileTabSwitcherViewController {
        let tabSwitcher = ProfileTabSwitcherViewController()
        
        tabSwitcher.tutorialsTabSelectedBlock = {
            self.disableAllDataSources(viewModel)
        
            viewModel.ownGuidesDataSource.attachDataSourceAndDelegateToTableView()
            viewModel.ownGuidesDataSource.tutorialTableViewDelegate = guidesTableViewDelegate
            viewModel.setEmptyState("No guides made", imageName: "emptystate-tutorial-ic")
            
            reloadTableView()
        }
        tabSwitcher.likedTabSelectedBlock = {
            self.disableAllDataSources(viewModel)
            
            viewModel.likedGuidesDataSource.attachDataSourceAndDelegateToTableView()
            viewModel.likedGuidesDataSource.tutorialTableViewDelegate = guidesTableViewDelegate
            viewModel.setEmptyState("No liked guides", imageName: "emptystate-liked-ic")
            
            reloadTableView()
        }
        tabSwitcher.followingTabSelectedBlock = {
            self.disableAllDataSources(viewModel)
            
            viewModel.followingDataSource.attachDataSourceToTableView()
            viewModel.attachFollowingTableViewDelegate()
            viewModel.followingDataSource.usersTableViewDelegate = usersTableViewDelegate
            viewModel.setEmptyState("Not following anyone yet", imageName: "emptystate-followers-ic")
            
            reloadTableView()
        }
        tabSwitcher.followersTabSelectedBlock = {
            self.disableAllDataSources(viewModel)
            
            viewModel.followersDataSource.attachDataSourceToTableView()
            viewModel.attachFollowersTableViewDelegate()
            viewModel.followersDataSource.usersTableViewDelegate = usersTableViewDelegate
            viewModel.setEmptyState("No followers yet", imageName: "emptystate-followers-ic")
            
            reloadTableView()
        }
        return tabSwitcher
    }
    
    func disableAllDataSources(viewModel: ProfileTabSwitcherViewModel) {
        viewModel.ownGuidesDataSource.detachFromTableView()
        viewModel.likedGuidesDataSource.detachFromTableView()
        viewModel.followingDataSource.detachFromTableView()
        viewModel.followersDataSource.detachFromTableView()
    }
}
