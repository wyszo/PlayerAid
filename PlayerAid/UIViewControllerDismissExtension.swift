import Foundation

extension UIViewController {
  
  // quite silly shorthand method, but required by UIViewControllerBehaviourDecorator
  func dismissViewController() {
    dismiss(animated: true, completion: nil)
  }
}
