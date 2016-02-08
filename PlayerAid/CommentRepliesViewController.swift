import Foundation

class CommentRepliesViewController : UIViewController {

    private var comment: TutorialComment
    private var commentCell: TutorialCommentCell
    private var replyToCommentBarVC: MakeCommentInputViewController
    private var replyInputViewHandler: KeyboardCustomAccessoryInputViewHandler?

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
        setupReplyInputViewHandler()
    }

    func setupReplyInputViewHandler() {
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

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        setupHeaderViewCell()
        self.replyInputViewHandler?.slideInputViewIn()
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
