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
    private var dataLoader: Services
    private var shouldUpdate = false
    private lazy var persistentContainer: NSPersistentContainer = {
        NSPersistentContainer(name: "ShortUrl")
    }()
    
    init(dataLoader: Services) {
        self.dataLoader = dataLoader
        NotificationCenter.default.addObserver(forName: .NSManagedObjectContextDidSave, object: persistentContainer.viewContext, queue: .main) { [weak self] _ in
            self?.fetchLinks()
        }
        NotificationCenter.default.addObserver(self, selector: #selector(self.deleteLink(_:)), name: Notification.Name.init("Delete"), object: nil)
        readStore()
    }
    
    func validateUrl (urlString: String?) -> Bool {
        let urlRegEx = "((?:http|https)://)?(?:\\w{1,9}\\.)?(?:\\w{1,9}\\.)?[\\w\\d\\-_]+\\.\\w{2,3}(\\.\\w{2})?(/(?<=/)(?:[\\w\\d\\-./_]+)?)?"
        return NSPredicate(format: "SELF MATCHES %@", urlRegEx).evaluate(with: urlString)
    }
    
    func shortURL(string: String) {
        let endPoint = HomeEndpoint(method: .get, path: "/v2/shorten", queryItems: [URLQueryItem(name: "url", value: string)], headers: nil, params: nil)//fullURlString = "\(newUrlString)\(string)"
        _ = dataLoader.getData(endPoint: endPoint, completion: {[weak self] (result: Result<ShortenResponse,Error>) in
            guard let self = self else {return}
            switch result {
            case .success(let data):
                guard let resultData = data.result else {return}
                self.shouldUpdate = true
                self.saveURL(shortenUrl: resultData)
            case .failure(let error):
                NotificationCenter.default.post(name: Notification.Name.init("NetworkError"), object: error)
                debugPrint(error.localizedDescription)
            }
        })
    }
    
    func saveURL(shortenUrl: ShortenResult) {
        let url = ShortUrl(context: persistentContainer.viewContext)
        url.code = shortenUrl.code
        url.fullShareLink = shortenUrl.fullShareLink
        url.fullShortLink = shortenUrl.fullShortLink
        url.fullShortLink2 = shortenUrl.fullShortLink2
        url.originalLink = shortenUrl.originalLink
        url.shareLink = shortenUrl.shareLink
        url.shortLink2 = shortenUrl.shortLink2
        
        do {
            try persistentContainer.viewContext.save()
        
        } catch {
            print("Unable to Save, \(error)")
        }
    }
    
    private func fetchLinks() {
        let fetchRequest: NSFetchRequest<ShortUrl> = ShortUrl.fetchRequest()
        
        persistentContainer.viewContext.perform { [weak self] in
            guard let self = self else {return}
            do {
                self.results = try fetchRequest.execute()
                if self.shouldUpdate {
                    NotificationCenter.default.post(name: Notification.Name.init("DataUpdated"), object: nil)
                }
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
        return [original,short]
    }
    
    func readStore() {
        persistentContainer.loadPersistentStores { [weak self] persistentStoreDescription, error in
            if let error = error {
                print("Unable to Add Persistent Store")
                print("\(error), \(error.localizedDescription)")
                
            } else {
                self?.fetchLinks()
            }
        }
    }
    
    @objc func deleteLink(_ notification: Notification) {
        let index = notification.object as! Int
        persistentContainer.viewContext.delete(results[index] as NSManagedObject)
        results.remove(at: index)
        
        let _ : NSError! = nil
        do {
            try  persistentContainer.viewContext.save()
        } catch {
            print("error : \(error)")
        }
    }
}
