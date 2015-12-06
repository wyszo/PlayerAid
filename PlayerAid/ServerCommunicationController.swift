//  PlayerAid

import Foundation

struct HTTPStatusCodes {
  static let success = 200
}

struct HTTPMethods {
  static let GET = "GET"
  static let POST = "POST"
  static let DELETE = "DELETE"
}

/**
 This class replaces AuthenticatedServerCommunicationController as is intended to be further extended. Implement new network requests here.
 */
class ServerCommunicationController : NSObject {
  
  private var apiToken: String? 
  
  func setApiToken(apiToken: String) {
    assert(apiToken.characters.count > 0); // TODO: figure out how to have assertOrReturn in Swift
    self.apiToken = apiToken;
  }
  
  // MARK: Comments
  
  func likeComment(comment: TutorialComment) {
    // POST /comment/{id}/upvote
    let urlPath = commentRelativePathForCommentWithId(comment.serverID, sufix: "upvote")
    
    sendPostRequest(urlPath, completion: {data, response, error -> Void in
      var statusCode = 0
      if let httpResponse = response as? NSHTTPURLResponse {
        statusCode = httpResponse.statusCode
      }
      
      if error != nil || statusCode != HTTPStatusCodes.success {
        dispatch_async(dispatch_get_main_queue(), {
          AlertFactory.showGenericErrorAlertViewNoRetry()
        })
      } else {
        // TODO: increase likes count
      }
    });
  }
  
  // MARK: Auxiliary path methods
  
  func commentRelativePathForCommentWithId(commentID: NSNumber, sufix: String) -> String {
    return "comment/" + commentID.stringValue + "/" + sufix;
  }
  
  // MARK: Generic methods
  
  func sendPostRequest(relativePath: String, completion: (NSData?, NSURLResponse?, NSError?) -> Void) {
    let request = authenticatedRequestWithRelativeServerPathString(relativePath, httpMethod: HTTPMethods.POST)
    
    let session = NSURLSession.sharedSession()
    let task = session.dataTaskWithRequest(request, completionHandler: completion)
    task.resume()
  }
  
  func authenticatedRequestWithRelativeServerPathString(pathString: String, httpMethod: String = HTTPMethods.GET) -> NSURLRequest {
    let serverURL = EnvironmentSettings().serverBaseURL() as String
    assert(serverURL.characters.count > 0)
    
    let requestURL = NSURL(string: serverURL + pathString)
    assert(requestURL != nil)
    
    let request = NSMutableURLRequest(URL: requestURL!)
    request.HTTPMethod = httpMethod
    addBearerAuthenticationToMutableRequest(request)
    
    return request.copy() as! NSURLRequest
  }
  
  func addBearerAuthenticationToMutableRequest(mutableRequest: NSMutableURLRequest) {
    assert(self.apiToken?.characters.count > 0)
    let bearer = "Bearer " + apiToken!
    mutableRequest.setValue(bearer, forHTTPHeaderField: "Authorization")
  }
}
