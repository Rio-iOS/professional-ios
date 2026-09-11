import XCTest
@testable import Password_Reset

final class ViewControllerTests: XCTestCase {
    @MainActor func testValidationClosuresDoNotRetainViewController() {
        weak var reference: ViewController?
        autoreleasepool {
            var viewController: ViewController? = ViewController()
            viewController?.loadViewIfNeeded()
            reference = viewController
            viewController = nil
        }
        XCTAssertNil(reference)
    }

    @MainActor func testConfirmationValidationRejectsDifferentPassword() {
        let viewController = ViewController()
        viewController.loadViewIfNeeded()
        viewController.newPasswordText = "Example123!"
        viewController.confirmPasswordText = "Different123!"
        XCTAssertFalse(viewController.confirmPasswordTextField.validate())
        viewController.confirmPasswordText = "Example123!"
        XCTAssertTrue(viewController.confirmPasswordTextField.validate())
    }
}
