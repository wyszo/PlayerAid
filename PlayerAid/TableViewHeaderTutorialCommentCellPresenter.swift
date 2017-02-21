import Foundation
import TWCommonLib

class TableViewHeaderTutorialCommentCellPresenter {
    func installTutorialCommentCell(_ commentCell: TutorialCommentCell, withTutorialComment comment: TutorialComment, inTableView tableView: UITableView) {
        let screenWidth = UIScreen.tw_width()
        
        commentCell.frame = CGRect(x: 0, y: 0, width: screenWidth, height: UIScreen.tw_height())
        tableView.tableHeaderView = commentCell
        /** In general you don't want to hook up UITableViewCell as a tableViewHeader (or anywhere to the view hierarchy really), since it'll can and will be removed from a superview 
            and attached to some tableView without your knowledge. We do this in here only to set it up, it's gonna be swapped with UITableViewCell's content view later in this method
            (which you can attach as a tableViewHeader or as a contentView somewhere as long as UITableViewCell gets discarded immediately and only contentView remains */
      
        commentCell.willChangeCellHeightBlock = { }
        commentCell.didChangeCellHeightBlock = { }
        commentCell.updateCommentsTableViewFooterHeight = { }
      
        commentCell.configure(with: comment, allowInlineCommentReplies: false)
        
        commentCell.replyButtonHidden = true
        commentCell.expand() // safe to call it, block callbacks are empty
      
        commentCell.setPreferredCommentLabelMaxLayoutWidth(self.preferredCommentLabelLayoutWidth(forMaxWidth: screenWidth))
        commentCell.layoutIfNeeded()
        
        let compressedSize = commentCell.contentView.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
        commentCell.frame = CGRect(x: 0, y: 0, width: UIScreen.tw_width(), height: ceil(compressedSize.height)) // not sure if this is correct, since calculated compressed width might be smaller than actual width
        
        commentCell.contentView.frame = commentCell.frame;
        tableView.tableHeaderView = commentCell.contentView // swapping cell with contentView and applying new size
    }
  
    fileprivate func preferredCommentLabelLayoutWidth(forMaxWidth maxWidth: CGFloat) -> CGFloat {
        // load view from xib, set desired width, measure commentLabel width applying constraints
        
        guard let cell = UIView.fromNibNamed("TutorialCommentCell") as? TutorialCommentCell else {
            assert(false, "couldn't initialize xib")
            return 0
        }
        
        cell.frame = CGRect(x: 0, y: 0, width: maxWidth, height: CGFloat.greatestFiniteMagnitude);
        cell.layoutIfNeeded()
        return cell.commentLabelWidth
    }
}
