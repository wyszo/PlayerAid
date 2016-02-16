import UIKit

@objc
class RepliesToCommentTableViewController : NSObject {
    
    private let cellReuseIdentifier = "commentReplyCell"
    
    // TODO: initialize this from an initializer!!! initWithTableView!!!
    private var tableView: UITableView? // Todo: private, !
    private var comment: TutorialComment?
    
    private var repliesDataSource: TWCoreDataTableViewDataSource?
    private var dataSourceConfigurator: CommentsTableViewDataSourceConfigurator?
    private var repliesFetchedResultsControllerBinder: TWTableViewFetchedResultsControllerBinder?
    
    // MARK: Public
    
    func attachToTableView(tableView: UITableView, withRepliesToComment comment: TutorialComment) {
        self.tableView = tableView
        self.comment = comment
        setupTableView()
        setupDataSource()
    }
    
    // MARK: Setup
    
    private func setupTableView() {
        assert(tableView != nil)
        
        tableView!.registerNibWithName("TutorialCommentCell", forCellReuseIdentifier: cellReuseIdentifier)
        tableView!.separatorColor = ColorsHelper.commentRepliesSeparatorColor()
        tableView!.rowHeight = UITableViewAutomaticDimension
        tableView!.estimatedRowHeight = 100.0
    }
    
    private func setupDataSource() {
        repliesFetchedResultsControllerBinder = TWTableViewFetchedResultsControllerBinder(tableView: tableView, configureCellBlock: {
            [weak self] (cell, indexPath) in
            self?.configureCell(cell, object: nil, indexPath: indexPath)
            })
        assert(repliesFetchedResultsControllerBinder != nil)
        assert(comment != nil)
        
        dataSourceConfigurator = CommentsTableViewDataSourceConfigurator(comment: comment!, cellReuseIdentifier: cellReuseIdentifier, fetchedResultsControllerDelegate: repliesFetchedResultsControllerBinder!, configureCellBlock: {
            [weak self] (cell, object, indexPath) in
            self?.configureCell(cell, object: object, indexPath: indexPath)
            })
        assert(dataSourceConfigurator != nil)
        
        repliesDataSource = dataSourceConfigurator?.dataSource()
        assert(tableView != nil)
        tableView!.dataSource = repliesDataSource
    }
    
    // MARK: Cell configuration
    
    private func configureCell(cell: UITableViewCell, object: AnyObject?, indexPath: NSIndexPath) {
        assert(cell is TutorialCommentCell);
        
        if let commentCell = cell as? TutorialCommentCell {
            commentCell.replyButtonHidden = true
            commentCell.backgroundColor = ColorsHelper.commentReplyBackgroundColor()
            
            guard let comment = self.repliesDataSource?.objectAtIndexPath(indexPath) as? TutorialComment else {
                assert(false, "internal error")
                return
            }
            assert(tableView != nil)
            
            // Inline comments always disabled - we don't want Replies inside replies!
            TutorialCommentCellConfigurator().configureCell(commentCell, inTableView: tableView!, comment: comment, allowInlineCommentReplies: false)
            
            commentCell.didPressUserAvatarOrName = {
                comment in // [weak self]
                // self.pushUserProfileLinkedToTutorialComment(comment)
            }
        }
    }
    
}