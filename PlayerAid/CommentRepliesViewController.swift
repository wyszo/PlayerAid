import Foundation

class CommentRepliesViewController : UIViewController {

    private var comment: TutorialComment
    private var commentCell: TutorialCommentCell

    private var replyToCommentBarVC: MakeCommentInputViewController
    private var replyInputViewHandler: KeyboardCustomAccessoryInputViewHandler?

    private var repliesDataSource: TWCoreDataTableViewDataSource?
    private var dataSourceConfigurator: CommentsTableViewDataSourceConfigurator?
    private var repliesFetchedResultsControllerBinder: TWTableViewFetchedResultsControllerBinder?

    @IBOutlet weak var tableView: UITableView!

    // MARK: Init

    convenience init(tutorialComment: TutorialComment) {
        self.init(nibName:"CommentRepliesView", bundle: nil, comment: tutorialComment)
    }

    required init?(coder aDecoder: NSCoder!) {
        fatalError("Don't use this initializer")
        return nil
    }

    init(nibName: String?, bundle nibBundleOrNil: NSBundle?, comment tutorialComment: TutorialComment) {
        commentCell = UIView.fromNibNamed("TutorialCommentCell") as! TutorialCommentCell
        comment = tutorialComment
        replyToCommentBarVC = MakeCommentInputViewController(user: UsersFetchController.sharedInstance().currentUser())
        super.init(nibName: nibName, bundle: nibBundleOrNil)
        setupTableViewCells();
        setupReplyToCommentBar()
    }

    func setupReplyToCommentBar() {
        replyInputViewHandler = KeyboardCustomAccessoryInputViewHandler(accessoryKeyboardInputViewController: self.replyToCommentBarVC, desiredInputViewHeight: kKeyboardMakeCommentAccessoryInputViewHeight)

        replyToCommentBarVC.setCustomPlaceholder("Reply to comment")
        replyToCommentBarVC.postButtonPressedBlock = {
            [weak self] (text: String, completion: ((success: Bool) -> Void)) in
                if self == nil { return }

                AuthenticatedServerCommunicationController.sharedInstance().serverCommunicationController.replyToComment(self!.comment, message: text) {
                    (success: Bool) -> Void in
                        DispatchSyncOnMainThread {
                            if success == false {
                                AlertFactory.showGenericErrorAlertViewNoRetry()
                            }
                            completion(success: success)
                        }
                }
        }
    }

    func setupTableViewCells() {
        let cellReuseIdentifier = "commentReplyCell"
        tableView.registerNibWithName("TutorialCommentCell", forCellReuseIdentifier: cellReuseIdentifier)
    }

    func setupDataSource() {
        repliesFetchedResultsControllerBinder = TWTableViewFetchedResultsControllerBinder(tableView: tableView, configureCellBlock: {
            [weak self] (cell, indexPath) in
                self?.configureCell(cell, object: nil, indexPath: indexPath)
        })
        assert(repliesFetchedResultsControllerBinder != nil, "initialisation failed")

        dataSourceConfigurator = CommentsTableViewDataSourceConfigurator(comment: comment, cellReuseIdentifier: cellReuseIdentifier, fetchedResultsControllerDelegate: repliesFetchedResultsControllerBinder!, configureCellBlock: {
            [weak self] (cell, object, indexPath) in
                self?.configureCell(cell, object: object, indexPath: indexPath)
        })
        assert(dataSourceConfigurator != nil, "initialisation failed")

        repliesDataSource = dataSourceConfigurator?.dataSource()
        tableView.dataSource = repliesDataSource
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupDataSource()
        setupNavigationBar()
        setupHeaderViewCell()
        self.replyInputViewHandler?.slideInputViewIn()
    }

    // MARK: Cell configuration

    private func configureCell(cell: UITableViewCell, object: AnyObject?, indexPath: NSIndexPath) {
        // TODO: implement this!
    }

    // MARK: Private

    private func setupNavigationBar() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "<    ", style: .Plain, target: self, action: "backButtonAction")
        self.title = "Reply to Comment"
    }

    private func setupHeaderViewCell() {
        TableViewHeaderTutorialCommentCellPresenter().installTutorialCommentCell(commentCell, withTutorialComment: comment, inTableView: tableView)
    }

    func backButtonAction() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
