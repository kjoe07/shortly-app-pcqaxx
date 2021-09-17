//
//  ChallengeService.swift
//  shortly-app-pcqaxx
//
//  Created by kjoe on 9/17/21.
//

import Foundation
import Network
protocol Services{
    func getData<T:Codable>(endPoint: Endpoint,completion: @escaping (Result<T,Error>)-> Void)  -> NetworkCancelable?
}
class RemoteDataService:Services{
    var loader: DataLoader
    func getData<T:Codable>(endPoint: Endpoint, completion: @escaping (Result<T,Error>) -> Void) -> NetworkCancelable? {
        let r = try! Resquetable().createRequest(endPoint: endPoint)
        return loader.loadData(request: r, completion: {result in
            switch result{
            case .success(let d):
                do{
                    let resp = try JSONDecoder().decode(T.self, from: d)
                    //UserDefaults.standard.setValue(d, forKey: t ?? "ios")
                    completion(.success(resp))
                }catch{
                    completion(.failure(error))
                }
            case .failure(let e):
                completion(.failure(e))
            }
        })
    }
    
    init(loader: DataLoader) {
        self.loader = loader
    }
}
class LocalDataService: Services{
    func getData<T:Codable>(endPoint: Endpoint, completion: @escaping (Result<T, Error>) -> Void) -> NetworkCancelable? {
        return nil
    }
}

class RemoteLoaderWithLocalFeedBack: Services{
    var remote: RemoteDataService!
    var local: LocalDataService!
    var monitor: NetworkReachability
    func getData<T:Codable>(endPoint: Endpoint, completion: @escaping (Result<T, Error>) -> Void) -> NetworkCancelable? {
        if  monitor.isNetworkAvailable(){
            return remote.getData(endPoint: endPoint, completion: {(result: Result<T,Error>) in
                switch result{
                case.success(let d):
                    completion(.success(d))
                case .failure(let e):
                    completion(.failure(e))
                }
            })
        }else{
            return local.getData(endPoint: endPoint, completion: {(result: Result<T,Error>) in
                switch result{
                case .success(let d):
                    completion(.success(d))
                case .failure(let e):
                    completion(.failure(e))
                }
            })
        }
    }
    
    init(remote: RemoteDataService,local: LocalDataService, monitor: NetworkReachability) {
        self.remote = remote
        self.local = local
        self.monitor = monitor
    }
}
