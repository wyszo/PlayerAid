import Foundation

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