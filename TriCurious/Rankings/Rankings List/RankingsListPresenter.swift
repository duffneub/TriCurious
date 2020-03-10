//
//  RankingsListPresenter.swift
//  TriCurious
//
//  Created by Duff Neubauer on 3/1/20.
//  Copyright © 2020 Duff Neubauer. All rights reserved.
//

import Combine
import Foundation
import UIKit

struct RankingsListPresenter {
    private var interactor: RankingsListInteractor

    init(interactor: RankingsListInteractor) {
        self.interactor = interactor
    }

    func currentRankings() -> AnyPublisher<RankingsListViewModel?, Never> {
        interactor.currentRankings()
            .map { RankingsListViewModel(listings: $0, interactor: self.interactor) }
            .map { $0 as RankingsListViewModel? }
            .replaceError(with: nil)
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }

    private func display(_ error: Error) {

    }
}
