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
    func testCurrentRankings() {
        let expectedOutput: [RankingListing] = [.fake()]
        let subject = DefaultAthleteRankingsInteractor(store: MockAthleteRankingsStore(.init(expectedOutput)))

        subject.currentRankings().assertFinished(expectedOutput)
    }

    func testCurrentRankingsWithStoreFailureShouldFail() {
        let subject = DefaultAthleteRankingsInteractor(store: MockAthleteRankingsStore(.init(dummyError)))

        subject.currentRankings().assertFailure(dummyError)
    }

}

// MARK: - MockAthleteRankingsStore

struct MockAthleteRankingsStore : AthleteRankingsStore {
    var currentRankingsResponse: Result<[RankingListing], Error>.Publisher

    init(_ currentRankingsResponse: Result<[RankingListing], Error>.Publisher) {
        self.currentRankingsResponse = currentRankingsResponse
    }

    func currentRankings() -> AnyPublisher<[RankingListing], Error> {
        currentRankingsResponse.eraseToAnyPublisher()
    }
}
