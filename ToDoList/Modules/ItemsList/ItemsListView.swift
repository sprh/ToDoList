//
//  ItemsListView.swift
//  ToDoList
//
//  Created by Софья Тимохина on 13.07.2021.
//

import UIKit

class ItemsListView: UIViewController {
    var doneShown: Bool = false
    let presenter: ItemsListPresenter!
    public init(presenter: ItemsListPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    func setupView() {
        view = ItemsListInterface()
        view.backgroundColor = .background
        navigationItem.title = "My to-dos".localized
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .automatic
        navigationController?.navigationBar.sizeToFit()
    }
}

extension ItemsListView: ItemsListViewDelegate {
}
