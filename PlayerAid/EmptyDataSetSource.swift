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
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        
        let attributes: [String : AnyObject] = [
            NSFontAttributeName : UIFont(name: "Avenir-Roman", size: 16.0)!,
            NSForegroundColorAttributeName : UIColor.black
        ]
        return NSAttributedString(string: title, attributes: attributes)
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return image
    }
    
    //MARK: delegate 
    
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView!) -> Bool {
        return scrollEnabled
    }
    
    func emptyDataSetDidDisappear(_ scrollView: UIScrollView!) {
        scrollView.isScrollEnabled = scrollEnabled
    }
}
