//
//  RankingsViewModel.swift
//  TriCurious
//
//  Created by Duff Neubauer on 3/18/20.
//  Copyright © 2020 Duff Neubauer. All rights reserved.
//

import Combine
import UIKit

class RankingListingsViewModel {
    private var store: RankingsStore
    private var listings: [RankingListingViewModel] = [] {
        didSet {
            self.isLoading = false
        }
    }
    private var cancellables: Set<AnyCancellable> = []

    @Published var isLoading: Bool = false

    @Published var selectedRanking: RankingViewModel?
    var numberOfListings: Int { listings.count }

    init(_ store: RankingsStore) {
        self.store = store
    }

    func listing(at index: Int) -> RankingListingViewModel {
        listings[index]
    }

    func ranking(at indexPath: IndexPath) -> RankingViewModel {
        listings[indexPath.section].ranking(at: indexPath.row)
    }

    func loadCurrentRankings() {
        isLoading = true

        store.loadCurrentRankings()
            .map { $0.sorted().map { RankingListingViewModel($0, store: self.store) }}
            .replaceError(with: [])
            .assign(to: \.listings, on: self)
            .store(in: &cancellables)
    }
}

struct RankingListingViewModel {
    private var listing: RankingListing
    private var rankings: [RankingViewModel]
    var title: String { listing.category }
    var numberOfRankings: Int { rankings.count }

    fileprivate init(_ rankingListing: RankingListing, store: RankingsStore) {
        self.listing = rankingListing
        self.rankings = rankingListing.rankings.map { .init($0, store: store) }
    }

    func ranking(at index: Int) -> RankingViewModel {
        rankings[index]
    }
}

class RankingViewModel {
    private static var headshotPlaceholder = UIImage(systemName: "person.crop.circle.fill")!
    private static var ordinalNumberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .ordinal
        return formatter
    }()

    private var ranking: Ranking
    @Published var athlete: AthleteViewModel

    var rankText: NSAttributedString? {
        Self.ordinalNumberFormatter.string(from: .init(value: ranking.rank)).map {
            let rankText = NSMutableAttributedString(
                string: "\(ranking.rank)",
                attributes: [
                    NSAttributedString.Key.font: UIFont.boldSystemFont(
                        ofSize: UIFont.preferredFont(forTextStyle: .body).pointSize)])

            let ordinalSuffix = $0.trimmingCharacters(in: .decimalDigits)
            rankText.append(.init(
                string: ordinalSuffix, attributes: [
                    NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption2)]))

            return rankText
        }
    }

    var totalPointsText: String { "\(ranking.pointsTotal)" }

    init(_ ranking: Ranking, store: RankingsStore) {
        self.ranking = ranking
        self.athlete = AthleteViewModel(ranking.athlete, store: store)
    }
}

class AthleteViewModel {
    private static var headshotPlaceholder = UIImage(systemName: "person.crop.circle.fill")!

    private let athlete: Athlete

    private var cancellables: Set<AnyCancellable> = []

    @Published var headshot: UIImage

    var fullName: String { "\(athlete.firstName) \(athlete.lastName)" }

    var countryText: String { athlete.country }
    @Published var countryFlag: UIImage?

    var startsText: String { athlete.stats.map { "\($0.starts)" } ?? "" }
    var finishesText: String { athlete.stats.map { "\($0.finishes)" } ?? "" }
    var podiumsText: String { athlete.stats.map { "\($0.podiums)" } ?? "" }
    var winsText: String { athlete.stats.map { "\($0.wins)" } ?? "" }

    var biographyText: String { athlete.biography ?? "" }

    init(_ athlete: Athlete, store: RankingsStore) {
        self.athlete = athlete
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
}
