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
    func loadCurrentRankings() -> AnyPublisher<[Ranking], Error>
}

protocol AthleteRankingsInteractor {
    func loadCurrentRankings() -> AnyPublisher<[Ranking], Error>
}

struct DefaultAthleteRankingsInteractor {
    var store: AthleteRankingsStore

    func loadCurrentRankings() -> AnyPublisher<[Ranking], Error> {
        store.loadCurrentRankings()
    }
}
