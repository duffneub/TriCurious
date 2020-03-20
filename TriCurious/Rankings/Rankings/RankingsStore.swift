//
//  RankingsStore.swift
//  TriCurious
//
//  Created by Duff Neubauer on 3/18/20.
//  Copyright © 2020 Duff Neubauer. All rights reserved.
//

import Combine
import Foundation

protocol RankingsStore : class {
    func loadCurrentRankings() -> AnyPublisher<[RankingListing], Error>
    func headshot(for athlete: Athlete) -> AnyPublisher<Data, Error>
    func countryFlag(for athlete: Athlete) -> AnyPublisher<Data, Error>
    func details(for athlete: Athlete) -> AnyPublisher<Athlete, Error>
}
