//
//  AthleteRankingsViewController.swift
//  TriCurious
//
//  Created by Duff Neubauer on 2/29/20.
//  Copyright © 2020 Duff Neubauer. All rights reserved.
//

import Combine
import UIKit

class AthleteRankingsViewController : UIViewController {
    @IBOutlet var tableView: UITableView!
    var presenter: AthleteRankingsPresenter?

    private var loadRankingsCancellable: AnyCancellable?
    var viewModel: RankingViewModel? {
        didSet {
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(
            .init(nibName: "AthleteTableViewCell", bundle: nil),
            forCellReuseIdentifier: "AthleteCell")
        tableView.rowHeight = AthleteTableViewCell.height

        loadRankingsCancellable = presenter?.currentRankings().assign(to: \.viewModel, on: self)
    }
}

extension AthleteRankingsViewController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel?.numberOfRankingCategories ?? 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Display the top 3 ranks at most
        min(3, viewModel?.numbersOfRanks(ofRankingAt: section) ?? 0)
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        viewModel?.titleForRankingCategory(at: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AthleteCell") as! AthleteTableViewCell
        cell.viewModel = viewModel?.athlete(
            rankIndex: indexPath.row, categoryIndex: indexPath.section)

        return cell
    }
}

extension AthleteRankingsViewController : UITableViewDelegate {

}
