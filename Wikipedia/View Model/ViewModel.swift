//
//  ViewModel.swift
//  Wikipedia
//
//  Created by Patryk Maciąg on 12/05/2023.
//

import Foundation
import Combine

class ViewModel: ObservableObject {
    fileprivate let model: Model
    fileprivate var cancellables = Set<AnyCancellable>()
    
    //MARK: Input
    @Published var userInput: String = ""
    @Published var isSearchBarInUse = false
    
    
    //MARK: Properties used to drive UI
    @Published var content: String = ""
    
    //Returns user serch history
    var history: Array<Page> {
        model.history
    }
    
    //
    var isLoading: Bool {
        model.isCurrentyFetching
    }
    
    var searchResults: Array<String> {
        model.searchResults
    }
    
    
    //Change this as its not the best solution
    func fetchPageTitled(title: String) {
        if let page = model.returnPageTitled(title: title) {
            self.content = page.unwrappedContent
        } else {
            self.content = "Loading..."
            
            model.searchQuery(title)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                guard let page = self.model.returnPageTitled(title: title) else {
                    return
                }
                self.content = page.unwrappedContent
            })
        }
    }
    
    //Fetches user search history
    func fetchUserSearchHistory() {
        model.fetchAllHistory()
    }
    
    //Deletes all user search history
    func deleteAll() {
        model.deleteAll()
    }
    
    //MARK: Initialiser used to drive app UI
    init() {
        self.model = Model()
        
        $userInput
            .debounce(for: .seconds(0.3), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .print("User input value")
            .sink{ newValue in
                self.model.fetchSearchResults(newValue)
            }
            .store(in: &cancellables)
        
        model.$isCurrentyFetching
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in self?.objectWillChange.send() }
            .store(in: &cancellables)
        
        model.$searchResults
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in self?.objectWillChange.send() }
            .store(in: &cancellables)
        
        model.$history
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in self?.objectWillChange.send() }
            .store(in: &cancellables)
    }
}
