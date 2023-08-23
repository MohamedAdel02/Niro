//
//  AllFilmographyViewController.swift
//  Niro
//
//  Created by Mohamed Adel on 14/08/2023.
//

import UIKit

class AllFilmographyViewController: UIViewController {

    let allFilmographyView = AllFilmographyView()
    var filmography: Filmography?
    var departments = [(department: String, isActive: Bool)]()
    var department = ""
    var titles = [FilmographyItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view = allFilmographyView
        
        navigationItem.backButtonTitle = ""
        
        allFilmographyView.filmographyTableView.register(CustomTableViewCell.self, forCellReuseIdentifier: K.Identifier.customTableViewCell)

        
        allFilmographyView.departmentsCollectionView.register(GenreCollectionViewCell.self, forCellWithReuseIdentifier: K.Identifier.genreCollectionViewCell)
        
        allFilmographyView.departmentsCollectionView.dataSource = self
        allFilmographyView.departmentsCollectionView.delegate = self
        
        allFilmographyView.filmographyTableView.dataSource = self
        allFilmographyView.filmographyTableView.delegate = self
        
        getDepartments()
    }
    
    func getDepartments() {
        
        guard let filmography = filmography else {
            return
        }

        
        if !filmography.cast.isEmpty {
            departments.append((department: "Acting", isActive: false))
        }
        
        let crewDepartments = getDepartments(filmography: filmography)

        for deptartment in crewDepartments {
            departments.append((department: deptartment, isActive: false))
        }
        
        if !departments.isEmpty {
            department = departments[0].department
            departments[0].isActive = true
            allFilmographyView.departmentsCollectionView.reloadData()
            updateTitles()
        }
        
    }
    
    
    func getDepartments(filmography: Filmography) -> [String] {
        
        var departmentSet = Set<String>()

        for title in filmography.crew {
            guard let department = title.department else {
                continue
            }
            
            departmentSet.insert(department)
        }
        
        return departmentSet.sorted()
    }
    
    
    func updateTitles() {
        
        guard let filmography = filmography else {
            return
        }
        
        if department == "Acting" {
            titles = filmography.cast
        } else {
            titles = filmography.crew.filter({ $0.department == department })
        }
        
        allFilmographyView.filmographyTableView.reloadData()
    }

}



// MARK: - UICollectionViewDataSource, UICollectionViewDelegate

extension AllFilmographyViewController: UICollectionViewDataSource, UICollectionViewDelegate {


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return departments.count
    }


    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.Identifier.genreCollectionViewCell, for: indexPath) as! GenreCollectionViewCell

        cell.label.text = departments[indexPath.row].department
        cell.layer.cornerRadius = 12
        cell.backgroundColor = .systemGray4
        
        if departments[indexPath.row].isActive {
            cell.backgroundColor = .systemGray
        }

        return cell
    }


    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        for index in 0..<departments.count {
            
            departments[index].isActive = false
        }
        
        departments[indexPath.row].isActive = true
        
        department = departments[indexPath.row].department
        allFilmographyView.departmentsCollectionView.reloadData()
        updateTitles()

    }

}



// MARK: - UICollectionViewDelegateFlowLayout

extension AllFilmographyViewController: UICollectionViewDelegateFlowLayout {


    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

            return CGSize(width: 100, height: 30)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }


    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }

}



// MARK: - UITableViewDataSource, UITableViewDelegate

extension AllFilmographyViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: K.Identifier.customTableViewCell, for: indexPath) as! CustomTableViewCell
        
        cell.customImageView.image = nil
        cell.defaultImageView.isHidden = true

        Task {
            await handleImageView(cell: cell, indexPath: indexPath)
        }
        
        cell.mainTextLabel.text = titles[indexPath.row].title ?? titles[indexPath.row].name
        cell.subTextLabel.text = titles[indexPath.row].character ?? titles[indexPath.row].job

        return cell
    }
    
    
    func handleImageView(cell: CustomTableViewCell, indexPath: IndexPath) async {
        
        let posterPath = titles[indexPath.row].posterPath

        do {
            var imageData: Data?

            if let posterPath = posterPath {
                imageData = try await NetworkManager.shared.data(imagePath: posterPath)
            }
            
            if let imageData = imageData {
                cell.customImageView.image = UIImage(data: imageData)
                return
            }

            handleDefaultImage(cell: cell, mediaType: titles[indexPath.row].mediaType)
        } catch {
            handleDefaultImage(cell: cell, mediaType: titles[indexPath.row].mediaType)
        }
    }
    
    
    func handleDefaultImage(cell: CustomTableViewCell, mediaType: String?) {
        
        if  mediaType == "movie" {
            cell.defaultImageView.image = UIImage(systemName: "film")
        } else {
            cell.defaultImageView.image = UIImage(systemName: "tv")
        }
        
        cell.defaultImageView.isHidden = false
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        
        if titles[indexPath.row].mediaType == "movie" {
            
            let vc = MovieDetailsViewController()
            vc.movieId = titles[indexPath.row].id
            navigationController?.pushViewController(vc, animated: true)
        } else {
            
            let vc = TVShowDetailsViewController()
            vc.showId = titles[indexPath.row].id
            navigationController?.pushViewController(vc, animated: true)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)

    }


}


