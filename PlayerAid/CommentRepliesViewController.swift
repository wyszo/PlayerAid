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
    }

    // MARK: Protected

    func setupNavigationBar() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "<    ", style: .Plain, target: self, action: "backButtonAction")
        self.title = "Reply to Comment"
    }

    func backButtonAction() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
