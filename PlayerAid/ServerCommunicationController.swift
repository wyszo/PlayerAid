import Foundation
import TWCommonLib

struct HTTPStatusCodes {
  static let success = 200
}

enum HTTPMethod: String {
  case GET = "GET"
  case POST = "POST"
  case DELETE = "DELETE"
}

typealias NetworkCompletionBlock = (response: AnyObject?, responseObject: NSURLResponse?, error: NSError?) -> Void

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

  func listTutorialsForUserId(userId: Int, completion: NetworkCompletionBlock) {
    let parameters = [ "fields" : "comments,author.tutorials" ] // shouldn't this be: comments,steps?
    let urlString = "user/\(userId)/tutorials"

    sendNetworkRequest(urlString, httpMethod: .GET, parameters: parameters, completion: networkResponseAsJSONArrayCompletionBlock(completion))
  }

  // MARK: User
  
  func getCurrentUser(completion completion: NetworkCompletionBlock) {
    // GET /user
    let fields = [ "fields" : "tutorials,followers,following" ]
    sendNetworkRequest("user", httpMethod: .GET, parameters: fields, completion: networkResponseAsJSONDictionaryCompletionBlock(completion))
  }
  
  // MARK: (un)liking comments
  
  func likeComment(comment: TutorialComment) {
    // POST /comment/{id}/upvote
    let urlPath = commentRelativePathForCommentWithId(comment.serverID, sufix: "upvote")
    
    sendPostRequest(urlPath, parameters: nil, completion: {
      [weak self] (data, response, error) -> Void in
        self?.handleResponseContainingTutorialComment(data, response: response, error: error)
    })
  }
  
  func unlikeComment(comment: TutorialComment) {
    // DELETE /comment/{id}/upvote
    let urlPath = commentRelativePathForCommentWithId(comment.serverID, sufix: "upvote")
    sendNetworkRequest(urlPath, httpMethod: .DELETE, parameters: nil, completion:self.handleResponseContainingTutorialComment);
  }

  // MARK: Replying and refreshing comment replies

  func replyToComment(comment: TutorialComment, message: String, completion: (success: Bool) -> Void) {
    // POST /comment/{id}/reply
    let urlPath = commentRelativePathForCommentWithId(comment.serverID, sufix: "reply")
    let parameters = [ "message" : message]

    sendPostRequest(urlPath, parameters: parameters) {
      (data, response, error) -> Void in
        let success = (error == nil)
        if let jsonResponse = try? data?.jsonDictionary() {
          TutorialCommentParsingHelper().saveCommentFromDictionary(jsonResponse!)
        }
        completion(success: success)
    }
  }
  
  func refreshCommentAndCommentReplies(comment: TutorialComment, completion: (success: Bool) -> Void) {
    // GET /comment/{id}
    let urlPath = commentRelativePathForCommentWithId(comment.serverID, sufix: nil)
    sendNetworkRequest(urlPath, httpMethod: .GET, parameters: nil, completion: self.handleResponseContainingTutorialComment);
  }
  
  // MARK: Handling comments parsing
  
  private func handleResponseContainingTutorialComment(data: NSData?, response: NSURLResponse?, error: NSError?) {
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
  }
  
  // MARK: Auxiliary path methods
  
  private func commentRelativePathForCommentWithId(commentID: NSNumber, sufix: String?) -> String {
    var path = "comment/" + commentID.stringValue
    if sufix != nil && sufix?.characters.count > 0 {
      path = path + "/" + sufix!
    }
    return path
  }
  
  // MARK: Generic methods
  
  private func sendPostRequest(relativePath: String, parameters: [String : AnyObject]?, completion: (NSData?, NSURLResponse?, NSError?) -> Void) {
    sendNetworkRequest(relativePath, httpMethod: .POST, parameters: parameters, completion: completion)
  }

  private func sendNetworkRequest(relativePath: String, httpMethod: HTTPMethod, parameters: [String : AnyObject]?, completion: (NSData?, NSURLResponse?, NSError?) -> Void) {
    let request = authenticatedRequestWithRelativeServerPathString(relativePath, httpMethod:httpMethod, parameters: parameters)
    let session = NSURLSession.sharedSession()
    let task = session.dataTaskWithRequest(request, completionHandler: completion)
    task.resume()
  }

  private func authenticatedRequestWithRelativeServerPathString(pathString: String, httpMethod: HTTPMethod = .GET, parameters: [String : AnyObject]? = nil) -> NSURLRequest {
    let serverURL = EnvironmentSettings().serverBaseURL() as String
    assert(serverURL.characters.count > 0)

    // TODO: extract adding GET request query parameters from this method
    var pathStringWithQueryParams = pathString
    if httpMethod == .GET {
      if let validParameters = parameters {
        pathStringWithQueryParams = pathString + QueryStringBuilder().queryString(fromDictionary: validParameters)
      }
    }

    let requestURL = NSURL(string: serverURL + pathStringWithQueryParams)
    assert(requestURL != nil)
    
    let request = NSMutableURLRequest(URL: requestURL!)
    request.HTTPMethod = httpMethod.rawValue
    addBearerAuthenticationToMutableRequest(request)

    if let validParameters = parameters {
      if httpMethod == .POST {
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        if let validData = try? validParameters.jsonEncodedData() {
          request.HTTPBody = validData
        }
      }
    }
    return request.copy() as! NSURLRequest
  }
  
  private func addBearerAuthenticationToMutableRequest(mutableRequest: NSMutableURLRequest) {
    assert(self.apiToken?.characters.count > 0)
    let bearer = "Bearer " + apiToken!
    mutableRequest.setValue(bearer, forHTTPHeaderField: "Authorization")
  }
  
  // MARK: Network responses handling
  
  private func networkResponseAsJSONArrayCompletionBlock(completion: NetworkCompletionBlock) -> (NSData?, NSURLResponse?, NSError?) -> Void {
    
    return networkResponseWithTransformationCompletionBlock({ (data) -> AnyObject? in
        return try! data?.jsonArray()
      }, completion: completion)
  }
  
  private func networkResponseAsJSONDictionaryCompletionBlock(completion: NetworkCompletionBlock) -> (NSData?, NSURLResponse?, NSError?) -> Void {
    
    return networkResponseWithTransformationCompletionBlock({ (data) -> AnyObject? in
        return try! data?.jsonDictionary()
      }, completion: completion)
  }
  
  private func networkResponseWithTransformationCompletionBlock(transformation: (NSData?) -> AnyObject?, completion: NetworkCompletionBlock) -> (NSData?, NSURLResponse?, NSError?) -> Void {
    
    return { (data, response, error) -> Void in
      if let transformedData = transformation(data) {
        completion(response: transformedData, responseObject: response, error: error)
      } else {
        assertionFailure("Unexpected response");
        completion(response: nil, responseObject: response, error: error)
      }
    }
  }
}
