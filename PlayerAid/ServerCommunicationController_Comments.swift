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
  
  func getCommentRepliesForComment(comment: TutorialComment, completion: (success: Bool) -> Void) {
    // GET /comment/{id}
    let urlPath = commentRelativePathForCommentWithId(comment.serverID, sufix: "replies")
    sendNetworkRequest(urlPath, httpMethod: .GET, parameters: nil) {
      [weak self] (data, response, error) -> Void in
        (self?.handleRepliesFeedToACommentWithID(comment.serverID, data: data, response: response, error: error))!
    }
  }
  
  // MARK: Handling comments parsing
  
  private func handleRepliesFeedToACommentWithID(parentCommentID: NSNumber, data: NSData?, response: NSURLResponse?, error: NSError?) {
    if isHttpResponseFailureShowGenericError(response, error: error) == false {
      if let jsonDictionary = try? data?.jsonDictionary(), jsonReplies = jsonDictionary?["data"] as? [AnyObject] {
        TutorialCommentParsingHelper().saveRepliesToCommentWithID(parentCommentID, repliesDictionaries:(jsonReplies));
      } else {
        AlertFactory.showGenericErrorAlertViewNoRetry()
      }
    }
  }
  
  private func handleResponseContainingTutorialComment(data: NSData?, response: NSURLResponse?, error: NSError?) {
    if isHttpResponseFailureShowGenericError(response, error: error) == false {
      if let jsonComment = try? data?.jsonDictionary() as? [String:AnyObject] {
        TutorialCommentParsingHelper().saveCommentFromDictionary(jsonComment!)
      } else {
        assertionFailure("Unexpected response")
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
