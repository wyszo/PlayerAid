//  PlayerAid

import UIKit
import TWCommonLib

typealias VoidCallback = () -> ()

class CommentBottomBarView: UIView {
  
  @IBOutlet private weak var view: UIView! 
  
  // MARK: Init
  
  override init(frame: CGRect) {
    super.init(frame:frame)
    setupView()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setupView()
  }

  private func setupView() {
    NSBundle.mainBundle().loadNibNamed("CommentBottomBar", owner:self, options:nil)
    self.addSubview(self.view);
  }
  
  // MARK: public
  
  func setNumberOfLikes(numberOfLikes: Int) {
    let numberOfLikesString = String(numberOfLikes)
    assert(numberOfLikesString.characters.count > 0)
    self.numberOfLikesButton.setTitle(numberOfLikesString, forState: .Normal)
  }
  
  // MARK: callbacks
  
  var likeButtonPressed: VoidCallback?
  var likesCountButtonPressed: VoidCallback?
  
  // MARK: UI
  
  @IBOutlet weak var timeAgoLabel: UILabel!
  @IBOutlet private weak var numberOfLikesButton: UIButton!
  
  @IBAction func likeButtonPressed(sender: AnyObject) {
    likeButtonPressed?()
  }
  
  @IBAction func numberOfLikesButtonPressed(sender: AnyObject) {
    likesCountButtonPressed?()
  }
}
