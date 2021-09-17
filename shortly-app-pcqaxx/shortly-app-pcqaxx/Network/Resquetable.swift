//
//  REsquetable.swift
//  shortly-app-pcqaxx
//
//  Created by kjoe on 9/17/21.
//

import Foundation
struct Resquetable{
    func createRequest(endPoint: Endpoint) throws -> URLRequest{
        guard let url = endPoint.url else {throw customError.badRequest}
        var request = URLRequest(url: url)
        request.httpMethod = endPoint.method.rawValue
        if endPoint.headers != nil{
            for (h,v) in endPoint.headers!{
                request.addValue(v, forHTTPHeaderField: h)
            }
        }
        if endPoint.params != nil{
            let httpBody = try! JSONSerialization.data(withJSONObject: endPoint.params ?? [:], options: [])
            request.httpBody = httpBody
            if endPoint.headers?["Content-Type"] == "application/x-www-form-urlencoded" {
                let jsonString = endPoint.params?.reduce("") { "\($0)\($1.0)=\($1.1)&" }.dropLast()
                let jsonData = jsonString?.data(using: .utf8, allowLossyConversion: false)!
                request.httpBody = jsonData
            }
        }
        return request
    }
}
