//
//  MainView.swift
//  Appella Health
//
//  Created by F.Q. on 29.03.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class MainView: UIView {
    
    //MARK: - Properties
    
    private var viewState: MainViewState? {
        didSet {
            tableView.reloadData()
            if tableView.numberOfSections > 0, tableView.numberOfRows(inSection: 0) > 0 {
                tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
            }
        }
    }
    weak var delegate: MainViewControllerDelegate?
    
    //MARK: - Outlets

    @IBOutlet private var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
            if #available(iOS 11.0, *) {
                tableView.contentInsetAdjustmentBehavior = .never
            } else {
                // Fallback on earlier versions
            }
            
            let mainViewLargeTableViewCellNib = UINib(nibName: MainViewLargeTableViewCell.identifier, bundle: nil)
            tableView.register(mainViewLargeTableViewCellNib, forCellReuseIdentifier: MainViewLargeTableViewCell.identifier)
            let mainViewSmallTableViewCellNib = UINib(nibName: MainViewSmallTableViewCell.identifier, bundle: nil)
            tableView.register(mainViewSmallTableViewCellNib, forCellReuseIdentifier: MainViewSmallTableViewCell.identifier)
        }
    }
    
    //MARK: - Configuration
    
    func configure(viewState: MainViewState) {
        self.viewState = viewState
    }
    
    //MARK: - Helpers
    
    func getArticleId(for cell: UITableViewCell) -> Int? {
        guard let indexPath = tableView.indexPath(for: cell) else {
            return nil
        }
        return indexPath.row
    }
    
}

//MARK: - UITableView Data Source

extension MainView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let viewState = viewState else {
            return 0
        }
        return viewState.articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewState = viewState else {
            fatalError("failed to get data")
        }
        let article = viewState.articles[indexPath.row]
        if indexPath.row == 0 {
            guard let fullScreenCell = tableView.dequeueReusableCell(withIdentifier: MainViewLargeTableViewCell.identifier, for: indexPath) as? MainViewLargeTableViewCell else {
                fatalError("Failed to deque MainViewLargeTableViewCell")
            }
            fullScreenCell.configure(with: article)
            return fullScreenCell
        }
        else {
            guard let smallCell = tableView.dequeueReusableCell(withIdentifier: MainViewSmallTableViewCell.identifier, for: indexPath) as? MainViewSmallTableViewCell else {
                fatalError("Failed to deque MainViewSmallTableViewCell")
            }
            smallCell.configure(with: article)
            return smallCell
        }
    }
}

//MARK: - UITableView Delegate

extension MainView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return self.bounds.height
        }
        else {
            return self.bounds.width / 2
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let articleId = viewState?.articles[indexPath.row].id else {
            return
        }
        delegate?.didSelectArticleWith(id: articleId)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
