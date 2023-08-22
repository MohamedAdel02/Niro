//
//  UserListHelper.swift
//  Niro
//
//  Created by Mohamed Adel on 15/08/2023.
//

import FirebaseFirestore


class UserListHelper {
    
    
    static let shared = UserListHelper()
    
    private init() { }
    
    private var favoriteList = [Item]()
    private var watchlist = [Item]()
    private var userRatings = [Item]()
    private var guestSessionId: String?
    
    func getUserLists() {

        Task {
            await setfavoriteList()
            await setWatchlist()
            await setUserRatings()
            await setGuestSession()
        }

    }
    
    
    private func setWatchlist() async {
        
        do {
            guard let snapshot = try await FirestoreManager.shared.getList(listName: "watchlist") else {
                return
            }
            handleWatchlist(snapshot: snapshot)
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
    private func handleWatchlist(snapshot: QuerySnapshot) {
        for document in snapshot.documents {
            
            guard let id = Int(document.documentID) else {
                continue
            }
            let title = document.get("title") as? String
            let poster = document.get("poster") as? Data
            let type = document.get("type") as? String
            
            watchlist.append(Item(id: id, title: title, poster: poster, type: type))
        }
    }
    
    
    private func setfavoriteList() async {
        
        do {
            guard let snapshot = try await FirestoreManager.shared.getList(listName: "favorite") else {
                return
            }
            handleFavoriteList(snapshot: snapshot)
            
        } catch {
            print(error.localizedDescription)
        }
    }

    
    private func handleFavoriteList(snapshot: QuerySnapshot) {
        
        for document in snapshot.documents {
            
            guard let id = Int(document.documentID) else {
                continue
            }
            let title = document.get("title") as? String
            let poster = document.get("poster") as? Data
            let type = document.get("type") as? String
            
            favoriteList.append(Item(id: id, title: title, poster: poster, type: type))
            
        }
    }

    
    private func setUserRatings() async {
        
        do {
            
            guard let guestSessionId = try await FirestoreManager.shared.getGuestSession() else {
                return
            }
            
            let moviesRatingsURL = NetworkHelper.getMoviseRatingsURL(guestSessionId: guestSessionId)
            let tvshowsRatingsURL = NetworkHelper.getTVShowsRatingsURL(guestSessionId: guestSessionId)
            
            async let moviesData = try NetworkManager.shared.data(url: moviesRatingsURL)
            async let tvShowsData = try NetworkManager.shared.data(url: tvshowsRatingsURL)
            
            let moviesDecodedData = try await NetworkManager.shared.decodeData(data: moviesData) as List
            let tvShowsDecodedData = try await NetworkManager.shared.decodeData(data: tvShowsData) as List
            
            handleUserRatings(movies: moviesDecodedData.results, shows: tvShowsDecodedData.results)
            
        } catch {
            
            print(error.localizedDescription)
        }
        
        
    }
    

    private func handleUserRatings(movies: [Item], shows: [Item]) {
        
        for movie in movies {
            userRatings.append(Item(id: movie.id,title: movie.title, name: movie.name, posterPath: movie.posterPath, rating: movie.rating, type: "movie"))
        }
                
        for show in shows {
            userRatings.append(Item(id: show.id, title: show.title, name: show.name, posterPath: show.posterPath, rating: show.rating, type: "tv"))
        }
        
    }
    
    
    private func setGuestSession() async {
        do {
            guestSessionId = try await FirestoreManager.shared.getGuestSession()
        } catch {
            print(error.localizedDescription)
        }
 
    }
    
    
    func getFavoriteList() -> [Item] {
        return favoriteList
    }
    
    func getWatchlist() -> [Item] {
        return watchlist
    }
    
    func getUserRatings() -> [Item] {
        return userRatings
    }
    
    func getGuestSessionId() -> String? {
        return guestSessionId
    }
    
    func clearLists() {
        
        favoriteList.removeAll()
        watchlist.removeAll()
        userRatings.removeAll()
        guestSessionId = nil
        
    }
    
    func removeFromFavorite(id: Int) {
        favoriteList.removeAll(where: { $0.id == id })
    }
    
    func removeFromWatchlist(id: Int) {
        watchlist.removeAll(where: { $0.id == id })
    }
    
    func removeFromUserRatings(id: Int) {
        userRatings.removeAll(where: { $0.id == id })
    }
    
    func updateGuestSessionId(guestSessionId: String) {
        self.guestSessionId = guestSessionId
    }
    
    func updateRatings(index: Int,rating: Double) {
        userRatings[index].rating = rating
    }
    
    func addToFavorite(_ item: Item) {
        favoriteList.append(item)
    }
    
    func addToWatchlist(_ item: Item) {
        watchlist.append(item)
    }
    
    func addToUserRatings(_ item: Item) {
        userRatings.append(item)
    }

}
