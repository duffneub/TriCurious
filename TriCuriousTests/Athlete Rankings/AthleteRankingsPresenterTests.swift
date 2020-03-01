//
//  AthleteRankingsPresenterTests.swift
//  TriCuriousTests
//
//  Created by Duff Neubauer on 2/29/20.
//  Copyright © 2020 Duff Neubauer. All rights reserved.
//

@testable import TriCurious

import Combine
import XCTest

class AthleteRankingsPresenterTests: XCTestCase {
    func testLoadCurrentRankings() {
        let listing = RankingListing.fake(category: "A REALLY COOL category", rankings: [
            .fake(firstName: "Jane", lastName: "Appleseed")
        ])

        let subject = AthleteRankingsPresenter(
            interactor: MockAthleteRankingsInteractor(.init([listing])))

        var viewModel: RankingListingViewModel!
        _ = subject.loadCurrentRankings().assertNoFailure().sink { viewModel = $0 }

        XCTAssertEqual(1, viewModel.numberOfRankingCategories)
        XCTAssertEqual("A REALLY COOL category", viewModel.titleForRankingCategory(at: 0))
        XCTAssertEqual("Jane Appleseed", viewModel.nameOfAthlete(rankIndex: 0, categoryIndex: 0))
    }

    func testRankingListingViewModelHandlesBadIndex() {
        let subject = AthleteRankingsPresenter(
            interactor: MockAthleteRankingsInteractor(.init([])))

        var viewModel: RankingListingViewModel!
        _ = subject.loadCurrentRankings().assertNoFailure().sink { viewModel = $0 }

        XCTAssertEqual("", viewModel.titleForRankingCategory(at: 0))
        XCTAssertEqual("", viewModel.nameOfAthlete(rankIndex: 0, categoryIndex: 0))
    }
}

struct MockAthleteRankingsInteractor : AthleteRankingsInteractor {
    var currentRankingsResult: Result<[RankingListing], Error>.Publisher

    init(_ currentRankingsResult: Result<[RankingListing], Error>.Publisher) {
        self.currentRankingsResult = currentRankingsResult
    }

    func currentRankings() -> AnyPublisher<[RankingListing], Error> {
        currentRankingsResult.eraseToAnyPublisher()
    }
}
