//
//  AthleteRankingsPresenter.swift
//  TriCurious
//
//  Created by Duff Neubauer on 3/1/20.
//  Copyright © 2020 Duff Neubauer. All rights reserved.
//

import Combine
import Foundation
import UIKit

struct AthleteRankingsPresenter {
    private var interactor: AthleteRankingsInteractor

    init(interactor: AthleteRankingsInteractor) {
        self.interactor = interactor
    }

    func currentRankings() -> AnyPublisher<RankingViewModel?, Never> {
        interactor.currentRankings()
            .map { AthleteViewControllerViewModel(rankings: $0, interactor: self.interactor) }
            .map { $0 as RankingViewModel? }
            .replaceError(with: nil)
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }

    private func display(_ error: Error) {

    }
}
