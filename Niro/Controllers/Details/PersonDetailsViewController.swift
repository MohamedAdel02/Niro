//
//  PersonDetailsViewController.swift
//  Niro
//
//  Created by Mohamed Adel on 13/08/2023.
//

import UIKit

class PersonDetailsViewController: UIViewController {

    let personDetailsView = PersonDetailsView()
    var personId: Int!
    var personDetails: PersonDetails?
    var filmography = [Title]()
    var allFilmography: Filmography?
    
    var websites = [(name: "TMDB", url: K.URL.tmdbPerson)]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view = personDetailsView
        
        navigationItem.backButtonTitle = ""
        
        personDetailsView.filmographyView.collectionView.register(DetailsCollectionViewCell.self, forCellWithReuseIdentifier: K.Identifier.detailsCollectionViewCell)
        
        personDetailsView.exploreMoreTableView.register(UITableViewCell.self, forCellReuseIdentifier: K.Identifier.tableViewCell)
        
        personDetailsView.filmographyView.collectionView.dataSource = self
        personDetailsView.filmographyView.collectionView.delegate = self

        personDetailsView.exploreMoreTableView.dataSource = self
        personDetailsView.exploreMoreTableView.delegate = self
        
        personDetailsView.filmographyView.seeAllButton.addTarget(self, action: #selector(seeAllPressed), for: UIControl.Event.touchUpInside)

        
        Task {
            await loadDetails()
            await loadFilmography()
        }

        
    }
    
    func loadDetails() async {
        
        do {
            let url = NetworkHelper.getPersonDetailsURL(personId: personId)
            let data = try await NetworkManager.shared.data(url: url)
            let decodedData = try NetworkManager.shared.decodeData(data: data) as PersonDetails
            try await handleData(data: decodedData)
            setData()
            resizeScrollView()
            
        } catch {
            showAlert(title: "Unable to load data", message: "An error occurred while loading data, please check your network connection and try again")
        }
    }

    

    func handleData(data: PersonDetails) async throws {
        
        let profile = try await getImage(path: data.profilePath)
        
        personDetails = PersonDetails(id: data.id, name: data.name, profilePath: data.profilePath, profile: profile, birthday: data.birthday, deathday: data.deathday, imdbId: data.imdbId, knownForDepartment: data.knownForDepartment)

    }
    
    
    func getImage(path: String?) async throws -> Data? {
        
        if let path = path {
            return try await NetworkManager.shared.data(imagePath: path)
        }

        return nil
    }
    
    

    
    func loadFilmography() async {

        do {
            let url = NetworkHelper.getPersonFilmographyURL(personId: personId)
            let data = try await NetworkManager.shared.data(url: url)
            let decodedData = try NetworkManager.shared.decodeData(data: data) as Filmography
            handleData(data: decodedData)
            personDetailsView.filmographyView.collectionView.reloadData()
            
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    
    
    func handleData(data: Filmography) {
        
        allFilmography = data
        
        guard let knownForDepartment = personDetails?.knownForDepartment else {
            handleTitlesData(titles: data.cast)
            return
        }
        
        if knownForDepartment == "Acting" {
              handleTitlesData(titles: data.cast)
        } else {
              handleTitlesData(titles: data.crew, department: knownForDepartment)
        }
        
    }
    
    
    func handleTitlesData(titles: [Title]) {
        
        var numOfTitles = 0
        
        for title in titles {

            if numOfTitles > 14 {
                break
            }
            
            self.filmography.append(Title(id: title.id, title: title.title, name: title.name, mediaType: title.mediaType, posterPath: title.posterPath, character: title.character, department: title.department, job: title.job))
            
            numOfTitles += 1
        }
    }
    
    
    func handleTitlesData(titles: [Title], department: String) {
        
        var numOfTitles = 0
        
        for title in titles {
            if numOfTitles > 14 {
                break
            }
            
            if department == title.department {
                self.filmography.append(Title(id: title.id, title: title.title, name: title.name, mediaType: title.mediaType, posterPath: title.posterPath, character: title.character, department: title.department, job: title.job))
                
                numOfTitles += 1

            }
        }
                
    }

    
    func setData() {
          
        guard let personDetails = personDetails else {
            return
        }
        
        title = personDetails.name

        personDetailsView.nameLabel.text = personDetails.name
        personDetailsView.profileImageView.image = getPoster(profile: personDetails.profile)
        updateWebisteList(personDetatils: personDetails)
        
        if let birthDate = personDetails.birthday {
            setBirthDate(birthDate: birthDate)
        }
        
        if let deathDate = personDetails.deathday {
            setDeathDate(deathDate: deathDate)
        }
    }
    
    
    func getPoster(profile: Data?) -> UIImage? {
        
        if let profile = profile {
             return UIImage(data: profile)
        } else {
            personDetailsView.defaultImageView.image = UIImage(systemName: "person.fill")
            personDetailsView.defaultImageView.isHidden = false
            
            return nil
        }
    }
    
    
    func updateWebisteList(personDetatils: PersonDetails) {
        
        if personDetatils.imdbId != nil {
            websites.insert((name: "IMDB", url: K.URL.imdbPerson), at: 0)
            personDetailsView.exploreMoreTableView.reloadData()
        }
    }
    
    
    func setBirthDate(birthDate: String) {
        let birthYear = birthDate.prefix(4)
        let birthDay = birthDate.suffix(2)
        
        let start = birthDate.index(birthDate.startIndex, offsetBy: 5)
        let end = birthDate.index(birthDate.startIndex, offsetBy: 6)
        let birthMonth = birthDate[start...end]
        
        personDetailsView.dateOfBirthLabel.text = "\(birthMonth)/\(birthDay)/\(birthYear)"
        
        personDetailsView.bornTextLabel.isHidden = false
        personDetailsView.dateOfBirthLabel.isHidden = false
    }
    
    
    func setDeathDate(deathDate: String) {
        let deathYear = deathDate.prefix(4)
        let deathDay = deathDate.suffix(2)

        let start = deathDate.index(deathDate.startIndex, offsetBy: 5)
        let end = deathDate.index(deathDate.startIndex, offsetBy: 6)
        let deathMonth = deathDate[start...end]
                
        personDetailsView.dateOfDeathLabel.text = "\(deathMonth)/\(deathDay)/\(deathYear)"
        
        personDetailsView.diedTextLabel.isHidden = false
        personDetailsView.dateOfDeathLabel.isHidden = false
    }
    
    

    @objc func seeAllPressed() {
        
        let vc = AllFilmographyViewController()
        vc.filmography = allFilmography
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        resizeScrollView()
    }
    
    func resizeScrollView() {
        
        view.layoutIfNeeded()

        let contentRect: CGRect = personDetailsView.contentView.frame
        
        personDetailsView.scrollView.snp.makeConstraints { make in
            make.height.equalTo(contentRect.size.height)
            make.width.equalTo(contentRect.size.width)
        }
        
        personDetailsView.scrollView.contentSize = contentRect.size
    }

    
}



// MARK: - UICollectionViewDataSource, UICollectionViewDelegate

extension PersonDetailsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filmography.isEmpty ? 0 : filmography.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.Identifier.detailsCollectionViewCell, for: indexPath) as! DetailsCollectionViewCell
        
