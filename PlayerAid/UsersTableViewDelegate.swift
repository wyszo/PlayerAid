import Foundation

@objc protocol UsersTableViewDelegate {
    optional func numberOfRowsDidChange(rows: Int)
}
