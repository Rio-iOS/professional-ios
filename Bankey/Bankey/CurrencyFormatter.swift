import Foundation
import UIKit

/// 教材の残高表示に使用する、米国ロケールの通貨フォーマッター。
struct CurrencyFormatter {
    /// 金額を米国ロケールの通貨文字列へ変換します。
    ///
    /// 例: `929466`は`$929,466.00`になります。変換できない場合は空文字列を返します。
    func dollarsFormatted(_ dollars: Double) -> String {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.numberStyle = .currency
        formatter.usesGroupingSeparator = true
        
        if let result = formatter.string(from: dollars as NSNumber) {
            return result
        }
        
        return ""
    }
    
    /// 金額の整数部分と小数部分を、表示用のドル文字列とセント文字列に分けます。
    ///
    /// 例: `929466.23`は`("929,466", "23")`になります。
    /// `Double`に変換して処理する表示用の実装であり、金額計算には使用しません。
    func breakIntoDollarsAndCents(_ amount: Decimal) -> (String, String) {
        let tuple = modf(amount.doubleValue)
        
        let dollars = convertDollar(tuple.0)
        let cents = convertCents(tuple.1)
        
        return (dollars, cents)
    }
    
    /// ドル記号とセント部分を小さく上付きにした、残高表示用の文字列を作ります。
    func makeAttributedCurrency(_ amount: Decimal) -> NSMutableAttributedString {
        let tupple = breakIntoDollarsAndCents(amount)
        return makeBalanceAttributed(dollars: tupple.0, cents: tupple.1)
    }
}

private extension CurrencyFormatter {
    /// 整数部分を通貨表記に変換し、先頭の通貨記号と小数部分を取り除きます。
    func convertDollar(_ dollartPart: Double) -> String {
        let dollartsWithDecimal = dollarsFormatted(dollartPart) // 例: "$929,466.00"
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "en_US")
        let decimalSeparator = formatter.decimalSeparator! // "."
        let dollarComponents = dollartsWithDecimal.components(separatedBy: decimalSeparator) // "$929,466" "00"
        var dollars = dollarComponents.first!
        dollars.removeFirst() // "929,466"
        
        return dollars
    }
  
    /// 小数部分を100倍して整数表記にします。0の場合は`00`を返します。
    ///
    /// 0以外の値は2桁へゼロ埋めしません。例: `0.05`は`5`になります。
    func convertCents(_ centPart: Double) -> String {
        let cents: String
        if centPart == 0 {
            cents = "00"
        } else {
            cents = String(format: "%.0f", centPart * 100)
        }
        
        return cents
    }
    
    func makeBalanceAttributed(dollars: String, cents: String) -> NSMutableAttributedString {
        let dollarSignAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.preferredFont(forTextStyle: .callout), .baselineOffset: 8]
        let dollarAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.preferredFont(forTextStyle: .title1)]
        let centAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.preferredFont(forTextStyle: .callout), .baselineOffset: 8]
        let rootString = NSMutableAttributedString(string: "$", attributes: dollarSignAttributes)
        let dollarString = NSAttributedString(string: dollars, attributes: dollarAttributes)
        let centString = NSAttributedString(string: cents, attributes: centAttributes)
        
        rootString.append(dollarString)
        rootString.append(centString)
        
        return rootString
    }
}
