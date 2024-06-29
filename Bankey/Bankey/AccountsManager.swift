//
//  AccountsManager.swift
//  Bankey
//
//  Created by 藤門莉生 on 2024/06/29.
//

import Foundation

protocol AccountsManagable: AnyObject {
    func fetchAccounts(forUserId userId: String, completion: @escaping (Result<[Account], NetworkError>) -> Void)
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
            type: .Banking,
            name: "Account name",
            amount: 0.0,
            createdDateTime: Date()
        )
    }
}

class AccountsManager: AccountsManagable {
    func fetchAccounts(forUserId userId: String, completion: @escaping (Result<[Account], NetworkError>) -> Void) {
        let url = URL(string: "https://fierce-retreat-36855.herokuapp.com/bankey/profile/\(userId)/accounts")!
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data, error == nil else {
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
