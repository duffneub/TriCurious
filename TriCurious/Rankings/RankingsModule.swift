//
//  RankingsModule.swift
//  TriCurious
//
//  Created by Duff Neubauer on 3/19/20.
//  Copyright © 2020 Duff Neubauer. All rights reserved.
//

import Combine
import UIKit

class RankingsModule : Module {
    private let navVC: UINavigationController
    private var cancellables: Set<AnyCancellable> = []

    var rootViewController: UIViewController { navVC }

    init(store: RankingsStore) {
        let viewModel = RankingListingsViewModel(store)
        let rankingsVC = RankingsViewController()
        rankingsVC.viewModel = viewModel

        self.navVC = UINavigationController(rootViewController: rankingsVC)

        viewModel.$selectedRanking
            .receive(on: RunLoop.main)
            .sink { ranking in
                guard let ranking = ranking else { return }
                self.showDetails(for: ranking.athlete)
            }
            .store(in: &cancellables)
    }

    func showDetails(for athlete: AthleteViewModel) {
//        athlete.fetchDetails()

        let athleteBioVC = AthleteBioViewController()
        athleteBioVC.viewModel = athlete
        athleteBioVC.additionalSafeAreaInsets = .init(
            top: navVC.navigationBar.frame.height, left: 0, bottom: 0, right: 0)

        navVC.pushViewController(athleteBioVC, animated: true)
    }
}
