//
//  AccountTests.swift
//  BankeyUnitTests
//
//  Created by 藤門莉生 on 2024/06/27.
//

import XCTest
@testable import Bankey

final class AccountTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }
    
    func testCanParse() {
        let json = """
            [
                {
                    "id": "1",
                    "type": "Banking",
                    "name": "Basic Savings",
                    "amount": 929466.23,
                    "createdDateTime": "2010-06-21T15:29:32Z",
                },
                {
                    "id": "2",
                    "type": "Banking",
                    "name": "No-Fee All-In Chequing",
                    "amount": 17562.44,
                    "createdDateTime": "2011-06-21T15:29:32Z",
                },
            ]
        """
        let data = json.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        let accounts = try! decoder.decode([Account].self, from: data)
        
        XCTAssertEqual(accounts[0].id, "1")
        XCTAssertEqual(accounts[0].type, .Banking)
        XCTAssertEqual(accounts[0].name, "Basic Savings")
        XCTAssertEqual(accounts[0].amount, 929466.23)
        XCTAssertEqual(accounts[0].createdDateTime.monthDayYearString, "Jun 21, 2010")
        
        XCTAssertEqual(accounts[1].id, "2")
        XCTAssertEqual(accounts[1].type, .Banking)
        XCTAssertEqual(accounts[1].name, "No-Fee All-In Chequing")
        XCTAssertEqual(accounts[1].amount, 17562.44)
        XCTAssertEqual(accounts[1].createdDateTime.monthDayYearString, "Jun 21, 2011")
    }
}
