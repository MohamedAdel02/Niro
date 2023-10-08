//
//  SearchTableViewController.swift
//  Niro
//
//  Created by Mohamed Adel on 02/08/2023.
//

import UIKit

class SearchTableViewController: UITableViewController, SelectCellProtocol {
    
    
    var searchController: UISearchController!
    
    let lists = [
        // Movies Lists
        [(listName: "Top rated movies",     url: NetworkHelper.getTopRatedMoviesURL()),
         (listName: "Popular movies",       url: NetworkHelper.getPopularMoviesURL()),
         (listName: "Comming soon",         url: NetworkHelper.getCommingSoonMoviesURL())],
        
        // TV Shows Lists
        [(listName: "Top rated TV shows",   url: NetworkHelper.getTopRatedTVShowsURL()),
         (listName: "Popular TV shows",     url: NetworkHelper.getPopularTVShowsURL())]
    ]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: K.Identifier.tableViewCell)
        
        tableView.backgroundColor = UIColor(named: "mainColor")
        
        let searchResultController = SearchResultTableViewController()
        searchResultController.delegate = self
        searchController = UISearchController(searchResultsController: searchResultController)
        searchController.searchResultsUpdater = searchResultController
        searchController.searchBar.autocapitalizationType = .none

        navigationItem.searchController = searchController
        navigationItem.title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationController?.navigationBar.tintColor = UIColor.label
        navigationItem.backButtonTitle = ""
        
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        return lists.count
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists[section].count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.Identifier.tableViewCell, for: indexPath)

        let list = lists[indexPath.section][indexPath.row]
        cell.textLabel?.text = list.listName
        cell.backgroundColor = UIColor(named: "cellMainColor")
        cell.accessoryType = .disclosureIndicator

        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70
    }
    
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let subView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 70))
        
        let label = UILabel(frame: CGRect(x: 15, y: 10, width: subView.frame.width ,height: subView.frame.height))
        label.text = ( section == 0 ? "Movies" : "TV Shows" )
        label.font = .systemFont(ofSize: 25, weight: .bold)
        
        subView.addSubview(label)
        
        return subView
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        let layout = UICollectionViewFlowLayout()
        let vc = MoviesCollectionViewController(collectionViewLayout: layout)
        
        let list = lists[indexPath.section][indexPath.row]
        vc.title = list.listName
        vc.url = list.url
        vc.mediaType = ( indexPath.section == 0 ? .movie : .tvShow )

        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)

    }
    
    
    func didSelectCell(id: Int, type: String) {
        
        let vc = getVC(id: id, type: type)
        vc.navigationItem.largeTitleDisplayMode = .never
        searchController.searchBar.text = ""
        navigationController?.pushViewController(vc, animated:true)
        searchController.isActive = false
        
    }
    
    
    func getVC(id: Int, type: String) -> UIViewController {
        
        if type == "movie" {
            let vc = MovieDetailsViewController()
            vc.movieId = id
            return vc
            
        } else if type == "tv" {
            let vc = TVShowDetailsViewController()
            vc.showId = id
            return vc
            
        } else {
            let vc = PersonDetailsViewController()
            vc.personId = id
            return vc
            
        }
    }
    
    
    
}
