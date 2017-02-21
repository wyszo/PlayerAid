import UIKit

@objc
class RepliesToCommentTableViewController : NSObject {
    
    fileprivate let cellReuseIdentifier = "commentReplyCell"
    
    // TODO: initialize this from an initializer!!! initWithTableView!!!
    fileprivate var tableView: UITableView?
    fileprivate var comment: TutorialComment?
    fileprivate var fetchLimit: Int?
    
    fileprivate var repliesDataSource: TWCoreDataTableViewDataSource<NSManagedObject>?
    fileprivate var dataSourceConfigurator: CommentsTableViewDataSourceConfigurator?
    fileprivate var repliesFetchedResultsControllerBinder: TWTableViewFetchedResultsControllerBinder?
    fileprivate var cellConfigurator: TutorialCommentCellConfigurator
  
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
  
    func attachToTableView(_ tableView: UITableView, withRepliesToComment comment: TutorialComment, fetchLimit: NSNumber) {
      self.fetchLimit = fetchLimit.intValue
      attachToTableView(tableView, withRepliesToComment: comment)
    }
  
    func attachToTableView(_ tableView: UITableView, withRepliesToComment comment: TutorialComment) {
        self.tableView = tableView
        self.comment = comment
        setupTableView()
        tableView.delegate = self
        setupFetchedResultsControllerBinder()
        setupDataSource()
    }
  
    func fetchedObjects() -> Int {
        return repliesDataSource?.objectCount() ?? 0
    }
}

extension RepliesToCommentTableViewController {
    // MARK: Setup
    
    fileprivate func setupTableView() {
        assert(tableView != nil)
        
        tableView!.registerNib(withName: "TutorialCommentCell", forCellReuseIdentifier: cellReuseIdentifier)
        tableView!.separatorColor = ColorsHelper.commentRepliesSeparatorColor()
        tableView!.rowHeight = UITableViewAutomaticDimension
        tableView!.estimatedRowHeight = 100.0
    }
  
    fileprivate func setupFetchedResultsControllerBinder() {
        repliesFetchedResultsControllerBinder = TWTableViewFetchedResultsControllerBinder(tableView: tableView, configureCellBlock: {
          [weak self] (cell, indexPath) in
          self?.configureCell(cell!, object: nil, indexPath: indexPath!)
          })
        repliesFetchedResultsControllerBinder?.numberOfObjectsChangedBlock = { [weak self] _ -> Void in
          self?.cellConfigurator.updateCommentsTableViewFooterHeightBlock?()
        }
    }
  
    fileprivate func setupDataSource() {
        assert(repliesFetchedResultsControllerBinder != nil)
        assert(comment != nil)
      
        dataSourceConfigurator = CommentsTableViewDataSourceConfigurator(comment: comment!, cellReuseIdentifier: cellReuseIdentifier, fetchLimit:fetchLimit as NSNumber?, fetchedResultsControllerDelegate: repliesFetchedResultsControllerBinder!, configureCellBlock: {
              [weak self] (cell: UITableViewCell, object: AnyObject, indexPath: IndexPath) in
                self?.configureCell(cell, object: object, indexPath: indexPath)
              } as! CellWithObjectAtIndexPathBlock)
        assert(dataSourceConfigurator != nil)
        
        repliesDataSource = dataSourceConfigurator?.dataSource()
        assert(tableView != nil)
        tableView!.dataSource = repliesDataSource
    }
    
    // MARK: Cell configuration
    
    fileprivate func configureCell(_ cell: UITableViewCell, object: AnyObject?, indexPath: IndexPath) {
        assert(cell is TutorialCommentCell);
        
        if let commentCell = cell as? TutorialCommentCell {
            commentCell.replyButtonHidden = true
            commentCell.backgroundColor = ColorsHelper.commentReplyBackgroundColor()
            
            guard let comment = self.repliesDataSource?.object(at: indexPath) as? TutorialComment else {
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
}

extension RepliesToCommentTableViewController: UITableViewDelegate {
  
    @objc internal func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
      if indexPath.row == tableView.indexPathsForVisibleRows?.last?.row {
        DispatchAsyncOnMainThread {
          self.tableViewDidLoadDataBlock?()
        }
      }
    }
}
