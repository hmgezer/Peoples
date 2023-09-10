//
//  PeopleListViewModel.swift
//  Peoples
//
//  Created by Hüseyin Murat Gezer on 10.09.2023.
//

import Foundation

extension PeopleListViewController {
    class PeopleListViewModel {
        public var preparedPerson: [Person] = []
        public var peopleListCount: String = ""
        private var isPaginationActive: Bool = false

        func fetchData(completion: @escaping () -> Void) {
            DataSource.fetch(
                next: peopleListCount.isEmpty ? nil : peopleListCount
            ) { [weak self] response, error in
                self?.isPaginationActive = true
                self?.preparePeopleData(response?.people ?? [])
                self?.peopleListCount = response?.next ?? ""
                completion()
            }
        }

        func fetchNext(index: Int, _ completion: @escaping () -> Void) {
            isPaginationActive = false
            let maxIndex = preparedPerson.count - 5

            guard index > maxIndex else { return }
            fetchData {
                completion()
            }
        }

        private func preparePeopleData(_ peopleData: [Person]) {
            if preparedPerson.isEmpty {
                preparedPerson.append(contentsOf: peopleData)
            } else {
                var uniquePeopleList: [Person] = []
                preparedPerson.forEach { people in
                    uniquePeopleList = peopleData.filter { $0.id != people.id }
                }
                preparedPerson.append(contentsOf: uniquePeopleList)
            }
        }
    }
}
