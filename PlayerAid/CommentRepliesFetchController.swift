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


@objc
class CommentRepliesFetchController: NSObject {
  
  fileprivate var tutorial: Tutorial
  fileprivate var session: URLSession
  fileprivate var started: Bool
  fileprivate var commentsToFetchReplies: NSOrderedSet
  fileprivate var nextRepliesFeedUrls: Dictionary<NSNumber,String>
  
  fileprivate let kRetryRequestAfterSeconds: TimeInterval = 6.0
  
  init(tutorial: Tutorial) {
    self.tutorial = tutorial
    self.commentsToFetchReplies = tutorial.hasComments
    self.started = false
    self.nextRepliesFeedUrls = Dictionary()
    
    let sessionConfiguration = URLSessionConfiguration.default
    sessionConfiguration.httpMaximumConnectionsPerHost = 3;
    self.session = URLSession(configuration: sessionConfiguration)
    super.init()
  }
  
  func start() {
    if started == true {
      return
    }
    started = true
    
    for comment in commentsToFetchReplies {
      fetchFirstBatchOfCommentReplies(comment as! TutorialComment, session: self.session);
    }
  }
  
  func fetchAllButFirstPageForComment(_ comment: TutorialComment) {
    if let feedUrl = self.nextRepliesFeedUrls[comment.serverID], feedUrl.characters.count > 0 {
      
      AuthenticatedServerCommunicationController.sharedInstance().serverCommunicationController.getCommentRepliesForComment(comment, fromFeed: feedUrl, session: session, allowErrorAlerts: false, completion: { [weak self] (success, nextFeedUrl) -> Void in
        
        if success == true && nextFeedUrl?.characters.count > 0 {
          var valueToSet: String? = nextFeedUrl
          
          if let currentUrl = self?.nextRepliesFeedUrls[comment.serverID], currentUrl == nextFeedUrl {
            valueToSet = nil // if current and next feed URLs are the same, we're done
          }
          self?.nextRepliesFeedUrls[comment.serverID] = valueToSet // remember next page URL 
          self?.fetchAllButFirstPageForComment(comment) // fetch next page
        }
        
        if success == false && self != nil {
          // fetching failure, try again
          DispatchAfter(self!.kRetryRequestAfterSeconds, closure: { () -> () in
            self?.fetchAllButFirstPageForComment(comment)
          })
        }
      })
    }
  }
  
  // MARK: private

  fileprivate func fetchFirstBatchOfCommentReplies(_ comment: TutorialComment, session: URLSession) {
    AuthenticatedServerCommunicationController.sharedInstance().serverCommunicationController.getCommentRepliesForComment(comment, session: session, allowErrorAlerts: false) {
      [weak self] (success, nextFeedUrl) -> Void in
        if success == true && nextFeedUrl?.characters.count > 0 {
          self?.nextRepliesFeedUrls[comment.serverID] = nextFeedUrl
        }
      
        if success == false && self != nil {
          DispatchAfter(self!.kRetryRequestAfterSeconds, closure: { () -> () in
            self?.fetchFirstBatchOfCommentReplies(comment, session: session)
          })
        }
    }
  }
}
