//
//  SearchResultViewController.swift
//  Netflix-Clone
//
//  Created by serhat on 11.07.2024.
//

import UIKit

protocol SearchResultViewControllerDelegate: AnyObject {
    func SearchResultViewControllerDidItemTapped(_viewModel: MoviePreviewViewModel)
}

final class SearchResultViewController: UIViewController {
    
     public var titles: [ResultMovie] = []
     public weak var delegate: SearchResultViewControllerDelegate?
    
     public let searchResultCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 3 - 10, height: 200)
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(searchResultCollectionView)
        
        searchResultCollectionView.delegate   = self
        searchResultCollectionView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchResultCollectionView.frame = view.bounds
        
    }
    
    
}


extension SearchResultViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath) as? TitleCollectionViewCell else {return UICollectionViewCell()}
        let title = titles[indexPath.item]
        guard let imageUrl = title.posterPath else {return UICollectionViewCell()}
        cell.configure(with: imageUrl)
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
            let title = self.titles[indexPath.item]
            guard let titleName = title.originalTitle ?? title.originalName,
                  let overview  = title.overview else {return}
            ApiCaller.shared.getMovieFromYoutube(with: titleName) { [weak self] results in
                switch results {
                case .success(let item):
                    let viewModel = MoviePreviewViewModel(title: titleName, youtubeView: item, titleOverview: overview)
                    self?.delegate?.SearchResultViewControllerDidItemTapped(_viewModel: viewModel)
                case .failure(let error):
                    print(error)
                }
            }
    }
    
}
