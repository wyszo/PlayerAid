import Foundation
import TWCommonLib
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


internal struct HTTPStatusCodes {
  static let success = 200
}

internal enum HTTPMethod: String {
  case GET = "GET"
  case POST = "POST"
  case DELETE = "DELETE"
}

typealias NetworkCompletionBlock = (_ response: Any?, _ responseObject: URLResponse?, _ error: NSError?) -> Void


/**
 This class replaces obsolete AuthenticatedServerCommunicationController. Implement new network requests handling here (in this class extensions)
 */
class ServerCommunicationController : NSObject {

  fileprivate var apiToken: String?
  
  func setApiToken(_ apiToken: String) {
    assert(apiToken.characters.count > 0); // TODO: figure out how to have assertOrReturn in Swift
    self.apiToken = apiToken;
  }
  
  // MARK: Public methods
  
  func ping(completion: @escaping NetworkCompletionBlock) {
    sendNetworkRequest("ping", httpMethod: .GET, parameters: nil, completion: completion)
  }
}

// MARK: Guides
extension ServerCommunicationController {
  
  func listGuides(completion: @escaping NetworkCompletionBlock) {
    // TODO: implement paging for this one!
    let parameters = [ "fields" : "steps,comments" ]
    sendNetworkRequest("guides", httpMethod: .GET, parameters: parameters as [String : AnyObject]?, completion: networkResponseAsJSONPagedDictionaryCompletionBlock(completion))
  }
  
  func listGuidesForUserId(_ userId: Int, completion: @escaping NetworkCompletionBlock) {
    let parameters = [ "fields" : "steps,comments" ]
    let urlString = "user/\(userId)/guides"
    
    sendNetworkRequest(urlString, httpMethod: .GET, parameters: parameters as [String : AnyObject]?, completion: networkResponseAsJSONPagedDictionaryCompletionBlock(completion))
  }

  func pullGuideBackFromReview(_ guideId: Int, completion: @escaping NetworkCompletionBlock) {
    let urlString = "/draft/\(guideId)/review"
    sendNetworkRequest(urlString, httpMethod: .DELETE, parameters: nil, completion: completion)
  }
}

// MARK: User
extension ServerCommunicationController {
  
  func getCurrentUser(completion: @escaping NetworkCompletionBlock) {
    // GET /user
    sendNetworkRequest("user", httpMethod: .GET, parameters: ServerCommunicationController.userRequestFields as [String : AnyObject]?, completion: networkResponseAsJSONDictionaryCompletionBlock(completion))
  }
  
  func getUser(id: String, completion: @escaping NetworkCompletionBlock) {
    // GET /user/{id}
    let urlString = "user/" + id
    sendNetworkRequest(urlString, httpMethod: .GET, parameters: ServerCommunicationController.userRequestFields as [String : AnyObject]?, completion: networkResponseAsJSONDictionaryCompletionBlock(completion))
  }
  
  fileprivate static let userRequestFields = [ "fields" : "guides,guides.steps,followers,following" ]
}

// MARK: Generic methods
extension ServerCommunicationController {
  
  internal func sendPostRequest(_ relativePath: String, parameters: [String : AnyObject]?, completion: @escaping (Data?, URLResponse?, NSError?) -> Void) {
    sendNetworkRequest(relativePath, httpMethod: .POST, parameters: parameters, completion: completion)
  }

  internal func sendNetworkRequest(_ path: String, httpMethod: HTTPMethod, isPathRelative: Bool = true, parameters: [String : AnyObject]?, session: URLSession = URLSession.shared, completion: @escaping (Data?, URLResponse?, NSError?) -> Void) {
    let request = authenticatedRequestWithServerPathString(path, httpMethod:httpMethod, isPathRelative:isPathRelative, parameters:parameters)
    let task = session.dataTask(with: request, completionHandler: completion as! (Data?, URLResponse?, Error?) -> Void)
    task.resume()
  }

