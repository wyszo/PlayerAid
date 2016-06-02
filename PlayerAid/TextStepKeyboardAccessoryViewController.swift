import Foundation
import TWCommonLib

final class TextStepKeyboardAccessoryViewController: UIViewController {
  let xibName = "TextStepKeyboardAccessoryViewController"
  
  @IBOutlet weak var boldButton: UIButton!
  @IBOutlet weak var titleButton: UIButton!
  @IBOutlet weak var subTitleButton: UIButton!
  @IBOutlet weak var bulletListButton: UIButton!
  @IBOutlet weak var numberedListButton: UIButton!
  @IBOutlet weak var dashButton: UIButton!
  
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
  
  @IBAction func didPressBoldButton(sender: AnyObject) {
    boldButton.selected = !boldButton.selected
  }

  @IBAction func didPressTitleButton(sender: AnyObject) {
    titleButton.selected = !titleButton.selected
  }

  @IBAction func didPressSubtitleButton(sender: AnyObject) {
    subTitleButton.selected = !subTitleButton.selected
  }
  
  @IBAction func didPressBulletListButton(sender: AnyObject) {
    bulletListButton.selected = !bulletListButton.selected
  }
  
  @IBAction func didPressNumberedListButton(sender: AnyObject) {
    numberedListButton.selected = !numberedListButton.selected
  }
}
