//
//   let welcome = try? newJSONDecoder().decode(Review.self, from: jsonData)

import Foundation

// MARK: - Review
struct Review: Codable {
    let status: Bool
    let totalReviewsComments: Int
    let data: [Datum]
    
    enum CodingKeys: String, CodingKey {
        case status
        case totalReviewsComments = "total_reviews_comments"
        case data
    }
}

// MARK: - Datum
struct Datum: Codable {
    let reviewID: Int
    let rating: String
    let title: String?
    let message, author: String
    let foreignLanguage: Bool
    let date: String
    let dateUnformatted: DateUnformatted
    let languageCode: LanguageCode
    let travelerType: String?
    let reviewerName: String
    let reviewerCountry: ReviewerCountry
    let reviewerProfilePhoto: String?
    let isAnonymous: Bool
    let firstInitial: String
    
    enum CodingKeys: String, CodingKey {
        case reviewID = "review_id"
        case rating, title, message, author, foreignLanguage, date
        case dateUnformatted = "date_unformatted"
        case languageCode
        case travelerType = "traveler_type"
        case reviewerName, reviewerCountry, reviewerProfilePhoto, isAnonymous, firstInitial
    }
}

// MARK: - DateUnformatted
struct DateUnformatted: Codable {
}

enum LanguageCode: String, Codable {
    case de = "de"
}

enum ReviewerCountry: String, Codable {
    case germany = "Germany"
    case switzerland = "Switzerland"
}
