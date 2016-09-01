import UIKit
import DZNEmptyDataSet

final class EmptyDataSetSource: NSObject, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    var offset: CGFloat!
    var title: String!
    var image: UIImage!
    var scrollEnabled = false
    
    init(title: String = "", image: UIImage = UIImage(), offset: CGFloat = 0) {
        self.title = title
        self.image = image
        self.offset = offset
    }
    
    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        
        let attributes: [String : AnyObject] = [
            NSFontAttributeName : UIFont(name: "Avenir-Roman", size: 16.0)!,
            NSForegroundColorAttributeName : UIColor.blackColor()
        ]
        return NSAttributedString(string: title, attributes: attributes)
    }
    
    func verticalOffsetForEmptyDataSet(scrollView: UIScrollView!) -> CGFloat {
        return offset
    }
    
    func imageForEmptyDataSet(scrollView: UIScrollView!) -> UIImage! {
        return image
    }
    
    //MARK: delegate 
    
    func emptyDataSetShouldAllowScroll(scrollView: UIScrollView!) -> Bool {
        return scrollEnabled
    }
}
