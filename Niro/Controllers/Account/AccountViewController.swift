//
//  AccountViewController.swift
//  Niro
//
//  Created by Mohamed Adel on 03/08/2023.
//

import UIKit
import FirebaseAuth

enum AccountTableViewRows: String {
    
    case ratings        = "Ratings"
    case favorite       = "Favorites"
    case watchlist      = "Watchlist"
    case editProfile    = "Edit profile"
    case signOut        = "Sign out"
}

class AccountViewController: UIViewController {
    
    let rows: [[AccountTableViewRows]] = [
        [ .ratings, .favorite, .watchlist ],
        [ .editProfile, .signOut ]
    ]
    
    let accountView = AccountView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = accountView
        
        accountView.tableView.register(UITableViewCell.self, forCellReuseIdentifier: K.Identifier.tableViewCell)
        
        accountView.tableView.dataSource = self
        accountView.tableView.delegate = self
        
        navigationController?.navigationBar.tintColor = UIColor.label
        navigationItem.backButtonTitle = ""
                   
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let user = Auth.auth().currentUser
        accountView.userNameLabel.text = user?.displayName
    }
    
}


// MARK: - UITableViewDataSource, UITableViewDelegate

extension AccountViewController: UITableViewDataSource, UITableViewDelegate {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return rows.count
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows[section].count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.Identifier.tableViewCell, for: indexPath)

        let cellText = rows[indexPath.section][indexPath.row]
        cell.textLabel?.text = cellText.rawValue
        cell.backgroundColor = UIColor(named: "cellMainColor")
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.textColor = .label
        
        if cellText == .signOut {
            cell.textLabel?.textColor = .orange
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let subView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 80))
        return subView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = rows[indexPath.section][indexPath.row]

        switch cell {
        case .ratings:
            ratingsPressed()
            
        case .watchlist:
            watchlistPressed()
            
        case .favorite:
            favoritePressed()
            
        case .editProfile:
            editProfilePressed()
            
        case .signOut:
            signOutPressed()
        }

        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func ratingsPressed() {
        
        let layout = UICollectionViewFlowLayout()
        let vc = UserRatingsCollectionViewController(collectionViewLayout: layout)
        navigationController?.pushViewController(vc, animated: true)

    }
    
    func watchlistPressed() {
        let layout = UICollectionViewFlowLayout()
        let vc = UserMoviesCollectionViewController(collectionViewLayout: layout)
        vc.title = "Watchlist"
        vc.listType = .watchlist
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func favoritePressed() {

        let layout = UICollectionViewFlowLayout()
        let vc = UserMoviesCollectionViewController(collectionViewLayout: layout)
        vc.title = "Favorites"
        vc.listType = .favorite
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func editProfilePressed() {
        
        let vc = EditProfileViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func signOutPressed() {
 
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Sign out", style: .default){ [weak self] _ in
            self?.signOut()
        })

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        alert.popoverPresentationController?.sourceView = self.view
        alert.popoverPresentationController?.sourceRect = CGRect(x: self.view.frame.maxX - 100, y: self.view.frame.maxY - 80, width: 0, height: 0)
        
        present(alert, animated: true)
        
    }
    
    
    func signOut() {
        
        do{
            try AuthManger.shared.signOut()
            UserListHelper.shared.clearLists()
            
            let vc = MainAuthViewController()
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true)
        } catch {
            showAlert(title: "Cannot sign out", message: "An error occurred while signing out")
        }
    }
    
    
}
