//
//  TVShowDetailsViewController.swift
//  Niro
//
//  Created by Mohamed Adel on 13/08/2023.
//

import UIKit

class TVShowDetailsViewController: UIViewController {

    let tvShowDetailsView = TVShowDetailsView()
    var showId: Int!
    var showDetails: TVShowDetails?
    var cast = [CastMember]()
    var allCast = [CastMember]()
    var isFavorite = false
    var isOnWatchlist = false
    var isRated = false
    var rating = 0.0
    
    let websites = [(name: "TMDB", url: K.URL.tmdbTVSHow)]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view = tvShowDetailsView
        
        navigationItem.backButtonTitle = ""
        
        tvShowDetailsView.genreCollectionView.register(GenreCollectionViewCell.self, forCellWithReuseIdentifier: K.Identifier.genreCollectionViewCell)
        
        tvShowDetailsView.castView.collectionView.register(DetailsCollectionViewCell.self, forCellWithReuseIdentifier: K.Identifier.detailsCollectionViewCell)
        
        tvShowDetailsView.seasonsView.collectionView.register(DetailsCollectionViewCell.self, forCellWithReuseIdentifier: K.Identifier.detailsCollectionViewCell)
        
        tvShowDetailsView.exploreMoreTableView.register(UITableViewCell.self, forCellReuseIdentifier: K.Identifier.tableViewCell)
        
        tvShowDetailsView.genreCollectionView.dataSource = self
        tvShowDetailsView.genreCollectionView.delegate = self
                
        tvShowDetailsView.castView.collectionView.delegate = self
        tvShowDetailsView.castView.collectionView.dataSource = self
        
        tvShowDetailsView.seasonsView.collectionView.delegate = self
        tvShowDetailsView.seasonsView.collectionView.dataSource = self

        tvShowDetailsView.exploreMoreTableView.delegate = self
        tvShowDetailsView.exploreMoreTableView.dataSource = self
        
