/* 
Copyright (c) 2019 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct Data : Codable {
	let review_id : Int?
	let rating : String?
	let title : String?
	let message : String?
	let author : String?
	let foreignLanguage : Bool?
	let date : String?
	let date_unformatted : Date_unformatted?
	let languageCode : String?
	let traveler_type : String?
	let reviewerName : String?
	let reviewerCountry : String?
	let reviewerProfilePhoto : String?
	let isAnonymous : Bool?
	let firstInitial : String?

	enum CodingKeys: String, CodingKey {

		case review_id = "review_id"
		case rating = "rating"
		case title = "title"
		case message = "message"
		case author = "author"
		case foreignLanguage = "foreignLanguage"
		case date = "date"
		case date_unformatted = "date_unformatted"
		case languageCode = "languageCode"
		case traveler_type = "traveler_type"
		case reviewerName = "reviewerName"
		case reviewerCountry = "reviewerCountry"
		case reviewerProfilePhoto = "reviewerProfilePhoto"
		case isAnonymous = "isAnonymous"
		case firstInitial = "firstInitial"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		review_id = try values.decodeIfPresent(Int.self, forKey: .review_id)
		rating = try values.decodeIfPresent(String.self, forKey: .rating)
		title = try values.decodeIfPresent(String.self, forKey: .title)
		message = try values.decodeIfPresent(String.self, forKey: .message)
		author = try values.decodeIfPresent(String.self, forKey: .author)
		foreignLanguage = try values.decodeIfPresent(Bool.self, forKey: .foreignLanguage)
		date = try values.decodeIfPresent(String.self, forKey: .date)
		date_unformatted = try values.decodeIfPresent(Date_unformatted.self, forKey: .date_unformatted)
		languageCode = try values.decodeIfPresent(String.self, forKey: .languageCode)
		traveler_type = try values.decodeIfPresent(String.self, forKey: .traveler_type)
		reviewerName = try values.decodeIfPresent(String.self, forKey: .reviewerName)
		reviewerCountry = try values.decodeIfPresent(String.self, forKey: .reviewerCountry)
		reviewerProfilePhoto = try values.decodeIfPresent(String.self, forKey: .reviewerProfilePhoto)
		isAnonymous = try values.decodeIfPresent(Bool.self, forKey: .isAnonymous)
		firstInitial = try values.decodeIfPresent(String.self, forKey: .firstInitial)
	}

}