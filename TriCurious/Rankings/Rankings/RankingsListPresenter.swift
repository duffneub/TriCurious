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

//class RankingsRouter {
//    var rootViewController: UIViewController { navVC }
//
//    private let navVC: UINavigationController
//    private let interactor: RankingsListInteractor
//
//    init() {
//        self.navVC = UINavigationController()
//        self.interactor = DefaultRankingsListInteractor(store: TriathlonOrg())
//
//        let presenter = RankingsListPresenter(interactor: interactor, router: self)
//        let rankingsListVC = RankingsViewController()
////        rankingsListVC.presenter = presenter
//        navVC.viewControllers = [rankingsListVC]
//    }
//
//    func showDetails(for athlete: Athlete) {
//        let nextVC = AthleteBioViewController()
//        nextVC.athlete = AthleteViewModel(
//            athlete: athlete, interactor: DefaultRankingsListInteractor(store: TriathlonOrg()))
//        nextVC.additionalSafeAreaInsets = .init(
//            top: navVC.navigationBar.frame.height, left: 0, bottom: 0, right: 0)
//
//        navVC.pushViewController(nextVC, animated: true)
//    }
//}

//struct RankingsListPresenter {
//    var interactor: RankingsListInteractor
//    weak var router: RankingsRouter?
//
//    private var athleteDetailsRequest: AnyCancellable?
//
//    init(interactor: RankingsListInteractor, router: RankingsRouter?) {
//        self.interactor = interactor
//        self.router = router
//    }
//    func currentRankings() -> AnyPublisher<RankingsListViewModel?, Never> {
//        interactor.currentRankings()
//            .map { RankingsListViewModel(listings: $0, interactor: self.interactor) }
//            .map { $0 as RankingsListViewModel? }
//            .replaceError(with: nil)
//            .receive(on: RunLoop.main)
//            .eraseToAnyPublisher()
//    }
//
//    mutating func showDetails(for athlete: AthleteViewModel) {
//        guard let router = router else { return }
//
//        athleteDetailsRequest = interactor.details(for: athlete.athlete)
//            .receive(on: RunLoop.main)
//            .sink(receiveCompletion: { completion in
//                if case let .failure(error) = completion {
//                    print(error)
//                }
//            }, receiveValue: router.showDetails(for:))
//    }
//
//    private func display(_ error: Error) {
//
//    }
//}
