import Foundation

@objc protocol UsersTableViewDelegate {
    @objc optional func numberOfRowsDidChange(_ rows: Int)
}
