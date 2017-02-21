import Foundation
import RichEditorView

final class CreateTextStepViewController: UIViewController {
  @IBOutlet weak var editorView: RichEditorView!
  @IBOutlet weak var characterLimit: UILabel!
  
  typealias CompletionType = (_ text: String?, _ error: NSError?) -> ()
  fileprivate var completion: CompletionType!
  fileprivate var tutorialTextStep: TutorialStep?
  
  fileprivate var remainingCharactersCount: Int
  fileprivate var confirmNavbarButton: UIBarButtonItem?
  
  lazy var toolbar: RichEditorToolbar = {
    let toolbar = RichEditorToolbar(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 44))
    toolbar.options = RichEditorOptions.playerAidOptions()
    toolbar.setToolbarBackgroundColor(UIColor.white)
    
    let toolbarGrayColor = UIColor(colorLiteralRed: 226.0/255.0, green: 226.0/255.0, blue: 226.0/255.0, alpha: 1.0)
    toolbar.setToolbarBorderColor(toolbarGrayColor)
    toolbar.setBorderSize(0.5)
    return toolbar
  }()
  
  required init(coder aDecoder: NSCoder) {
    fatalError("VC to be used with xib")
  }
  
  convenience init(completion: @escaping CompletionType, textStep: TutorialStep? = nil) {
    self.init(nibName: "CreateTextStep", bundle: nil)
    self.completion = completion
    self.tutorialTextStep = textStep
  }
  
  override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: Bundle!) {
    self.remainingCharactersCount = Constants.MaxTextStepCharactersCount
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }
  
  //MARK: view loading
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    editorView.inputAccessoryView = toolbar
    toolbar.editor = editorView
    editorView.delegate = self
    prepopulateTextViewText()
    
    setupNavbarButtons()
    updateCharactersCountLabel()
    updateConfirmButtonState()
    installSwipeRightGestureRecognizer()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    editorView.focus() // slides keyboard in
  }
  
  //MARK: Navbar
  
  fileprivate func setupNavbarButtons() {
    let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action:#selector(cancelButtonPressed))
    navigationItem.leftBarButtonItem = cancelButton
    
    confirmNavbarButton = UIBarButtonItem(title: "Confirm", style: .plain, target: self, action:#selector(confirmButtonPressed))
    navigationItem.rightBarButtonItem = confirmNavbarButton
  }
  
  @objc fileprivate func cancelButtonPressed() {
    dismissViewControllerPresentingConfirmationAlertIfNeeded()
  }
  
  @objc fileprivate func confirmButtonPressed() {
    popViewController()
    completion!(processedHTML(), nil)
  }
  
  //MARK: Private
  
  fileprivate func dismissViewControllerPresentingConfirmationAlertIfNeeded() {
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
      AlertFactory.showCancelEditingExistingTutorialStepConfirmationAlertView(completion: dismissBlock)
    } else {
      AlertFactory.showRemoveNewTutorialTextStepConfirmationAlertView(completion: dismissBlock)
    }
  }
  
  fileprivate func updateCharactersCountLabel() {
    characterLimit.text = "\(remainingCharactersCount)"
    
    var labelColor = UIColor.gray
    if overCharacterLimit() {
      labelColor = UIColor.red
    }
    characterLimit.textColor = labelColor
  }
  
  fileprivate func prepopulateTextViewText() {
    if let text = tutorialTextStep?.text {
      editorView.setHTML(text)
    }
  }
  
  fileprivate func updateConfirmButtonState() {
    confirmNavbarButton?.isEnabled = (!overCharacterLimit() && hasAnyText())
  }
  
  fileprivate func updateTextColor() {
    var textColor = UIColor.black
    if overCharacterLimit() {
      textColor = UIColor.red
    }
    
    // FIXME: regression - this only changes color of text that's about to be typed in - we want to change whole component text here
    // editorView.setTextColor(textColor)
  }
  
  fileprivate func installSwipeRightGestureRecognizer() {
    let gestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeGestureRecognizer))
    view.addGestureRecognizer(gestureRecognizer)
  }
  
  @objc fileprivate func swipeGestureRecognizer() {
    dismissViewControllerPresentingConfirmationAlertIfNeeded()
  }
  
  //MARK: Auxiliary
  
  fileprivate func overCharacterLimit() -> Bool {
    return remainingCharactersCount < 0
  }
  
  fileprivate func isEditingExistingTutorialStep() -> Bool {
    return tutorialTextStep != nil
  }
  
  fileprivate func hasAnyText() -> Bool {
    return processedText().characters.count > 0
  }
  
  fileprivate func processedText() -> String {
    return self.editorView.getText().tw_stringByTrimmingWhitespaceAndNewline()
  }
  
  fileprivate func processedHTML() -> String {
    // TODO: remove &nbsp; at the beginning and end of a div!
    return self.editorView.getHTML()
  }
  
  //MARK: dismiss
  
  fileprivate func forceDismissViewControllerWithError() {
    popViewController()
    
    // FIXME: replace with ErrorType when we can
    let error = NSError(domain: Errors.TutorialErrorDomain, code: Errors.TextStepDismissedErrorCode, userInfo: nil)
    completion!(nil, error)
  }
  
  fileprivate func popViewController() {
    navigationController!.popViewController(animated: true)
  }
  
  struct Errors {
    static let TutorialErrorDomain = "CreateTutorialDomain"
    static let TextStepDismissedErrorCode = 1
  }
  
  struct Constants {
    static let MaxTextStepCharactersCount = 1000
  }
}

extension CreateTextStepViewController: RichEditorDelegate {
  func richEditor(_ editor: RichEditorView, contentDidChange content: String) {
    remainingCharactersCount = Constants.MaxTextStepCharactersCount - editor.getText().characters.count
    updateCharactersCountLabel()
    updateConfirmButtonState()
    updateTextColor()
  }
}

extension RichEditorOptions {
  public static func playerAidOptions() -> [RichEditorOption] {
    return [
      bold, header(1), header(2), orderedList, unorderedList, // <HR>
    ]
  }
}

extension String {
  func tw_stringByTrimmingWhitespaceAndNewline() -> String {
    return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
  }
}
