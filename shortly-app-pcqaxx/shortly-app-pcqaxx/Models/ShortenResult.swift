//
//  ShortenResult.swift
//  shortly-app-pcqaxx
//
//  Created by kjoe on 9/9/21.
//

import Foundation
struct ShortenResponse : Codable {
    let ok : Bool?
    let result : ShortenResult?
    let error_code : Int?
    let error : String?

    enum CodingKeys: String, CodingKey {

        case ok = "ok"
        case result = "result"
        case error_code = "error_code"
        case error = "error"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        ok = try values.decodeIfPresent(Bool.self, forKey: .ok)
        result = try values.decodeIfPresent(ShortenResult.self, forKey: .result)
        error_code = try values.decodeIfPresent(Int.self, forKey: .error_code)
        error = try values.decodeIfPresent(String.self, forKey: .error)
    }

}
struct ShortenResult : Codable {
    let code : String?
    let short_link : String?
    let full_short_link : String?
    let short_link2 : String?
    let full_short_link2 : String?
    let share_link : String?
    let full_share_link : String?
    let original_link : String?

    enum CodingKeys: String, CodingKey {

        case code = "code"
        case short_link = "short_link"
        case full_short_link = "full_short_link"
        case short_link2 = "short_link2"
        case full_short_link2 = "full_short_link2"
        case share_link = "share_link"
        case full_share_link = "full_share_link"
        case original_link = "original_link"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        code = try values.decodeIfPresent(String.self, forKey: .code)
        short_link = try values.decodeIfPresent(String.self, forKey: .short_link)
        full_short_link = try values.decodeIfPresent(String.self, forKey: .full_short_link)
        short_link2 = try values.decodeIfPresent(String.self, forKey: .short_link2)
        full_short_link2 = try values.decodeIfPresent(String.self, forKey: .full_short_link2)
        share_link = try values.decodeIfPresent(String.self, forKey: .share_link)
        full_share_link = try values.decodeIfPresent(String.self, forKey: .full_share_link)
        original_link = try values.decodeIfPresent(String.self, forKey: .original_link)
    }

}
