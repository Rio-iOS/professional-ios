import Foundation

protocol AccountsRepository: AnyObject {
    func fetchAccounts(forUserID userID: String, completion: @escaping (Result<[Account], NetworkError>) -> Void)
}

struct Account: Codable {
    let id: String
    let type: AccountType
    let name: String
    let amount: Decimal
    let createdDateTime: Date

    static func makeSkeleton() -> Account {
        Account(
            id: "1",
            type: .banking,
            name: "Account name",
            amount: 0.0,
            createdDateTime: Date()
        )
    }
}

final class AccountsManager: AccountsRepository {
    func fetchAccounts(forUserID userID: String, completion: @escaping (Result<[Account], NetworkError>) -> Void) {
        let url = URL(string: "https://fierce-retreat-36855.herokuapp.com/bankey/profile/\(userID)/accounts")!

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data, let response = response as? HTTPURLResponse, (200..<300).contains(response.statusCode), error == nil else {
                completion(.failure(.serverError))
                return
            }

            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            do {
                let accounts = try decoder.decode([Account].self, from: data)
                completion(.success(accounts))
            } catch {
                completion(.failure(.decodingError))
                return
            }
        }.resume()
    }
}

// Preserve the service's wire values while following Swift enum-case naming.
enum AccountType: String, Codable {
    case banking = "Banking"
    case creditCard = "CreditCard"
    case investment = "Investment"
}
