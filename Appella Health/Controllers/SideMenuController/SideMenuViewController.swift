//
//  SideMenuViewController.swift
//  Appella Health
//
//  Created by F.Q. on 27.03.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import SideMenu

class SideMenuViewController: UIViewController {
    
    //MARK: - Properties
    
    var kitchen: SideMenuKitchen!

    //MARK: - Outlets
    
    @IBOutlet var tableView: UITableView!
    
    //MARK: - DependencyInjections
    
    func inject(kitchen: SideMenuKitchen) {
        self.kitchen = kitchen
    }
    
    //MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        let nib = UINib(nibName: SideMenuTableViewCell.identifier, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: SideMenuTableViewCell.identifier)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let viewHeight = view.frame.size.height - 20
        let tableViewContentHeight = tableView.contentSize.height
        let marginHeight = (viewHeight - tableViewContentHeight) / 2.0
        
        tableView.contentInset = UIEdgeInsets(top: marginHeight, left: 0, bottom:  -marginHeight, right: 0)
    }
}

//MARK: - UITableViewDataSource

extension SideMenuViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ArticleCategory.allCategories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let category = ArticleCategory.allCategories[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SideMenuTableViewCell.identifier, for: indexPath) as? SideMenuTableViewCell else {
            fatalError("Unexpected UITableViewCell")
        }
        let imageViewIsHidden = indexPath.row != ArticleCategory.allCategories.count - 1
        cell.setupCell(with: category.describing, imageViewIsHidden: imageViewIsHidden)
        return cell
    }
}

//MARK: - UITableViewDelegate

extension SideMenuViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let category = ArticleCategory.allCategories[indexPath.row]
        switch category {
        case .appellaHealth:
            break
        default:
            kitchen.receive(event: .disSelectCategory(category: category))
            dismiss(animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        let category = ArticleCategory.allCategories[indexPath.row]
        if category == .appellaHealth {
            return false
        }
        return true
    }
}

//MARK: - Kitchen Delegate

extension SideMenuViewController: KitchenDelegate {
    typealias Command = SideMenuState
    
    func perform(_ command: SideMenuState) {
        switch command {
        default:
            break
        }
    }
}
