//
//  AccountSummaryViewController+Networking.swift
//  Bankey
//
//  Created by 藤門莉生 on 2024/06/27.
//

import Foundation
import UIKit

enum NetworkError: Error {
    case serverError
    case decodingError
}

struct Profile: Codable {
    let id: String
    let firstName: String
    let lastName: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
    }
}

extension AccountSummaryViewController {
    func fetchProfile(forUserId userId: String, completion: @escaping (Result<Profile, NetworkError>) -> Void) {
        let url = URL(string: "https://fierce-retreat-36855.herokuapp.com/bankey/profile/\(userId)")!
        URLSession.shared.dataTask(with: url) {
            data,
            response,
            error in
            guard let data,
                  error == nil else {
                print(error?.localizedDescription)
                completion(.failure(.serverError))
                return
            }
           
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            do {
                let profile = try decoder.decode(Profile.self, from: data)
                completion(.success(profile))
            } catch {
                print(error.localizedDescription)
                completion(.failure(.decodingError))
                return
            }
        }.resume()
    }
}

struct Account: Codable {
    let id: String
    let type: AccountType
    let name: String
    let amount: Decimal
    let createdDateTime: Date
}

extension AccountSummaryViewController {
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
