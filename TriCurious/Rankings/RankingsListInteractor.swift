//
//  DefaultRankingsListInteractor.swift
//  TriCurious
//
//  Created by Duff Neubauer on 2/28/20.
//  Copyright © 2020 Duff Neubauer. All rights reserved.
//

import Foundation
import Combine

protocol RankingsListStore {
    func currentRankings() -> AnyPublisher<[RankingListing], Error>
    func headshot(for athlete: Athlete) -> AnyPublisher<Data, Error>
    func countryFlag(for athlete: Athlete) -> AnyPublisher<Data, Error>
}

protocol RankingsListInteractor {
    func currentRankings() -> AnyPublisher<[RankingListing], Error>
    func headshot(for athlete: Athlete) -> AnyPublisher<Data, Error>
    func countryFlag(for athlete: Athlete) -> AnyPublisher<Data, Error>
}

struct DefaultRankingsListInteractor : RankingsListInteractor {
    var store: RankingsListStore

    func currentRankings() -> AnyPublisher<[RankingListing], Error> {
        store.currentRankings()
    }

    func headshot(for athlete: Athlete) -> AnyPublisher<Data, Error> {
        store.headshot(for: athlete).retry(3).eraseToAnyPublisher()
    }

    func countryFlag(for athlete: Athlete) -> AnyPublisher<Data, Error> {
        store.countryFlag(for: athlete).retry(3).eraseToAnyPublisher()
    }
}
