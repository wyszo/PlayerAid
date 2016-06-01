import Foundation
import TWCommonLib

final class TextStepKeyboardAccessoryViewController: UIViewController {
  let xibName = "TextStepKeyboardAccessoryViewController"
  
  init() {
    super.init(nibName: xibName, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(nibName: xibName, bundle: nil)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.view.tw_addTopBorderWithWidth(1.0, color: ColorsHelper.textStepKeyboardInputAccessoryViewBorderColor())
  }
  
  //MARK: IBActions
  
  @IBAction func didPressBold(sender: AnyObject) {
  }
}
