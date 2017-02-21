import Foundation
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


// MARK: Comments
extension ServerCommunicationController {
  // MARK: (un)liking comments
  
  func likeComment(_ comment: TutorialComment) {
    // POST /comment/{id}/upvote
    let urlPath = commentRelativePathForCommentWithId(comment.serverID, sufix: "upvote")
    
    sendPostRequest(urlPath, parameters: nil, completion: {
      [weak self] (data, response, error) -> Void in
      self?.handleResponseContainingTutorialComment(data, response: response, error: error)
      })
  }
  
  func unlikeComment(_ comment: TutorialComment) {
    // DELETE /comment/{id}/upvote
    let urlPath = commentRelativePathForCommentWithId(comment.serverID, sufix: "upvote")
    sendNetworkRequest(urlPath, httpMethod: .DELETE, parameters: nil, completion:self.handleResponseContainingTutorialComment);
  }
  
  // MARK: Replying and refreshing comment replies
  
  func replyToComment(_ comment: TutorialComment, message: String, completion: @escaping (_ success: Bool) -> Void) {
    // POST /comment/{id}/reply
    let urlPath = commentRelativePathForCommentWithId(comment.serverID, sufix: "reply")
    let parameters = [ "message" : message]
    
    sendPostRequest(urlPath, parameters: parameters as [String : AnyObject]?) {
      (data, response, error) -> Void in
      let success = (error == nil)
      if let jsonResponse = try? data?.jsonDictionary() {
        let replyID = TutorialComment.serverID(fromTutorialCommentDictionary: jsonResponse!)
        assert(replyID != nil)
        assert(jsonResponse!["replies"] == nil, "old unsupported communication protocol - contains parent comment instead of new reply ID, not supported anymore")
        TutorialCommentParsingHelper().saveNewReply(withID: replyID!, message: message, parentCommentID: comment.serverID)
      }
      completion(success)
    }
  }
  
  func getCommentRepliesForComment(_ comment: TutorialComment, session: URLSession = URLSession.shared, allowErrorAlerts: Bool = true, completion: @escaping (_ success: Bool, _ nextFeedURL: String?) -> Void) {
    let urlPath = serverRelativePathForCommentRepliesToCommentWithID(comment.serverID)
    getCommentRepliesForComment(comment, fromFeed: urlPath, isPathRelative: true, session: session, allowErrorAlerts: allowErrorAlerts, completion: completion);
  }
  
  func getCommentRepliesForComment(_ comment: TutorialComment, fromFeed feed: String, isPathRelative: Bool = false, session: URLSession, allowErrorAlerts: Bool, completion: @escaping (_ success: Bool, _ nextFeedURL: String?) -> Void) {
    
    sendNetworkRequest(feed, httpMethod: .GET, isPathRelative: isPathRelative, parameters: nil, session: session) {
      [weak self] (data, response, error) -> Void in
        (self?.handleRepliesFeedToACommentWithID(comment.serverID, allowErrorAlerts: allowErrorAlerts, data: data, response: response, error: error, completion: completion))!
    }
  }
}

// MARK: Comments parsing
extension ServerCommunicationController {
  
  fileprivate func serverRelativePathForCommentRepliesToCommentWithID(_ commentID: NSNumber) -> String {
      // GET /comment/{id}/replies
    return commentRelativePathForCommentWithId(commentID, sufix: "replies")
  }
  
  fileprivate func handleRepliesFeedToACommentWithID(_ parentCommentID: NSNumber, allowErrorAlerts: Bool = true, data: Data?, response: URLResponse?, error: NSError?, completion: (_ success: Bool, _ nextFeedUrl: String?) -> Void) {
    if isHttpResponseFailureShowGenericError(response, error: error) == false {
      if let jsonDictionary = try? data?.jsonDictionary(), let jsonReplies = jsonDictionary?["data"] as? [AnyObject] {
        TutorialCommentParsingHelper().saveRepliesToComment(withID: parentCommentID, repliesDictionaries:(jsonReplies));
        
        var feedUrl: String? = nil
        if let nextFeed = jsonDictionary?["nextPage"] as? String {
          feedUrl = nextFeed
        }
        completion(true, feedUrl)
      } else {
        if allowErrorAlerts {
          AlertFactory.showGenericErrorAlertViewNoRetry()
        }
        completion(false, nil)
      }
    }
  }
  
  fileprivate func handleResponseContainingTutorialComment(_ data: Data?, response: URLResponse?, error: NSError?) {
    if isHttpResponseFailureShowGenericError(response, error: error) == false {
      if let jsonComment = try? data?.jsonDictionary() as? [String:AnyObject] {
        TutorialCommentParsingHelper().saveComment(from: jsonComment!)
      } else {
        assertionFailure("Unexpected response")
      }
    }
  }
  
  // MARK: Auxiliary path methods
  
  fileprivate func commentRelativePathForCommentWithId(_ commentID: NSNumber, sufix: String?) -> String {
    var path = "comment/" + commentID.stringValue
    if sufix != nil && sufix?.characters.count > 0 {
      path = path + "/" + sufix!
    }
    return path
  }
}
