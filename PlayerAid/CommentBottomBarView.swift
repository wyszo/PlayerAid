//  PlayerAid

import UIKit
import TWCommonLib

typealias VoidCallback = () -> ()

class CommentBottomBarView: UIView {
  
  @IBOutlet fileprivate weak var view: UIView! 
  
  // MARK: Init
  
  override init(frame: CGRect) {
    super.init(frame:frame)
    setupView()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setupView()
  }

  fileprivate func setupView() {
    Bundle.main.loadNibNamed("CommentBottomBar", owner:self, options:nil)
    self.addSubview(self.view);
  }
  
  // MARK: public
  
  func setNumberOfLikes(_ numberOfLikes: Int) {
    let numberOfLikesString = String(numberOfLikes)
    assert(numberOfLikesString.characters.count > 0)
    self.numberOfLikesButton.setTitle(numberOfLikesString, for: UIControlState())
  }

  func setLikeButtonActive(_ active: Bool) {
    self.likeButton.alpha = (active ? 1.0 : 0.5)
  }
  
  // MARK: callbacks
  
  var likeButtonPressed: VoidCallback?
  var likesCountButtonPressed: VoidCallback?
  
  // MARK: UI
  
  @IBOutlet weak var timeAgoLabel: UILabel!
  @IBOutlet weak var likeButton: UIButton!
  @IBOutlet fileprivate weak var numberOfLikesButton: UIButton!
  
  @IBAction func likeButtonPressed(_ sender: AnyObject) {
    likeButtonPressed?()
  }
  
  @IBAction func numberOfLikesButtonPressed(_ sender: AnyObject) {
    likesCountButtonPressed?()
  }
}
