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
    @IBOutlet var headshotImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var flagImageView: UIImageView!
    @IBOutlet var pointsLabel: UILabel!

    private var headshotRequest: AnyCancellable?
    private var flagRequest: AnyCancellable?

    var ranking: RankingViewModel? {
        didSet {
            reset()

            guard let ranking = self.ranking else { return }
            let athlete = ranking.athlete

            rankLabel.attributedText = ranking.rankText
            pointsLabel.text = ranking.totalPointsText

            nameLabel.text = athlete.fullName
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
        headshotImageView.image = ranking?.athlete.headshotPlaceholder ?? nil
        nameLabel.text = ""
        flagImageView.image = nil
        pointsLabel.text = ""
    }
}
