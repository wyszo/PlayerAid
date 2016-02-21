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
