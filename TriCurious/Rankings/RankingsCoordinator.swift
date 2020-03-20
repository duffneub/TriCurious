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
    private var router: Router!
    private var cancellables: Set<AnyCancellable> = []

    var viewController: UIViewController { router.viewController }

    init(store: RankingsStore) {
        let rankings = makeRankingsView(store: store)
        if (UIDevice.current.userInterfaceIdiom == .phone) {
            self.router = StackRankingsRouter(rootViewController: rankings)
        } else {
            self.router = ColumnRankingsRouter(rootViewController: rankings)
        }
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

        router.showDetailViewController(athleteBioVC, animated: true, sender: self)
    }
}

private protocol Router {
    init(rootViewController: UIViewController)
    var viewController: UIViewController { get }
    func showDetailViewController(_ detailVC: UIViewController, animated: Bool, sender: Any?)
}

private class StackRankingsRouter : Router {
    private let navVC: UINavigationController

    var viewController: UIViewController { navVC }

    required init(rootViewController: UIViewController) {
        self.navVC = UINavigationController(rootViewController: rootViewController)
    }

    func showDetailViewController(_ detailVC: UIViewController, animated: Bool, sender: Any?) {
        navVC.pushViewController(detailVC, animated: animated)
    }
}

private class ColumnRankingsRouter : Router {
    private let splitVC: UISplitViewController
    private lazy var placeholderVC: UIViewController = {
        let placeholderVC = UIViewController()
        placeholderVC.view = UIView()
        placeholderVC.view.backgroundColor = UIColor.systemBackground

        let placeholder = UILabel()
        placeholder.text = "No Athlete Selected."
        placeholder.font = UIFont.preferredFont(forTextStyle: .caption1)
        placeholder.textAlignment = .center
        placeholder.textColor = UIColor.tertiaryLabel
        placeholder.translatesAutoresizingMaskIntoConstraints = false
        placeholderVC.view.addSubview(placeholder)

        NSLayoutConstraint.activate([
            placeholder.centerXAnchor.constraint(equalTo: placeholderVC.view.centerXAnchor),
            placeholder.centerYAnchor.constraint(equalTo: placeholderVC.view.centerYAnchor),
        ])

        return placeholderVC
    }()

    var viewController: UIViewController { splitVC }

    required init(rootViewController: UIViewController) {
        self.splitVC = UISplitViewController()
        self.splitVC.preferredDisplayMode = .allVisible
        self.splitVC.viewControllers = [rootViewController, self.placeholderVC]
    }

    func showDetailViewController(_ detailVC: UIViewController, animated: Bool, sender: Any?) {
        splitVC.showDetailViewController(detailVC, sender: sender)
    }
}
