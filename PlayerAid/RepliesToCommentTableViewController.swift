import UIKit

@objc
class RepliesToCommentTableViewController : NSObject, UITableViewDelegate {
    
    private let cellReuseIdentifier = "commentReplyCell"
    
    // TODO: initialize this from an initializer!!! initWithTableView!!!
    private var tableView: UITableView?
    private var comment: TutorialComment?
    private var fetchLimit: Int?
    
    private var repliesDataSource: TWCoreDataTableViewDataSource?
    private var dataSourceConfigurator: CommentsTableViewDataSourceConfigurator?
    private var repliesFetchedResultsControllerBinder: TWTableViewFetchedResultsControllerBinder?
    private var cellConfigurator: TutorialCommentCellConfigurator
  
    var tableViewDidLoadDataBlock: (()->())?
  
    var replyCellDidResizeBlock: (()->())?
    {
      didSet {
        cellConfigurator.updateCommentsTableViewFooterHeightBlock = replyCellDidResizeBlock
      }
    }
  
    override init() {
      cellConfigurator = TutorialCommentCellConfigurator()
      super.init()
    }
  
    // MARK: Public
  
    func attachToTableView(tableView: UITableView, withRepliesToComment comment: TutorialComment, fetchLimit: NSNumber) {
      self.fetchLimit = fetchLimit.integerValue
      attachToTableView(tableView, withRepliesToComment: comment)
    }
  
    func attachToTableView(tableView: UITableView, withRepliesToComment comment: TutorialComment) {
        self.tableView = tableView
        self.comment = comment
        setupTableView()
        setupDataSource()
        tableView.delegate = self
    }
  
    func fetchedObjects() -> Int {
        return repliesDataSource?.objectCount() ?? 0
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
      
        dataSourceConfigurator = CommentsTableViewDataSourceConfigurator(comment: comment!, cellReuseIdentifier: cellReuseIdentifier, fetchLimit:fetchLimit, fetchedResultsControllerDelegate: repliesFetchedResultsControllerBinder!, configureCellBlock: {
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
            cellConfigurator.configureCell(commentCell, inTableView: tableView!, comment: comment, allowInlineCommentReplies: false)
            
            commentCell.didPressUserAvatarOrName = {
                comment in // [weak self]
                // self.pushUserProfileLinkedToTutorialComment(comment)
            }
        }
    }
  
    // MARK: TableView Delegate
    
    @objc internal func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
      if indexPath.row == tableView.indexPathsForVisibleRows?.last!.row {
        DispatchAsyncOnMainThread {
          assert(self.tableViewDidLoadDataBlock != nil)
          self.tableViewDidLoadDataBlock!()
        }
      }
    }
}