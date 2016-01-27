import Foundation

struct HTTPStatusCodes {
  static let success = 200
}

enum HTTPMethod: String {
  case GET = "GET"
  case POST = "POST"
  case DELETE = "DELETE"
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

  // MARK: Tutorials

  func listTutorialsForUserId(userId: Int, completion: ([AnyObject]?, NSURLResponse?, NSError?) -> Void) {
    let parameters = [ "fields" : "comments,author.tutorials" ]
    let urlString = "user/\(userId)/tutorials"

    // TODO: pass parameters to this method!

    sendNetworkRequest(urlString, httpMethod: .GET, completion: {
      data, response, error -> Void in
        if let jsonResponse = try? data?.jsonArray() { 
          completion(jsonResponse, response, error)
        } else {
          assertionFailure("Unexpected response!")
          completion(nil, response, error)
        }
    });
  }

  // MARK: Comments
  
  func likeComment(comment: TutorialComment) {
    // POST /comment/{id}/upvote
    let urlPath = commentRelativePathForCommentWithId(comment.serverID, sufix: "upvote")
    
    sendPostRequest(urlPath, completion: {
      data, response, error -> Void in
        var statusCode = 0
        if let httpResponse = response as? NSHTTPURLResponse {
          statusCode = httpResponse.statusCode
        }

        if error != nil || statusCode != HTTPStatusCodes.success {
          dispatch_async(dispatch_get_main_queue(), {
            AlertFactory.showGenericErrorAlertViewNoRetry()
          })
        } else {
          if let jsonResponse = try? data?.jsonDictionary() {
            TutorialCommentParsingHelper().saveCommentFromDictionary(jsonResponse!)
          } else {
            assertionFailure("Unexpected response!")
          }
        }
    });
  }
  
  // MARK: Auxiliary path methods
  
  func commentRelativePathForCommentWithId(commentID: NSNumber, sufix: String) -> String {
    return "comment/" + commentID.stringValue + "/" + sufix;
  }
  
  // MARK: Generic methods
  
  func sendPostRequest(relativePath: String, completion: (NSData?, NSURLResponse?, NSError?) -> Void) {
    sendNetworkRequest(relativePath, httpMethod: .POST, completion: completion)
  }

  func sendNetworkRequest(relativePath: String, httpMethod: HTTPMethod, completion: (NSData?, NSURLResponse?, NSError?) -> Void) {
    let request = authenticatedRequestWithRelativeServerPathString(relativePath, httpMethod:httpMethod)
    let session = NSURLSession.sharedSession()
    let task = session.dataTaskWithRequest(request, completionHandler: completion)
    task.resume()
  }

  func authenticatedRequestWithRelativeServerPathString(pathString: String, httpMethod: HTTPMethod = .GET) -> NSURLRequest {
    let serverURL = EnvironmentSettings().serverBaseURL() as String
    assert(serverURL.characters.count > 0)
    
    let requestURL = NSURL(string: serverURL + pathString)
    assert(requestURL != nil)
    
    let request = NSMutableURLRequest(URL: requestURL!)
    request.HTTPMethod = httpMethod.rawValue
    addBearerAuthenticationToMutableRequest(request)

    // TODO: add request parameters - they should be passed as a parameter to this method

    return request.copy() as! NSURLRequest
  }
  
  func addBearerAuthenticationToMutableRequest(mutableRequest: NSMutableURLRequest) {
    assert(self.apiToken?.characters.count > 0)
    let bearer = "Bearer " + apiToken!
    mutableRequest.setValue(bearer, forHTTPHeaderField: "Authorization")
  }
}
