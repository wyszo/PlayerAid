import Foundation

@objc
class CommentsCountLabelFormatter : NSObject {
    var fontSize: Double

    init(fontSize: Double) {
        self.fontSize = fontSize
    }

    func attributedTextForCommentsCount(_ count: Int) -> NSAttributedString? {
        let numberOfComments = self.numberOfCommentsAttributedStringForCount(count)
        let sufix = self.commentsSufixAttributedStringForCount(count)

        let attributedText = NSMutableAttributedString(attributedString:numberOfComments)
        attributedText.append(sufix)
        return attributedText
    }

    // MARK: private

    fileprivate func numberOfCommentsAttributedStringForCount(_ count: Int) -> NSAttributedString {
        var numberOfComments = ""
        if count > 0 { numberOfComments = "\(count) " }

        func boldAttributes(_ fontSize: Double) -> [String : AnyObject] {
            return [ NSFontAttributeName : UIFont.boldSystemFont(ofSize: CGFloat(fontSize)) ]
        }
        return NSAttributedString(string:numberOfComments, attributes:boldAttributes(self.fontSize))
    }

    fileprivate func commentsSufixAttributedStringForCount(_ count: Int) -> NSAttributedString {
        var sufix = ""
        if count != 1 { sufix = "s" }
        return NSAttributedString(string:"Comment\(sufix)")
    }
}
