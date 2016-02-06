import Foundation
import TWCommonLib

class CommentRepliesViewController : UIViewController {

    var comment: TutorialComment
    var commentCell: TutorialCommentCell

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
        super.init(nibName: nibName, bundle: nibBundleOrNil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupHeaderViewCell()
    }

    // MARK: Protected

    func setupNavigationBar() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "<    ", style: .Plain, target: self, action: "backButtonAction")
        self.title = "Reply to Comment"
    }

    func setupHeaderViewCell() {
        commentCell.frame = CGRectMake(0, 0, UIScreen.tw_width(), UIScreen.tw_height())
        tableView.tableHeaderView = commentCell
        commentCell.configureWithTutorialComment(comment)
        commentCell.replyButtonHidden = true

        commentCell.willChangeCellHeightBlock = { }
        commentCell.didChangeCellHeightBlock = { }
        commentCell.expandCell()

        let compressedSize = commentCell.contentView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize)
        commentCell.frame = CGRectMake(0, 0, UIScreen.tw_width(), compressedSize.height) // not sure if this is correct, since calculated compressed width might be smaller than actual width

        tableView.tableHeaderView = commentCell // required to adjust to new size
    }

    func backButtonAction() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
