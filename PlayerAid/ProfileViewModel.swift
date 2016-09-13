import Foundation
import MagicalRecord

final class ProfileViewModel: NSObject {
    var user: User?
    private let imageDownloader = ImageDownloader()
    
    init(user: User? = nil) {
        self.user = user
        super.init()
        
        if user == nil {
            reloadUser()
        }
    }
    
    func fetchProfileImage(completion: (UIImage?)->()) {
        if let urlString = user?.pictureURL, pictureURL = NSURL(string: urlString) {
            imageDownloader.fetchImage(pictureURL) { image in
                completion(image)
            }
        } else {
            completion(nil)
        }
    }
    
    func reloadUser() {
        let predicate = NSPredicate(format: "loggedInUser == 1")
        user = User.MR_findFirstWithPredicate(predicate)
    }
}
