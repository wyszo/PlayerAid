import Foundation
import MagicalRecord

final class NewProfileViewModel {
    let user: User
    private let imageDownloader = ImageDownloader()
    
    init() {
        let predicate = NSPredicate(format: "loggedInUser == 1")
        user = User.MR_findFirstWithPredicate(predicate)!
    }
    
    func fetchProfileImage(completion: (UIImage?)->()) {
        imageDownloader.fetchImage(NSURL(string: user.pictureURL)!) { image in
            completion(image)
        }
    }
}
