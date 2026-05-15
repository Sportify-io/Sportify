//
//  Untitled.swift
//  Sportify
//
//  Created by Elsobky on 15/05/2026.
//

import XCTest
@testable import Sportify

final class TeamsServiceTests: XCTestCase {

    var sut: TeamsService!
    var mockAPIClient: MockAPIClient!

    override func setUp() {
        super.setUp()
        mockAPIClient = MockAPIClient()
        sut = TeamsService(apiClient: mockAPIClient)
    }

    override func tearDown() {
        sut = nil
        mockAPIClient = nil
        super.tearDown()
    }

    func test_getTeams_callsTeamsEndpointWithCorrectParams() {
        let expectedResponse = BaseResponse<[Team]>(success: 1, result: [])
        mockAPIClient.result = Result<BaseResponse<[Team]>, NetworkError>.success(expectedResponse)
        let expectation = expectation(description: "Wait")

        sut.getTeams(sport:.football, leagueId: 302) { _ in
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1)

        XCTAssertEqual(mockAPIClient.calledCount, 1)

        guard let endpoint = mockAPIClient.capturedEndpoint else {
            XCTFail("Endpoint not captured")
            return
        }

        if case let.teams(sport, leagueId) = endpoint {
            XCTAssertEqual(sport,.football)
            XCTAssertEqual(leagueId, 302)
        } else {
            XCTFail("Wrong endpoint type called")
        }
    }

    func test_getTeams_whenAPISucceeds_returnsTeams() {
        let players = [Player(playerKey: 1, playerName: "Salah", playerNumber: "11", playerCountry: "EG", playerType: "Forward", playerAge: "31", playerYellowCards: "2", playerRedCards: "0", playerRating: "8.5", playerImage: "url")]
        let teams = [Team(teamKey: 40, teamName: "Liverpool", teamLogo: "logo.png", players: players)]
        let response = BaseResponse<[Team]>(success: 1, result: teams)
        mockAPIClient.result = Result<BaseResponse<[Team]>, NetworkError>.success(response)
        let expectation = expectation(description: "Wait")

        sut.getTeams(sport:.football, leagueId: 302) { result in
            switch result {
            case.success(let data):
                XCTAssertEqual(data.success, 1)
                XCTAssertEqual(data.result?.count, 1)
                XCTAssertEqual(data.result?.first, teams.first)
            case.failure:
                XCTFail("Expected success")
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1)
    }

    func test_getTeams_whenAPIFails_returnsError() {
        mockAPIClient.result = Result<BaseResponse<[Team]>, NetworkError>.failure(.noInternet)
        let expectation = expectation(description: "Wait")

        sut.getTeams(sport:.football, leagueId: 302) { result in
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
