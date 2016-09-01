import UIKit
import DZNEmptyDataSet

final class EmptyDataSetSource: NSObject, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    var title: String!
    var image: UIImage!
    var scrollEnabled = false
    
    init(title: String = "", image: UIImage = UIImage()) {
        self.title = title
        self.image = image
    }
    
    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        
        let attributes: [String : AnyObject] = [
            NSFontAttributeName : UIFont(name: "Avenir-Roman", size: 16.0)!,
            NSForegroundColorAttributeName : UIColor.blackColor()
        ]
        return NSAttributedString(string: title, attributes: attributes)
    }
    
    func imageForEmptyDataSet(scrollView: UIScrollView!) -> UIImage! {
        return image
    }
    
    //MARK: delegate 
    
    func emptyDataSetShouldAllowScroll(scrollView: UIScrollView!) -> Bool {
        return scrollEnabled
    }
    
    func emptyDataSetDidDisappear(scrollView: UIScrollView!) {
        scrollView.scrollEnabled = scrollEnabled
    }
}