        tvShowDetailsView.activityView.favoriteButton.addTarget(self, action: #selector(favoritePressed), for: UIControl.Event.touchUpInside)
        tvShowDetailsView.activityView.watchlistButton.addTarget(self, action: #selector(watchlistPressed), for: UIControl.Event.touchUpInside)
        tvShowDetailsView.activityView.userRatingButton.addTarget(self, action: #selector(ratePressed), for: UIControl.Event.touchUpInside)
        tvShowDetailsView.castView.seeAllButton.addTarget(self, action: #selector(seeAllCastPressed), for: UIControl.Event.touchUpInside)
        
        updateActivityView()

        Task {
            await loadDetails()
        }
        
        
        Task {
            await loadCredits()
        }
        
        
    }
    
    
    func updateActivityView() {
        
        if UserListHelper.shared.getFavoriteList().contains(where: {$0.id == showId}) {
            tvShowDetailsView.activityView.favoriteButton.tintColor = .systemRed
            tvShowDetailsView.activityView.favoriteLabel.textColor = .systemRed
            isFavorite = true
        }
        
        if UserListHelper.shared.getWatchlist().contains(where: {$0.id == showId}) {
            tvShowDetailsView.activityView.watchlistButton.tintColor = UIColor(named: "watchlistButtonColor")
            tvShowDetailsView.activityView.watchlistLabel.textColor = UIColor(named: "watchlistButtonColor")
            isOnWatchlist = true
        }
        
        
        let userRatings = UserListHelper.shared.getUserRatings()
        if let index = userRatings.firstIndex(where: {$0.id == showId}) {
            
            guard let rating = userRatings[index].rating else {
                return
            }
            
            tvShowDetailsView.activityView.userRatingButton.setImage( UIImage(systemName: "\(Int(rating)).circle.fill"), for: .normal)
            tvShowDetailsView.activityView.userRatingButton.tintColor = UIColor(named: "goldColor")
            tvShowDetailsView.activityView.userRatingLabel.textColor = UIColor(named: "goldColor")
            self.rating = rating
            isRated = true
        }
        
    }
    
    
    func loadDetails() async {
        
        do {
            let url = NetworkHelper.getTVShowDetailsURL(showId: showId)
            let data = try await NetworkManager.shared.data(url: url)
            let decodedData = try NetworkManager.shared.decodeData(data: data) as TVShowDetails
            try await handleData(data: decodedData)
            setData()
            resizeScrollView()
            
        } catch {
            showAlert(title: "Unable to load data", message: "An error occurred while loading data, please check your network connection and try again")
        }
    }
    
    
    func handleData(data: TVShowDetails) async throws {
        
        async let poster = getImage(path: data.posterPath)
        async let dropback = getImage(path: data.backdropPath)
        
        showDetails = await TVShowDetails(id: data.id, name: data.name, voteAverage: data.voteAverage, voteCount: data.voteCount, status: data.status, seasons: data.seasons, overview: data.overview, posterPath: data.posterPath, poster: try poster, backdropPath: data.backdropPath, backdrop: try dropback, createdBy: data.createdBy, genres: data.genres)

    }
    
    
    func getImage(path: String?) async throws -> Data? {
        
        if let path = path {
            return try await NetworkManager.shared.data(imagePath: path)
        }
        
        return nil
    }
    

    
    func loadCredits() async {

        do {
            let url = NetworkHelper.getTVShowCreditsURL(showId: showId)
            let data = try await NetworkManager.shared.data(url: url)
            let decodedData = try NetworkManager.shared.decodeData(data: data) as Credits
            try await handleCastData(cast: decodedData.cast)

        } catch {
            print(error.localizedDescription)
        }
    }
    
    
    
    func handleCastData(cast: [CastMember]) async throws {
        
        allCast = cast
        
        var numOfcastMembers = 0
        
        for castMember in cast {
            if numOfcastMembers > 14 {
                break
            }
            
            self.cast.append(CastMember(id: castMember.id, name: castMember.name, profilePath: castMember.profilePath, character: castMember.character, roles: castMember.roles))
            
            numOfcastMembers += 1
        }
        tvShowDetailsView.castView.collectionView.reloadData()
    }
    
    
    func setCreators() {
        
        guard let creators = showDetails?.createdBy else {
            return
        }
        
        if !creators.isEmpty {

            var creatorsNames = ""
            creatorsNames += creators[0].name
            for index in 1..<creators.count {
                
                creatorsNames += ", \(creators[index].name)"
            }
            tvShowDetailsView.creatorNameLabel.text = creatorsNames
            tvShowDetailsView.creatorNameLabel.isHidden = false
            tvShowDetailsView.createdByTextLabel.isHidden = false
        }
    }
    
    
    func setData() {
        
        showDetails?.seasons.removeAll(where: { $0.seasonNumber == 0 })
        
        guard let showDetails = showDetails else {
            return
        }


        title = showDetails.name
        tvShowDetailsView.topContentView.titleLabel.text = showDetails.name
        tvShowDetailsView.overviewLabel.text = showDetails.overview
        tvShowDetailsView.activityView.voteCountLabel.text = "(\(showDetails.voteCount))"
        updateGenre(genres: showDetails.genres)
        setCreators()
        
        tvShowDetailsView.topContentView.backdropImageView.image = getBackdrop(backdrop: showDetails.backdrop)
        tvShowDetailsView.topContentView.posterImageView.image = getPoster(poster: showDetails.poster)
        tvShowDetailsView.topContentView.infoAboveTitleLabel.text = getInfoAboveTitle(seasons: showDetails.seasons)
        tvShowDetailsView.activityView.ratingLabel.text = getVoteAverage(voteAverage: showDetails.voteAverage)
        
        tvShowDetailsView.seasonsView.collectionView.reloadData()

    }
    
    
    func updateGenre(genres: [Genre]) {
        
        if genres.count <= 1 {
            
            tvShowDetailsView.genreCollectionView.snp.makeConstraints { make in
                make.height.equalTo(40)
            }
        }
        
        tvShowDetailsView.genreCollectionView.reloadData()
    }
    
    
    func getBackdrop(backdrop: Data?) -> UIImage? {
        
        if let backdrop = backdrop {
            
            return UIImage(data: backdrop)
        } else {
            
            tvShowDetailsView.topContentView.backdropImageView.snp.makeConstraints { make in
                make.height.equalTo(90)
            }
            
            tvShowDetailsView.topContentView.snp.makeConstraints { make in
                make.height.equalTo(210)
            }
         
            return nil
        }
        
    }
    
    
    func getPoster(poster: Data?) -> UIImage? {
        
        if let poster = poster {
             return UIImage(data: poster)
        } else {
            tvShowDetailsView.topContentView.defaultImageView.image = UIImage(systemName: "tv")
            tvShowDetailsView.topContentView.defaultImageView.isHidden = false
            
            return nil
        }
    }
    
    
    func getInfoAboveTitle(seasons: [Seasons]) -> String? {
        
        if let seasonsNumber = seasons.last?.seasonNumber {
            
            if seasonsNumber == 1 {
                return "\(seasonsNumber) season"
            } else if seasonsNumber > 1 {
                return "\(seasonsNumber) seasons"
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
        
        tvShowDetailsView.topContentView.gradientView.layer.sublayers?.removeAll()

        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 170)
        let gradientColor = UIColor(named: "mainColor")!
        gradientLayer.colors = [gradientColor.cgColor, gradientColor.withAlphaComponent(0).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0)
        tvShowDetailsView.topContentView.gradientView.layer.addSublayer(gradientLayer)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        resizeScrollView()
    }
    
    
    func resizeScrollView() {
        
        view.layoutIfNeeded()

        let contentRect: CGRect = tvShowDetailsView.contentView.frame
        
        tvShowDetailsView.scrollView.snp.makeConstraints { make in
            make.height.equalTo(contentRect.size.height)
            make.width.equalTo(contentRect.size.width)
        }
        
        tvShowDetailsView.scrollView.contentSize = contentRect.size
    }
    
        
    @objc func favoritePressed() {
        
        Task {
            await handleFavorite()
        }
    }

    
    
    func handleFavorite() async {
        
        guard let showDetails = showDetails else {
            return
        }
        
        if isFavorite {
            await removeFromFavorite(showDetails: showDetails)
        } else {
            await addToFavorite(showDetails: showDetails)
        }
        
    }
    
    
    func removeFromFavorite(showDetails: TVShowDetails) async {
        
        do {
            try await FirestoreManager.shared.removeTitle(from: "favorite", titleId: showId)
            tvShowDetailsView.activityView.favoriteButton.tintColor = .label
            tvShowDetailsView.activityView.favoriteLabel.textColor = .label
            
            UserListHelper.shared.removeFromFavorite(id: showId)
            isFavorite = false
        } catch {
            
            showAlert(title: "Cannot remove \(showDetails.name) from favorite", message: "An error occurred while removing the show from favorites")
        }
        
    }
    
    
    func addToFavorite(showDetails: TVShowDetails) async {
        
        do {
            let data: [String: Any] = [
                "type": "tv",
                "title": showDetails.name,
                "poster": showDetails.poster as Any
            ]
            
            try await FirestoreManager.shared.addTitle(to: "favorite", titleId: showId, data: data)
            tvShowDetailsView.activityView.favoriteButton.tintColor = .systemRed
            tvShowDetailsView.activityView.favoriteLabel.textColor = .systemRed
            
            UserListHelper.shared.addToFavorite(Item(id: showId, title: showDetails.name, poster: showDetails.poster, type: "tv"))
            isFavorite = true
        } catch {
            showAlert(title: "Cannot add \(showDetails.name) to favorite", message: "An error occurred while adding the show to favorites")
        }
    }

    
    @objc func watchlistPressed() {
        
        Task {
            await addToWatchlist()
        }
    }
    
    
    func addToWatchlist() async {
        
        guard let showDetails = showDetails else {
            return
        }
        
        if isOnWatchlist {
            await removeFromWatchlist(showDetails: showDetails)
        } else {
            await addToWatchlist(showDetails: showDetails)
        }
    }
    
    
    func removeFromWatchlist(showDetails: TVShowDetails) async {
        
        do {
            try await FirestoreManager.shared.removeTitle(from: "watchlist", titleId: showId)
            tvShowDetailsView.activityView.watchlistButton.tintColor = .label
            tvShowDetailsView.activityView.watchlistLabel.textColor = .label
            
            UserListHelper.shared.removeFromWatchlist(id: showId)
            isOnWatchlist = false
        } catch {
            showAlert(title: "Cannot remove \(showDetails.name) from watchlist", message: "An error occurred while removing the show from watchlist")
        }
        
    }
    
    
    func addToWatchlist(showDetails: TVShowDetails) async {
        
        do {
            let data: [String: Any] = [
                "type": "movie",
                "title": showDetails.name,
                "poster": showDetails.poster as Any
            ]
            
            try await FirestoreManager.shared.addTitle(to: "watchlist", titleId: showId, data: data)
            tvShowDetailsView.activityView.watchlistButton.tintColor = UIColor(named: "watchlistButtonColor")
            tvShowDetailsView.activityView.watchlistLabel.textColor = UIColor(named: "watchlistButtonColor")
            
            UserListHelper.shared.addToWatchlist(Item(id: showId, title: title, poster: showDetails.poster, type: "tv"))
            isOnWatchlist = true
        } catch {
            showAlert(title: "Cannot add \(showDetails.name) to watchlist", message: "An error occurred while adding the show to watchlist")
        }
        
    }
    
    
    @objc func seeAllCastPressed() {
        
        if allCast.isEmpty {
            return
        }
        
        let vc = AllCastTableViewController()
        vc.cast = allCast
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
        alert.popoverPresentationController?.sourceRect = CGRect(x: self.tvShowDetailsView.activityView.frame.midX - 80, y: self.tvShowDetailsView.activityView.frame.midY + 50, width: alert.view.frame.width, height: 0)

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
            
            let url = NetworkHelper.getRateTVShowURL(showId: showId, guestSessionId: guestSessionId)
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
        
        tvShowDetailsView.activityView.userRatingButton.setImage( UIImage(systemName: "\(Int(rating)).circle.fill"), for: .normal)
        tvShowDetailsView.activityView.userRatingButton.tintColor = UIColor(named: "goldColor")
        tvShowDetailsView.activityView.userRatingLabel.textColor = UIColor(named: "goldColor")
    }
    
    
    func updateRatingsListAfterAddingRate() {
        
        if let index = UserListHelper.shared.getUserRatings().firstIndex(where: { $0.id == showId }) {
            
            UserListHelper.shared.updateRatings(index: index, rating: rating)
        } else {
            UserListHelper.shared.addToUserRatings(Item(id: showId, title: nil, name: showDetails?.name, posterPath: showDetails?.posterPath, rating: rating, type: "tv"))
        }
    }
    
    
    func removeRating() async {
        
        guard let guestSessionId = UserListHelper.shared.getGuestSessionId() else {
            return
        }

        do {
            
            let url = NetworkHelper.getRateTVShowURL(showId: showId, guestSessionId: guestSessionId)
            try await NetworkManager.shared.removeRating(url: url)
            self.rating = 0
            self.isRated = false
            UserListHelper.shared.removeFromUserRatings(id: showId)
            updateUIAfterRemovingRate()
        } catch {
            showAlert(title: "Network error", message: "An error occurred while removing the rating, please check your network connection and try again")
        }
    }
    
    
    func updateUIAfterRemovingRate() {
        
        tvShowDetailsView.activityView.userRatingButton.setImage(UIImage(systemName: "star.circle.fill"), for: .normal)
        tvShowDetailsView.activityView.userRatingButton.tintColor = .label
        tvShowDetailsView.activityView.userRatingLabel.textColor = .label
    }

    

}



// MARK: - UICollectionViewDataSource, UICollectionViewDelegate

extension TVShowDetailsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == tvShowDetailsView.castView.collectionView {
            return cast.count
        } else if collectionView == tvShowDetailsView.seasonsView.collectionView {
            return showDetails?.seasons.count ?? 0
        } else {
            return showDetails?.genres.count ?? 0
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        if collectionView == tvShowDetailsView.castView.collectionView {
            
            return setCastCell(collectionView: collectionView, indexPath: indexPath)
        } else if collectionView == tvShowDetailsView.seasonsView.collectionView {
            
            return setSeasonCell(collectionView: collectionView, indexPath: indexPath)
        } else {
            
            return setGenreCell(collectionView: collectionView, indexPath: indexPath)
        }

    }
    
    
    func setCastCell(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.Identifier.detailsCollectionViewCell, for: indexPath) as! DetailsCollectionViewCell
        
        cell.imageView.image = nil
        
        Task {
            await handleImageView(cell: cell, indexPath: indexPath, defaultImage: "person.fill")
        }
        
        cell.mainTextLabel.text = cast[indexPath.row].name
        cell.subTextLabel.text = cast[indexPath.row].roles?[0].character
        
        return cell
    }
    
    
    
    func setSeasonCell(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.Identifier.detailsCollectionViewCell, for: indexPath) as! DetailsCollectionViewCell
        
        cell.imageView.image = nil
        cell.defaultImageView.isHidden = true
        
        Task {
            await handleImageView(cell: cell, indexPath: indexPath, defaultImage: "tv")
        }
        
        cell.mainTextLabel.text = showDetails?.seasons[indexPath.row].name
        cell.mainTextLabel.font = .systemFont(ofSize: 14)
        
        return cell
    }
    
    
    func handleImageView(cell: DetailsCollectionViewCell, indexPath: IndexPath, defaultImage: String) async {
        
        let path: String?
        
        if defaultImage == "tv" {
            path = showDetails?.seasons[indexPath.row].posterPath
        } else {
            path = cast[indexPath.row].profilePath
        }
        
        
        do {
            var imageData: Data?

            if let path = path {
                imageData = try await NetworkManager.shared.data(imagePath: path)
            }
            
            if let imageData = imageData {
                cell.imageView.image = UIImage(data: imageData)
                return
            }

            cell.defaultImageView.image = UIImage(systemName: defaultImage)
            cell.defaultImageView.isHidden = false
            
        } catch {
            cell.defaultImageView.image = UIImage(systemName: defaultImage)
            cell.defaultImageView.isHidden = false
            
        }
        
    }
    
    
    
    func setGenreCell(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.Identifier.genreCollectionViewCell, for: indexPath) as! GenreCollectionViewCell
        
        cell.label.text = showDetails?.genres[indexPath.row].name
        cell.label.font = .systemFont(ofSize: 12)
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == tvShowDetailsView.castView.collectionView {
            
            let vc = PersonDetailsViewController()
            vc.personId = cast[indexPath.row].id
            navigationController?.pushViewController(vc, animated: true)
        }
    }


}


// MARK: - UICollectionViewDelegateFlowLayout

extension TVShowDetailsViewController: UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == tvShowDetailsView.genreCollectionView{
            return CGSize(width: 120, height: 30)
        } else {
            return CGSize(width: 90, height: 150)
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

extension TVShowDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    
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
        
        guard let showDetails = showDetails else {
            return
        }

        let url = URL(string: "\(website.url)\(showDetails.id)")
        
        guard let url = url else {
            return
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        UIApplication.shared.open(url)
        
    }

    
}



