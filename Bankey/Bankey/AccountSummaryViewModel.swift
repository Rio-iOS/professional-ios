import Foundation

/// 同じユーザーIDについて取得したプロフィールと口座一覧。
struct AccountSummary {
    let profile: Profile
    let accounts: [Account]
}

/// プロフィールと口座一覧を並行して取得し、両方の結果をメインキューで集約するUseCase。
final class FetchAccountSummaryUseCase {
    private let profiles: ProfileRepository
    private let accounts: AccountsRepository

    init(profiles: ProfileRepository, accounts: AccountsRepository) {
        self.profiles = profiles
        self.accounts = accounts
    }

    /// 両方の取得完了を待ち、成功時は集約結果を返します。両方が失敗した場合はプロフィール側のエラーを優先します。
    func execute(userID: String, completion: @escaping (Result<AccountSummary, NetworkError>) -> Void) {
        let group = DispatchGroup()
        // Both results are written and consumed on the main queue.
        var profileResult: Result<Profile, NetworkError>?
        var accountsResult: Result<[Account], NetworkError>?
        group.enter()
        profiles.fetchProfile(forUserID: userID) { result in
            DispatchQueue.main.async {
                profileResult = result
                group.leave()
            }
        }
        group.enter()
        accounts.fetchAccounts(forUserID: userID) { result in
            DispatchQueue.main.async {
                accountsResult = result
                group.leave()
            }
        }
        group.notify(queue: .main) {
            guard let profileResult = profileResult, let accountsResult = accountsResult else {
                completion(.failure(.serverError))
                return
            }
            completion(profileResult.flatMap { profile in
                accountsResult.map { AccountSummary(profile: profile, accounts: $0) }
            })
        }
    }
}

/// 口座一覧画面の読込状態を管理し、通信中の重複した読込要求を無視するViewModel。
final class AccountSummaryViewModel {
    enum State {
        case loading
        case loaded(AccountSummary)
        case failed(NetworkError)
    }

    var onStateChange: ((State) -> Void)?
    private let fetchSummary: FetchAccountSummaryUseCase
    private var isLoading = false

    init(fetchSummary: FetchAccountSummaryUseCase) {
        self.fetchSummary = fetchSummary
    }

    /// 指定したユーザーの取得を開始し、状態の変化を通知します。
    ///
    /// - Precondition: メインスレッドから呼び出してください。
    func load(userID: String) {
        guard !isLoading else { return }
        isLoading = true
        onStateChange?(.loading)
        fetchSummary.execute(userID: userID) { [weak self] result in
            guard let self = self else { return }
            self.isLoading = false
            switch result {
            case .success(let summary): self.onStateChange?(.loaded(summary))
            case .failure(let error): self.onStateChange?(.failed(error))
            }
        }
    }

    static func errorMessage(for error: NetworkError) -> (title: String, message: String) {
        switch error {
        case .serverError: return ("Server Error", "Ensure you are connected to the internet. Please try again.")
        case .decodingError: return ("Decoding Error", "We could not process your request, Please try again.")
        }
    }
}
