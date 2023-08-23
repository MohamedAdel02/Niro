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

    var titles = [Title]()
    
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
        
        titles = data.results
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.isEmpty ? 0 : 18
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.Identifier.moviesCollectionViewCell, for: indexPath) as! MoviesCollectionViewCell
        
        Task {
            await handleImageView(cell: cell, indexPath: indexPath)
        }
        
        return cell
    }
    
    
    func handleImageView(cell: MoviesCollectionViewCell, indexPath: IndexPath) async {
        
        let title = titles[indexPath.row]
        
        cell.imageView.image = nil
        cell.nameLabel.isHidden = true
        
        do {
            
            var imageData: Data?
            
            if let posterPath = title.posterPath {
                imageData = try await NetworkManager.shared.data(imagePath: posterPath)
            }
            
            if let imageData = imageData {
                cell.imageView.image = UIImage(data: imageData)
                return
            }
            
            handleDefaultImage(cell: cell, indexPath: indexPath)
        } catch {
            
            handleDefaultImage(cell: cell, indexPath: indexPath)
        }
        
    }
    
    
    func handleDefaultImage(cell: MoviesCollectionViewCell, indexPath: IndexPath) {
        
        if mediaType == .movie {
            cell.nameLabel.text = titles[indexPath.row].title
        } else {
            cell.nameLabel.text = titles[indexPath.row].name
        }
        
        cell.nameLabel.isHidden = false
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if mediaType == .movie {
            
            let vc = MovieDetailsViewController()
            vc.movieId = titles[indexPath.row].id
            navigationController?.pushViewController(vc, animated: true)
        } else {
            
            let vc = TVShowDetailsViewController()
            vc.showId = titles[indexPath.row].id
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
