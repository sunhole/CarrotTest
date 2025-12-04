//
//  SerachViewController.swift
//  CarrotTest
//
//  Created by vision on 12/2/25.
//

import UIKit

final class SearchViewController: UIViewController {
    private let viewModel = SearchViewModel()
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "검색어를 입력하세요."
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "책 검색"

        setupViews()
        setupTableView()
        setupSearchBar()
        
        self.search(query: "swift")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = true
        view.addSubview(searchBar)
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    private func setupSearchBar() {
        searchBar.delegate = self
    }
    
    private func search(query: String) {
        guard !query.isEmpty else { return }
        
        viewModel.search(query: query, completion: { [weak self] result in
            switch result {
            case .success:
                self?.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        })
    }
}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.books.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let book = viewModel.books[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        content.text = book.title
        content.secondaryText = book.subtitle.isEmpty ? book.isbn13 : book.subtitle
        cell.contentConfiguration = content
        
        return cell
    }
    
    
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let book = viewModel.books[indexPath.row]
        let detailViewModel = BookDetailViewModel(repository: BookRepositoryImpl(), isbn13: book.isbn13)
        let detailVC = BookDetailViewController(viewModel: detailViewModel)
        navigationController?.pushViewController(detailVC, animated: true)
        
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let text = searchBar.text ?? ""
        search(query: text)
        searchBar.resignFirstResponder()
    }
}
