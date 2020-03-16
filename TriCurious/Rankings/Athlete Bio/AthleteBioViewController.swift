//
//  AthleteBioViewController.swift
//  TriCurious
//
//  Created by Duff Neubauer on 3/15/20.
//  Copyright © 2020 Duff Neubauer. All rights reserved.
//

import Combine
import UIKit

class AthleteBioViewController: UIViewController {
    @IBOutlet private var headshotImageView: UIImageView!
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var countryFlagImageView: UIImageView!
    @IBOutlet private var countryLabel: UILabel!
    @IBOutlet private var startsLabel: UILabel!
    @IBOutlet private var finishesLabel: UILabel!
    @IBOutlet private var podiumsLabel: UILabel!
    @IBOutlet private var winsLabel: UILabel!
    @IBOutlet private var biographyTextView: UITextView!

    private var headshotRequest: AnyCancellable?
    private var flagRequest: AnyCancellable?

    var athlete: AthleteViewModel? {
        didSet {
            guard self.isViewLoaded else { return }
            configure()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        headshotImageView.layer.cornerRadius = headshotImageView.frame.height / 2.0
        configure()
        title = athlete?.fullName
    }

    private func configure() {
        guard let athlete = self.athlete else { return reset() }
        headshotRequest = athlete.headshot.assign(to: \.image, on: self.headshotImageView)
        nameLabel.text = athlete.fullName
        flagRequest = athlete.countryFlag.assign(to: \.image, on: self.countryFlagImageView)
        countryLabel.text = athlete.countryText

        startsLabel.text = athlete.startsText
        finishesLabel.text = athlete.finishesText
        podiumsLabel.text = athlete.podiumsText
        winsLabel.text = athlete.winsText

        biographyTextView.text = athlete.biographyText
    }

    private func reset() {
        headshotImageView.image = athlete?.headshotPlaceholder
        nameLabel.text = nil
        countryLabel.text = nil
        startsLabel.text = nil
        finishesLabel.text = nil
        podiumsLabel.text = nil
        winsLabel.text = nil
        biographyTextView.text = nil
    }

}
