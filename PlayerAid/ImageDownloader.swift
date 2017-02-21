import Foundation
import AFNetworking

final class ImageDownloader {
    
    func fetchImage(_ url: URL, completion: @escaping (UIImage?)->()) {
        
        let request = URLRequest(url: url)
        let requestOperation = AFHTTPRequestOperation(request: request)
        requestOperation.responseSerializer = AFImageResponseSerializer()
        
        requestOperation.setCompletionBlockWithSuccess({ (operation, responseObject) in
            let image = responseObject as? UIImage
            assert(image != nil)
            completion(image)
            }, failure: { (operation, error) in
                assertionFailure("image download failed")
                completion(nil)
        })
        requestOperation.start()
    }
}
