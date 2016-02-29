import Foundation

@objc
class CommentRepliesFetchController: NSObject {
  
  private var tutorial: Tutorial
  private var session: NSURLSession
  private var started: Bool
  private var commentsToFetchReplies: NSOrderedSet
  
  private let kRetryRequestAfterSeconds: NSTimeInterval = 6.0
  
  init(tutorial: Tutorial) {
    self.tutorial = tutorial
    self.commentsToFetchReplies = tutorial.hasComments
    self.started = false
    
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
      fetchCommentReplies(comment as! TutorialComment, session: self.session);
    }
  }
  
  // MARK: private

  private func fetchCommentReplies(comment: TutorialComment, session: NSURLSession) {
    AuthenticatedServerCommunicationController.sharedInstance().serverCommunicationController.getCommentRepliesForComment(comment, session: session, allowErrorAlerts: false) {
      [weak self] (success) -> Void in
        if success == false && self != nil {
          DispatchAfter(self!.kRetryRequestAfterSeconds, closure: { () -> () in
            self?.fetchCommentReplies(comment, session: session)
          })
        }
    }
  }
}