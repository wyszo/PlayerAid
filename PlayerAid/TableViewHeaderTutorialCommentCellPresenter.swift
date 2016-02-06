import Foundation
import TWCommonLib

class TableViewHeaderTutorialCommentCellPresenter {
    func installTutorialCommentCell(commentCell: TutorialCommentCell, withTutorialComment comment: TutorialComment, inTableView tableView: UITableView) {
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
}
