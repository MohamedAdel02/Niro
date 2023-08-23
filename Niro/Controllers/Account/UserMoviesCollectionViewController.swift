//
//  UserMoviesCollectionViewController.swift
//  Niro
//
//  Created by Mohamed Adel on 11/08/2023.
//

import UIKit


class UserMoviesCollectionViewController: UICollectionViewController {

    var listType: AccountTableViewRows?
    var list = [Title]()
    
    override func viewDidLoad() {
        super.viewDidLoad()


        self.collectionView.register(MoviesCollectionViewCell.self, forCellWithReuseIdentifier: K.Identifier.moviesCollectionViewCell)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = UIColor(named: "mainColor")
        navigationItem.backButtonTitle = ""

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if listType == .favorite {
            list = UserListHelper.shared.getFavoriteList()
        } else if listType == .watchlist {
            list = UserListHelper.shared.getWatchlist()
        }
        
        collectionView.reloadData()
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return list.count
    }

    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.Identifier.moviesCollectionViewCell, for: indexPath) as! MoviesCollectionViewCell
        
        cell.imageView.image = nil
        cell.nameLabel.isHidden = true
        
        if let posterData = list[indexPath.row].poster {
            cell.imageView.image = UIImage(data: posterData)
        }else {
            handleDefaultImage(cell: cell, indexPath: indexPath, mediaType: list[indexPath.row].type)
        }
        
        return cell
    }
    
    
    func handleDefaultImage(cell: MoviesCollectionViewCell, indexPath: IndexPath, mediaType: String?) {
        
        if mediaType == "movie" {
            cell.nameLabel.text = list[indexPath.row].title
        } else {
            cell.nameLabel.text = list[indexPath.row].name
        }
        
        cell.nameLabel.isHidden = false
    }
        
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if list[indexPath.row].type == "movie" {
            
            let vc = MovieDetailsViewController()
            vc.movieId = list[indexPath.row].id
            navigationController?.pushViewController(vc, animated: true)
        } else {
            
            let vc = TVShowDetailsViewController()
            vc.showId = list[indexPath.row].id
            navigationController?.pushViewController(vc, animated: true)
        }
      
    }


}



// MARK: - UICollectionViewDelegateFlowLayout

extension UserMoviesCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    
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
        return UIEdgeInsets(top: 15, left: 10, bottom: 10, right: 10)
    }
    
     
}

