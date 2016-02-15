import Foundation
import MagicalRecord

class CommentRepliesViewController : UIViewController {

    private let cellReuseIdentifier = "commentReplyCell"

    private var commentCell: TutorialCommentCell
    private var commentID: Int
  
    private var commentObjectFetchHelper: TWSingleCoreDataObjectFetchHelper<TutorialComment>?
    private var comment: TutorialComment?
    {
        get {
            return commentObjectFetchHelper?.managedObject
        }
    }
  
    private var replyToCommentBarVC: MakeCommentInputViewController
    private var replyInputViewHandler: KeyboardCustomAccessoryInputViewHandler?

    private var repliesDataSource: TWCoreDataTableViewDataSource?
    private var dataSourceConfigurator: CommentsTableViewDataSourceConfigurator?
    private var repliesFetchedResultsControllerBinder: TWTableViewFetchedResultsControllerBinder?

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewBottomConstraint: NSLayoutConstraint!

    // MARK: Init

    convenience init(commentID: Int) {
        self.init(nibName:"CommentRepliesView", bundle: nil, commentID: commentID)
    }

    required init?(coder aDecoder: NSCoder!) {
        fatalError("Don't use this initializer")
        return nil
    }
  
    init(nibName: String?, bundle nibBundleOrNil: NSBundle?, commentID: Int) {
        commentCell = UIView.fromNibNamed("TutorialCommentCell") as! TutorialCommentCell
        self.commentID = commentID
        replyToCommentBarVC = MakeCommentInputViewController(user: UsersFetchController.sharedInstance().currentUser())
        super.init(nibName: nibName, bundle: nibBundleOrNil)
      
        commentObjectFetchHelper = TWSingleCoreDataObjectFetchHelper(objectIdPropertyName: "serverID", objectID: commentID, objectChanged: {
          [weak self] in
            self?.setupHeaderViewCell()
        })
        setupReplyToCommentBar()
    }

    func setupReplyToCommentBar() {
        replyInputViewHandler = KeyboardCustomAccessoryInputViewHandler(accessoryKeyboardInputViewController: self.replyToCommentBarVC, initialInputViewHeight: kKeyboardMakeCommentAccessoryInputViewHeight)

        replyToCommentBarVC.setCustomPlaceholder("Reply to comment")
        replyToCommentBarVC.postButtonPressedBlock = {
            [weak self] (text: String, completion: ((success: Bool) -> Void)) in
                if self == nil { return }
                let comment = self?.comment
                assert(comment != nil)

                AuthenticatedServerCommunicationController.sharedInstance().serverCommunicationController.replyToComment(comment!, message: text) {
                    (success: Bool) -> Void in
                        DispatchSyncOnMainThread {
                            if success == false {
                                AlertFactory.showGenericErrorAlertViewNoRetry()
                            }
                            completion(success: success)
                        }
                }
        }
        replyToCommentBarVC.heightDidChange = { [weak self] height in
            self?.tableViewBottomConstraint.constant = height
        }
    }

    func setupTableView() {
        tableView.registerNibWithName("TutorialCommentCell", forCellReuseIdentifier: cellReuseIdentifier)
        tableView.separatorColor = ColorsHelper.commentRepliesSeparatorColor()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100.0
    }

    func setupDataSource() {
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
        tableView.dataSource = repliesDataSource
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupDataSource()
        setupTableView()
        setupNavigationBar()
        setupHeaderViewCell()
        replyInputViewHandler?.slideInputViewIn()
        setInitialTableViewBottomOffset()
        setupFooterViewCompensatingForKeyboardOut()
      
        refreshCommentAndReplies()
    }

    func setInitialTableViewBottomOffset() {
        assert(replyInputViewHandler != nil)
        tableViewBottomConstraint.constant = replyInputViewHandler!.inputViewHeight
    }
  
    func setupFooterViewCompensatingForKeyboardOut() {
        let sampleWidth: CGFloat = 100 // will resize correctly automatically
        let footerView = UIView(frame: CGRectMake(0, 0, sampleWidth, 0))
        footerView.backgroundColor = UIColor.whiteColor()
        tableView.tableFooterView = footerView
        
        assert(replyInputViewHandler != nil);
        replyInputViewHandler!.keyboardDidShowBlock = { [weak self] (keyboardHeight) in
            footerView.frame = CGRectMake(0, 0, sampleWidth, keyboardHeight)
            self?.tableView.tableFooterView = footerView
        }
        replyInputViewHandler?.keyboardWillHideBlock = { [weak self] in
            self?.tableView.tableFooterView?.frame = CGRectMake(0, 0, sampleWidth, 0)
        }
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
            TutorialCommentCellConfigurator().configureCell(commentCell, inTableView: tableView, comment: comment)

            commentCell.didPressUserAvatarOrName = {
                comment in // [weak self]
                    // self.pushUserProfileLinkedToTutorialComment(comment)
            }
        }
    }

    // MARK: Private

    private func refreshCommentAndReplies() {
      assert(self.comment != nil);
      AuthenticatedServerCommunicationController.sharedInstance().serverCommunicationController.refreshCommentAndCommentReplies(self.comment!) {
        (success) -> Void in
        if success == false {
          AlertFactory.showGenericErrorAlertViewNoRetry()
        }
      }
    }
  
    private func setupNavigationBar() {
        let backButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "back_arrow"), style: .Plain, target: self, action: "backButtonAction")
        self.navigationItem.leftBarButtonItem = backButton
        
        self.title = "Reply to Comment"
    }

    private func setupHeaderViewCell() {
        assert(self.comment != nil)
        TableViewHeaderTutorialCommentCellPresenter().installTutorialCommentCell(commentCell, withTutorialComment: self.comment!, inTableView: tableView)
    }

    func backButtonAction() {
        self.replyToCommentBarVC.hideKeyboard()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
