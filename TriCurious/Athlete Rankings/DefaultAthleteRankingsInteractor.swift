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
    func currentRankings() -> AnyPublisher<[RankingListing], Error>
}

protocol AthleteRankingsInteractor {
    func currentRankings() -> AnyPublisher<[RankingListing], Error>
}

struct DefaultAthleteRankingsInteractor {
    var store: AthleteRankingsStore
    
    /// Fetch current athlete rankings
    func currentRankings() -> AnyPublisher<[RankingListing], Error> {
        store.currentRankings()
    }
}
