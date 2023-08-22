//
//  EditProfileViewController.swift
//  Niro
//
//  Created by Mohamed Adel on 13/08/2023.
//

import UIKit
import FirebaseAuth

class EditProfileViewController: UIViewController {
    
    let editProfileView = EditProfileView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view = editProfileView
        
        navigationItem.backButtonTitle = ""
        
        editProfileView.updateButton.addTarget(self, action: #selector(updatePressed), for: UIControl.Event.touchUpInside)
        editProfileView.deleteAccountButton.addTarget(self, action: #selector(deleteAccountPressed), for: UIControl.Event.touchUpInside)
        editProfileView.resetPasswordButton.addTarget(self, action: #selector(resetPressed), for: UIControl.Event.touchUpInside)
        
        if let user = Auth.auth().currentUser {
            
            editProfileView.nameTextField.text = user.displayName
            editProfileView.emailTextField.text = user.email
        }
        
    }
    
    
    @objc func updatePressed() {
        
        guard let name = editProfileView.nameTextField.text else {
            return
        }
        
        Task {
            await updateUserName(name: name)
        }
    }
    
    
    func updateUserName(name: String) async {
        
        do {
            try await AuthManger.shared.UpdateUserName(name: name)
            navigationController?.popViewController(animated: true)

        } catch {
            showAlert(title: "Cannot update your name", message: "An error occurred while updating your name")
        }
    }
    
    
    @objc func deleteAccountPressed() {

        let vc = DeleteAccountViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @objc func resetPressed() {
        
        let vc = ResetPasswordViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

}
