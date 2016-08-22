import Foundation
import MagicalRecord

final class NewProfileViewModel {
    var user: User?
    private let imageDownloader = ImageDownloader()
    
    init() {
        reloadUser()
    }
    
    func fetchProfileImage(completion: (UIImage?)->()) {
        if let pictureURL = user?.pictureURL {
            imageDownloader.fetchImage(NSURL(string: pictureURL)!) { image in
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
