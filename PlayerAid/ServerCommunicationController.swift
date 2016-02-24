import Foundation
import TWCommonLib

internal struct HTTPStatusCodes {
  static let success = 200
}

internal enum HTTPMethod: String {
  case GET = "GET"
  case POST = "POST"
  case DELETE = "DELETE"
}

typealias NetworkCompletionBlock = (response: AnyObject?, responseObject: NSURLResponse?, error: NSError?) -> Void


/**
 This class replaces obsolete AuthenticatedServerCommunicationController. Implement new network requests handling here (in this class extensions)
 */
class ServerCommunicationController : NSObject {

  private var apiToken: String?
  
  func setApiToken(apiToken: String) {
    assert(apiToken.characters.count > 0); // TODO: figure out how to have assertOrReturn in Swift
    self.apiToken = apiToken;
  }
  
  // MARK: Public methods
  
  func ping(completion completion: NetworkCompletionBlock) {
    sendNetworkRequest("ping", httpMethod: .GET, parameters: nil, completion: completion)
  }
}

extension ServerCommunicationController {
  // MARK: Tutorials
  
  func listTutorials(completion completion: NetworkCompletionBlock) {
    let parameters = [ "fields" : "steps,comments" ]
    sendNetworkRequest("tutorials", httpMethod: .GET, parameters: parameters, completion: networkResponseAsJSONArrayCompletionBlock(completion))
  }
  
  func listTutorialsForUserId(userId: Int, completion: NetworkCompletionBlock) {
    let parameters = [ "fields" : "comments,author.tutorials" ] // shouldn't this be: comments,steps?
    let urlString = "user/\(userId)/tutorials"
    
    sendNetworkRequest(urlString, httpMethod: .GET, parameters: parameters, completion: networkResponseAsJSONArrayCompletionBlock(completion))
  }
}

extension ServerCommunicationController {
  // MARK: User
  
  func getCurrentUser(completion completion: NetworkCompletionBlock) {
    // GET /user
    sendNetworkRequest("user", httpMethod: .GET, parameters: ServerCommunicationController.userRequestFields, completion: networkResponseAsJSONDictionaryCompletionBlock(completion))
  }
  
  func getUser(id id: String, completion: NetworkCompletionBlock) {
    // GET /user/{id}
    let urlString = "user/" + id
    sendNetworkRequest(urlString, httpMethod: .GET, parameters: ServerCommunicationController.userRequestFields, completion: networkResponseAsJSONDictionaryCompletionBlock(completion))
  }
  
  private static let userRequestFields = [ "fields" : "tutorials,followers,following" ]
}

extension ServerCommunicationController {
  // MARK: Generic methods
  
  internal func sendPostRequest(relativePath: String, parameters: [String : AnyObject]?, completion: (NSData?, NSURLResponse?, NSError?) -> Void) {
    sendNetworkRequest(relativePath, httpMethod: .POST, parameters: parameters, completion: completion)
  }

  internal func sendNetworkRequest(relativePath: String, httpMethod: HTTPMethod, parameters: [String : AnyObject]?, completion: (NSData?, NSURLResponse?, NSError?) -> Void) {
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
  
  internal func isHttpResponseFailureShowGenericError(response: NSURLResponse?, error: NSError?) -> Bool {
    var statusCode = 0
    if let httpResponse = response as? NSHTTPURLResponse {
      statusCode = httpResponse.statusCode
    }
    
    if error != nil || statusCode != HTTPStatusCodes.success {
      dispatch_async(dispatch_get_main_queue(), {
        AlertFactory.showGenericErrorAlertViewNoRetry()
      })
      return true
    }
    return false
  }
  
  internal func networkResponseAsJSONArrayCompletionBlock(completion: NetworkCompletionBlock) -> (NSData?, NSURLResponse?, NSError?) -> Void {
    
    return networkResponseWithTransformationCompletionBlock({ (data) -> AnyObject? in
        let result = try? data?.jsonArray()
        assert(result != nil && result! != nil)
        return result!
      }, completion: completion)
  }
  
  internal func networkResponseAsJSONDictionaryCompletionBlock(completion: NetworkCompletionBlock) -> (NSData?, NSURLResponse?, NSError?) -> Void {
    
    return networkResponseWithTransformationCompletionBlock({ (data) -> AnyObject? in
      let result = try? data?.jsonDictionary()
      assert(result != nil && result! != nil)
      return result!
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
