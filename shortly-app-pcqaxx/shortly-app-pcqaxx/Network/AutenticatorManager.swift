//
//  AutenticatorManager.swift
//  shortly-app-pcqaxx
//
//  Created by kjoe on 9/17/21.
//

import Foundation
class AuthenticatorManager{
    static let shared = AuthenticatorManager()
    
    func authenticaApp() {
        // TODO - Not needed unlesss some requets need some Autentication with JWT Token or someThing like
        
//        let dataLoader = NetworkLoader(session: URLSession.shared)
//        let challengeService = RemoteDataService(loader: dataLoader)
//        let qItems = [URLQueryItem(name: "operation", value: "getchallenge"),URLQueryItem(name: "username", value: "prueba")]
//        let challengeEndpoint = HomeEndpoint(method: .get , path: "/datacrm/pruebatecnica/webservice.php", queryItems: qItems, headers: nil, params: nil)
//        let challengeTask = challengeService.getData(endPoint: challengeEndpoint, completion: { (result: Result<GetChallengeResult,Error>) in
//            switch result {
//            case .success(let data):
//                if !KeychainService.savePassword(service: "PTecnica", account: "token", data: data.result?.token ?? "") {
//                    KeychainService.updatePassword(service: "PTecnica", account: "token", data: data.result?.token ?? "")
//                }
//                NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "challengeResponse"), object: data)
//            case .failure(let error):
//                NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "challengeFailed"), object: error)
//            }
//        })
    }
    
    
}
