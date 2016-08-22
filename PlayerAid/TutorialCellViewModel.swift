import Foundation
import DateTools

final class TutorialCellViewModel: NSObject {
    let cellOverlayAlpha: CGFloat
    let cellOverlayBackground: UIColor
    let cellOverlayLabelBackground: UIColor
    let cellOverlayLabelText: String
    let overlayHidden: Bool
    
    let timeAgo: String
    
    init(tutorial: Tutorial) {
        overlayHidden = tutorial.isPublished
        
        if tutorial.primitiveDraftValue() {
            cellOverlayLabelText = "Draft"
            cellOverlayLabelBackground = ColorsHelper.tutorialCellDraftTextBackgroundColor()
            cellOverlayBackground = ColorsHelper.tutorialCellDraftOverlayBackgroundColor()
            cellOverlayAlpha = 0.6
        } else if tutorial.primitiveInReviewValue() {
            cellOverlayLabelText = "In Review";
            cellOverlayLabelBackground = ColorsHelper.tutorialCellInReviewTextBackgroundColor()
            cellOverlayBackground = ColorsHelper.tutorialCellInReviewOverlayBackgroundColor()
            cellOverlayAlpha = 0.6;
        } else {
            cellOverlayAlpha = 1.0
            cellOverlayLabelText = ""
            cellOverlayBackground = UIColor.whiteColor()
            cellOverlayLabelBackground = UIColor.whiteColor()
        }
        
        timeAgo = tutorial.createdAt.shortTimeAgoSinceNow()
    }
}
