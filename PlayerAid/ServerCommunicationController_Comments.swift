import Foundation

// MARK: Comments
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
        let replyID = TutorialComment.serverIDFromTutorialCommentDictionary(jsonResponse!)
        assert(replyID != nil)
        assert(jsonResponse!["replies"] == nil, "old unsupported communication protocol - contains parent comment instead of new reply ID, not supported anymore")
        TutorialCommentParsingHelper().saveNewReplyWithID(replyID!, message: message, parentCommentID: comment.serverID)
      }
      completion(success: success)
    }
  }
  
  func getCommentRepliesForComment(comment: TutorialComment, session: NSURLSession = NSURLSession.sharedSession(), allowErrorAlerts: Bool = true, completion: (success: Bool, nextFeedURL: String?) -> Void) {
    let urlPath = serverRelativePathForCommentRepliesToCommentWithID(comment.serverID)
    getCommentRepliesForComment(comment, fromFeed: urlPath, isPathRelative: true, session: session, allowErrorAlerts: allowErrorAlerts, completion: completion);
  }
  
  func getCommentRepliesForComment(comment: TutorialComment, fromFeed feed: String, isPathRelative: Bool = false, session: NSURLSession, allowErrorAlerts: Bool, completion: (success: Bool, nextFeedURL: String?) -> Void) {
    
    sendNetworkRequest(feed, httpMethod: .GET, isPathRelative: isPathRelative, parameters: nil, session: session) {
      [weak self] (data, response, error) -> Void in
        (self?.handleRepliesFeedToACommentWithID(comment.serverID, allowErrorAlerts: allowErrorAlerts, data: data, response: response, error: error, completion: completion))!
    }
  }
}

// MARK: Comments parsing
extension ServerCommunicationController {
  
  private func serverRelativePathForCommentRepliesToCommentWithID(commentID: NSNumber) -> String {
      // GET /comment/{id}/replies
    return commentRelativePathForCommentWithId(commentID, sufix: "replies")
  }
  
  private func handleRepliesFeedToACommentWithID(parentCommentID: NSNumber, allowErrorAlerts: Bool = true, data: NSData?, response: NSURLResponse?, error: NSError?, completion: (success: Bool, nextFeedUrl: String?) -> Void) {
    if isHttpResponseFailureShowGenericError(response, error: error) == false {
      if let jsonDictionary = try? data?.jsonDictionary(), jsonReplies = jsonDictionary?["data"] as? [AnyObject] {
        TutorialCommentParsingHelper().saveRepliesToCommentWithID(parentCommentID, repliesDictionaries:(jsonReplies));
        
        var feedUrl: String? = nil
        if let nextFeed = jsonDictionary?["nextPage"] as? String {
          feedUrl = nextFeed
        }
        completion(success: true, nextFeedUrl: feedUrl)
      } else {
        if allowErrorAlerts {
          AlertFactory.showGenericErrorAlertViewNoRetry()
        }
        completion(success: false, nextFeedUrl: nil)
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
