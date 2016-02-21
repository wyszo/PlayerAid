import Foundation

extension ServerCommunicationController {
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
}
