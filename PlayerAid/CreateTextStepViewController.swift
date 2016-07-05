import Foundation
import RichEditorView

final class CreateTextStepViewController: UIViewController {
  @IBOutlet weak var editorView: RichEditorView!
  @IBOutlet weak var characterLimit: UILabel!
  
  typealias CompletionType = (text: String?, error: NSError?) -> ()
  private var completion: CompletionType!
  private var tutorialTextStep: TutorialStep?
  
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
  
  convenience init(completion: CompletionType, textStep: TutorialStep? = nil) {
    self.init(nibName: "CreateTextStep", bundle: nil)
    self.completion = completion
    self.tutorialTextStep = textStep
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
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    editorView.focus() // slides keyboard in
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
    popViewController()
    completion!(text: processedHTML(), error: nil)
  }
  
  private func dismissViewControllerPresentingConfirmationAlertIfNeeded() {
    self.editorView.resignFirstResponder()
    
    if !hasAnyText() {
      forceDismissViewControllerWithError()
      return
    }
    
    let dismissBlock = { [unowned self] (discard: Bool) in
      if discard {
        self.forceDismissViewControllerWithError()
      }
    }
    
    if isEditingExistingTutorialStep() {
      AlertFactory.showCancelEditingExistingTutorialStepConfirmationAlertViewWithCompletion(dismissBlock)
    } else {
      AlertFactory.showRemoveNewTutorialTextStepConfirmationAlertViewWithCompletion(dismissBlock)
    }
  }
  
  //MARK: Auxiliary
  
  private func isEditingExistingTutorialStep() -> Bool {
    return tutorialTextStep != nil
  }
  
  private func hasAnyText() -> Bool {
    return processedText().characters.count > 0
  }
  
  private func processedText() -> String {
    return self.editorView.getText().tw_stringByTrimmingWhitespaceAndNewline()
  }
  
  private func processedHTML() -> String {
    // TODO: remove &nbsp; at the beginning and end of a div!
    return self.editorView.getHTML()
  }
  
  //MARK: dismiss
  
  private func forceDismissViewControllerWithError() {
    popViewController()
    
    // FIXME: replace with ErrorType when we can
    let error = NSError(domain: Errors.TutorialErrorDomain, code: Errors.TextStepDismissedErrorCode, userInfo: nil)
    completion!(text: nil, error: error)
  }
  
  private func popViewController() {
    navigationController!.popViewControllerAnimated(true)
  }
  
  struct Errors {
    static let TutorialErrorDomain = "CreateTutorialDomain"
    static let TextStepDismissedErrorCode = 1
  }
}

extension RichEditorOptions {
  public static func playerAidOptions() -> [RichEditorOption] {
    return [
      Bold, Header(1), Header(2), OrderedList, UnorderedList, // <HR>
    ]
  }
}

extension String {
  func tw_stringByTrimmingWhitespaceAndNewline() -> String {
    return self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
  }
}
