//
//  UpComingViewController.swift
//  Netflix-Clone
//
//  Created by serhat on 6.07.2024.
//

import UIKit

final class UpComingViewController: UIViewController{
    
    private var titles:[ResultMovie] = []
    
    private let upComingTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Upcoming"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        upComingTableView.delegate = self
        upComingTableView.dataSource = self
        view.addSubview(upComingTableView)
        fetchUpComing()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        upComingTableView.frame = view.bounds
    }
    
    private func fetchUpComing(){
        ApiCaller.shared.getUPComingMovies { [weak self] results in
            switch results {
            case .success(let success):
                self?.titles = success.results!
                DispatchQueue.main.async {self?.upComingTableView.reloadData()}
            case .failure(let failure):
                print(failure)
            }
        }
    }
    
}


extension UpComingViewController: UITableViewDelegate,UITableViewDataSource {
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
