import Foundation
import MagicalRecord

class CommentRepliesViewController : UIViewController {
    
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
    private var repliesTableViewController: RepliesToCommentTableViewController

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
        repliesTableViewController = RepliesToCommentTableViewController()
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

    override func viewDidLoad() {
        super.viewDidLoad()

        assert(self.comment != nil)
        repliesTableViewController.attachToTableView(tableView, withRepliesToComment: self.comment!)
        
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
