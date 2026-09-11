import Foundation
#if canImport(UIKit)
import UIKit
#endif

/// 米ドルを小数点以下2桁、四捨五入（中間値は絶対値を大きくする方向）で表示します。
struct CurrencyFormatter {
    private let locale = Locale(identifier: "en_US")

    func dollarsFormatted(_ amount: Decimal) -> String {
        let parts = breakIntoDollarsAndCents(amount)
        guard !parts.0.isEmpty else { return "" }
        let isNegative = parts.0.hasPrefix("-")
        let dollars = isNegative ? String(parts.0.dropFirst()) : parts.0
        return "\(isNegative ? "-" : "")$\(dollars).\(parts.1)"
    }

    /// Decimalのまま丸め、符号を整数部分に付けて返します。負の1ドル未満は `-0` になります。
    /// NaNは空の2要素を返します。
    func breakIntoDollarsAndCents(_ amount: Decimal) -> (String, String) {
        guard !amount.isNaN else { return ("", "") }
        var source = amount
        var rounded = Decimal()
        NSDecimalRound(&rounded, &source, 2, .plain)
        let isNegative = rounded < 0
        let magnitude = isNegative ? -rounded : rounded
        let formatter = NumberFormatter()
        formatter.locale = locale
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        formatter.roundingMode = .halfUp
        formatter.usesGroupingSeparator = true
        guard let text = formatter.string(from: NSDecimalNumber(decimal: magnitude)) else { return ("", "") }
        let parts = text.split(separator: ".", omittingEmptySubsequences: false)
        guard parts.count == 2 else { return ("", "") }
        return ((isNegative ? "-" : "") + parts[0], String(parts[1]))
    }

#if canImport(UIKit)
    /// 符号・ドル記号・セントを上付きにした表示文字列。VoiceOverには `dollarsFormatted(_:)` を使います。
    func makeAttributedCurrency(_ amount: Decimal) -> NSAttributedString {
        let parts = breakIntoDollarsAndCents(amount)
        guard !parts.0.isEmpty else { return NSAttributedString(string: "") }
        let isNegative = parts.0.hasPrefix("-")
        let dollars = isNegative ? String(parts.0.dropFirst()) : parts.0
        let small: [NSAttributedString.Key: Any] = [.font: UIFont.preferredFont(forTextStyle: .callout), .baselineOffset: 8]
        let result = NSMutableAttributedString(string: isNegative ? "-$" : "$", attributes: small)
        result.append(NSAttributedString(string: dollars, attributes: [.font: UIFont.preferredFont(forTextStyle: .title1)]))
        result.append(NSAttributedString(string: parts.1, attributes: small))
        return result
    }
#endif
}
