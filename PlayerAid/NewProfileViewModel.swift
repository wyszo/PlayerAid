import Foundation
import MagicalRecord

final class NewProfileViewModel {
    var user: User?
    private let imageDownloader = ImageDownloader()
    
    var guidesCount: Int {
        return -1; // TODO: update this!!
    }
    
    var likedGuidesCount: Int {
        return self.user?.likes.count ?? 0
    }
    
    var followingCount: Int {
        return self.user?.follows.count ?? 0
    }
    
    var followersCount: Int {
        return self.user?.isFollowedBy.count ?? 0
    }
    
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
