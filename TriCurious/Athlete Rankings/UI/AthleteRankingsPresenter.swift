//
//  AthleteRankingsPresenter.swift
//  TriCurious
//
//  Created by Duff Neubauer on 3/1/20.
//  Copyright © 2020 Duff Neubauer. All rights reserved.
//

import Combine
import Foundation

struct AthleteRankingsPresenter {
    private var interactor: AthleteRankingsInteractor
    private var viewModel: RankingListingViewModel?

    init(interactor: AthleteRankingsInteractor) {
        self.interactor = interactor
    }

    func loadCurrentRankings() -> AnyPublisher<RankingListingViewModel, Error> {
        interactor.loadCurrentRankings().map { $0 as RankingListingViewModel } .eraseToAnyPublisher()
    }
}
