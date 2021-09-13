//
//  ResultViewModel.swift
//  shortly-app-pcqaxx
//
//  Created by kjoe on 9/9/21.
//

import Foundation
import CoreData
class ResultViewModel {
    private var results: [ShortUrl] = []
    private var networkLoader: NetworkLoader
    private var managedObjectContext: NSManagedObjectContext?
    
    private lazy var persistentContainer: NSPersistentContainer = {
        NSPersistentContainer(name: "Short")
    }()
    
    init(networkLoader: NetworkLoader) {
        self.networkLoader = networkLoader
        NotificationCenter.default.addObserver(forName: .NSManagedObjectContextDidSave, object: persistentContainer.viewContext, queue: .main) { [weak self] _ in
            self?.fetchLinks()
        }
    }
    
    func validateUrl (urlString: String?) -> Bool {
        let urlRegEx = "(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+"
        return NSPredicate(format: "SELF MATCHES %@", urlRegEx).evaluate(with: urlString)
    }
    
    func shortURL(string: String) {
        do {
            let request = try createURLRequest(string: string)
            networkLoader.loadData(request: request, completion: {[weak self] result in
                switch result {
                case .success(let data):
                    if data.error == nil {
                        guard let resultData = data.result else { return }
                        self?.saveURL(shortenUrl: resultData)
                    }else {
                        NotificationCenter.default.post(name: Notification.Name.init("InvalidCall"), object: result)
                    }
                case .failure(let error):
                    NotificationCenter.default.post(name: Notification.Name.init("NetworkError"), object: error)
                    debugPrint(error.localizedDescription)
                }
            })
        }catch {
            NotificationCenter.default.post(name: Notification.Name.init("invalidURL"), object: nil)
        }
    }
    
    func createURLRequest(string: String) throws  -> URLRequest {
        guard let url = URL(string: string) else {
            fatalError("invalid URL")
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        return request
    }
    
    func saveURL(shortenUrl: ShortenResult) {
        guard let managedObjectContext = managedObjectContext else {
            fatalError("No Managed Object Context Available")
        }
        
        let url = ShortUrl(context: managedObjectContext)
        url.code = shortenUrl.code
        url.fullShareLink = shortenUrl.fullShareLink
        url.fullShortLink = shortenUrl.fullShortLink
        url.fullShortLink2 = shortenUrl.fullShortLink2
        url.originalLink = shortenUrl.originalLink
        url.shareLink = shortenUrl.shareLink
        url.shortLink2 = shortenUrl.shortLink2
        
        do {
            try managedObjectContext.save()
        
        } catch {
            print("Unable to Save Book, \(error)")
        }
    }
    
    private func fetchLinks() {
        let fetchRequest: NSFetchRequest<ShortUrl> = ShortUrl.fetchRequest()
        
        persistentContainer.viewContext.perform { [weak self] in
            guard let self = self else {return}
            do {
                self.results = try fetchRequest.execute()
                NotificationCenter.default.post(name: Notification.Name.init("DataUpdated"), object: nil)
            } catch {
                print("Unable to Execute Fetch Request, \(error)")
            }
        }
    }
    func numberOfRows() -> Int {
        return results.count
    }
    func cellData(index: Int) -> [String] {
        let short = results[index].fullShortLink?.replacingOccurrences(of: "\\", with: "") ?? ""
        let original = results[index].originalLink?.replacingOccurrences(of: "\\", with: "") ?? ""
        let code = results[index].code ?? ""
        return [original,short,code]
    }
}
