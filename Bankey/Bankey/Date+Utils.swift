import Foundation

extension Date {
    static var bankeyDateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.timeZone = .init(abbreviation: "MDT")
        return formatter
    }
    
    var monthDayYearString: String {
        let dateFormatter =  Date.bankeyDateFormatter
        dateFormatter.dateFormat = "MMM d, yyyy"
        return dateFormatter.string(from: self)
    }
}
