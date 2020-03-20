//
//  AthleteViewModel.swift
//  TriCurious
//
//  Created by Duff Neubauer on 3/19/20.
//  Copyright © 2020 Duff Neubauer. All rights reserved.
//

import Combine
import UIKit

class AthleteViewModel {
    private static var headshotPlaceholder = UIImage(systemName: "person.crop.circle.fill")!

    private let athlete: Athlete
    private let store: RankingsStore

    private var cancellables: Set<AnyCancellable> = []

    @Published var headshot: UIImage

    var fullName: String { "\(athlete.firstName) \(athlete.lastName)" }

    var countryText: String { athlete.country }
    @Published var countryFlag: UIImage?

    var startsText: String { athlete.stats.map { "\($0.starts)" } ?? "--" }
    var finishesText: String { athlete.stats.map { "\($0.finishes)" } ?? "--" }
    var podiumsText: String { athlete.stats.map { "\($0.podiums)" } ?? "--" }
    var winsText: String { athlete.stats.map { "\($0.wins)" } ?? "--" }

    var biographyText: String { athlete.biography ?? "" }

    init(_ athlete: Athlete, store: RankingsStore) {
        self.athlete = athlete
        self.store = store
        self.headshot = Self.headshotPlaceholder

        store.headshot(for: athlete)
            .tryMap { UIImage(data: $0) ?? Self.headshotPlaceholder }
            .replaceError(with: Self.headshotPlaceholder)
            .assign(to: \.headshot, on: self)
            .store(in: &cancellables)

        store.countryFlag(for: athlete)
            .tryMap { UIImage(data: $0) }
            .replaceError(with: nil)
            .assign(to: \.countryFlag, on: self)
            .store(in: &cancellables)
    }

    func loadDetails() -> AnyPublisher<AthleteViewModel, Never> {
        store.details(for: athlete)
            .map { AthleteViewModel($0, store: self.store) }
            .replaceError(with: self)
            .eraseToAnyPublisher()
    }
}
