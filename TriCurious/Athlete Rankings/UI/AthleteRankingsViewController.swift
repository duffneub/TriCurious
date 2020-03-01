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
    var viewModel: RankingListingViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        loadRankingsCancellable = presenter?.loadCurrentRankings()
            .assertNoFailure()
            .sink { self.viewModel = $0 }
    }
}

extension AthleteRankingsViewController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel?.numberOfRankingCategories ?? 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3 // Always displays top 3 athletes
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        viewModel?.titleForRankingCategory(at: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: "Cell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        }

        cell?.textLabel?.text = viewModel?.nameOfAthlete(
            rankIndex: indexPath.row, categoryIndex: indexPath.section)

        return cell
    }
}

extension AthleteRankingsViewController : UITableViewDelegate {

}
