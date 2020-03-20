//
//  RankingTableViewCell.swift
//  TriCurious
//
//  Created by Duff Neubauer on 3/1/20.
//  Copyright © 2020 Duff Neubauer. All rights reserved.
//

import Combine
import UIKit

class RankingTableViewCell: UITableViewCell {
    static var reuseIdentifier = "RankingTableViewCell"
    static var height: CGFloat = 80

    @IBOutlet var rankLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var flagImageView: UIImageView!
    @IBOutlet var pointsLabel: UILabel!
    @IBOutlet var headshotImageView: UIImageView! {
        didSet {
            self.headshotImageView.layer.cornerRadius = self.headshotImageView.frame.height / 2.0
        }
    }

    private var cancellables: Set<AnyCancellable> = []

    var viewModel: RankingViewModel! {
        didSet {
            cancellables.forEach { $0.cancel() }

            rankLabel.attributedText = self.viewModel.rankText
            pointsLabel.text = self.viewModel.totalPointsText
            nameLabel.text = self.viewModel.athlete.fullName

            self.viewModel.athlete.$headshot
                .map { $0 as UIImage? }
                .receive(on: RunLoop.main)
                .assign(to: \.image, on: headshotImageView)
                .store(in: &cancellables)

            self.viewModel.athlete.$countryFlag
                .receive(on: RunLoop.main)
                .assign(to: \.image, on: flagImageView)
                .store(in: &cancellables)
        }
    }
}
