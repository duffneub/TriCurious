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
    private var cancellables: Set<AnyCancellable> = []

    @Published var viewModel: AthleteViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        $viewModel.receive(on: RunLoop.main).sink(receiveValue: configure(_:)).store(in: &cancellables)
        viewModel.loadDetails().assign(to: \.viewModel, on: self).store(in: &cancellables)
    }

    private func configure(_ viewModel: AthleteViewModel!) {
        nameLabel.text = viewModel.fullName
        countryLabel.text = viewModel.countryText

        startsLabel.text = viewModel.startsText
        finishesLabel.text = viewModel.finishesText
        podiumsLabel.text = viewModel.podiumsText
        winsLabel.text = viewModel.winsText

        biographyTextView.text = viewModel.biographyText

        viewModel.$headshot
            .map { $0 as UIImage? }
            .receive(on: RunLoop.main)
            .assign(to: \.image, on: headshotImageView)
            .store(in: &cancellables)

        viewModel.$countryFlag
            .receive(on: RunLoop.main)
            .assign(to: \.image, on: countryFlagImageView)
            .store(in: &cancellables)
    }

}
