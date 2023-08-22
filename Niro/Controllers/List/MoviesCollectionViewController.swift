//
//  MoviesCollectionViewController.swift
//  Niro
//
//  Created by Mohamed Adel on 01/08/2023.
//

import UIKit
import Alamofire

enum MediaType {
    case movie
    case tvShow
}

class MoviesCollectionViewController: UICollectionViewController {

    var items = [Item]()
    
    var url = NetworkHelper.getPopularMoviesURL()
    var mediaType: MediaType = .movie
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView.register(MoviesCollectionViewCell.self, forCellWithReuseIdentifier: K.Identifier.moviesCollectionViewCell)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = UIColor(named: "mainColor")
        
        navigationController?.navigationBar.tintColor = UIColor.label
        navigationItem.backButtonTitle = ""

        
        Task {
            do {
                try await loadData()
            } catch {
                showAlert(title: "Unable to load data", message: "An error occurred while loading data, please check your network connection and try again")
            }

        }
    }

    
    func loadData() async throws {
        
        let data = try await NetworkManager.shared.data(url: url)
        let decodedData = try NetworkManager.shared.decodeData(data: data) as List
        try await handleData(data: decodedData)
        collectionView.reloadData()
        
    }
    
    
    func handleData(data: List) async throws {
        
        for item in data.results {
            let poster = try await getPoster(item: item)
            items.append(Item(id: item.id, title: item.title, name: item.name, poster: poster))
        }
    }
    
    
    func getPoster(item: Item) async throws -> Data? {
        
        if let posterPath = item.posterPath {
            return try await NetworkManager.shared.data(imagePath: posterPath)
        }
        
        return nil
    }
        
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.isEmpty ? 0 : 18
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.Identifier.moviesCollectionViewCell, for: indexPath) as! MoviesCollectionViewCell
        
        if let posterData = items[indexPath.row].poster {

            cell.imageView.image = UIImage(data: posterData)
        } else {
        
            handleDefaultImage(cell: cell, indexPath: indexPath)
        }
        
        return cell
    }
    
    
    func handleDefaultImage(cell: MoviesCollectionViewCell, indexPath: IndexPath) {
        
        if mediaType == .movie {
            cell.nameLabel.text = items[indexPath.row].title
        } else {
            cell.nameLabel.text = items[indexPath.row].name
        }
        
        cell.nameLabel.isHidden = false
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if mediaType == .movie {
            
            let vc = MovieDetailsViewController()
            vc.movieId = items[indexPath.row].id
            navigationController?.pushViewController(vc, animated: true)
        } else {
            
            let vc = TVShowDetailsViewController()
            vc.showId = items[indexPath.row].id
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}



// MARK: - UICollectionViewDelegateFlowLayout

extension MoviesCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width * 0.3, height: self.view.frame.width * 0.4)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
     
}
