//
//  ItemsListViewDelegate.swift
//  ToDoList
//
//  Created by Софья Тимохина on 13.07.2021.
//

import Foundation
import Models

protocol ItemsListViewDelegate: AnyObject {
    func reloadItems()
    func tableViewAddCell()
    func tableViewReloadCell(at indexPath: IndexPath)
    func tableViewDeleteCell(at indexPath: IndexPath)
    func presentViewController(_ viewController: UIViewController)
    func startAnimatingSpinner()
    func stopAnimatingSpinner()
}
