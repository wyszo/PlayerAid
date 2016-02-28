import Foundation

@objc
class UIViewControllerBehaviourDecorator: NSObject {
  func installLeftEdgeSwipeToDismissBehaviourOnViewController(viewController: UIViewController) {
    let gestureRecognizer = UIScreenEdgePanGestureRecognizer(target: viewController, action: "dismissViewController")
    gestureRecognizer.edges = .Left
    viewController.view .addGestureRecognizer(gestureRecognizer)
  }
}