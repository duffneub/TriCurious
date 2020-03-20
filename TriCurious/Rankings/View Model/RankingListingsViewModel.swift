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
