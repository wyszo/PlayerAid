//  PlayerAid

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

  // TODO: we want to return jsonDictionary from this request - not NSData..
  func listTutorialsForUserId(userId: Int, completion: (NSData?, NSURLResponse?, NSError?) -> Void) {
    let parameters = [ "fields" : "comments,author.tutorials" ]
    let urlString = "user/\(userId)/tutorials"
    sendNetworkRequest(urlString, httpMethod: .GET, completion: completion);

    // TODO: parse the response and pass to callback as JSON dictionary
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
        enum JSONError: String, ErrorType {
          case NoData = "Error: no data"
          case ConversionFailed = "Error: Conversion from JSON failed"
        }

        do {
          // TODO: export JSON parsing from this method
          guard let validData = data else { throw JSONError.NoData }
          guard let jsonResponse = try NSJSONSerialization.JSONObjectWithData(validData, options: []) as? [NSObject : AnyObject] else { throw JSONError.ConversionFailed }
          TutorialCommentParsingHelper().saveCommentFromDictionary(jsonResponse)
        }
        catch let error as JSONError {
          assertionFailure(error.rawValue)
        }
        catch {
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
    
    return request.copy() as! NSURLRequest
  }
  
  func addBearerAuthenticationToMutableRequest(mutableRequest: NSMutableURLRequest) {
    assert(self.apiToken?.characters.count > 0)
    let bearer = "Bearer " + apiToken!
    mutableRequest.setValue(bearer, forHTTPHeaderField: "Authorization")
  }
}
