//
//  ItemsListTableViewHeader.swift
//  ToDoList
//
//  Created by Софья Тимохина on 14.07.2021.
//

import UIKit

final class ItemsListTableViewHeader: UIView {
    let showLabel = UILabel()
    let showButton = UIButton()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func addSubviews() {
        addSubview(showLabel)
        showLabel.translatesAutoresizingMaskIntoConstraints = false
        showLabel.textColor = .textGray
        showLabel.font = .headkune
        NSLayoutConstraint.activate([
            showLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            showLabel.topAnchor.constraint(equalTo: topAnchor, constant: 18),
            showLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -18)
        ])
        showButton.translatesAutoresizingMaskIntoConstraints = false
        showButton.setTitleColor(.azure, for: .normal)
        showButton.titleLabel?.font = .headkune
        addSubview(showButton)
        NSLayoutConstraint.activate([
            showButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            showButton.centerYAnchor.constraint(equalTo: showLabel.centerYAnchor)
        ])
    }
}
