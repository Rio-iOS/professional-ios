import Foundation

protocol ProfileRepository: AnyObject {
    func fetchProfile(forUserID userID: String, completion: @escaping (Result<Profile, NetworkError>) -> Void)
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

final class ProfileManager: ProfileRepository {
    func fetchProfile(forUserID userID: String, completion: @escaping (Result<Profile, NetworkError>) -> Void) {
        let url = URL(string: "https://fierce-retreat-36855.herokuapp.com/bankey/profile/\(userID)")!
        URLSession.shared.dataTask(with: url) {
            data,
            response,
            error in
            guard let data, let response = response as? HTTPURLResponse, (200..<300).contains(response.statusCode),
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
