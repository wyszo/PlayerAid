import Foundation

final class ProfileTabSwitcherFactory {
    typealias VoidBlock = ()->()
    
    func createNewProfileTabSwitcherViewController(viewModel: ProfileTabSwitcherViewModel, guidesTableViewDelegate: GuidesTableViewDelegate, reloadTableView: VoidBlock) -> ProfileTabSwitcherViewController {
        let tabSwitcher = ProfileTabSwitcherViewController()
        
        tabSwitcher.tutorialsTabSelectedBlock = {
            viewModel.ownGuidesDataSource.attachDataSourceAndDelegateToTableView()
            viewModel.ownGuidesDataSource.tutorialTableViewDelegate = guidesTableViewDelegate
            
            reloadTableView()
        }
        tabSwitcher.likedTabSelectedBlock = {
            viewModel.likedGuidesDataSource.attachDataSourceAndDelegateToTableView()
            viewModel.likedGuidesDataSource.tutorialTableViewDelegate = guidesTableViewDelegate
            
            reloadTableView()
        }
        tabSwitcher.followingTabSelectedBlock = {
            viewModel.followingDataSource.attachDataSourceToTableView()
            viewModel.attachFollowingTableViewDelegate()
            
            reloadTableView()
        }
        tabSwitcher.followersTabSelectedBlock = {
            viewModel.followersDataSource.attachDataSourceToTableView()
            viewModel.attachFollowersTableViewDelegate()
            
            reloadTableView()
        }
        return tabSwitcher
    }
}
