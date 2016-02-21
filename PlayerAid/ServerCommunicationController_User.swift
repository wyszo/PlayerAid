import Foundation

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