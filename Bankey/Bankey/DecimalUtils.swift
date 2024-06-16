//
//  DecimalUtils.swift
//  Bankey
//
//  Created by 藤門莉生 on 2024/06/19.
//

import Foundation

extension Decimal {
    var doubleValue: Double {
        return NSDecimalNumber(decimal: self).doubleValue
    }
}
