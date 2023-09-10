//
//  PeopleCardTableViewCell.swift
//  Peoples
//
//  Created by Hüseyin Murat Gezer on 10.09.2023.
//

import UIKit

class PeopleCardTableViewCell: UITableViewCell {
    @IBOutlet weak var peopleNameLabel: UILabel!

    public var viewModel: ViewModel? {
        didSet {
            guard let model = viewModel else {
                return
            }
            initView(model: model)
        }
    }

    private func initView(model: ViewModel) {
        peopleNameLabel.text = model.peopleName
    }
}

extension PeopleCardTableViewCell {
    struct ViewModel {
        public let peopleName: String

        public init(peopleName: String = "") {
            self.peopleName = peopleName
        }
    }
}

