//
//  SearchViewController.swift
//  Netflix-Clone
//
//  Created by serhat on 6.07.2024.
//

import UIKit

final class SearchViewController: UIViewController {
    
    private var titles: [ResultMovie] = []
    
    private let discoverTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        return tableView
    }()
    
    private let searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: SearchResultViewController())
        controller.searchBar.placeholder = "Search for a Movie or Tv show"
        controller.searchBar.searchBarStyle = .minimal
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        navigationItem.searchController = searchController
        navigationController?.navigationBar.tintColor = .white
        discoverTableView.delegate = self
        discoverTableView.dataSource = self
        view.addSubview(discoverTableView)
        fetchDiscoverMovie()
        searchController.searchResultsUpdater = self
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        discoverTableView.frame = view.bounds
    }
    
    private func fetchDiscoverMovie(){
        ApiCaller.shared.getDiscoverMovies { [weak self]results in
            switch results {
            case .success(let success):
                self?.titles = success.results!
                DispatchQueue.main.async {self?.discoverTableView.reloadData()}
            case .failure(let failure):
                print(failure)
            }
        }
    }
    
    

}

extension SearchViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as? TitleTableViewCell else {return UITableViewCell()}
        let movie = titles[indexPath.row]
        guard let title = movie.title, let imageUrl = movie.posterPath else {return UITableViewCell()}
        let titleViewModel = TitleViewModel(title: title, imageUrl: imageUrl)
        cell.configure(with: titleViewModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let title = titles[indexPath.row]
        guard let titleName = title.originalTitle ?? title.originalName,
              let overview = title.overview else {return}
   
            ApiCaller.shared.getMovieFromYoutube(with: titleName + " trailer") { [weak self] results in
                guard let self = self else {return}
                switch results {
                case .success(let videoElement):
                    let viewModel = MoviePreviewViewModel(title: titleName, youtubeView: videoElement, titleOverview: overview)
                    DispatchQueue.main.async{
                        let destinationVC = MoviePreviewViewController()
                        destinationVC.configure(with: viewModel)
                        
                        self.navigationController?.pushViewController(destinationVC, animated: true)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
     
    }
    
}

extension SearchViewController: UISearchResultsUpdating, SearchResultViewControllerDelegate{
    func SearchResultViewControllerDidItemTapped(_viewModel: MoviePreviewViewModel) {
        DispatchQueue.main.async {[weak self] in 
            let destinationVc = MoviePreviewViewController()
            destinationVc.configure(with: _viewModel)
            self?.navigationController?.pushViewController(destinationVc, animated: true)
        }
     
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        guard let query = searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty,
              query.trimmingCharacters(in: .whitespaces).count >= 3,
              let resultsController = searchController.searchResultsController as? SearchResultViewController else {return}
        resultsController.delegate = self
        ApiCaller.shared.search(with: query) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let success):
                    resultsController.titles = success.results!
                    resultsController.searchResultCollectionView.reloadData()
                case .failure(let failure):
                    print(failure.localizedDescription)
                }
            }
           
        }
    }
}
