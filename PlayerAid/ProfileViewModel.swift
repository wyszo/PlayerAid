import Foundation
import MagicalRecord

final class ProfileViewModel: NSObject {
    var user: User?
    fileprivate let imageDownloader = ImageDownloader()
    
    init(user: User? = nil) {
        self.user = user
        super.init()
        
        if user == nil {
            reloadUser()
        }
    }
    
    func fetchProfileImage(_ completion: @escaping (UIImage?)->()) {
      
        if OFFLINE_DEMO_ENVIRONMENT.boolValue {
            let image = UIImage(named: user!.pictureURL!)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
              completion(image)
            })
            return
        }
      
        if let urlString = user?.pictureURL, let pictureURL = URL(string: urlString) {
            imageDownloader.fetchImage(pictureURL) { image in
                completion(image)
            }
        } else {
            completion(nil)
        }
    }
    
    func reloadUser() {
        let predicate = NSPredicate(format: "loggedInUser == 1")
        user = User.mr_findFirst(with: predicate)
    }
}
