//
//  Model.swift
//  Wikipedia
//
//  Created by Patryk Maciąg on 13/05/2023.
//

import Foundation
import Combine

class Model: ObservableObject {
    fileprivate let httpManager: HTTPManager
    fileprivate let context = CoreDataManager.shared.context
    
    fileprivate var cancellables = Set<AnyCancellable>()
    fileprivate var searchQuery: String?
    

    @Published private(set) var searchResults = Array<String>()
    @Published private(set) var isCurrentyFetching = false
    @Published private(set) var history = Array<Page>() {
        didSet { if(history.count > 10) { deleteOldestRecod() }}
    }
    
    //MARK: Functions related to CoreDataManager
    func returnPageTitled(title: String) -> Page? {
        CoreDataManager.shared.returnPageTitled(title: title)
    }
    
    func deleteOldestRecod() {
        CoreDataManager.shared.deleteOldestRecord()
    }
    
    //Delates all data stored in Page data model
    func deleteAll() {
        CoreDataManager.shared.deleteAll()
    }
    
    //Fetches all data
    func fetchAllHistory() {
        self.history = CoreDataManager.shared.fetchFromStorage()
    }
    
    //MARK: Functions related to HTTPManager
    func searchQuery(_ query: String) {
        let url = httpManager.createURLToFetchPageTitled(query)
        if let url = url {
            self.isCurrentyFetching = true
            httpManager.fetchPageData(url)
                .sink(receiveCompletion: {completion in
                    switch(completion){
                    case .failure(_):
                        self.isCurrentyFetching = false
                    case .finished :
                        CoreDataManager.shared.persist()
                        self.history = CoreDataManager.shared.fetchFromStorage()
                        self.isCurrentyFetching = false
                    }
                }, receiveValue: { data in
                    let decoder = JSONDecoder()
                    decoder.userInfo[CodingUserInfoKey.context] = self.context
                    _ = try? decoder.decode(Page.self, from: data)
                })
                .store(in: &cancellables)
        }
    }
    
    //Fetches result similar to user input
    func fetchSearchResults(_ query: String) {
        guard query != "" else { return }
        
        let url = httpManager.createSearchQuery(query: query)
        if let url = url {
            httpManager.fetchSearchResults(url)
                .sink(receiveCompletion: { completion in
                    switch(completion) {
                    case .failure(_): self.isCurrentyFetching = false
                    case .finished: self.isCurrentyFetching = false
                    }
                }, receiveValue: { searchResults in
                    self.searchResults = searchResults
                })
                .store(in: &cancellables)
        }
    }
    
    //MARK: Initialiser
    init() {
        self.httpManager = HTTPManager()
    }
    
}


