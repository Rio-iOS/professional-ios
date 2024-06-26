//
//  ProfileTests.swift
//  BankeyUnitTests
//
//  Created by 藤門莉生 on 2024/06/27.
//

import Foundation
import XCTest

@testable import Bankey

final class ProfileTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }
    
    func testCanParse() {
        let json = """
            {
                "id": "1",
                "first_name": "Kevin",
                "last_name": "Flynn",
            }
        """
        
        let data = json.data(using: .utf8)!
        let result = try! JSONDecoder().decode(Profile.self, from: data)
        
        XCTAssertEqual(result.id, "1")
        XCTAssertEqual(result.firstName, "Kevin")
        XCTAssertEqual(result.lastName, "Flynn")
    }
}
