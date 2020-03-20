//
//  RankingsListViewModel.swift
//  TriCurious
//
//  Created by Duff Neubauer on 3/1/20.
//  Copyright © 2020 Duff Neubauer. All rights reserved.
//

import Combine
import UIKit

//struct RankingsListViewModel {
//    let listings: [RankingListing]
//    let interactor: RankingsListInteractor
//
//    init(listings: [RankingListing], interactor: RankingsListInteractor) {
//        self.listings = listings.sorted()
//        self.interactor = interactor
//    }
//
//    var numberOfRankingCategories: Int {
//        listings.count
//    }
//
//    func numbersOfRanks(ofRankingAt index: Int) -> Int {
//        listings[index].rankings.count
//    }
//
//    func titleForRankingCategory(at index: Int) -> String {
//        guard index < listings.count else { return "" }
//        return listings[index].category
//    }
//
//    func ranking(at index: Int, categoryIndex: Int) -> RankingViewModel? {
//        guard
//            categoryIndex < listings.count,
//            index < listings[categoryIndex].rankings.count
//        else {
//            return nil
//        }
//
//        return .init(ranking: listings[categoryIndex].rankings[index], interactor: interactor)
//    }
//}
//
//struct RankingViewModel {
//    private static var ordinalNumberFormatter: NumberFormatter = {
//        let formatter = NumberFormatter()
//        formatter.numberStyle = .ordinal
//        return formatter
//    }()
//
//    let ranking: Ranking
//    let athlete: AthleteViewModel
//
//    init(ranking: Ranking, interactor: RankingsListInteractor) {
//        self.ranking = ranking
//        self.athlete = AthleteViewModel(athlete: ranking.athlete, interactor: interactor)
//    }
//
//    var rankText: NSAttributedString? {
//        Self.ordinalNumberFormatter.string(from: .init(value: ranking.rank)).map {
//            let rankText = NSMutableAttributedString(
//                string: "\(ranking.rank)",
//                attributes: [
//                    NSAttributedString.Key.font: UIFont.boldSystemFont(
//                        ofSize: UIFont.preferredFont(forTextStyle: .body).pointSize)])
//
//            let ordinalSuffix = $0.trimmingCharacters(in: .decimalDigits)
//            rankText.append(.init(
//                string: ordinalSuffix, attributes: [
//                    NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption2)]))
//
//            return rankText
//        }
//    }
//
//    var totalPointsText: String { "\(ranking.pointsTotal)" }
//}
//
//struct AthleteViewModel {
//    private static var headshotPlaceholder: UIImage {
//        UIImage(systemName: "person.crop.circle.fill")!
//    }
//
//    let athlete: Athlete
//    let interactor: RankingsListInteractor
//
//    var fullName: String { "\(athlete.firstName) \(athlete.lastName)" }
//    var headshotPlaceholder: UIImage { Self.headshotPlaceholder }
//
//    var headshot: AnyPublisher<UIImage?, Never> {
//        interactor.headshot(for: athlete)
//            .tryMap { UIImage(data: $0) }
//            .replaceError(with: headshotPlaceholder)
//            .receive(on: RunLoop.main)
//            .eraseToAnyPublisher()
//    }
//
//    var countryFlag: AnyPublisher<UIImage?, Never> {
//        interactor.countryFlag(for: athlete)
//            .tryMap { UIImage(data: $0) }
//            .replaceError(with: nil)
//            .receive(on: RunLoop.main)
//            .eraseToAnyPublisher()
//    }
//
//    var countryText: String { athlete.country }
//
//    var startsText: String { athlete.stats.map { "\($0.starts)" } ?? "" }
//    var finishesText: String { athlete.stats.map { "\($0.finishes)" } ?? "" }
//    var podiumsText: String { athlete.stats.map { "\($0.podiums)" } ?? "" }
//    var winsText: String { athlete.stats.map { "\($0.wins)" } ?? "" }
//
//    var biographyText: String { athlete.biography ?? "" }
//}
