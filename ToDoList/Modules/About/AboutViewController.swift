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
    let logoImage = UIImageView()
    let versionNumber = UILabel()
    let scrollView = UIScrollView()
    
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
        // MARK: - Adding a scroll view to the view.
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        [
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ].forEach({$0.isActive = true})
        // MARK: - Setuping a logo image and adding it to the scroll view.
        logoImage.translatesAutoresizingMaskIntoConstraints = false
        logoImage.contentMode = .scaleToFill
        let logoImageHeight = UIImage.logo.size.height
        scrollView.addSubview(logoImage)
        [
            logoImage.topAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.topAnchor, constant: 10),
            logoImage.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            logoImage.bottomAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.topAnchor, constant: 10 + logoImageHeight),
        ].forEach({$0.isActive = true})
        logoImage.image = .logo
        // MARK: - Setuping a label with the current version number and adding it to the scroll view.
        versionNumber.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(versionNumber)
        [
            versionNumber.topAnchor.constraint(equalTo: logoImage.bottomAnchor, constant: 20),
            versionNumber.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor)
        ].forEach({$0.isActive = true})
        versionNumber.textColor = .black
        versionNumber.font = .systemFont(ofSize: 20)
        versionNumber.text = "\(NSLocalizedString("The current version is", comment: "")) \(model.getTheCurrentVersionNumber())"
    }
}
