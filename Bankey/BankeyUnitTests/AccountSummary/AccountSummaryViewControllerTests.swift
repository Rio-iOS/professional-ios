import XCTest
#if canImport(BankeyCore)
@testable import BankeyCore
#else
@testable import Bankey
#endif

final class AccountSummaryViewModelTests: XCTestCase {
    func testErrorMessages() {
        XCTAssertEqual(AccountSummaryViewModel.errorMessage(for: .serverError).title, "Server Error")
        XCTAssertEqual(AccountSummaryViewModel.errorMessage(for: .decodingError).title, "Decoding Error")
    }

    func testSummaryWaitsForBothRequestsAndCompletesOnMainThread() {
        let profiles = ProfileStub()
        let accounts = AccountsStub()
        let useCase = FetchAccountSummaryUseCase(profiles: profiles, accounts: accounts)
        let finished = expectation(description: "Both results received")
        useCase.execute(userID: "42") { result in
            XCTAssertTrue(Thread.isMainThread)
            guard case .success(let summary) = result else { return XCTFail() }
            XCTAssertEqual(summary.profile.id, "42")
            XCTAssertEqual(summary.accounts.count, 0)
            finished.fulfill()
        }
        XCTAssertEqual(profiles.requestedUserID, "42")
        XCTAssertEqual(accounts.requestedUserID, "42")
        accounts.completion?(.success([]))
        profiles.completion?(.success(Profile(id: "42", firstName: "Rio", lastName: "Sample")))
        wait(for: [finished], timeout: 2)
    }

    func testFailureIsForwardedAndRetryIsAllowed() {
        let profiles = ProfileStub()
        let accounts = AccountsStub()
        let viewModel = AccountSummaryViewModel(fetchSummary: FetchAccountSummaryUseCase(profiles: profiles, accounts: accounts))
        let failed = expectation(description: "Failure presented")
        viewModel.onStateChange = { state in
            if case .failed(.decodingError) = state { failed.fulfill() }
        }
        viewModel.load(userID: "1")
        profiles.completion?(.failure(.decodingError))
        accounts.completion?(.success([]))
        wait(for: [failed], timeout: 2)
        viewModel.load(userID: "1")
        XCTAssertEqual(profiles.requestCount, 2)
    }

    func testDuplicateLoadDoesNotStartMoreRequests() {
        let profiles = ProfileStub()
        let accounts = AccountsStub()
        let viewModel = AccountSummaryViewModel(fetchSummary: FetchAccountSummaryUseCase(profiles: profiles, accounts: accounts))
        viewModel.load(userID: "1")
        viewModel.load(userID: "1")
        XCTAssertEqual(profiles.requestCount, 1)
        XCTAssertEqual(accounts.requestCount, 1)
    }

    func testPendingRequestsDoNotRetainViewModel() {
        let profiles = ProfileStub()
        let accounts = AccountsStub()
        var viewModel: AccountSummaryViewModel? = AccountSummaryViewModel(fetchSummary: FetchAccountSummaryUseCase(profiles: profiles, accounts: accounts))
        weak var reference = viewModel
        viewModel?.load(userID: "1")
        viewModel = nil
        XCTAssertNil(reference)
        profiles.completion?(.failure(.serverError))
        accounts.completion?(.success([]))
    }

    func testAccountTypeKeepsServiceWireValues() throws {
        let type = try JSONDecoder().decode(AccountType.self, from: Data("\"CreditCard\"".utf8))
        XCTAssertEqual(type, .creditCard)
        XCTAssertEqual(String(decoding: try JSONEncoder().encode(type), as: UTF8.self), "\"CreditCard\"")
    }
}

private final class ProfileStub: ProfileRepository {
    private(set) var requestedUserID: String?
    private(set) var requestCount = 0
    var completion: ((Result<Profile, NetworkError>) -> Void)?
    func fetchProfile(forUserID userID: String, completion: @escaping (Result<Profile, NetworkError>) -> Void) {
        requestedUserID = userID
        requestCount += 1
        self.completion = completion
    }
}

private final class AccountsStub: AccountsRepository {
    private(set) var requestedUserID: String?
    private(set) var requestCount = 0
    var completion: ((Result<[Account], NetworkError>) -> Void)?
    func fetchAccounts(forUserID userID: String, completion: @escaping (Result<[Account], NetworkError>) -> Void) {
        requestedUserID = userID
        requestCount += 1
        self.completion = completion
    }
}
