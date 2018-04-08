//
//  ArticleView.swift
//  Appella Health
//
//  Created by F.Q. on 01.04.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import SDWebImage

protocol ArticleViewDelegate: class {
    func didTapPlayButton()
    func didTapImage()
}

class ArticleView: UIView {
    
    //MARK: - Consts
    
    enum Consts {
        static let sectionHeaderHeight: CGFloat = 23
    }
    
    //MARK: - Properties
    
    private var viewState: ArticleViewState! {
        didSet {
            tableView.reloadData()
        }
    }
    weak var articleViewControllerDelegate: ArticleViewControllerDelegate?
    
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
            
            let cellNib = UINib(nibName: MainViewSmallTableViewCell.identifier, bundle: nil)
            tableView.register(cellNib, forCellReuseIdentifier: MainViewSmallTableViewCell.identifier)
            let sectionHeaderNib = UINib(nibName: ArticleSectionHeader.identifier, bundle: nil)
            tableView.register(sectionHeaderNib, forCellReuseIdentifier: ArticleSectionHeader.identifier)
            let mainNib = UINib(nibName: ArticleMainTableViewCell.identifier, bundle: nil)
            tableView.register(mainNib, forCellReuseIdentifier: ArticleMainTableViewCell.identifier)
        }
    }
    
    //MARK: - Configuration
    
    func configureWith(viewState: ArticleViewState) {
        self.viewState = viewState
    }
}

//MARK: - UITableView Data Source

extension ArticleView: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        
        guard let viewState = viewState else {
            return 0
        }
        if viewState.articles.count > 0 {
            return 2
        }
        else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        else {
            return viewState.articles.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let article = viewState.article
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ArticleMainTableViewCell.identifier, for: indexPath) as? ArticleMainTableViewCell else {
                fatalError("Failed to dequeue ArticleMainTableViewCell")
            }
            cell.configure(with: article)
            cell.delegate = self
            return cell
        }
        else {
            guard let article = viewState?.articles[indexPath.row] else {
                fatalError("No article was found")
            }
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MainViewSmallTableViewCell.identifier, for: indexPath) as? MainViewSmallTableViewCell else {
                fatalError("Failed to dequeue MainViewSmallTableViewCell")
            }
            cell.configure(with: article)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return nil
        }
        guard let header = tableView.dequeueReusableCell(withIdentifier: ArticleSectionHeader.identifier) as? ArticleSectionHeader else {
            fatalError("Failed to dequeue ArticleSectionHeader")
        }
        header.configureWith(text: viewState.moreNewsTitle)
        return header
    }
}

//MARK: - UITableView Delegate

extension ArticleView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return UITableViewAutomaticDimension
        }
        return self.bounds.width / 2
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return .leastNormalMagnitude
        }
        return Consts.sectionHeaderHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let articleId = viewState?.articles[indexPath.row].id else {
            return
        }
        articleViewControllerDelegate?.didSelectArticleWith(id: articleId)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return indexPath.section != 0
    }
}

//MARK: - Article View Delegate

extension ArticleView: ArticleViewDelegate {
    func didTapPlayButton() {
        articleViewControllerDelegate?.playVideo(url: viewState.article.video)
    }
    
    func didTapImage() {
        guard viewState.canShowPhotos else {
            return
        }
        articleViewControllerDelegate?.show(photos: viewState.article.photoUrls)
    }
}
