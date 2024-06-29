//
//  ProfileManager.swift
//  Bankey
//
//  Created by 藤門莉生 on 2024/06/29.
//

import Foundation

protocol ProfileManagable: AnyObject {
    func fetchProfile(forUserId userId: String, completion: @escaping (Result<Profile, NetworkError>) -> Void)
}

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

class ProfileManager: ProfileManagable {
    func fetchProfile(forUserId userId: String, completion: @escaping (Result<Profile, NetworkError>) -> Void) {
        let url = URL(string: "https://fierce-retreat-36855.herokuapp.com/bankey/profile/\(userId)")!
        URLSession.shared.dataTask(with: url) {
            data,
            response,
            error in
            guard let data,
                  error == nil else {
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
