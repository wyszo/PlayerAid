import DZNEmptyDataSet

final class EmptyDataSetSource: NSObject, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    var offset: CGFloat!
    var title: String!
    var image: UIImage!
    
    init(title: String = "", image: UIImage = UIImage(), offset: CGFloat = 0) {
        self.title = title
        self.image = image
        self.offset = offset
    }
    
    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string: title)
    }
    
    func verticalOffsetForEmptyDataSet(scrollView: UIScrollView!) -> CGFloat {
        return offset
    }
    
    func imageForEmptyDataSet(scrollView: UIScrollView!) -> UIImage! {
        return image
    }
}
