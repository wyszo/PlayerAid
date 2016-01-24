import Foundation

@objc
class CommentsCountLabelFormatter : NSObject {
    var fontSize: Double

    init(fontSize: Double) {
        self.fontSize = fontSize
    }

    public func attributedTextForCommentsCount(count: Int) -> NSAttributedString? {
        let numberOfComments = self.numberOfCommentsAttributedStringForCount(count)
        let sufix = self.commentsSufixAttributedStringForCount(count)

        let attributedText = NSMutableAttributedString(attributedString:numberOfComments)
        attributedText.appendAttributedString(sufix)
        return attributedText
    }

    // MARK: internal

    func numberOfCommentsAttributedStringForCount(count: Int) -> NSAttributedString {
        var numberOfComments = ""
        if count > 0 { numberOfComments = "\(count) " }

        func boldAttributes(fontSize: Double) -> [String : AnyObject] {
            return [ NSFontAttributeName : UIFont.boldSystemFontOfSize(CGFloat(fontSize)) ]
        }
        return NSAttributedString(string:numberOfComments, attributes:boldAttributes(self.fontSize))
    }

    func commentsSufixAttributedStringForCount(count: Int) -> NSAttributedString {
        var sufix = ""
        if count != 1 { sufix = "s" }
        return NSAttributedString(string:"Comment\(sufix)")
    }
}
