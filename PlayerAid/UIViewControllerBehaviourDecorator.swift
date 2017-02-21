import Foundation

@objc
class UIViewControllerBehaviourDecorator: NSObject {
  func installLeftEdgeSwipeToDismissBehaviourOnViewController(_ viewController: UIViewController) {
    let gestureRecognizer = UIScreenEdgePanGestureRecognizer(target: viewController, action: "dismissViewController")
    gestureRecognizer.edges = .left
    viewController.view .addGestureRecognizer(gestureRecognizer)
  }
}
