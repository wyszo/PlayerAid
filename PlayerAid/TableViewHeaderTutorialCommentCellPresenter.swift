import Foundation
import TWCommonLib

class TableViewHeaderTutorialCommentCellPresenter {
    func installTutorialCommentCell(commentCell: TutorialCommentCell, withTutorialComment comment: TutorialComment, inTableView tableView: UITableView) {
        let screenWidth = UIScreen.tw_width()
        
        commentCell.frame = CGRectMake(0, 0, screenWidth, UIScreen.tw_height())
        tableView.tableHeaderView = commentCell
        /** In general you don't want to hook up UITableViewCell as a tableViewHeader (or anywhere to the view hierarchy really), since it'll can and will be removed from a superview 
            and attached to some tableView without your knowledge. We do this in here only to set it up, it's gonna be swapped with UITableViewCell's content view later in this method
            (which you can attach as a tableViewHeader or as a contentView somewhere as long as UITableViewCell gets discarded immediately and only contentView remains */
      
        commentCell.willChangeCellHeightBlock = { }
        commentCell.didChangeCellHeightBlock = { }
        commentCell.updateCommentsTableViewFooterHeight = { }
      
        commentCell.configureWithTutorialComment(comment, allowInlineCommentReplies: false)
        
        commentCell.replyButtonHidden = true
        commentCell.expandCell() // safe to call it, block callbacks are empty
      
        commentCell.setPreferredCommentLabelMaxLayoutWidth(self.preferredCommentLabelLayoutWidth(forMaxWidth: screenWidth))
        commentCell.layoutIfNeeded()
        
        let compressedSize = commentCell.contentView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize)
        commentCell.frame = CGRectMake(0, 0, UIScreen.tw_width(), compressedSize.height) // not sure if this is correct, since calculated compressed width might be smaller than actual width
        
        commentCell.contentView.frame = commentCell.frame;
        tableView.tableHeaderView = commentCell.contentView // swapping cell with contentView and applying new size
    }
  
    private func preferredCommentLabelLayoutWidth(forMaxWidth maxWidth: CGFloat) -> CGFloat {
        // load view from xib, set desired width, measure commentLabel width applying constraints
        
        guard let cell = UIView.fromNibNamed("TutorialCommentCell") as? TutorialCommentCell else {
            assert(false, "couldn't initialize xib")
            return 0
        }
        
        cell.frame = CGRectMake(0, 0, maxWidth, CGFloat.max);
        cell.layoutIfNeeded()
        return cell.commentLabelWidth
    }
}
