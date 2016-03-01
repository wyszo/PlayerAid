import Foundation

@objc
class CommentRepliesFetchController: NSObject {
  
  private var tutorial: Tutorial
  private var session: NSURLSession
  private var started: Bool
  private var commentsToFetchReplies: NSOrderedSet
  private var nextRepliesFeedUrls: Dictionary<NSNumber,String>
  
  private let kRetryRequestAfterSeconds: NSTimeInterval = 6.0
  
  init(tutorial: Tutorial) {
    self.tutorial = tutorial
    self.commentsToFetchReplies = tutorial.hasComments
    self.started = false
    self.nextRepliesFeedUrls = Dictionary()
    
    let sessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
    sessionConfiguration.HTTPMaximumConnectionsPerHost = 3;
    self.session = NSURLSession(configuration: sessionConfiguration)
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
  
  func fetchAllButFirstPageForComment(comment: TutorialComment) {
    if let feedUrl = self.nextRepliesFeedUrls[comment.serverID] where feedUrl.characters.count > 0 {
      
      AuthenticatedServerCommunicationController.sharedInstance().serverCommunicationController.getCommentRepliesForComment(comment, fromFeed: feedUrl, session: session, allowErrorAlerts: false, completion: { [weak self] (success, nextFeedUrl) -> Void in
        
        if success == true && nextFeedUrl?.characters.count > 0 {
          var valueToSet: String? = nextFeedUrl
          
          if let currentUrl = self?.nextRepliesFeedUrls[comment.serverID] where currentUrl == nextFeedUrl {
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

  private func fetchFirstBatchOfCommentReplies(comment: TutorialComment, session: NSURLSession) {
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