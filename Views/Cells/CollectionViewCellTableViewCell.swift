//
//  CollectionViewCellTableViewCell.swift
//  Netflix-Clone
//
//  Created by serhat on 6.07.2024.
//

import UIKit

protocol CollectionViewCellTableViewCellDelegate: AnyObject {
    func CollectionViewCellTableViewCellDidTapped(_ cell: CollectionViewCellTableViewCell,moviePreviewViewModel: MoviePreviewViewModel)
}
class CollectionViewCellTableViewCell: UITableViewCell {
    
    static let identifier = "CollectionViewCellTableViewCell"
    weak var delegate: CollectionViewCellTableViewCellDelegate?
    private var titles: [ResultMovie] = []
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 140, height: 200)
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
        return collectionView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .systemBackground
        contentView.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.bounds
    }
    
    public func configure(with titles: [ResultMovie]) {
        self.titles = titles
        DispatchQueue.main.async {[weak self] in 
            self?.collectionView.reloadData()
        }
    }
    
    private func downloadItemAt(indexPath: IndexPath){
        let model = titles[indexPath.row]
        DataPersistenceManager.shared.downloadTitleWith(model: model) { results in
            switch results {
            case .success(let success):
                NotificationCenter.default.post(name:  NSNotification.Name("downloaded"), object: nil)
            case .failure(let e):
                print(e)
            }
        }
    }
    
}


extension CollectionViewCellTableViewCell: UICollectionViewDelegate,UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        titles.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath) as? TitleCollectionViewCell else {return UICollectionViewCell()}
        guard let imageUrl = titles[indexPath.item].posterPath else {return UICollectionViewCell()}
            cell.configure(with: imageUrl)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        collectionView.deselectItem(at: indexPath, animated: true)
        let title = titles[indexPath.item]
        guard let titleName = title.originalTitle ?? title.originalName else {return}
        
        ApiCaller.shared.getMovieFromYoutube(with: titleName + " trailer") { [weak self] results in
            guard let self = self else {return}
            switch results {
            case .success(let videoElement):
                let viewModel = MoviePreviewViewModel(title: titleName, youtubeView: videoElement, titleOverview: title.overview ?? "")
                self.delegate?.CollectionViewCellTableViewCellDidTapped(self, moviePreviewViewModel: viewModel)
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let config = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            let downloadAction = UIAction(title: "Download", image: nil, discoverabilityTitle: nil, state: .off) { _ in
                self.downloadItemAt(indexPath: indexPath)
            }
            return UIMenu(title: "", subtitle: nil, image: nil, identifier: nil, options: .displayInline, children: [downloadAction])
        }
        
        return config
    }
    
}
