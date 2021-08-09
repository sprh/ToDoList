//
//  AboutViewController.swift
//  ToDoList
//
//  Created by Софья Тимохина on 04.06.2021.
//

import Foundation
import UIKit

public class AboutViewController: UIViewController {
    var model: AboutModel!
    var logoImage: UIImageView {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
        imageView.image = .logo
        return imageView
    }
    
    var versionNumber: UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = .systemFont(ofSize: 20)
        label.text = "The current version is ".localized +
            "\(model.getTheCurrentVersionNumber())"
        return label
    }
    
    var scrollView: UIScrollView {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }
    init(model: AboutModel) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented -> About screen")
    }
    override public func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        addSubviews()
    }
    fileprivate func setupView() {
        view = UIView()
        view.backgroundColor = .background
    }
    fileprivate func addSubviews() {
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
        let logoImageHeight = UIImage.logo.size.height
        scrollView.addSubview(logoImage)
        NSLayoutConstraint.activate([
            logoImage.topAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.topAnchor, constant: 10),
            logoImage.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            logoImage.bottomAnchor.constraint(equalTo:
                                  scrollView.safeAreaLayoutGuide.topAnchor, constant: 10 + logoImageHeight)
        ])
        scrollView.addSubview(versionNumber)
        NSLayoutConstraint.activate([
            versionNumber.topAnchor.constraint(equalTo: logoImage.bottomAnchor, constant: 20),
            versionNumber.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor)
        ])
    }
}
