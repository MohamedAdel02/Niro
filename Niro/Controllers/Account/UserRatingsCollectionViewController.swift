//
//  UserRatingsCollectionViewController.swift
//  Niro
//
//  Created by Mohamed Adel on 13/08/2023.
//

import UIKit

class UserRatingsCollectionViewController: UICollectionViewController {

    
    var userRatings = [Item]()
    
    override func viewDidLoad() {
        super.viewDidLoad()


        self.collectionView!.register(RatingsCollectionViewCell.self, forCellWithReuseIdentifier: K.Identifier.ratingsCollectionViewCell)
        
        title = "Ratings"
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = UIColor(named: "mainColor")
        navigationItem.backButtonTitle = ""
                
    }

    override func viewWillAppear(_ animated: Bool) {

        userRatings = UserListHelper.shared.getUserRatings()
        collectionView.reloadData()
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return userRatings.count
    }

    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.Identifier.ratingsCollectionViewCell, for: indexPath) as! RatingsCollectionViewCell
        
        cell.ratingImageView.image =  UIImage(systemName: "\(Int(userRatings[indexPath.row].rating!)).circle.fill")
        
        Task {
            await handleImageView(cell: cell, indexPath: indexPath)
        }
        
        return cell
    }
    

    
    func handleImageView(cell: RatingsCollectionViewCell, indexPath: IndexPath) async {
        
        let title = userRatings[indexPath.row]
        
        cell.posterImageView.image = nil
        cell.nameLabel.isHidden = true

        do {
            
            var imageData: Data?

            if let posterPath = title.posterPath {
                imageData = try await NetworkManager.shared.data(imagePath: posterPath)
            }

            if let imageData = imageData {
                cell.posterImageView.image = UIImage(data: imageData)
                return
            }
            
            handleDefaultImage(cell: cell, indexPath: indexPath, mediaType: title.type)
        } catch {
            
            handleDefaultImage(cell: cell, indexPath: indexPath, mediaType: title.type)
        }
        
    }

    
    func handleDefaultImage(cell: RatingsCollectionViewCell, indexPath: IndexPath, mediaType: String?) {
        
        if mediaType == "movie" {
            cell.nameLabel.text = userRatings[indexPath.row].title
        } else {
            cell.nameLabel.text = userRatings[indexPath.row].name
        }
        
        cell.nameLabel.isHidden = false
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {        
        
        if userRatings[indexPath.row].type == "movie" {
            
            let vc = MovieDetailsViewController()
            vc.movieId = userRatings[indexPath.row].id
            navigationController?.pushViewController(vc, animated: true)
        } else {
            
            let vc = TVShowDetailsViewController()
            vc.showId = userRatings[indexPath.row].id
            navigationController?.pushViewController(vc, animated: true)
        }
        
    }
}



// MARK: - UICollectionViewDelegateFlowLayout

extension UserRatingsCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    
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
