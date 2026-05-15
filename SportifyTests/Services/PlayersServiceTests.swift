//
//  PlayersServiceTests.swift
//  Sportify
//
//  Created by Elsobky on 15/05/2026.
//

import Foundation


import XCTest
@testable import Sportify

final class PlayersServiceTests: XCTestCase {

    var sut: PlayersService!
    var mockAPIClient: MockAPIClient!

    override func setUp() {
        super.setUp()
        mockAPIClient = MockAPIClient()
        sut = PlayersService(apiClient: mockAPIClient)
    }

    override func tearDown() {
        sut = nil
        mockAPIClient = nil
        super.tearDown()
    }

    func test_getPlayers_callsPlayersEndpointWithCorrectParams() {
        let expectedResponse = BaseResponse<[Player]>(success: 1, result: [])
        mockAPIClient.result = Result<BaseResponse<[Player]>, NetworkError>.success(expectedResponse)
        let expectation = expectation(description: "Wait")

        sut.getPlayers(sport:.football, teamId: 42) { _ in
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1)

        XCTAssertEqual(mockAPIClient.calledCount, 1)

        guard let endpoint = mockAPIClient.capturedEndpoint else {
            return XCTFail("Endpoint not captured")
        }
        
        if case let.players(sport, teamId) = endpoint {
            XCTAssertEqual(sport,.football)
            XCTAssertEqual(teamId, 42)
        } else {
            XCTFail("Wrong endpoint type called")
        }
    }

    func test_getPlayers_whenAPISucceeds_returnsPlayers() {
        let players = [
            Player(playerKey: 1, playerName: "Salah", playerNumber: "11",
                   playerCountry: "EG", playerType: "Forward", playerAge: "31",
                   playerYellowCards: "2", playerRedCards: "0", playerRating: "8.5",
                   playerImage: "url")
        ]
        let response = BaseResponse<[Player]>(success: 1, result: players)
        mockAPIClient.result = Result<BaseResponse<[Player]>, NetworkError>.success(response)
        let expectation = expectation(description: "Wait")

        sut.getPlayers(sport:.football, teamId: 42) { result in
            switch result {
            case.success(let data):
                XCTAssertEqual(data.success, 1)
                XCTAssertEqual(data.result?.count, 1)
                XCTAssertEqual(data.result?.first, players.first)
            case.failure:
                XCTFail("Expected success")
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1)
    }

    func test_getPlayers_whenResultIsNil_returnsNilResult() {
        let response = BaseResponse<[Player]>(success: 0, result: nil)
        mockAPIClient.result = Result<BaseResponse<[Player]>, NetworkError>.success(response)
        let expectation = expectation(description: "Wait")

        sut.getPlayers(sport:.basketball, teamId: 99) { result in
            switch result {
            case.success(let data):
                XCTAssertEqual(data.success, 0)
                XCTAssertNil(data.result)
            case.failure:
                XCTFail("Expected success with nil result")
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1)
    }

    func test_getPlayers_whenAPIFails_returnsError() {
        mockAPIClient.result = Result<BaseResponse<[Player]>, NetworkError>.failure(.noInternet)
        let expectation = expectation(description: "Wait")

        sut.getPlayers(sport:.football, teamId: 42) { result in
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
