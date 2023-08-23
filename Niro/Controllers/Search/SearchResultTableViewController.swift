//
//  SearchResultTableViewController.swift
//  Niro
//
//  Created by Mohamed Adel on 02/08/2023.
//

import UIKit
import Alamofire


protocol SelectCellProtocol {
    func didSelectCell(id: Int, type: String)
}

class SearchResultTableViewController: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate {

    var results = [SearchResult]()
    var task: Task<(), Never>? = nil
    var delegate: SelectCellProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: K.Identifier.customTableViewCell)
        
        tableView.backgroundColor = UIColor(named: "mainColor")
        tableView.keyboardDismissMode = .onDrag
        
    }
    
    
    func updateSearchResults(for searchController: UISearchController) {
        
        if let text = searchController.searchBar.text {
            
            task?.cancel()
            
            task = Task {
                await loadData(text: text)
            }
        }
    }
    
    
    func loadData(text: String) async {

        do {
            try await Task.sleep(nanoseconds: 1_000_000_000)
            try Task.checkCancellation()
            try await fetchResults(text: text)
        } catch let error {
            print(error.localizedDescription)
        }
        
    }

    
    func fetchResults(text: String) async throws {
        
        guard let text = text.addingPercentEncoding(withAllowedCharacters: .alphanumerics) else {
            return
        }
        
        let url = NetworkHelper.getSearchURL(text: text)
        try Task.checkCancellation()
        
        let data = try await NetworkManager.shared.data(url: url)
        let decodedData = try NetworkManager.shared.decodeData(data: data) as Search
        try await handleData(data: decodedData)
        tableView.reloadData()
        
    }
    
    
    func handleData(data: Search) async throws {
        
        results.removeAll()
        tableView.reloadData()
        try Task.checkCancellation()
        results = data.results
        
        print(results)
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: K.Identifier.customTableViewCell, for: indexPath) as! CustomTableViewCell
        
        let result = results[indexPath.row]
        
        cell.mainTextLabel.text = nil
        cell.subTextLabel.text = nil
        cell.customImageView.image = nil
        cell.defaultImageView.isHidden = true
        
        Task {
            await handleImageView(cell: cell, result: result)
            cell.mainTextLabel.text = result.title ?? result.name
            cell.subTextLabel.text = getSubText(type: result.type)
        }

        return cell
    }
    
    
    func getSubText(type: String) -> String {
        if type == "movie" {
            return "Movie"
        } else if type == "tv" {
            return "TV Show"
        } else {
            return ""
        }
    }
    
    
    func handleImageView(cell: CustomTableViewCell, result: SearchResult) async {

        
        do {
            
            var imageData: Data?
            
            if let posterPath = result.posterPath {
                imageData = try await NetworkManager.shared.data(imagePath: posterPath)
            }
            
            if let profilePath = result.profilePath {
                imageData = try await NetworkManager.shared.data(imagePath: profilePath)
            }
            
            try Task.checkCancellation()
            if let imageData = imageData {
                cell.customImageView.image = UIImage(data: imageData)
                return
            }
            
            handleDefaultImage(cell: cell, mediaType: result.type)
            
        } catch {
            
            handleDefaultImage(cell: cell, mediaType: result.type)
        }
        
    }
    
    
    func handleDefaultImage(cell: CustomTableViewCell, mediaType: String?) {
        
        
        if mediaType == "Movie" {
            cell.defaultImageView.image = UIImage(systemName: "film")
            
        } else if mediaType == "TV Show" {
            cell.defaultImageView.image = UIImage(systemName: "tv")
            
        } else {
            cell.defaultImageView.image = UIImage(systemName: "person.fill")
            
        }
        
        cell.defaultImageView.isHidden = false
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height / 8
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let result = results[indexPath.row]
        
        self.delegate?.didSelectCell(id: result.id, type: result.type)
        dismiss(animated: true)
 
    }

}
