//
//  MainLoginViewController.swift
//  Niro
//
//  Created by Mohamed Adel on 04/08/2023.
//

import UIKit

class MainAuthViewController: UIViewController {
    
    var images = [String]()
    static var timer = Timer()
    var photoCount = 0
    let rows = [ "Sign in", "Create account"]

    let mainAuthView = MainAuthView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = mainAuthView

        mainAuthView.tableView.register(UITableViewCell.self, forCellReuseIdentifier: K.Identifier.tableViewCell)
        
        mainAuthView.tableView.dataSource = self
        mainAuthView.tableView.delegate = self
        mainAuthView.tableView.separatorColor = UIColor.darkGray
                
        images = ["Dunkirk","OnceUponTimeInHollywood","Batman","GoneGirl","Tenet"]
        mainAuthView.imageView.image = UIImage.init(named: "Dunkirk")
        MainAuthViewController.timer = Timer.scheduledTimer(timeInterval: 8.0, target: self, selector: #selector(onTransition), userInfo: nil, repeats: true)
        
    }
    
    
    @objc func onTransition() {
                
        if (photoCount < images.count - 1){
            photoCount += 1;
        }else{
            photoCount = 0;
        }

        UIView.transition(with: self.mainAuthView.imageView, duration: 2.0, options: .transitionCrossDissolve, animations: {
            self.mainAuthView.imageView.image = UIImage.init(named: (self.images[self.photoCount]))
        }, completion: nil)
        
    }

    
    override func viewDidLayoutSubviews() {
        
        mainAuthView.gradientView.layer.sublayers?.removeAll()
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = mainAuthView.gradientView.bounds
        
        let gradientColor = UIColor(named: "mainColor")!.resolvedColor(with: UITraitCollection(userInterfaceStyle: .dark))
        gradientLayer.colors = [gradientColor.cgColor, gradientColor.withAlphaComponent(0).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0)
        mainAuthView.gradientView.layer.addSublayer(gradientLayer)
                     
    }
    
}


// MARK: - UITableViewDataSource, UITableViewDelegate

extension MainAuthViewController: UITableViewDataSource, UITableViewDelegate {


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows.count
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.Identifier.tableViewCell, for: indexPath)

        cell.textLabel?.text = rows[indexPath.row]
        cell.textLabel?.textColor = .lightGray
        cell.backgroundColor = UIColor(named: "cellMainColor")
        cell.accessoryView = UIImageView(image: UIImage(systemName: "chevron.right"))
        cell.tintColor = .darkGray

        return cell
    }


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let vc: UIViewController
        if rows[indexPath.row] == "Sign in" {
            vc = SignInViewController()
        } else {
            vc = CreateAccountViewController()
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        present(vc, animated: true)

    }

}

