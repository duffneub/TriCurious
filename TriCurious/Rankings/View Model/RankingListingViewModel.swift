//
//  RankingListingViewModel.swift
//  TriCurious
//
//  Created by Duff Neubauer on 3/19/20.
//  Copyright © 2020 Duff Neubauer. All rights reserved.
//

import Foundation

struct RankingListingViewModel {
    private var listing: RankingListing
    private var rankings: [RankingViewModel]
    var title: String { listing.category }
    var numberOfRankings: Int { rankings.count }

    init(_ rankingListing: RankingListing, store: RankingsStore) {
        self.listing = rankingListing
        self.rankings = rankingListing.rankings.map { .init($0, store: store) }
    }

    func ranking(at index: Int) -> RankingViewModel {
        rankings[index]
    }
}
