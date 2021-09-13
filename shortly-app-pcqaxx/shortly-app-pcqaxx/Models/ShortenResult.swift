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
    let shortLink : String?
    let fullShortLink : String?
    let shortLink2 : String?
    let fullShortLink2 : String?
    let shareLink : String?
    let fullShareLink : String?
    let originalLink : String?

    enum CodingKeys: String, CodingKey {

        case code = "code"
        case shortLink = "short_link"
        case fullShortLink = "full_short_link"
        case shortLink2 = "short_link2"
        case fullShortLink2 = "full_short_link2"
        case shareLink = "share_link"
        case fullShareLink = "full_share_link"
        case originalLink = "original_link"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        code = try values.decodeIfPresent(String.self, forKey: .code)
        shortLink = try values.decodeIfPresent(String.self, forKey: .shortLink)
        fullShortLink = try values.decodeIfPresent(String.self, forKey: .fullShortLink)
        shortLink2 = try values.decodeIfPresent(String.self, forKey: .shortLink2)
        fullShortLink2 = try values.decodeIfPresent(String.self, forKey: .fullShortLink2)
        shareLink = try values.decodeIfPresent(String.self, forKey: .shareLink)
        fullShareLink = try values.decodeIfPresent(String.self, forKey: .fullShareLink)
        originalLink = try values.decodeIfPresent(String.self, forKey: .originalLink)
    }

}
