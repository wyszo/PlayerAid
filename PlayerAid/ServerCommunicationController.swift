//  PlayerAid

import Foundation

/**
 This class replaces AuthenticatedServerCommunicationController as is intended to be further extended. Implement new network requests here.
 */
class ServerCommunicationController : NSObject {
  
  private var apiToken: String? 
  
  func setApiToken(apiToken: String) {
    assert(apiToken.characters.count > 0); // TODO: figure out how to have assertOrReturn in Swift
    self.apiToken = apiToken;
  }
}
