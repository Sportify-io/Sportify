//
//  FixturesServiceTests.swift
//  Sportify
//
//  Created by Elsobky on 15/05/2026.
//

import XCTest
@testable import Sportify

final class FixturesServiceTests: XCTestCase {

    var sut: FixturesService!
    var mockAPIClient: MockAPIClient!

    override func setUp() {
        super.setUp()
        mockAPIClient = MockAPIClient()
        sut = FixturesService(apiClient: mockAPIClient)
    }

    override func tearDown() {
        sut = nil
        mockAPIClient = nil
        super.tearDown()
    }

    func test_getFixtures_callsFixturesEndpointWithCorrectParams() {
        let fromDate = Date(timeIntervalSinceNow: 0)
        let toDate = Date(timeIntervalSinceNow: 86400*3)

        let expectedResponse = BaseResponse<[Event]>(success: 1, result: [])
        mockAPIClient.result = Result<BaseResponse<[Event]>, NetworkError>.success(expectedResponse)
        let expectation = expectation(description: "Wait")

        sut.getFixtures(sport:.football, leagueId: 4328, from: fromDate, to: toDate) { _ in
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1)

        XCTAssertEqual(mockAPIClient.calledCount, 1)

        guard let endpoint = mockAPIClient.capturedEndpoint else {
            return XCTFail("Endpoint not captured")
        }

        if case let.fixtures(sport, leagueId, from, to) = endpoint {
            XCTAssertEqual(sport,.football)
            XCTAssertEqual(leagueId, 4328)
            XCTAssertEqual(from, fromDate)
            XCTAssertEqual(to, toDate)
        } else {
            XCTFail("Wrong endpoint type called")
        }
    }

    func test_getFixtures_whenAPISucceeds_returnsEvents() {
        let events = [
            Event(
                eventDate: "2025-10-05",
                eventTime: "21:00",
                eventHomeTeam: "Liverpool",
                homeTeamLogo: "liverpool.png",
                eventAwayTeam: "Man City",
                awayTeamLogo: "city.png",
                eventFinalResult: "2-1"
            )
        ]
        let response = BaseResponse<[Event]>(success: 1, result: events)
        mockAPIClient.result = Result<BaseResponse<[Event]>, NetworkError>.success(response)
        let expectation = expectation(description: "Wait")

        sut.getFixtures(sport:.football, leagueId: 4328, from: Date(), to: Date()) { result in
            switch result {
            case.success(let data):
                XCTAssertEqual(data.success, 1)
                XCTAssertEqual(data.result?.count, 1)
                XCTAssertEqual(data.result?.first, events.first)
            case.failure:
                XCTFail("Expected success")
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1)
    }

    func test_getFixtures_whenAPIFails_returnsError() {
        mockAPIClient.result = Result<BaseResponse<[Event]>, NetworkError>.failure(.serverError("500"))
        let expectation = expectation(description: "Wait")

        sut.getFixtures(sport:.basketball, leagueId: 1, from: Date(), to: Date()) { result in
            switch result {
            case.success:
                XCTFail("Expected failure")
            case.failure(let error):
                if case.serverError(let msg) = error {
                    XCTAssertEqual(msg, "500")
                } else {
                    XCTFail("Wrong error type")
                }
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1)
    }
}
