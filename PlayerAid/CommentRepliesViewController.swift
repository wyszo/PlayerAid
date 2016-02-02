import Foundation

class CommentRepliesViewController : UIViewController {

    @IBOutlet weak var tableView: UITableView!
  
    // MARK: Init

    convenience init() {
        self.init(nibName:"CommentRepliesView", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
    }

    override init(nibName: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibName, bundle: nibBundleOrNil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigationBar()
        self.setupHeaderViewCell()
    }

    // MARK: Protected

    func setupNavigationBar() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "<    ", style: .Plain, target: self, action: "backButtonAction")
        self.title = "Reply to Comment"
    }

    func setupHeaderViewCell() {
        // for now just setup an arbitrary view as a tableView header...
        let dummyHeaderView = UIView(frame: CGRectMake(0,0,100,100))
        dummyHeaderView.backgroundColor = UIColor.blueColor()
        self.tableView.tableHeaderView = dummyHeaderView

        // TODO: - put a comment cell there and populate it with comment data...
    }

    func backButtonAction() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
