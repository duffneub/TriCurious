//
//  DefaultAthleteRankingsInteractorTests.swift
//  TriCuriousTests
//
//  Created by Duff Neubauer on 2/28/20.
//  Copyright © 2020 Duff Neubauer. All rights reserved.
//

@testable import TriCurious

import Combine
import XCTest

class DefaultAthleteRankingsInteractorTests: XCTestCase {
    func testLoadCurrentRankings() {
        let expectedOutput: [Rankings] = [.fake()]
        let subject = DefaultAthleteRankingsInteractor(store: MockAthleteRankingsStore(.init(expectedOutput)))

        subject.loadCurrentRankings().assertFinished(expectedOutput)
    }

    func testLoadCurrentRankingsWithStoreFailureShouldFail() {
        let subject = DefaultAthleteRankingsInteractor(store: MockAthleteRankingsStore(.init(dummyError)))

        subject.loadCurrentRankings().assertFailure(dummyError)
    }

}

// MARK: - MockAthleteRankingsStore

struct MockAthleteRankingsStore : AthleteRankingsStore {
    var currentRankingsResponse: Result<[Rankings], Error>.Publisher

    init(_ currentRankingsResponse: Result<[Rankings], Error>.Publisher) {
        self.currentRankingsResponse = currentRankingsResponse
    }

    func loadCurrentRankings() -> AnyPublisher<[Rankings], Error> {
        currentRankingsResponse.eraseToAnyPublisher()
    }
}
