//
//  Untitled.swift
//  Sportify
//
//  Created by Elsobky on 15/05/2026.
//

import XCTest
@testable import Sportify

final class LeaguesServiceTests: XCTestCase {

    var sut: LeaguesService!
    var mockAPIClient: MockAPIClient!

    override func setUp() {
        super.setUp()
        mockAPIClient = MockAPIClient()
        sut = LeaguesService(apiClient: mockAPIClient)
    }

    override func tearDown() {
        sut = nil
        mockAPIClient = nil
        super.tearDown()
    }

    func test_getLeagues_callsLeaguesEndpointWithCorrectSport() {
        let expectedResponse = BaseResponse<[League]>(success: 1, result: [])
        mockAPIClient.result = Result<BaseResponse<[League]>, NetworkError>.success(expectedResponse)
        let expectation = expectation(description: "Wait")

        sut.getLeagues(sport:.football) { _ in
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1)

        XCTAssertEqual(mockAPIClient.calledCount, 1)

        guard let endpoint = mockAPIClient.capturedEndpoint else {
            return XCTFail("Endpoint not captured")
        }

        if case let.leagues(sport) = endpoint {
            XCTAssertEqual(sport,.football)
        } else {
            XCTFail("Wrong endpoint type called")
        }
    }

    func test_getLeagues_whenAPISucceeds_returnsLeagues(){
        let leagues = [
            League(
                leagueKey: 302,
                leagueName: "Premier League",
                countryName: "England",
                leagueImageURL: "pl.png",
                countryImageURL: "eng.png"
            )
        ]
        let response = BaseResponse<[League]>(success: 1, result: leagues)
        mockAPIClient.result = Result<BaseResponse<[League]>, NetworkError>.success(response)
        let expectation = expectation(description: "Wait")

        sut.getLeagues(sport:.football) { result in
            switch result {
            case.success(let data):
                XCTAssertEqual(data.success, 1)
                XCTAssertEqual(data.result?.count, 1)
                XCTAssertEqual(data.result?.first, leagues.first)
            case.failure:
                XCTFail("Expected success")
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1)
    }

    func test_getLeagues_whenResultIsEmpty_returnsEmptyArray() {
        let response = BaseResponse<[League]>(success: 1, result: [])
        mockAPIClient.result = Result<BaseResponse<[League]>, NetworkError>.success(response)
        let expectation = expectation(description: "Wait")

        sut.getLeagues(sport:.basketball) { result in
            switch result {
            case.success(let data):
                XCTAssertEqual(data.result?.count, 0)
            case.failure:
                XCTFail("Expected success")
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1)
    }

    func test_getLeagues_whenAPIFails_returnsError() {
        mockAPIClient.result = Result<BaseResponse<[League]>, NetworkError>.failure(.noInternet)
        let expectation = expectation(description: "Wait")

        sut.getLeagues(sport:.football) { result in
            switch result {
            case.success:
                XCTFail("Expected failure")
            case.failure(let error):
                XCTAssertEqual(error,.noInternet)
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1)
    }
}
