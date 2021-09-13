//
//  ResultViewModelTest.swift
//  shortly-app-pcqaxxTests
//
//  Created by kjoe on 9/13/21.
//

import XCTest
@testable import shortly_app_pcqaxx
class ResultViewModelTest: XCTestCase {
    var sut: ResultViewModel!
    //let newUrlString = "https://api.shrtco.de/v2/shorten?url="
    override func setUpWithError() throws {
        let loader = NetworkLoader(session: URLSession.shared)
        sut = ResultViewModel(networkLoader: loader)
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func test_validURlIWithHttptisTrue() {
        let urlString = "http://finances.wikipedia.org/wiki/Fox_Broadcasting_Company"
        let result = sut.validateUrl(urlString: urlString)
        XCTAssertTrue(result)
    }
    func test_validURlIWithHttpstisTrue() {
        let urlString = "https://bpa.cu/example"
        let result = sut.validateUrl(urlString: urlString)
        XCTAssertTrue(result)
    }
    func test_NoUrlFormTestReturnFalse() {
        let urlString = "adasdaf fsfsfs"
        let result = sut.validateUrl(urlString: urlString)
        XCTAssertFalse(result)
    }
    func test_ValidURlWithNoHttpOrHttpsIsValid(){
        let urlString = "bpa.cu/example"
        let result = sut.validateUrl(urlString: urlString)
        XCTAssertTrue(result)
    }
    func test_InvalidStringbeginWithColonReturnFalse() {
        let urlString = "://bpa.cu/example"
        let result = sut.validateUrl(urlString: urlString)
        XCTAssertFalse(result)
    }
    func test_InvalidStringbeginWithDoubleSlashReturnFalse() {
        let urlString = "//bpa.cu/example"
        let result = sut.validateUrl(urlString: urlString)
        XCTAssertFalse(result)
    }
    func test_InvalidStringbeginWithSingleSlashReturnFalse() {
        let urlString = "//bpa.cu/example"
        let result = sut.validateUrl(urlString: urlString)
        XCTAssertFalse(result)
    }

    func test_createURLRequestWithValidURLIsNotNil() {
        let url = "\(sut.newUrlString)bpa.cu/example"
        do {
            let request = try sut.createURLRequest(string: url)
            XCTAssertNotNil(request)
        }catch{
            XCTAssertNil(error)
        }
    }

    

}