        cell.imageView.image = nil
        cell.defaultImageView.isHidden = true
        
        Task {
             await handleImageView(cell: cell, indexPath: indexPath)
        }
        
        cell.mainTextLabel.text = filmography[indexPath.row].title ?? filmography[indexPath.row].name
        cell.subTextLabel.text = filmography[indexPath.row].character ?? filmography[indexPath.row].job
        
        cell.mainTextLabel.numberOfLines = 1
        cell.mainTextLabel.textAlignment = .left
        cell.mainTextLabel.font = .systemFont(ofSize: 12)
        cell.subTextLabel.textAlignment = .left
        cell.subTextLabel.font = .systemFont(ofSize: 10)

        return cell
    }
    
    
    func handleImageView(cell: DetailsCollectionViewCell, indexPath: IndexPath) async {
        
        let profilePath = filmography[indexPath.row].posterPath

        do {
            var imageData: Data?

            if let profilePath = profilePath {
                imageData = try await NetworkManager.shared.data(imagePath: profilePath)
            }
            
            if let imageData = imageData {
                cell.imageView.image = UIImage(data: imageData)
                return
            }

            handleDefaultImage(cell: cell, mediaType: filmography[indexPath.row].mediaType)
            
        } catch {
            handleDefaultImage(cell: cell, mediaType: filmography[indexPath.row].mediaType)
        }
        
    }
    
    func handleDefaultImage(cell: DetailsCollectionViewCell, mediaType: String?) {
        
        if  mediaType == "movie" {
            cell.defaultImageView.image = UIImage(systemName: "film")
        } else {
            cell.defaultImageView.image = UIImage(systemName: "tv")
        }
        
        cell.defaultImageView.isHidden = false
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if filmography[indexPath.row].mediaType == "movie" {
            
            let vc = MovieDetailsViewController()
            vc.movieId = filmography[indexPath.row].id
            navigationController?.pushViewController(vc, animated: true)
        } else {
            
            let vc = TVShowDetailsViewController()
            vc.showId = filmography[indexPath.row].id
            navigationController?.pushViewController(vc, animated: true)
        }
        
    }

}


// MARK: - UICollectionViewDelegateFlowLayout

extension PersonDetailsViewController: UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 95, height: 150)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
    }
    
}




// MARK: - UITableViewDataSource, UITableViewDelegate

extension PersonDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return websites.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.Identifier.tableViewCell, for: indexPath)
        
        let websiteName = websites[indexPath.row].name
        
        cell.textLabel?.text = "More on \(websiteName)"
        cell.textLabel?.font = .systemFont(ofSize: 15)
        cell.accessoryView = UIImageView(image: UIImage(systemName: "arrowshape.turn.up.forward.circle.fill"))
        cell.tintColor = .label
        
        cell.imageView?.image = UIImage(named: websiteName)
        cell.imageView?.snp.makeConstraints { make in
            make.width.height.equalTo(30)
            make.leading.equalToSuperview().offset(30)
            make.top.equalToSuperview().offset(5)
        }

        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 30))
        
        let label = UILabel(frame: CGRect(x: 15, y: -10, width: headerView.frame.width ,height: headerView.frame.height))
        label.text = "Explore more"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        headerView.addSubview(label)
        
        return headerView
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let website = websites[indexPath.row]
        let url: URL?
        
        guard let personDetails = personDetails else {
            return
        }
        
        if website.name == "IMDB" {
            
            url = URL(string: "\(website.url)\(personDetails.imdbId!)")
        } else {
            
            url = URL(string: "\(website.url)\(personDetails.id)")
        }
        
        guard let url = url else {
            return
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        UIApplication.shared.open(url)
        
    }

    
}

