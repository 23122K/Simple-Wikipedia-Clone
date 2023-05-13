//
//  HTTPManager.swift
//  Wikipedia
//
//  Created by Patryk Maciąg on 13/05/2023.
//

import Combine
import Foundation

class HTTPManager: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    
    //Wikipedia API error response structure
    private struct APIErrorResponse: Codable {
        let code: String
        let info: String
    }
    
    
    private enum APIError: LocalizedError {
        case invalidResponse    ///Response not from <200,300> rage
        case decodingError      ///Recived JSON could not be doecoded
        
        var errorDescription: String? {
            switch self {
            case .invalidResponse:
                return "Invalid response"
            case .decodingError:
                return "JSON coud not be decoded"
            }
        }
    }
    
    //MARK: Functions used to create queries
    private func coreURLComponents() -> URLComponents{
        var components = URLComponents()
        components.scheme = "https"
        components.host = "en.wikipedia.org"
        components.path = "/w/api.php"
        
        components.queryItems = [
            URLQueryItem(name: "action", value: "query"),
            URLQueryItem(name: "format", value: "json"),
            URLQueryItem(name: "exintro", value: "true"),
            URLQueryItem(name: "explaintext", value: "true")
        ]
        
        return components
    }
    
    
    func createURLToFetchPageTitled(_ title: String) -> URL?{
        var components = coreURLComponents()
        
        let queryItems = [
            URLQueryItem(name: "prop", value: "extracts"), //extracts|pageimages
            URLQueryItem(name: "titles", value: title)
        ]
        
        components.queryItems! += queryItems
        return components.url
    }
    
    func createSearchQuery(query: String) -> URL?{
        var components = coreURLComponents()
        
        let queryItems = [
            URLQueryItem(name: "generator", value: "search"),
            URLQueryItem(name: "gsrsearch", value: "<\(query)>"),
            URLQueryItem(name: "gsrlimit", value: "5")
        ]
        
        components.queryItems! += queryItems
        return components.url
    }
    
    //MARK: Publishers used to fetch data from server
    
    //Establishes a connection to the server, if succedes publishes undecoded data further
    private func fetchDataFrom(_ url: URL) -> AnyPublisher<Data, Error> {
        URLSession.shared.dataTaskPublisher(for: url)
            .tryMap({ data, response in
                guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                    throw APIError.invalidResponse
                }
                return data
            })
            .eraseToAnyPublisher()
    }
    
    //Matches page titles from search query, if found returns array of closely matching titles
    func fetchSearchResults(_ url: URL) -> AnyPublisher<[String], Error> {
        fetchDataFrom(url)
            .tryMap { data -> [String] in
                let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
                guard let result = jsonObject as? [String: Any],
                      let query = result["query"] as? [String: Any],
                      let pages = query["pages"] as? [String: Any] else {
                    throw APIError.decodingError
                }
                
                var titles: [String] = []
                for key in pages.keys {
                    if let page = pages[key] as? [String: Any], let title = page["title"] as? String {
                        titles.append(title)
                    }
                }
                return titles
            }
            .eraseToAnyPublisher()
    }
    
    //Fetches data from page (eg. title, description)
    func fetchPageData(_ url: URL) -> AnyPublisher<Data, Error> {
        fetchDataFrom(url)
            .tryMap { data -> [String: Any] in
                let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
                guard let result = jsonObject as? [String: Any],
                      let query = result["query"] as? [String: Any],
                      let pages = query["pages"] as? [String: Any],
                      let firstPageId = pages.keys.first,
                      let page = pages[firstPageId] as? [String: Any] else {
                    throw APIError.decodingError
                }
                return page
            }
            .tryMap { page -> Data in
                let data = try JSONSerialization.data(withJSONObject: page, options: [])
                return data
            }
            .eraseToAnyPublisher()
    }
}