  fileprivate func authenticatedRequestWithServerPathString(_ pathString: String, httpMethod: HTTPMethod = .GET, isPathRelative: Bool = true, parameters: [String : AnyObject]? = nil) -> URLRequest {
    let serverURL = EnvironmentSettings().serverBaseURL() as String
    assert(serverURL.characters.count > 0)

    // TODO: extract adding GET request query parameters from this method
    var pathStringWithQueryParams = pathString
    if httpMethod == .GET {
      if let validParameters = parameters {
        pathStringWithQueryParams = pathString + QueryStringBuilder().queryString(fromDictionary: validParameters)
      }
    }

    let requestURL = URL(string: (isPathRelative ? serverURL : "") + pathStringWithQueryParams)
    assert(requestURL != nil)
    
    let request = NSMutableURLRequest(url: requestURL!)
    request.httpMethod = httpMethod.rawValue
    addBearerAuthenticationToMutableRequest(request)

    if let validParameters = parameters {
      if httpMethod == .POST {
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        if let validData = try? validParameters.jsonEncodedData() {
          request.httpBody = validData
        }
      }
    }
    return request.copy() as! URLRequest
  }
  
  fileprivate func addBearerAuthenticationToMutableRequest(_ mutableRequest: NSMutableURLRequest) {
    assert(self.apiToken?.characters.count > 0)
    let bearer = "Bearer " + apiToken!
    mutableRequest.setValue(bearer, forHTTPHeaderField: "Authorization")
  }
  
  // MARK: Network responses handling
  
  internal func isHttpResponseFailureShowGenericError(_ response: URLResponse?, error: NSError?) -> Bool {
    var statusCode = 0
    if let httpResponse = response as? HTTPURLResponse {
      statusCode = httpResponse.statusCode
    }
    
    if error != nil || statusCode != HTTPStatusCodes.success {
      DispatchQueue.main.async(execute: {
        AlertFactory.showGenericErrorAlertViewNoRetry()
      })
      return true
    }
    return false
  }
  
  internal func networkResponseAsJSONArrayCompletionBlock(_ completion: @escaping NetworkCompletionBlock) -> (Data?, URLResponse?, NSError?) -> Void {
  
    return networkResponseWithTransformationCompletionBlock({ (data) -> AnyObject? in
        let result = try? data?.jsonArray()
        assert(result != nil && result! != nil)
        return result! as AnyObject?
      }, completion: completion)
  }
  
  internal func networkResponseAsJSONDictionaryCompletionBlock(_ completion: @escaping NetworkCompletionBlock) -> (Data?, URLResponse?, NSError?) -> Void {
    
    return networkResponseWithTransformationCompletionBlock({ (data) -> AnyObject? in
      let result = try? data?.jsonDictionary()
      assert(result != nil && result! != nil)
      return result! as AnyObject?
    }, completion: completion)
  }
  
  // FIXME: Temporary method that just returns first page of results!
  internal func networkResponseAsJSONPagedDictionaryCompletionBlock(_ completion: @escaping NetworkCompletionBlock) -> (Data?, URLResponse?, NSError?) -> Void {
    return networkResponseWithTransformationCompletionBlock({ (data) -> AnyObject? in
      // TODO: this only returns first page of results, be careful!
      let result = try? data?.jsonDictionary()["data"]
      assert(result != nil && result! != nil)
      return result! as AnyObject?
    }, completion: completion)
  }
  
  fileprivate func networkResponseWithTransformationCompletionBlock(_ transformation: @escaping (Data?) -> AnyObject?, completion: @escaping NetworkCompletionBlock) -> (Data?, URLResponse?, NSError?) -> Void {
    
    return { (data, response, error) -> Void in
      if let transformedData = transformation(data) {
        completion(transformedData, response, error)
      } else {
        assertionFailure("Unexpected response");
        completion(nil, response, error)
      }
    }
  }
}
