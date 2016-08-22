import Foundation
import AFNetworking

final class ImageDownloader {
    
    func fetchImage(url: NSURL, completion: (UIImage?)->()) {
        
        let request = NSURLRequest(URL: url)
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
