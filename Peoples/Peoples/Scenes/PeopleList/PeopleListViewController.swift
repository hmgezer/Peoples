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
    private let refreshControl = UIRefreshControl()

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
        tableView.register(
            UINib(
                nibName: "EmptyTableViewCell",
                bundle: nil
            ),
            forCellReuseIdentifier: "EmptyTableViewCell"
        )
        customizeRefreshControl()
    }

    private func updateUI() {
        peopleList = viewModel.preparedPerson
        DispatchQueue.main.async { [weak self] in
            self?.refreshControl.endRefreshing()
            self?.tableView.reloadData()
        }
    }

    private func customizeRefreshControl() {
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        refreshControl.tintColor = UIColor(red:0.25, green:0.72, blue:0.85, alpha:1.0)
    }

    @objc private func refreshData() {
        viewModel.isRefresh = true
        viewModel.fetchNext(index: .zero) { [weak self] in
            self?.updateUI()
        }
    }
}

extension PeopleListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        peopleList?.count ?? 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if peopleList?.count == .zero {
            let cell: EmptyTableViewCell = tableView.dequeueReusableCell(withIdentifier: "EmptyTableViewCell") as! EmptyTableViewCell
            return cell
        } else {
            let cell: PeopleCardTableViewCell = tableView.dequeueReusableCell(withIdentifier: "PeopleCardTableViewCell") as! PeopleCardTableViewCell
            cell.viewModel = PeopleCardTableViewCell.ViewModel(
                peopleName: peopleList?[indexPath.row].fullName ?? ""
            )
            return cell
        }
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
