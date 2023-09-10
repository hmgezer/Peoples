//
//  PeopleListViewController.swift
//  Peoples
//
//  Created by Hüseyin Murat Gezer on 10.09.2023.
//

import UIKit

class PeopleListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!

    public var viewModel = PeopleListViewModel()
    public var peopleList: [Person]?

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.fetchNext(index: .zero) { [weak self] in
            self?.updateUI()
        }
        setupViews()
    }

    private func setupViews() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(
            UINib(
                nibName: "PeopleCardTableViewCell",
                bundle: nil
            ),
            forCellReuseIdentifier: "PeopleCardTableViewCell"
        )
    }

    private func updateUI() {
        peopleList = viewModel.preparedPerson
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
}

extension PeopleListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        peopleList?.count ?? 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PeopleCardTableViewCell = tableView.dequeueReusableCell(withIdentifier: "PeopleCardTableViewCell") as! PeopleCardTableViewCell
        cell.viewModel = PeopleCardTableViewCell.ViewModel(
            peopleName: peopleList?[indexPath.row].fullName ?? ""
        )
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        viewModel.fetchNext(index: indexPath.row) { [weak self] in
            self?.updateUI()
        }
    }
}
