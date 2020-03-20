//
//  RankingsModule.swift
//  TriCurious
//
//  Created by Duff Neubauer on 3/19/20.
//  Copyright © 2020 Duff Neubauer. All rights reserved.
//

import Combine
import UIKit

protocol RankingsStore : class {
    func loadCurrentRankings() -> AnyPublisher<[RankingListing], Error>
    func headshot(for athlete: Athlete) -> AnyPublisher<Data, Error>
    func countryFlag(for athlete: Athlete) -> AnyPublisher<Data, Error>
    func details(for athlete: Athlete) -> AnyPublisher<Athlete, Error>
}

class RankingsCoordinator : ViewControllerRepresentable {
    private let navVC: UINavigationController
    private var cancellables: Set<AnyCancellable> = []

    var viewController: UIViewController { navVC }

    init(store: RankingsStore) {
        self.navVC = UINavigationController()

        let rankings = makeRankingsView(store: store)
        self.navVC.viewControllers = [rankings]
    }

    private func makeRankingsView(store: RankingsStore) -> UIViewController {
        let viewModel = RankingListingsViewModel(store)
        let rankingsVC = RankingsViewController()
        rankingsVC.viewModel = viewModel
        rankingsVC.title = "Rankings"

        viewModel.$selectedRanking
            .receive(on: RunLoop.main)
            .sink { ranking in
                guard let ranking = ranking else { return }
                self.showDetails(for: ranking.athlete)
            }
            .store(in: &cancellables)

        return rankingsVC
    }

    func showDetails(for athlete: AthleteViewModel) {
        let athleteBioVC = AthleteBioViewController()
        athleteBioVC.viewModel = athlete
        athleteBioVC.title = athlete.fullName

        navVC.pushViewController(athleteBioVC, animated: true)
    }
}
