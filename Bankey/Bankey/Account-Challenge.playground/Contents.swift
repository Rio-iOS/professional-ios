import Foundation

let json = """
    [
        {
            "id": "1",
            "type": "Banking",
            "name": "Basic Savings",
            "amount": 929466.23,
            "createdDateTime": "2010-06-21T15:29:32Z"
        },
        {
            "id": "2",
            "type": "Banking",
            "name": "No-Free All-In Chequing",
            "amount": 17562.44,
            "createdDateTime": "2011-06-21T15:29:32Z"
        },
    ]
"""

enum AccountType: String, Codable {
    case Banking
    case CredeitCard
    case Investment
}

struct Account: Codable {
    let id: String
    let type: AccountType
    let name: String
    let amount: Decimal
    let createdDateTime: Date
}

let jsonData = json.data(using: .utf8)!

let decoder = JSONDecoder()
decoder.dateDecodingStrategy = .iso8601
do {
    let accounts = try decoder.decode([Account].self, from: jsonData)
    print(accounts)
} catch {
    print(error)
}
