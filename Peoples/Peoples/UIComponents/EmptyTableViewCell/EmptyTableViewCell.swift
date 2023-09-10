//
//  EmptyTableViewCell.swift
//  Peoples
//
//  Created by Hüseyin Murat Gezer on 10.09.2023.
//

import UIKit

class EmptyTableViewCell: UITableViewCell {
    @IBOutlet weak var messageLabel: UILabel!

    public var viewModel: ViewModel? {
        didSet {
            guard let model = viewModel else {
                return
            }
            initView(model: model)
        }
    }

    private func initView(model: ViewModel) {
        messageLabel.text = model.message
    }
}

extension EmptyTableViewCell {
    struct ViewModel {
        public let message: String

        public init(message: String = "") {
            self.message = message
        }
    }
}
