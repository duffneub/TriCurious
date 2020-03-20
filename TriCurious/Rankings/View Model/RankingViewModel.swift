//
//  RankingViewModel.swift
//  TriCurious
//
//  Created by Duff Neubauer on 3/19/20.
//  Copyright © 2020 Duff Neubauer. All rights reserved.
//

import Combine
import UIKit

class RankingViewModel {
    private static var headshotPlaceholder = UIImage(systemName: "person.crop.circle.fill")!
    private static var ordinalNumberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .ordinal
        return formatter
    }()

    private var ranking: Ranking
    @Published var athlete: AthleteViewModel

    var rankText: NSAttributedString? {
        Self.ordinalNumberFormatter.string(from: .init(value: ranking.rank)).map {
            let rankText = NSMutableAttributedString(
                string: "\(ranking.rank)",
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

    var totalPointsText: String { "\(ranking.pointsTotal)" }

    init(_ ranking: Ranking, store: RankingsStore) {
        self.ranking = ranking
        self.athlete = AthleteViewModel(ranking.athlete, store: store)
    }
}
