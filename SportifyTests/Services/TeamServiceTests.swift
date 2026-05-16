//
//  TeamServiceTests.swift
//  SportifyTests
//
//  Created by Tasneem Hakeem on 15/05/2026.
//

import XCTest
@testable import Sportify

final class TeamsServiceTests: XCTestCase {

    var teamService: TeamsService!
    var mockAPIClient: MockAPIClient!

    override func setUp() {
        super.setUp()
        mockAPIClient = MockAPIClient()
        teamService = TeamsService(apiClient: mockAPIClient)
    }

    override func tearDown() {
        teamService = nil
        mockAPIClient = nil
        super.tearDown()
    }

    private func makeTeam(
        key: Int = 1,
        name: String? = "FC Barcelona",
        logo: String? = "https://example.com/logo.png",
        players: [Player]? = nil
    ) -> Team {
        Team(teamKey: key, teamName: name, teamLogo: logo, players: players)
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

    func test_getTeams_callsAPIClientOnce() {
        let response = BaseResponse<[Team]>(success: 1, result: [])
        mockAPIClient.result = Result<BaseResponse<[Team]>, NetworkError>.success(response)

        teamService.getTeams(sport: .football, leagueId: 1) { _ in }

        XCTAssertEqual(mockAPIClient.calledCount, 1)
    }

    func test_getTeams_passesCorrectEndpoint_football() {
        let expectedSport = APISport.football
        let expectedLeagueId = 42
        mockAPIClient.result = Result<BaseResponse<[Team]>, NetworkError>
            .success(BaseResponse(success: 1, result: []))

        teamService.getTeams(sport: expectedSport, leagueId: expectedLeagueId) { _ in }

        guard case .teams(let sport, let leagueId) = mockAPIClient.capturedEndpoint else {
            return XCTFail("Expected .teams endpoint, got \(String(describing: mockAPIClient.capturedEndpoint))")
        }
        XCTAssertEqual(sport, expectedSport)
        XCTAssertEqual(leagueId, expectedLeagueId)
    }

    func test_getTeams_passesCorrectEndpoint_basketball() {
        let expectedSport = APISport.basketball
        let expectedLeagueId = 99
        mockAPIClient.result = Result<BaseResponse<[Team]>, NetworkError>
            .success(BaseResponse(success: 1, result: []))

        teamService.getTeams(sport: expectedSport, leagueId: expectedLeagueId) { _ in }

        guard case .teams(let sport, let leagueId) = mockAPIClient.capturedEndpoint else {
            return XCTFail("Expected .teams endpoint, got \(String(describing: mockAPIClient.capturedEndpoint))")
        }
        XCTAssertEqual(sport, expectedSport)
        XCTAssertEqual(leagueId, expectedLeagueId)
    }

    func test_getTeams_onSuccess_returnsTeams() {
        let expectedTeams = [makeTeam(key: 1, name: "FC Barcelona"),
                             makeTeam(key: 2, name: "Real Madrid")]
        mockAPIClient.result = Result<BaseResponse<[Team]>, NetworkError>
            .success(BaseResponse(success: 1, result: expectedTeams))

        let expectation = expectation(description: "completion called")
        var receivedTeams: [Team]?

        teamService.getTeams(sport: .football, leagueId: 1) { result in
            if case .success(let response) = result {
                receivedTeams = response.result
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1)
        XCTAssertEqual(receivedTeams, expectedTeams)
    }

    func test_getTeams_onSuccess_returnsEmptyList() {
        mockAPIClient.result = Result<BaseResponse<[Team]>, NetworkError>
            .success(BaseResponse(success: 1, result: []))

        let expectation = expectation(description: "completion called")
        var receivedTeams: [Team]?

        teamService.getTeams(sport: .football, leagueId: 1) { result in
            if case .success(let response) = result {
                receivedTeams = response.result
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1)
        XCTAssertEqual(receivedTeams, [])
    }

    func test_getTeams_onSuccess_returnsTeamWithPlayers() {
        let player = makePlayer(key: 10, name: "Lionel Messi")
        let team = makeTeam(key: 1, name: "FC Barcelona", players: [player])
        mockAPIClient.result = Result<BaseResponse<[Team]>, NetworkError>
            .success(BaseResponse(success: 1, result: [team]))

        let expectation = expectation(description: "completion called")
        var receivedTeam: Team?

        teamService.getTeams(sport: .football, leagueId: 1) { result in
            if case .success(let response) = result {
                receivedTeam = response.result?.first
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1)
        XCTAssertEqual(receivedTeam?.players?.first, player)
    }

    func test_getTeams_onSuccess_teamWithNilOptionalFields() {
        let team = makeTeam(key: 5, name: nil, logo: nil, players: nil)
        mockAPIClient.result = Result<BaseResponse<[Team]>, NetworkError>
            .success(BaseResponse(success: 1, result: [team]))

        let expectation = expectation(description: "completion called")
        var receivedTeam: Team?

        teamService.getTeams(sport: .football, leagueId: 1) { result in
            if case .success(let response) = result {
                receivedTeam = response.result?.first
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1)
        XCTAssertNil(receivedTeam?.teamName)
        XCTAssertNil(receivedTeam?.teamLogo)
        XCTAssertNil(receivedTeam?.players)
    }

    func test_getTeams_onServerError_returnsFailure() {
        let expectedError = NetworkError.serverError("Internal Server Error")
        mockAPIClient.result = Result<BaseResponse<[Team]>, NetworkError>
            .failure(expectedError)

        let expectation = expectation(description: "completion called")
        var receivedError: NetworkError?

        teamService.getTeams(sport: .football, leagueId: 1) { result in
            if case .failure(let error) = result {
                receivedError = error
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1)
        XCTAssertEqual(receivedError, expectedError)
    }

    func test_getTeams_onDecodingError_returnsFailure() {
        let expectedError = NetworkError.decodingError
        mockAPIClient.result = Result<BaseResponse<[Team]>, NetworkError>
            .failure(expectedError)

        let expectation = expectation(description: "completion called")
        var receivedError: NetworkError?

        teamService.getTeams(sport: .football, leagueId: 1) { result in
            if case .failure(let error) = result {
                receivedError = error
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1)
        XCTAssertEqual(receivedError, expectedError)
    }

    func test_getTeams_onNoInternetError_returnsFailure() {
        let expectedError = NetworkError.noInternet
        mockAPIClient.result = Result<BaseResponse<[Team]>, NetworkError>
            .failure(expectedError)

        let expectation = expectation(description: "completion called")
        var receivedError: NetworkError?

        teamService.getTeams(sport: .football, leagueId: 1) { result in
            if case .failure(let error) = result {
                receivedError = error
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1)
        XCTAssertEqual(receivedError, expectedError)
    }

    func test_getTeams_onTypeMismatch_returnsServerError() {
        mockAPIClient.result = Result<String, NetworkError>.success("wrong type")

        let expectation = expectation(description: "completion called")
        var receivedError: NetworkError?

        teamService.getTeams(sport: .football, leagueId: 1) { result in
            if case .failure(let error) = result {
                receivedError = error
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1)
        XCTAssertNotNil(receivedError)
        if case .serverError(let msg) = receivedError {
            XCTAssertEqual(msg, "Mock result type mismatch")
        } else {
            XCTFail("Expected .serverError for type mismatch, got \(String(describing: receivedError))")
        }
    }

    func test_getTeams_completionIsCalledExactlyOnce() {
        mockAPIClient.result = Result<BaseResponse<[Team]>, NetworkError>
            .success(BaseResponse(success: 1, result: []))

        var callCount = 0
        let expectation = expectation(description: "completion called")
        expectation.expectedFulfillmentCount = 1
        expectation.assertForOverFulfill = true

        teamService.getTeams(sport: .football, leagueId: 1) { _ in
            callCount += 1
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1)
        XCTAssertEqual(callCount, 1)
    }
}
