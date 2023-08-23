//
//  MovieDetailsViewController.swift
//  Niro
//
//  Created by Mohamed Adel on 08/08/2023.
//

import UIKit
import SnapKit

class MovieDetailsViewController: UIViewController{

    let movieDetailsView = MovieDetailsView()
    var movieId: Int!
    var movieDetails: MovieDetails?
    var cast = [CastMember]()
    var directors = [CrewMember]()
    var isFavorite = false
    var isOnWatchlist = false
    var isRated = false
    var rating = 0.0
    var websites = [(name: "TMDB", url: K.URL.tmdbMovie)]

    
    override func viewDidLoad() {
        super.viewDidLoad()

        view = movieDetailsView
        
        navigationItem.backButtonTitle = ""
        
        movieDetailsView.genreCollectionView.register(GenreCollectionViewCell.self, forCellWithReuseIdentifier: K.Identifier.genreCollectionViewCell)
        
        movieDetailsView.castView.collectionView.register(DetailsCollectionViewCell.self, forCellWithReuseIdentifier: K.Identifier.detailsCollectionViewCell)
        
        movieDetailsView.exploreMoreTableView.register(UITableViewCell.self, forCellReuseIdentifier: K.Identifier.tableViewCell)
        
        
        movieDetailsView.genreCollectionView.dataSource = self
        movieDetailsView.genreCollectionView.delegate = self
                
        movieDetailsView.castView.collectionView.delegate = self
        movieDetailsView.castView.collectionView.dataSource = self

        movieDetailsView.exploreMoreTableView.delegate = self
        movieDetailsView.exploreMoreTableView.dataSource = self
        
        movieDetailsView.activityView.favoriteButton.addTarget(self, action: #selector(favoritePressed), for: UIControl.Event.touchUpInside)
        movieDetailsView.activityView.watchlistButton.addTarget(self, action: #selector(watchlistPressed), for: UIControl.Event.touchUpInside)
        movieDetailsView.activityView.userRatingButton.addTarget(self, action: #selector(ratePressed), for: UIControl.Event.touchUpInside)
        movieDetailsView.castView.seeAllButton.addTarget(self, action: #selector(seeAllCastPressed), for: UIControl.Event.touchUpInside)

        updateActivityView()
        
        Task {
            await loadDetails()
        }
        
        Task {
            await loadCredits()
        }

    }
    
    
    func updateActivityView() {
        
        if UserListHelper.shared.getFavoriteList().contains(where: {$0.id == movieId}) {
            movieDetailsView.activityView.favoriteButton.tintColor = .systemRed
            movieDetailsView.activityView.favoriteLabel.textColor = .systemRed
            isFavorite = true
        }
        
        if UserListHelper.shared.getWatchlist().contains(where: {$0.id == movieId}) {
            movieDetailsView.activityView.watchlistButton.tintColor = UIColor(named: "watchlistButtonColor")
            movieDetailsView.activityView.watchlistLabel.textColor = UIColor(named: "watchlistButtonColor")
            isOnWatchlist = true
        }
        
        
        let userRatings = UserListHelper.shared.getUserRatings()
        if let index = userRatings.firstIndex(where: {$0.id == movieId}) {
            
            guard let rating = userRatings[index].rating else {
                return
            }
            
            movieDetailsView.activityView.userRatingButton.setImage( UIImage(systemName: "\(Int(rating)).circle.fill"), for: .normal)
            movieDetailsView.activityView.userRatingButton.tintColor = UIColor(named: "goldColor")
            movieDetailsView.activityView.userRatingLabel.textColor = UIColor(named: "goldColor")
            self.rating = rating
            isRated = true
        }
        
    }


    
    func loadDetails() async {

        do {
            let url = NetworkHelper.getMovieDetailsURL(movieId: movieId)
            let data = try await NetworkManager.shared.data(url: url)
            let decodedData = try NetworkManager.shared.decodeData(data: data) as MovieDetails
            try await handleData(data: decodedData)
            setData()
            resizeScrollView()
            
        } catch {
            showAlert(title: "Unable to load data", message: "An error occurred while loading data, please check your network connection and try again")
            
        }
    }
    
    
    func handleData(data: MovieDetails) async throws {
        
        async let poster = getImage(path: data.posterPath)
        async let dropback = getImage(path: data.backdropPath)
        
        movieDetails = await MovieDetails(id: data.id, title: data.title, voteAverage: data.voteAverage, voteCount: data.voteCount, overview: data.overview, status: data.status, runtime: data.runtime, releaseDate: data.releaseDate, imdbId: data.imdbId, posterPath: data.posterPath, poster: try poster, backdropPath: data.backdropPath, backdrop: try dropback, genres: data.genres)

    }


    func getImage(path: String?) async throws -> Data? {
        
        if let path = path {
            return try await NetworkManager.shared.data(imagePath: path)
        }
        
        return nil
    }
    
    
    
    func loadCredits() async  {
        
        do {
            let url = NetworkHelper.getMovieCreditsURL(movieId: movieId)
            let data = try await NetworkManager.shared.data(url: url)
            let decodedData = try NetworkManager.shared.decodeData(data: data) as Credits
            handleCrewData(crew: decodedData.crew)
            handleCastData(cast: decodedData.cast)
            
        } catch {
            print(error.localizedDescription)
        }
    }
    

    func handleCrewData(crew: [CrewMember]) {

        directors = crew.filter({ $0.job == "Director" })

        handleDirectors()
    }
    
    
    func handleDirectors() {
        
        if !directors.isEmpty {
            
            var directorsNames = ""
            
            directorsNames += directors[0].name
            for index in 1..<directors.count {
                
                directorsNames += ", \(directors[index].name)"
            }
            movieDetailsView.directorNameLabel.text = directorsNames
            movieDetailsView.directedByTextLabel.isHidden = false
            movieDetailsView.directorNameLabel.isHidden = false
        }
    }
    

    func handleCastData(cast: [CastMember]) {
        
        self.cast = cast
        
        movieDetailsView.castView.collectionView.reloadData()
    }

    
    func setData() {
        
        guard let movieDetails = movieDetails else {
            return
        }
        
        title = movieDetails.title
        movieDetailsView.topContentView.titleLabel.text = movieDetails.title
        movieDetailsView.overviewLabel.text = movieDetails.overview
        movieDetailsView.activityView.voteCountLabel.text = "(\(movieDetails.voteCount))"
        updateGenre(genres: movieDetails.genres)
        updateWebisteList(movieDetails: movieDetails)

        movieDetailsView.topContentView.backdropImageView.image = getBackdrop(backdrop: movieDetails.backdrop)
        movieDetailsView.topContentView.posterImageView.image = getPoster(poster: movieDetails.poster)
        
        movieDetailsView.topContentView.dateLabel.text = getReleaseDate(status: movieDetails.status, releaseDate: movieDetails.releaseDate)
        
        movieDetailsView.topContentView.infoAboveTitleLabel.text = getInfoAboveTitle(runtime: movieDetails.runtime, releaseDate: movieDetails.releaseDate)

        movieDetailsView.activityView.ratingLabel.text = getVoteAverage(voteAverage: movieDetails.voteAverage)

    }
    
    
    func updateGenre(genres: [Genre]) {
        
        if genres.count <= 1 {
            
            movieDetailsView.genreCollectionView.snp.makeConstraints { make in
                make.height.equalTo(40)
            }
        }
        
        movieDetailsView.genreCollectionView.reloadData()
    }
    
    
    func updateWebisteList(movieDetails: MovieDetails) {
        
        if movieDetails.imdbId != nil {
            websites.insert((name: "IMDB", url: K.URL.imdbMovie), at: 0)
            movieDetailsView.exploreMoreTableView.reloadData()
        }
    }
     
    
    func getBackdrop(backdrop: Data?) -> UIImage? {
        
        if let backdrop = backdrop {
            
            return UIImage(data: backdrop)
        } else {
            
            movieDetailsView.topContentView.backdropImageView.snp.makeConstraints { make in
                make.height.equalTo(90)
            }
            
            movieDetailsView.topContentView.snp.makeConstraints { make in
                make.height.equalTo(210)
            }
                        
            return nil
        }
    }
    
    
    func getPoster(poster: Data?) -> UIImage? {
        
        if let poster = poster {
             return UIImage(data: poster)
        } else {
            movieDetailsView.topContentView.defaultImageView.image = UIImage(systemName: "film")
            movieDetailsView.topContentView.defaultImageView.isHidden = false
            
            return nil
        }
    }
    
    
    func getReleaseDate(status: String, releaseDate: String) -> String? {
        
        if status == "Released" {
            return nil
        }
        
        movieDetailsView.activityView.userRatingButton.isEnabled = false
        
        if !releaseDate.isEmpty {
            movieDetailsView.topContentView.releaseDateTextLabel.isHidden = false
            movieDetailsView.topContentView.dateLabel.isHidden = false
            return handleReleaseDate(releaseDate: releaseDate)
        }
        
        return nil
    }
    
    
    func handleReleaseDate(releaseDate: String) -> String {
        let releaseYear = releaseDate.prefix(4)
        var releaseDay = String(releaseDate.suffix(2))
        
        if releaseDay[releaseDay.startIndex] == "0" {
            releaseDay = String(releaseDay[releaseDay.index(releaseDay.startIndex, offsetBy: 1)])
        }
        
        let start = releaseDate.index(releaseDate.startIndex, offsetBy: 5)
        let end = releaseDate.index(releaseDate.startIndex, offsetBy: 6)
        let releaseMonth = String(releaseDate[start...end])
        
        return "\(releaseMonth.getMonth()) \(releaseDay), \(releaseYear)"
    }
    
    
    func getInfoAboveTitle(runtime: Int, releaseDate: String) -> String? {
        
        if !releaseDate.isEmpty {
            
            let releaseYear = releaseDate.prefix(4)
            
            if runtime == 0 {
                return "\(releaseYear)"
            } else {
                return "\(releaseYear) ٠ \(runtime) mins"
            }
        }
        return nil
    }

    
    func getVoteAverage(voteAverage: Float) -> String {
        
        let voteAverage = round(voteAverage * 10) / 10.0
        
        if voteAverage == Float(Int(voteAverage)) {
            return "\(Int(voteAverage))"
        } else {
            return "\(voteAverage)"
        }
    }
    
 
    override func viewDidLayoutSubviews() {
        
        movieDetailsView.topContentView.gradientView.layer.sublayers?.removeAll()

        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 170)
        let gradientColor = UIColor(named: "mainColor")!
        gradientLayer.colors = [gradientColor.cgColor, gradientColor.withAlphaComponent(0).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0)
        movieDetailsView.topContentView.gradientView.layer.addSublayer(gradientLayer)
    }

    override func viewDidAppear(_ animated: Bool) {
        resizeScrollView()
    }
    
    
    func resizeScrollView() {
        
        view.layoutIfNeeded()
        let contentRect: CGRect = movieDetailsView.contentView.frame
        
        movieDetailsView.scrollView.snp.makeConstraints { make in
            make.height.equalTo(contentRect.size.height)
            make.width.equalTo(contentRect.size.width)
        }
        
        movieDetailsView.scrollView.contentSize = contentRect.size
    }
    
    
    
    @objc func favoritePressed() {
        
        Task {
            await handleFavorite()
        }
    }
    
    
    func handleFavorite() async {
        
        guard let movieDetails = movieDetails else {
            return
        }
        
        if isFavorite {
            await removeFromFavorite(movieDetails: movieDetails)
        } else {
            await addToFavorite(movieDetails: movieDetails)
        }
    }
    
    
    func removeFromFavorite(movieDetails: MovieDetails) async {
        do {
            try await FirestoreManager.shared.removeTitle(from: "favorite", titleId: movieId)
            movieDetailsView.activityView.favoriteButton.tintColor = .label
            movieDetailsView.activityView.favoriteLabel.textColor = .label
            
            UserListHelper.shared.removeFromFavorite(id: movieId)
            isFavorite = false
        } catch {
            
            showAlert(title: "Cannot remove \(movieDetails.title) from favorite", message: "An error occurred while removing    the movie from favorites")
        }
    }
    
    
    func addToFavorite(movieDetails: MovieDetails) async {
        do {
            let data: [String: Any] = [
                "type": "movie",
                "title": movieDetails.title,
                "poster": movieDetails.poster as Any
            ]
            
            try await FirestoreManager.shared.addTitle(to: "favorite", titleId: movieId, data: data)
            movieDetailsView.activityView.favoriteButton.tintColor = .systemRed
            movieDetailsView.activityView.favoriteLabel.textColor = .systemRed
            
            UserListHelper.shared.addToFavorite(Title(id: movieId, title: movieDetails.title, poster: movieDetails.poster, type: "movie"))
            isFavorite = true
        } catch {
            showAlert(title: "Cannot add \(movieDetails.title) to favorite", message: "An error occurred while adding the movie to favorites")
        }
        
    }
    
    
    @objc func watchlistPressed() {
        
        Task {
            await handleWatchlist()
        }
        
    }
    
    
    func handleWatchlist() async {
        
        guard let movieDetails = movieDetails else {
            return
        }
        
        if isOnWatchlist {
            await removeFromWatchlist(movieDetails: movieDetails)
        } else {
            await addToWatchlist(movieDetails: movieDetails)
        }
    }
    
    
    func removeFromWatchlist(movieDetails: MovieDetails) async {
        do {
            try await FirestoreManager.shared.removeTitle(from: "watchlist", titleId: movieId)
            movieDetailsView.activityView.watchlistButton.tintColor = .label
            movieDetailsView.activityView.watchlistLabel.textColor = .label
            
            UserListHelper.shared.removeFromWatchlist(id: movieId)
            isOnWatchlist = false
        } catch {
            showAlert(title: "Cannot remove \(movieDetails.title) from watchlist", message: "An error occurred while removing the movie from watchlist")
        }
    }
    
    
    func addToWatchlist(movieDetails: MovieDetails) async {
        do {
            let data: [String: Any] = [
                "type": "movie",
                "title": movieDetails.title,
                "poster": movieDetails.poster as Any
            ]
            
            try await FirestoreManager.shared.addTitle(to: "watchlist", titleId: movieId, data: data)
            movieDetailsView.activityView.watchlistButton.tintColor = UIColor(named: "watchlistButtonColor")
            movieDetailsView.activityView.watchlistLabel.textColor = UIColor(named: "watchlistButtonColor")
            
            UserListHelper.shared.addToWatchlist(Title(id: movieId, title: movieDetails.title, poster: movieDetails.poster, type: "movie"))
            isOnWatchlist = true
        }catch {
            showAlert(title: "Cannot add \(movieDetails.title) to watchlist", message: "An error occurred while adding the movie to watchlist")
            
        }
        
    }

    
    @objc func seeAllCastPressed() {
        
        if cast.isEmpty {
            return
        }
        
        let vc = AllCastTableViewController()
        vc.cast = cast
        vc.title = "All Cast"
        navigationController?.pushViewController(vc, animated: true)        
    }
    
    
    @objc func ratePressed() {
        
        let alert = UIAlertController(title: "\n\n\n\n\n", message: nil, preferredStyle: .actionSheet)
        
        let ratingView = getRatingView()

        alert.addAction(UIAlertAction(title: "Rate", style: .default){ [weak self] _ in
            
            Task {
                await self?.setRating(rating: ratingView.starsView.rating)
            }
        })

        if isRated {
            alert.addAction(UIAlertAction(title: "Remove Rating", style: .default){ [weak self] _ in
                Task {
                    await self?.removeRating()
                    self?.isRated = false
                }
            })
        }


        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.view.addSubview(ratingView)
        alert.popoverPresentationController?.sourceView = self.view
        alert.popoverPresentationController?.sourceRect = CGRect(x: self.movieDetailsView.activityView.frame.midX - 80, y: self.movieDetailsView.activityView.frame.midY + 50, width: alert.view.frame.width, height: 0)

        ratingView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
        }
        
        present(alert, animated: true)
    }
    
    
    func getRatingView() -> RatingView {
        
        let ratingView = RatingView()
        ratingView.starsView.rating = rating
        ratingView.imageView.image = UIImage(systemName: "\(Int(rating)).circle.fill")
        
        ratingView.starsView.didTouchCosmos = { rating in
            ratingView.imageView.image = UIImage(systemName: "\(Int(rating)).circle.fill")
        }
        
        return ratingView
    }
    
    
    

    func setRating(rating: Double) async {
        
        if let guestSessionId = UserListHelper.shared.getGuestSessionId() {
            await addRaing(guestSessionId: guestSessionId, rating: rating)
        } else {
            await getNewGuestSession(rating: rating)
        }
        
    }
    
    
    func getNewGuestSession(rating: Double) async {
        
        do{
            let url = NetworkHelper.getNewGuestSessionURL()
            
            let data = try await NetworkManager.shared.data(url: url)
            let guestSession = try NetworkManager.shared.decodeData(data: data) as GuestSession
            UserListHelper.shared.updateGuestSessionId(guestSessionId: guestSession.id)
            try await FirestoreManager.shared.addGuestSessionId(guestSessionId: guestSession.id)
            
            await addRaing(guestSessionId: guestSession.id, rating: rating)
        } catch {
            showAlert(title: "Network error", message: "An error occurred while adding the rating, please check your network connection and try again")
        }
    }
    
    
    func addRaing(guestSessionId: String, rating: Double) async {
        
        do {
            
            let url = NetworkHelper.getRateMovieURL(movieId: movieId, guestSessionId: guestSessionId)
            try await NetworkManager.shared.addRating(url: url, rating: rating)
            self.rating = rating
            self.isRated = true
            updateUIAfterAddingRate()
            updateRatingsListAfterAddingRate()

        } catch {
            showAlert(title: "Network error", message: "An error occurred while adding the rating, please check your network connection and try again")
        }
    }
    
    
    func updateUIAfterAddingRate() {
        
        movieDetailsView.activityView.userRatingButton.setImage( UIImage(systemName: "\(Int(rating)).circle.fill"), for: .normal)
        movieDetailsView.activityView.userRatingButton.tintColor = UIColor(named: "goldColor")
        movieDetailsView.activityView.userRatingLabel.textColor = UIColor(named: "goldColor")
    }
    
    
    func updateRatingsListAfterAddingRate() {
        
        if let index = UserListHelper.shared.getUserRatings().firstIndex(where: { $0.id == movieId }) {
            
            UserListHelper.shared.updateRatings(index: index, rating: rating)
        } else {
            UserListHelper.shared.addToUserRatings(Title(id: movieId, title: movieDetails?.title, name: nil, posterPath: movieDetails?.posterPath, rating: rating, type: "movie"))
        }
    }
    
    
    func removeRating() async {
        
        guard let guestSessionId = UserListHelper.shared.getGuestSessionId() else {
            return
        }

        do {
            
            let url = NetworkHelper.getRateMovieURL(movieId: movieId, guestSessionId: guestSessionId)
            try await NetworkManager.shared.removeRating(url: url)
            self.rating = 0
            self.isRated = false
            UserListHelper.shared.removeFromUserRatings(id: movieId)
            updateUIAfterRemovingRate()

        } catch {
            showAlert(title: "Network error", message: "An error occurred while removing the rating, please check your network connection and try again")
        }
    }
    
    
    func updateUIAfterRemovingRate() {
        
        movieDetailsView.activityView.userRatingButton.setImage(UIImage(systemName: "star.circle.fill"), for: .normal)
        movieDetailsView.activityView.userRatingButton.tintColor = .label
        movieDetailsView.activityView.userRatingLabel.textColor = .label
    }
    
}



// MARK: - UICollectionViewDataSource, UICollectionViewDelegate

extension MovieDetailsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == movieDetailsView.castView.collectionView {
            return cast.count < 15 ? cast.count : 14
        } else {
            return movieDetails?.genres.count ?? 0
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == movieDetailsView.castView.collectionView {
            
            return setCastCell(collectionView: collectionView, indexPath: indexPath)
        } else {
            
            return setGenreCell(collectionView: collectionView, indexPath: indexPath)
        }
    }
    
    func setCastCell(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.Identifier.detailsCollectionViewCell, for: indexPath) as! DetailsCollectionViewCell
        
        cell.imageView.image = nil
        cell.defaultImageView.isHidden = true
        
        Task {
            await handleImageView(cell: cell, indexPath: indexPath)
        }
        
        cell.mainTextLabel.text = cast[indexPath.row].name
        cell.subTextLabel.text = cast[indexPath.row].character
        
        return cell
    }
    
