//
//  AccountSummaryViewControllerTests.swift
//  BankeyUnitTests
//
//  Created by 藤門莉生 on 2024/06/29.
//

import XCTest
@testable import Bankey

final class AccountSummaryViewControllerTests: XCTestCase {
    private var vc: AccountSummaryViewController!
    private var mockProfileManager: MockProfileManager!
    private var mockAccountsManager: MockAccountsManager!

    class MockProfileManager: ProfileManagable {
        var profile: Profile?
        var error: NetworkError?
        
        func fetchProfile(forUserId userId: String, completion: @escaping (Result<Profile, NetworkError>) -> Void) {
            if error != nil {
                completion(.failure(error!))
                return
            }
            
            profile = Profile(
                id: "1",
                firstName: "FirstName",
                lastName: "LastName"
            )
            completion(.success(profile!))
        }
    }
    
    class MockAccountsManager: AccountsManagable {
        var accounts: [Account]?
        var error: NetworkError?
        func fetchAccounts(forUserId userId: String, completion: @escaping (Result<[Account], NetworkError>) -> Void) {
            if error != nil {
                completion(.failure(error!))
                return
            }
            
            completion(
                .success(
                    [
                        Account(
                            id: "1",
                            type: .Banking,
                            name: "name",
                            amount: 100.0,
                            createdDateTime: Date()
                        )
                    ]
                )
            )
        }
    }
    
    override func setUp() {
        super.setUp()
        vc = AccountSummaryViewController()
        
        mockProfileManager = MockProfileManager()
        vc.profileManager = mockProfileManager
        
        mockAccountsManager = MockAccountsManager()
        vc.accountsManager = mockAccountsManager
    }

    func testTitleAndMessageForServerError() {
        let (title, message) = vc.titleAndMessageForTesting(for: .serverError)
        XCTAssertEqual(title, "Server Error")
        XCTAssertEqual(message, "Ensure you are connected to the internet. Please try again.")
    }
    
    func testTitleAndMessageForDecodingError() {
        let (title, message) = vc.titleAndMessageForTesting(for: .decodingError)
        XCTAssertEqual(title, "Decoding Error")
        XCTAssertEqual(message, "We could not process your request, Please try again.")
    }
    
    func testAlertForServerError() {
        let expectation = XCTestExpectation(description: "Wait for alert to be presented")
        
        mockProfileManager.error = .serverError
        
        DispatchQueue.main.async {
            self.vc.forceFetchProfile()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                XCTAssertEqual("Server Error", self.vc.errorAlert.title!)
                XCTAssertEqual("Ensure you are connected to the internet. Please try again.", self.vc.errorAlert.message!)
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testAlertForDecodingError() {
        let expectation = XCTestExpectation(description: "Wait for alert to be presented")
       
        mockAccountsManager.error = .decodingError
       
        DispatchQueue.main.async {
            self.vc.forceFetchAccounts()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                XCTAssertEqual("Decoding Error", self.vc.errorAlert.title!)
                XCTAssertEqual("We could not process your request, Please try again.", self.vc.errorAlert.message!)
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
}
