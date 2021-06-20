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
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: ToDoLayout())
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
        addCollectionView()
        addSubviews()
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionView.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.bounds.width, height: view.bounds.height - view.safeAreaInsets.top)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = NSLocalizedString("My to-dos", comment: "")
    }
    private func setupView() {
        view = UIView()
        view.backgroundColor = .background
    }
    private func addSubviews() {
        addButton.setImage(.addButton, for: .normal)
        view.addSubview(addButton)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        [
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ].forEach({$0.isActive = true})
        addButton.addTarget(self, action: #selector(addButtonClick), for: .touchUpInside)
    }
    private func addCollectionView() {
        collectionView.backgroundColor = .subviewsBackgtound
        collectionView.register(ToDoCell.self, forCellWithReuseIdentifier: "\(ToDoCell.self)")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        [
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ].forEach({$0.isActive = true})
        
    }
}

extension ToDoViewController {
    @objc func addButtonClick() {
        let newToDoModel = NewToDoModel(toDoItem: ToDoItem(text: "", color: "#ACFA00", done: false))
        let newToDoViewController = NewToDoViewController(model: newToDoModel)
        let newToDoNavigationController = UINavigationController(rootViewController: newToDoViewController)
        self.present(newToDoNavigationController, animated: true, completion: nil)
    }
}

extension ToDoViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, heightForTextAtIndexPath indexPath: IndexPath) -> CGFloat {
        guard let cell = collectionView.cellForItem(at: indexPath) else {
            print("can't")
            return 100 as CGFloat
        }
        print("can")
        return cell.sizeThatFits(cell.bounds.size).height
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSize = (collectionView.frame.width - (collectionView.contentInset.left + collectionView.contentInset.right + 10)) / 2
        return CGSize(width: itemSize, height: itemSize)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Because I can't use force unvrap.
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(ToDoCell.self)", for:  indexPath) as? ToDoCell else {
            return ToDoCell(frame: .zero)
        }
        cell.layer.borderWidth = 1.0
        cell.backgroundColor = .white
        let toDoItem = ToDoItem(text: "AAA", color: "color", done: false)
        cell.loadData(toDoItem: toDoItem)
        return cell
    }
}
