import Foundation
import RichEditorView

final class CreateTextStepViewController: UIViewController {
  @IBOutlet weak var editorView: RichEditorView!
  @IBOutlet weak var characterLimit: UILabel!
  
  lazy var toolbar: RichEditorToolbar = {
    let toolbar = RichEditorToolbar(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 44))
    toolbar.options = RichEditorOptions.playerAidOptions()
    toolbar.setToolbarBackgroundColor(UIColor.whiteColor())
    
    let toolbarGrayColor = UIColor(colorLiteralRed: 226.0/255.0, green: 226.0/255.0, blue: 226.0/255.0, alpha: 1.0)
    toolbar.setToolbarBorderColor(toolbarGrayColor)
    toolbar.setBorderSize(0.5)
    return toolbar
  }()
  
  required init(coder aDecoder: NSCoder) {
    fatalError("VC to be used with xib")
  }
  
  convenience init() {
    self.init(nibName: "CreateTextStep", bundle: nil)
  }
  
  override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }
  
  //MARK: view loading
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    editorView.inputAccessoryView = toolbar
    toolbar.editor = editorView
    
    setupNavbarButtons()
    editorView.webView.becomeFirstResponder()
  }
  
  private func setupNavbarButtons() {
    let cancelButton = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action:#selector(cancelButtonPressed))
    navigationItem.leftBarButtonItem = cancelButton
    
    let confirmButton = UIBarButtonItem(title: "Confirm", style: .Plain, target: self, action:#selector(confirmButtonPressed))
    navigationItem.rightBarButtonItem = confirmButton
  }
  
  //MARK: private
  
  @objc private func cancelButtonPressed() {
    dismissViewControllerPresentingConfirmationAlertIfNeeded()
  }
  
  @objc private func confirmButtonPressed() {
    // TODO: invoke completion callback and pop view controller
  }
  
  private func dismissViewControllerPresentingConfirmationAlertIfNeeded() {
    // TODO: not implemented yet, see CreateTutorialTextStepviewController for reference implementation
    navigationController!.popViewControllerAnimated(true)
  }
}

extension RichEditorOptions {
  public static func playerAidOptions() -> [RichEditorOption] {
    return [
      Bold, Header(1), Header(2), OrderedList, UnorderedList, // <HR>
    ]
  }
}
