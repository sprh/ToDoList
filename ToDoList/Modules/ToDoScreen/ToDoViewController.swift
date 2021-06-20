//
//  ToDoViewController.swift
//  ToDoList
//
//  Created by Софья Тимохина on 11.06.2021.
//

import Foundation
import UIKit

class ToDoViewController: UIViewController {
    let model: ToDoModel!
    let addButton = UIButton()
    let tableView = UITableView(frame: CGRect(x: 16, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 100), style: .plain)
    let stackView = UIStackView()
    var doneShown: Bool = false
    let showButton = UIButton()
    let scrollView = UIScrollView()
    public init(model: ToDoModel) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupScrollView()
        doneToDosSetup()
        addTableView()
        addAddButton()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print(scrollView.convert(showButton.frame.origin, to: stackView).y + UIViewController.safeAreaHeight())
        scrollView.contentSize.height = scrollView.convert(showButton.frame.origin, to: stackView).y + UIViewController.safeAreaHeight() +
            tableView.contentSize.height + addButton.bounds.height
    }
    private func setupView() {
        view = UIView()
        view.backgroundColor = .background
        navigationItem.title = NSLocalizedString("My to-dos", comment: "")
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .automatic
        navigationController?.navigationBar.sizeToFit()
    }
    private func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alwaysBounceVertical = true
        view.addSubview(scrollView)
        [
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ].forEach({$0.isActive = true})
    }
    private func addAddButton() {
        addButton.setImage(.addButton, for: .normal)
        view.addSubview(addButton)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        [
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ].forEach({$0.isActive = true})
        addButton.addTarget(self, action: #selector(addButtonClick), for: .touchUpInside)
    }
    private func addTableView() {
        tableView.layer.cornerRadius = 20
        tableView.layer.masksToBounds = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        tableView.delaysContentTouches = true
        tableView.canCancelContentTouches = true
        tableView.register(ToDoCell.self, forCellReuseIdentifier: "\(ToDoCell.self)")
        tableView.backgroundColor = .clear
        tableView.rowHeight = UITableView.automaticDimension
        tableView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(tableView)
        [
            tableView.topAnchor.constraint(equalTo: showButton.safeAreaLayoutGuide.bottomAnchor, constant: 12),
            tableView.leadingAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.bottomAnchor)
        ].forEach({$0.isActive = true})
    }
    private func doneToDosSetup() {
        let show = UILabel()
        show.text = "\(NSLocalizedString("Done", comment: "")) — \(model.doneToDoItemsCount())"
        show.translatesAutoresizingMaskIntoConstraints = false
        show.textColor = .textGray
        show.font = .headkune
        scrollView.addSubview(show)
        [
            show.leadingAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.leadingAnchor, constant: 32),
            show.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 18)
        ].forEach({$0.isActive = true})
        showButton.setTitle(NSLocalizedString("Show", comment: ""), for: .normal)
        showButton.translatesAutoresizingMaskIntoConstraints = false
        showButton.setTitleColor(.azure, for: .normal)
        showButton.titleLabel?.font = .headkune
        scrollView.addSubview(showButton)
        [
            showButton.trailingAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.trailingAnchor, constant: -32),
            showButton.centerYAnchor.constraint(equalTo: show.centerYAnchor)
        ].forEach({$0.isActive = true})
        showButton.addTarget(self, action: #selector(showButtonClick), for: .touchUpInside)
    }
}

extension ToDoViewController {
    @objc func addButtonClick() {
        let newToDoModel = NewToDoModel(toDoItem: ToDoItem(text: "", color: "#ACFA00", done: false))
        let newToDoViewController = NewToDoViewController(model: newToDoModel)
        let newToDoNavigationController = UINavigationController(rootViewController: newToDoViewController)
        self.present(newToDoNavigationController, animated: true, completion: nil)
    }
    @objc func showButtonClick() {
        doneShown = !doneShown
    }
    @objc func test() {
    }
}

extension ToDoViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.toDoItemsCount()
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(ToDoCell.self)") as? ToDoCell else {
            return UITableViewCell()
        }
        let toDoItem = model.getToDoItem(at: indexPath.row)
        cell.loadData(toDoItem: toDoItem)
        cell.doneButton.addTarget(self, action: #selector(test), for: .touchUpInside)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("a")
    }
}
