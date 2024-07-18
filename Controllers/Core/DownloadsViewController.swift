//
//  DownloadsViewController.swift
//  Netflix-Clone
//
//  Created by serhat on 6.07.2024.
//

import UIKit

final class DownloadsViewController: UIViewController {
    private var titles: [TitleItem] = []
    
    private let downloadsTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        return tableView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Downloads"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        downloadsTableView.delegate = self
        downloadsTableView.dataSource = self
        view.addSubview(downloadsTableView)
        fetchLocalStorageForDownloads()
        NotificationCenter.default.addObserver(forName: NSNotification.Name("downloaded"), object: nil, queue: nil) { _ in
            self.fetchLocalStorageForDownloads()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        downloadsTableView.frame = view.bounds
    }

    private func fetchLocalStorageForDownloads(){
        DataPersistenceManager.shared.fetchTitleFromDatabase { results in
            switch results {
            case .success(let titles):
                self.titles = titles
                DispatchQueue.main.async{self.downloadsTableView.reloadData()}
            case .failure(let failure):
                print(failure)
            }
        }
    }

}


extension DownloadsViewController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as? TitleTableViewCell else {return UITableViewCell()}
        let movie = titles[indexPath.row]
        guard let title = movie.title ?? movie.originalTitle ?? movie.originalName, let imageUrl = movie.posterPath else {return UITableViewCell()}
        let titleViewModel = TitleViewModel(title: title, imageUrl: imageUrl)
        cell.configure(with: titleViewModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        150
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            DataPersistenceManager.shared.deleteTitleWith(model: titles[indexPath.row]) { [weak self] results in
                switch results {
                case .success(let success):
                    print("data deleted from the database")
                case .failure(let failure):
                    print(failure)
                }
                self?.titles.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                
            }
        default:
            break
        }
        
        
    }
    
}
