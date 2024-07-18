//
//  HomeViewController.swift
//  Netflix-Clone
//
//  Created by serhat on 6.07.2024.
//

import UIKit


enum Sections: Int {
    case TrendingMovie  = 0
    case TrendingTv     = 1
    case Popular        = 2
    case UpComingMovies = 3
    case TopRated       = 4
}

final class HomeViewController: UIViewController {

    private let sectionTitles = ["Trending Movies","Trending Tv","Popular","Upcoming Movies","Top rated"]
    
    private let homeTable: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(CollectionViewCellTableViewCell.self, forCellReuseIdentifier: CollectionViewCellTableViewCell.identifier)
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        homeTable.delegate = self
        homeTable.dataSource = self
        configureNavbar()
        view.addSubview(homeTable)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeTable.frame = view.bounds
        let heroHeaderView = HeroHeaderView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 450))
        homeTable.tableHeaderView = heroHeaderView
    }
    
    func configureNavbar() {
        var image = UIImage(named: "netflixLogo")
        image = image?.withRenderingMode(.alwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: nil)
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "play.rectangle"), style: .done, target: self, action: nil)
        ]
        
        navigationController?.navigationBar.tintColor = .white
    }

}

extension HomeViewController: UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewCellTableViewCell.identifier, for: indexPath) as? CollectionViewCellTableViewCell else { return UITableViewCell() }
        cell.delegate = self
        
        switch indexPath.section {
        case Sections.TrendingMovie.rawValue:
            ApiCaller.shared.getTrendingMovies { results in
                switch results {
                case .success(let success):
                    cell.configure(with: success.results!)
                case .failure(let failure):
                    print(failure)
                }
            }
        case Sections.TrendingTv.rawValue:
            ApiCaller.shared.getTrendingTV { results in
                switch results {
                case .success(let success):
                    cell.configure(with: success.results!)
                case .failure(let failure):
                    print(failure)
                }
            }
        case Sections.Popular.rawValue:
            ApiCaller.shared.getPopularMovies { results in
                switch results {
                case .success(let success):
                    cell.configure(with: success.results!)
                case .failure(let failure):
                    print(failure)
                }
            }
        case Sections.UpComingMovies.rawValue:
            ApiCaller.shared.getUPComingMovies { results in
                switch results {
                case .success(let success):
                    cell.configure(with: success.results!)
                case .failure(let failure):
                    print(failure)
                }
            }
        case Sections.TopRated.rawValue:
            ApiCaller.shared.getTopRatedMovies { results in
                switch results {
                case .success(let success):
                    cell.configure(with: success.results!)
                case .failure(let failure):
                    print(failure)
                }
            }
        default:
            return UITableViewCell()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        200
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        50
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultOffset = view.safeAreaInsets.top
        let offset = scrollView.contentOffset.y + defaultOffset
        
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else {return}
        header.textLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        header.textLabel?.frame = CGRect(x: header.bounds.origin.x + 20, y: header.bounds.origin.y, width: 100, height: header.bounds.height)
        header.textLabel?.textColor = .white
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
}

extension HomeViewController: CollectionViewCellTableViewCellDelegate{
    
    func CollectionViewCellTableViewCellDidTapped(_ cell: CollectionViewCellTableViewCell, moviePreviewViewModel: MoviePreviewViewModel) {
        DispatchQueue.main.async {[weak self] in
            let destinationVC = MoviePreviewViewController()
            destinationVC.configure(with: moviePreviewViewModel)
            self?.navigationController?.pushViewController(destinationVC, animated: true)
        }
    }
    
   
    
}
