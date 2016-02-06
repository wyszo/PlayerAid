import Foundation

class CommentRepliesViewController : UIViewController {

    private var comment: TutorialComment
    private var commentCell: TutorialCommentCell
    private var replyToCommentBarVC: MakeCommentInputViewController
    private var replyInputViewHandler: KeyboardCustomAccessoryInputViewHandler

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
        replyInputViewHandler = KeyboardCustomAccessoryInputViewHandler(accessoryKeyboardInputViewController: replyToCommentBarVC, desiredInputViewHeight: 200) // TODO: set real desired height!
        super.init(nibName: nibName, bundle: nibBundleOrNil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupHeaderViewCell()

        DispatchAfter(2.0) {
            self.replyInputViewHandler.slideInputViewIn()
        }
    }

    // MARK: Private

    private func setupNavigationBar() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "<    ", style: .Plain, target: self, action: "backButtonAction")
        self.title = "Reply to Comment"
    }

    private func setupHeaderViewCell() {
        TableViewHeaderTutorialCommentCellPresenter().installTutorialCommentCell(commentCell, withTutorialComment: comment, inTableView: tableView)
    }

    private func backButtonAction() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
