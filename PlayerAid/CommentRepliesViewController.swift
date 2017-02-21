import Foundation
import MagicalRecord

class CommentRepliesViewController : UIViewController {
    
    fileprivate var commentCell: TutorialCommentCell
    fileprivate var commentID: Int
  
    fileprivate var commentObjectFetchHelper: TWSingleCoreDataObjectFetchHelper<TutorialComment>?
    fileprivate var comment: TutorialComment?
    {
        get {
            return commentObjectFetchHelper?.managedObject
        }
    }
  
    fileprivate var replyToCommentBarVC: MakeCommentInputViewController
    fileprivate var replyInputViewHandler: KeyboardCustomAccessoryInputViewHandler?
    fileprivate var repliesTableViewController: RepliesToCommentTableViewController

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
  
    init(nibName: String?, bundle nibBundleOrNil: Bundle?, commentID: Int) {
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
            [weak self] (text: String, completion: @escaping ((_ success: Bool) -> Void)) in
                if self == nil { return }
                let comment = self?.comment
                assert(comment != nil)

                AuthenticatedServerCommunicationController.sharedInstance().serverCommunicationController.replyToComment(comment!, message: text) {
                    (success: Bool) -> Void in
                        DispatchSyncOnMainThread {
                            if success == false {
                                AlertFactory.showGenericErrorAlertViewNoRetry()
                            }
                            completion(success)
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
    }

    func setInitialTableViewBottomOffset() {
        assert(replyInputViewHandler != nil)
        tableViewBottomConstraint.constant = replyInputViewHandler!.inputViewHeight
    }
  
    func setupFooterViewCompensatingForKeyboardOut() {
        let sampleWidth: CGFloat = 100 // will resize correctly automatically
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: sampleWidth, height: 0))
        footerView.backgroundColor = UIColor.white
        tableView.tableFooterView = footerView
        
        assert(replyInputViewHandler != nil);
        replyInputViewHandler!.keyboardDidShowBlock = { [weak self] (keyboardHeight) in
            footerView.frame = CGRect(x: 0, y: 0, width: sampleWidth, height: keyboardHeight)
            self?.tableView.tableFooterView = footerView
        }
        replyInputViewHandler?.keyboardWillHideBlock = { [weak self] in
            self?.tableView.tableFooterView?.frame = CGRect(x: 0, y: 0, width: sampleWidth, height: 0)
        }
    }
    
    // MARK: Private
    
    fileprivate func setupNavigationBar() {
        let backButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "back_arrow"), style: .plain, target: self, action: #selector(CommentRepliesViewController.backButtonAction))
        self.navigationItem.leftBarButtonItem = backButton
        
        self.title = "Reply to Comment"
    }

    fileprivate func setupHeaderViewCell() {
        assert(self.comment != nil)
        TableViewHeaderTutorialCommentCellPresenter().installTutorialCommentCell(commentCell, withTutorialComment: self.comment!, inTableView: tableView)
    }

    func backButtonAction() {
        self.replyToCommentBarVC.hideKeyboard()
        self.dismiss(animated: true, completion: nil)
    }
}
