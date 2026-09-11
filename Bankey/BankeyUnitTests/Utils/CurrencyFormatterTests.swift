import Foundation
import XCTest
#if canImport(BankeyCore)
@testable import BankeyCore
#else
@testable import Bankey
#endif

final class CurrencyFormatterTests: XCTestCase {
    func testFractionDigitsRoundingCarryAndSign() throws {
        let formatter = CurrencyFormatter()
        let cases: [(String, String, String)] = [
            ("0", "$0.00", "00"), ("0.05", "$0.05", "05"),
            ("1.005", "$1.01", "01"), ("999.995", "$1,000.00", "00"),
            ("-0.05", "-$0.05", "05"), ("-1.005", "-$1.01", "01"),
            ("-929466.23", "-$929,466.23", "23"), ("-0.004", "$0.00", "00"),
            ("929466.23", "$929,466.23", "23"),
        ]
        for (input, expected, cents) in cases {
            let amount = try XCTUnwrap(Decimal(string: input, locale: Locale(identifier: "en_US_POSIX")))
            XCTAssertEqual(formatter.dollarsFormatted(amount), expected, input)
            XCTAssertEqual(formatter.breakIntoDollarsAndCents(amount).1, cents, input)
        }
    }

    func testInvalidAmountDoesNotCrashOrProduceMisleadingZero() {
        let formatter = CurrencyFormatter()
        XCTAssertEqual(formatter.dollarsFormatted(.nan), "")
        XCTAssertEqual(formatter.breakIntoDollarsAndCents(.nan).0, "")
    }
}
