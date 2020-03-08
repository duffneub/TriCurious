//
//  DefaultAthleteRankingsInteractor.swift
//  TriCurious
//
//  Created by Duff Neubauer on 2/28/20.
//  Copyright © 2020 Duff Neubauer. All rights reserved.
//

import Foundation
import Combine

protocol AthleteRankingsStore {
    func currentRankings() -> AnyPublisher<[Ranking], Error>
    func headshot(for athlete: Athlete) -> AnyPublisher<Data, Error>
    func countryFlag(for athlete: Athlete) -> AnyPublisher<Data, Error>
}

protocol AthleteRankingsInteractor {
    func currentRankings() -> AnyPublisher<[Ranking], Error>
    func headshot(for athlete: Athlete) -> AnyPublisher<Data, Error>
    func countryFlag(for athlete: Athlete) -> AnyPublisher<Data, Error>
}

struct DefaultAthleteRankingsInteractor : AthleteRankingsInteractor {
    var store: AthleteRankingsStore

    func currentRankings() -> AnyPublisher<[Ranking], Error> {
        store.currentRankings()
    }

    func headshot(for athlete: Athlete) -> AnyPublisher<Data, Error> {
        store.headshot(for: athlete).retry(3).eraseToAnyPublisher()
    }

    func countryFlag(for athlete: Athlete) -> AnyPublisher<Data, Error> {
        store.countryFlag(for: athlete).retry(3).eraseToAnyPublisher()
    }
}
