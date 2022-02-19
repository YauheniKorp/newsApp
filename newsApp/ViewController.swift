//
//  ViewController.swift
//  newsApp
//
//  Created by Admin on 18.02.2022.
//

import UIKit
import SafariServices

class ViewController: UIViewController {
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: NewsTableViewCell.identifier)
        return tableView
    }()
    
    private let searchVC = UISearchController(searchResultsController: nil)
    
    private var articles = [Article]()
    private var models = [NewsTableViewCellModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "News"
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        getTopStories()
        configureSearchBar()
        
        
    }
    
    private func configureSearchBar() {
        navigationItem.searchController = searchVC
        searchVC.searchBar.delegate = self
    }
    
    private func getTopStories() {
        ApiCaller.shared.getTopStories { result in
            switch result {
            case .success(let article):
                self.articles = article
                self.models = article.compactMap({ NewsTableViewCellModel(title: $0.title, subtitle: $0.description ?? "No description", imageUrl: URL(string: $0.urlToImage ?? ""))
                    
                })
                DispatchQueue.main.async {
                    self.tableView.reloadData()

                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.identifier, for: indexPath) as! NewsTableViewCell
        cell.configure(with: models[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let article = articles[indexPath.row]
        
        guard let url = URL(string: article.url ?? "") else {return}
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true, completion: nil)
        
        
    }
    
}

extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else {return}
        
        ApiCaller.shared.searchQuery(text) { result in
            switch result {
            case .success(let article):
                self.articles = article
                self.models = article.compactMap({ NewsTableViewCellModel(title: $0.title, subtitle: $0.description ?? "No description", imageUrl: URL(string: $0.urlToImage ?? ""))
                    
                })
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.searchVC.dismiss(animated: true, completion: nil)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
