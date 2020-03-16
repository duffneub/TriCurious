//
//  RankingsListViewController.swift
//  TriCurious
//
//  Created by Duff Neubauer on 2/29/20.
//  Copyright © 2020 Duff Neubauer. All rights reserved.
//

import Combine
import UIKit

class RankingsListViewController : UIViewController {
    @IBOutlet var tableView: UITableView!
    var presenter: RankingsListPresenter?

    private var loadRankingsCancellable: AnyCancellable?
    var rankingsList: RankingsListViewModel? {
        didSet {
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(
            .init(nibName: "RankingTableViewCell", bundle: nil),
            forCellReuseIdentifier: RankingTableViewCell.reuseIdentifier)
        tableView.rowHeight = RankingTableViewCell.height

        loadRankingsCancellable = presenter?.currentRankings().assign(to: \.rankingsList, on: self)
        title = "Rankings"
    }
}

extension RankingsListViewController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        rankingsList?.numberOfRankingCategories ?? 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Display the top 3 ranks at most
        min(3, rankingsList?.numbersOfRanks(ofRankingAt: section) ?? 0)
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        rankingsList?.titleForRankingCategory(at: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: RankingTableViewCell.reuseIdentifier) as! RankingTableViewCell
        cell.ranking = rankingsList?.ranking(at: indexPath.row, categoryIndex: indexPath.section)

        return cell
    }
}

extension RankingsListViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard
            let cell = tableView.cellForRow(at: indexPath) as? RankingTableViewCell,
            let athlete = cell.ranking?.athlete
        else {
            return
        }

        presenter?.showDetails(for: athlete)

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            tableView.deselectRow(at: indexPath, animated: false)
        }
    }
}
