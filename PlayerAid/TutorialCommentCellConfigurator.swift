import Foundation

@objc
class TutorialCommentCellConfigurator : NSObject {

    var updateCommentsTableViewFooterHeightBlock: (() -> ())?
  
    func configureCell(_ commentCell: TutorialCommentCell, inTableView tableView: UITableView, comment: TutorialComment, allowInlineCommentReplies: Bool) {
      
        commentCell.updateCommentsTableViewFooterHeight = { [weak self] in
          self?.updateCommentsTableViewFooterHeightBlock?()
        };
      
        commentCell.willChangeCellHeightBlock = { [weak self] in
            tableView.beginUpdates()
        }
        commentCell.didChangeCellHeightBlock = {
            tableView.endUpdates()
        }
        commentCell.likeButtonPressedBlock = {
            comment in
            AuthenticatedServerCommunicationController.sharedInstance().serverCommunicationController.likeComment(comment)
        }
        commentCell.unlikeButtonPressedBlock = {
            comment in
            AuthenticatedServerCommunicationController.sharedInstance().serverCommunicationController.unlikeComment(comment)
        }

        commentCell.configureWithTutorialComment(comment, allowInlineCommentReplies: allowInlineCommentReplies)
    }
}