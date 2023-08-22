//
//  ViewControllerExtension.swift
//  Niro
//
//  Created by Mohamed Adel on 17/08/2023.
//

import UIKit


extension UIViewController {
    
    func showAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        
        self.present(alert, animated: true)
    }
    
}
