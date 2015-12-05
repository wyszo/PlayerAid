//  PlayerAid

import UIKit
import TWCommonLib

class CommentBottomBarView: UIView {
  
  private var view: UIView!
  
  // MARK: Init
  
  override init(frame: CGRect) {
    super.init(frame:frame);
    setupView();
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder);
    setupView();
  }
  
  private func setupView() {
    self.view = self.tw_loadView(self.view, fromNibNamed:"CommentBottomBar");
  }
  
  // MARK: IBActions
  
  // Those two methods should cetrainly be part of the view controller, not the view, right?
  
  @IBAction func likeButtonPressed(sender: AnyObject) {
  }
  
  @IBAction func numberOfLikesButtonPressed(sender: AnyObject) {
  }
}