    func handleImageView(cell: DetailsCollectionViewCell, indexPath: IndexPath) async {
        
        let profilePath = cast[indexPath.row].profilePath

        do {
            var imageData: Data?

            if let profilePath = profilePath {
                imageData = try await NetworkManager.shared.data(imagePath: profilePath)
            }
            
            if let imageData = imageData {
                cell.imageView.image = UIImage(data: imageData)
                return
            }

            cell.defaultImageView.image = UIImage(systemName: "person.fill")
            cell.defaultImageView.isHidden = false
            
        } catch {
            cell.defaultImageView.image = UIImage(systemName: "person.fill")
            cell.defaultImageView.isHidden = false
        }
        
    }
    
    
    func setGenreCell(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.Identifier.genreCollectionViewCell, for: indexPath) as! GenreCollectionViewCell
        
        cell.label.text = movieDetails?.genres[indexPath.row].name
        cell.label.font = .systemFont(ofSize: 12)
        
        
        return cell
    }
    
    

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == movieDetailsView.castView.collectionView {
            
            let vc = PersonDetailsViewController()
            vc.personId = cast[indexPath.row].id
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}



// MARK: - UICollectionViewDelegateFlowLayout

extension MovieDetailsViewController: UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == movieDetailsView.castView.collectionView  {
            return CGSize(width: 90, height: 150)
        } else {
            return CGSize(width: 100, height: 30)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
}



// MARK: - UITableViewDataSource, UITableViewDelegate

extension MovieDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    
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
        
        guard let movieDetails = movieDetails else {
            return
        }
        
        if website.name == "IMDB" {
            
            url = URL(string: "\(website.url)\(movieDetails.imdbId!)")
        } else {
            url = URL(string: "\(website.url)\(movieDetails.id)")
        }
        
        guard let url = url else {
            return
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        UIApplication.shared.open(url)
        
    }

    
}

