//
//  AllCastTableViewController.swift
//  Niro
//
//  Created by Mohamed Adel on 11/08/2023.
//

import UIKit

class AllCastTableViewController: UITableViewController {

    
    var cast = [CastMember]()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: K.Identifier.customTableViewCell)
        
        tableView.backgroundColor = UIColor(named: "mainColor")
        navigationItem.backButtonTitle = ""
        
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cast.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.Identifier.customTableViewCell, for: indexPath) as! CustomTableViewCell
        
        cell.customImageView.image = nil
        cell.defaultImageView.isHidden = true
        
        Task {
             await handleImageView(cell: cell, indexPath: indexPath)
        }
        
        cell.mainTextLabel.text = cast[indexPath.row].name
        cell.subTextLabel.text = cast[indexPath.row].character ?? cast[indexPath.row].roles?[0].character

        return cell
    }
    
    
    func handleImageView(cell: CustomTableViewCell, indexPath: IndexPath) async {
        
        let profilePath = cast[indexPath.row].profilePath

        do {
            var imageData: Data?

            if let posterPath = profilePath {
                imageData = try await NetworkManager.shared.data(imagePath: posterPath)
            }
            
            if let imageData = imageData {
                cell.customImageView.image = UIImage(data: imageData)
                return
            }

            cell.defaultImageView.image = UIImage(systemName: "person.fill")
            cell.defaultImageView.isHidden = false
            
        } catch {
            cell.defaultImageView.image = UIImage(systemName: "person.fill")
            cell.defaultImageView.isHidden = false
        }
        
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = PersonDetailsViewController()
        vc.personId = cast[indexPath.row].id
        navigationController?.pushViewController(vc, animated: true)
    }

}
