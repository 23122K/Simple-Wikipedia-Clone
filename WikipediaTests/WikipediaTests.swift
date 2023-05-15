//
//  WikipediaTests.swift
//  WikipediaTests
//
//  Created by Patryk Maciąg on 15/05/2023.
//

import Combine
import XCTest
@testable import Wikipedia

//Naming structure, name should be self explainatory
//Blueprint of naming test_<Unit Of Work>_<State under test>_<Expected Behavior>
//Testing structure: Given, When, Then

final class WikipediaTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    //MARK: HTTPManager tests

    func test_HTTPManager_URLCreationToFetchPageData_ShouldReturnValidURL() {
        //Given
        let pageTitle: String = "Apple"
        let httpmanager = Wikipedia.HTTPManager()
        //When
        
        let url = httpmanager.createURLToFetchPageTitled(pageTitle)
        //Then
        XCTAssertNotNil(url)
    }
    
    
    func test_Model_SearchResults_ShouldReturnEmptyArray() {
        //Given
        //When
        let model = Model()
        //Then
        XCTAssertEqual(model.searchResults.count, 0)
    }
    
    func test_Model_SearchResults_ShotNotBeEmpty() {
        let model = Model()
        var cancellables = Set<AnyCancellable>()
        
        let expectation = XCTestExpectation(description: "Should return data")
        
        model.$searchResults
            .dropFirst()
            .sink { _ in
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        model.fetchSearchResults("Poland")
        wait(for: [expectation], timeout: 1)
        XCTAssertGreaterThan(model.searchResults.count, 0)
    }
    
    

}
