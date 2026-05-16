//
//  PlayerServiceTests.swift
//  SportifyTests
//
//  Created by Tasneem Hakeem on 15/05/2026.
//

import XCTest
@testable import Sportify

final class PlayersServiceTests: XCTestCase {

    var playerService: PlayersService!
    var mockAPIClient: MockAPIClient!

    override func setUp() {
        super.setUp()
        mockAPIClient = MockAPIClient()
        playerService = PlayersService(apiClient: mockAPIClient)
    }

    override func tearDown() {
        playerService = nil
        mockAPIClient = nil
        super.tearDown()
    }

    private func makePlayer(
        key: Int = 10,
        name: String? = "Lionel Messi"
    ) -> Player {
        Player(
            playerKey: key,
            playerName: name,
            playerNumber: "10",
            playerCountry: "Argentina",
            playerType: "Attackers",
            playerAge: "37",
            playerYellowCards: "1",
            playerRedCards: "0",
            playerRating: "9.0",
            playerImage: "https://example.com/player.png"
        )
    }

    func test_getPlayers_callsAPIClientOnce() {
        mockAPIClient.result = Result<BaseResponse<[Player]>, NetworkError>
            .success(BaseResponse(success: 1, result: []))

        playerService.getPlayers(sport: .football, teamId: 1) { _ in }

        XCTAssertEqual(mockAPIClient.calledCount, 1)
    }

    func test_getPlayers_passesCorrectEndpoint() {
        let expectedSport = APISport.football
        let expectedTeamId = 42

        mockAPIClient.result = Result<BaseResponse<[Player]>, NetworkError>
            .success(BaseResponse(success: 1, result: []))

        playerService.getPlayers(sport: expectedSport, teamId: expectedTeamId) { _ in }

        guard case .players(let sport, let teamId) = mockAPIClient.capturedEndpoint else {
            return XCTFail("Expected .players endpoint, got \(String(describing: mockAPIClient.capturedEndpoint))")
        }

        XCTAssertEqual(sport, expectedSport)
        XCTAssertEqual(teamId, expectedTeamId)
    }

    func test_getPlayers_onSuccess_returnsPlayers() {
        let expectedPlayers = [
            makePlayer(key: 10, name: "Messi"),
            makePlayer(key: 7, name: "Ronaldo")
        ]

        mockAPIClient.result = Result<BaseResponse<[Player]>, NetworkError>
            .success(BaseResponse(success: 1, result: expectedPlayers))

        let expectation = expectation(description: "completion called")
        var receivedPlayers: [Player]?

        
        playerService.getPlayers(sport: .football, teamId: 1) { result in
            if case .success(let response) = result {
                receivedPlayers = response.result
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1)
        XCTAssertEqual(receivedPlayers, expectedPlayers)
    }

    func test_getPlayers_onSuccess_returnsEmptyList() {
        mockAPIClient.result = Result<BaseResponse<[Player]>, NetworkError>
            .success(BaseResponse(success: 1, result: []))

        let expectation = expectation(description: "completion called")
        var receivedPlayers: [Player]?

        playerService.getPlayers(sport: .football, teamId: 1) { result in
            if case .success(let response) = result {
                receivedPlayers = response.result
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1)
        XCTAssertEqual(receivedPlayers, [])
    }

    func test_getPlayers_onSuccess_playerWithNilFields() {
        let player = makePlayer(key: 1, name: nil)

        mockAPIClient.result = Result<BaseResponse<[Player]>, NetworkError>
            .success(BaseResponse(success: 1, result: [player]))

        let expectation = expectation(description: "completion called")
        var receivedPlayer: Player?

        playerService.getPlayers(sport: .football, teamId: 1) { result in
            if case .success(let response) = result {
                receivedPlayer = response.result?.first
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1)
        XCTAssertNil(receivedPlayer?.playerName)
    }

    func test_getPlayers_onServerError_returnsFailure() {
        let expectedError = NetworkError.serverError("Internal Server Error")

        mockAPIClient.result = Result<BaseResponse<[Player]>, NetworkError>
            .failure(expectedError)

        let expectation = expectation(description: "completion called")
        var receivedError: NetworkError?

        playerService.getPlayers(sport: .football, teamId: 1) { result in
            if case .failure(let error) = result {
                receivedError = error
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1)
        XCTAssertEqual(receivedError, expectedError)
    }

    func test_getPlayers_completionCalledExactlyOnce() {
        mockAPIClient.result = Result<BaseResponse<[Player]>, NetworkError>
            .success(BaseResponse(success: 1, result: []))

        var callCount = 0
        let expectation = expectation(description: "completion called")
        expectation.expectedFulfillmentCount = 1
        expectation.assertForOverFulfill = true

        playerService.getPlayers(sport: .football, teamId: 1) { _ in
            callCount += 1
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1)
        XCTAssertEqual(callCount, 1)
    }
}
