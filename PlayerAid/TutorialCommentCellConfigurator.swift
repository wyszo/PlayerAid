import Foundation

@objc
class TutorialCommentCellConfigurator : NSObject {

    func configureCell(_ commentCell: TutorialCommentCell, inTableView tableView: UITableView, comment: TutorialComment) {

        commentCell.willChangeCellHeightBlock = {
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

        commentCell.configureWithTutorialComment(comment)
    }
}