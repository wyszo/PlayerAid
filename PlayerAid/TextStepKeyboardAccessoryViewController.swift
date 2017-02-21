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
  
  typealias ButtonCallback = (Bool)->()
  
  var didPressBold: ButtonCallback?
  var didPressTitle: ButtonCallback?
  var didPressSubtitle: ButtonCallback?
  var didPressBulletList: ButtonCallback?
  var didPressNumberedList: ButtonCallback?
  var didPressDash: ( ()->() )?
  
  init() {
    super.init(nibName: xibName, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(nibName: xibName, bundle: nil)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.view.tw_addTopBorder(withWidth: 1.0, color: ColorsHelper.textStepKeyboardInputAccessoryViewBorderColor())
  }
  
  //MARK: IBActions
  
  @IBAction func didPressBoldButton(_ sender: AnyObject) {
    boldButton.isSelected = !boldButton.isSelected
  }

  @IBAction func didPressTitleButton(_ sender: AnyObject) {
    titleButton.isSelected = !titleButton.isSelected
  }

  @IBAction func didPressSubtitleButton(_ sender: AnyObject) {
    subTitleButton.isSelected = !subTitleButton.isSelected
  }
  
  @IBAction func didPressBulletListButton(_ sender: AnyObject) {
    bulletListButton.isSelected = !bulletListButton.isSelected
  }
  
  @IBAction func didPressNumberedListButton(_ sender: AnyObject) {
    numberedListButton.isSelected = !numberedListButton.isSelected
  }
  
  @IBAction func didPressDashButton(_ sender: AnyObject) {
    dashButton.isSelected = !dashButton.isSelected
    didPressDash?()
  }
}
