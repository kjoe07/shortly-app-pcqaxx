//
//  Network.swift
//  shortly-app-pcqaxx
//
//  Created by kjoe on 9/12/21.
//

import Foundation
struct NetworkLoader{
    let session: URLSession
    
    func loadData(request: URLRequest?, completion: @escaping (Result<ShortenResponse,Error>) -> Void) {
        guard let request = request else { return }
        let task = session.dataTask(with: request){data,response,error in
            if error != nil{
                guard let error = error else { return }
                completion(.failure(error))
            }else {
                guard let data = data else {return}
                do {
                    let response = try JSONDecoder().decode(ShortenResponse.self, from: data)    
                    completion(.success(response))
                }catch {
                    completion(.failure(error))
                }
                //completion(.success(data))
                
            }
        }
        task.resume()
    }
    
    init(session: URLSession) {
        self.session = session
    }
}
