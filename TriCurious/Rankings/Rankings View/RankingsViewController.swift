//
//  RankingsViewController.swift
//  TriCurious
//
//  Created by Duff Neubauer on 2/29/20.
//  Copyright © 2020 Duff Neubauer. All rights reserved.
//

import Combine
import UIKit

class RankingsViewController : UIViewController {
    @IBOutlet private var progressContainerView: UIView!
    @IBOutlet private var progressView: UIActivityIndicatorView!
    @IBOutlet private var tableView: UITableView! {
        didSet {
            self.tableView.register(
                .init(nibName: "RankingTableViewCell", bundle: nil),
                forCellReuseIdentifier: RankingTableViewCell.reuseIdentifier)
            self.tableView.rowHeight = RankingTableViewCell.height
        }
    }

    private var cancellables: Set<AnyCancellable> = []

    var viewModel: RankingListingsViewModel! {
        didSet {
            cancellables.forEach { $0.cancel() }
            cancellables.removeAll()

            self.viewModel.$isLoading
                .receive(on: RunLoop.main)
                .dropFirst()
                .sink(receiveValue: toggleProgressView)
                .store(in: &cancellables)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.loadCurrentRankings()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        tableView.indexPathForSelectedRow.map {
            tableView.deselectRow(at: $0, animated: true)
        }
    }

    private func toggleProgressView(_ isLoading: Bool) {
        if isLoading {
            UIView.animate(withDuration: 0, animations: {
                self.progressContainerView.alpha = 1.0
            }) { _ in
                self.progressContainerView.isHidden = false
                self.progressView.startAnimating()
            }
        } else {
            UIView.animate(withDuration: 0.25, animations: {
                self.progressContainerView.alpha = 0.0
            }) { _ in
                self.progressContainerView.isHidden = true
                self.progressContainerView.alpha = 1.0
                self.progressView.stopAnimating()
                self.tableView.reloadData()
            }
        }
    }
}

extension RankingsViewController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.numberOfListings
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Display the top 3 ranks at most
        min(3, viewModel.listing(at: section).numberOfRankings)
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        viewModel.listing(at: section).title
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: RankingTableViewCell.reuseIdentifier) as! RankingTableViewCell
        cell.viewModel = viewModel.ranking(at: indexPath)

        return cell
    }
}

extension RankingsViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectedRanking = viewModel.ranking(at: indexPath)
    }
}
