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
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var countryFlagImageView: UIImageView!
    @IBOutlet private var countryLabel: UILabel!
    @IBOutlet private var startsLabel: UILabel!
    @IBOutlet private var finishesLabel: UILabel!
    @IBOutlet private var podiumsLabel: UILabel!
    @IBOutlet private var winsLabel: UILabel!
    @IBOutlet private var biographyTextView: UITextView!
    @IBOutlet private var headshotImageView: UIImageView! {
        didSet {
            self.headshotImageView.layer.cornerRadius = self.headshotImageView.frame.height / 2.0
        }
    }

    private var headshotRequest: AnyCancellable?
    private var flagRequest: AnyCancellable?

    var viewModel: AthleteViewModel! {
        didSet {
            title = self.viewModel.fullName

//            headshotRequest = viewModel.headshot.assign(to: \.image, on: self.headshotImageView)
            nameLabel.text = viewModel.fullName
//            flagRequest = viewModel.countryFlag.assign(to: \.image, on: self.countryFlagImageView)
            countryLabel.text = viewModel.countryText

            startsLabel.text = viewModel.startsText
            finishesLabel.text = viewModel.finishesText
            podiumsLabel.text = viewModel.podiumsText
            winsLabel.text = viewModel.winsText

            biographyTextView.text = viewModel.biographyText
        }
    }

}
