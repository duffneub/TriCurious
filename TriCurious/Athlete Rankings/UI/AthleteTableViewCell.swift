//
//  AthleteTableViewCell.swift
//  TriCurious
//
//  Created by Duff Neubauer on 3/1/20.
//  Copyright © 2020 Duff Neubauer. All rights reserved.
//

import Combine
import UIKit

class AthleteTableViewCell: UITableViewCell {
    static var height: CGFloat = 80

    @IBOutlet var rankLabel: UILabel!
    @IBOutlet var headshotImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var flagImageView: UIImageView!
    @IBOutlet var pointsLabel: UILabel!

    private var headshotRequest: AnyCancellable?
    private var flagRequest: AnyCancellable?

    var viewModel: AthleteViewModel? {
        didSet {
            reset()

            guard let athlete = self.viewModel else { return }

            rankLabel.attributedText = athlete.currentRankingText
            nameLabel.text = athlete.fullName
            pointsLabel.text = athlete.currentPointsText
            headshotRequest = athlete.headshot.assign(to: \.image, on: self.headshotImageView)
            flagRequest = athlete.countryFlag.assign(to: \.image, on: self.flagImageView)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        headshotImageView.layer.cornerRadius = headshotImageView.frame.height / 2.0

        reset()
    }

    func reset() {
        headshotRequest?.cancel()

        rankLabel.text = ""
        headshotImageView.image = viewModel?.headshotPlaceholder ?? nil
        nameLabel.text = ""
        flagImageView.image = nil
        pointsLabel.text = ""
    }
}

//KEEP WORKING ON LOADING CELLS
