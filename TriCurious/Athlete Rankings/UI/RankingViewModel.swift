//
//  Ranking.swift
//  TriCurious
//
//  Created by Duff Neubauer on 3/1/20.
//  Copyright © 2020 Duff Neubauer. All rights reserved.
//

import Combine
import UIKit

protocol RankingViewModel {
    var numberOfRankingCategories: Int { get }
    func titleForRankingCategory(at index: Int) -> String
    func numbersOfRanks(ofRankingAt index: Int) -> Int
    func athlete(rankIndex: Int, categoryIndex: Int) -> AthleteViewModel?
}

protocol AthleteViewModel {
    var currentRankingText: NSAttributedString? { get }
    var fullName: String { get }
    var currentPointsText: String { get }
    var headshotPlaceholder: UIImage { get }
    var headshot: AnyPublisher<UIImage?, Never> { get }
    var countryFlag: AnyPublisher<UIImage?, Never> { get }
}

struct AthleteViewControllerViewModel : RankingViewModel {
    let rankings: [Ranking]
    let interactor: AthleteRankingsInteractor

    var numberOfRankingCategories: Int {
        rankings.count
    }

    func numbersOfRanks(ofRankingAt index: Int) -> Int {
        rankings[index].rankings.count
    }

    func titleForRankingCategory(at index: Int) -> String {
        guard index < rankings.count else { return "" }
        return rankings[index].category
    }

    func athlete(rankIndex: Int, categoryIndex: Int) -> AthleteViewModel? {
        guard
            categoryIndex < rankings.count,
            rankIndex < rankings[categoryIndex].rankings.count
        else {
            return nil
        }

        return AthleteTableCellViewModel(
            athlete: rankings[categoryIndex].rankings[rankIndex], interactor: interactor)
    }
}

struct AthleteTableCellViewModel : AthleteViewModel {
    private static var ordinalNumberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .ordinal
        return formatter
    }()
    private static var headshotPlaceholder: UIImage {
        UIImage(systemName: "person.crop.circle.fill")!
    }

    let athlete: Athlete
    let interactor: AthleteRankingsInteractor

    var currentRankingText: NSAttributedString? {
        Self.ordinalNumberFormatter.string(from: .init(value: athlete.currentRank)).map {
            let rankText = NSMutableAttributedString(
                string: "\(athlete.currentRank)",
                attributes: [
                    NSAttributedString.Key.font: UIFont.boldSystemFont(
                        ofSize: UIFont.preferredFont(forTextStyle: .body).pointSize)])

            let ordinalSuffix = $0.trimmingCharacters(in: .decimalDigits)
            rankText.append(.init(
                string: ordinalSuffix, attributes: [
                    NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption2)]))

            return rankText
        }
    }

    var fullName: String { "\(athlete.firstName) \(athlete.lastName)" }
    var currentPointsText: String { "\(athlete.currentPointsTotal)" }

    var headshotPlaceholder: UIImage { Self.headshotPlaceholder }

    var headshot: AnyPublisher<UIImage?, Never> {
        interactor.headshot(for: athlete)
            .tryMap { UIImage(data: $0) }
            .replaceError(with: headshotPlaceholder)
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }

    var countryFlag: AnyPublisher<UIImage?, Never> {
        interactor.countryFlag(for: athlete)
            .tryMap { UIImage(data: $0) }
            .replaceError(with: nil)
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
}
