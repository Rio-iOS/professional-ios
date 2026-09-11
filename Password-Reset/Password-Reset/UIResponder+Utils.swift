import Foundation
import UIKit

extension UIResponder {
    static func currentFirst() -> UIResponder? {
        Static.responder = nil
        UIApplication.shared.sendAction(#selector(UIResponder._trap), to: nil, from: nil, for: nil)
        return Static.responder
    }
}

private extension UIResponder {
    struct Static {
        static weak var responder: UIResponder?
    }
}

// MARK: selector
private extension UIResponder {
    @objc func _trap() {
        Static.responder = self
    }
}
