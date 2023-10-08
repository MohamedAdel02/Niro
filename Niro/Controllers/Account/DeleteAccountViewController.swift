//
//  DeleteAccountViewController.swift
//  Niro
//
//  Created by Mohamed Adel on 13/08/2023.
//

import UIKit

class DeleteAccountViewController: UIViewController {

    let deleteAccountView = DeleteAccountView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = deleteAccountView
        
        deleteAccountView.passwordTextField.delegate = self
        
        deleteAccountView.deleteButton.addTarget(self, action: #selector(deletePressed), for: UIControl.Event.touchUpInside) 
    }
    

    @objc func deletePressed() {

        
        let password = deleteAccountView.passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

        if !password.isEmpty {
            
            Task {
                await deleteAccount(password: password)
            }
            
        } else {
            showError(text: "Please enter your password")
        }

    }
    
    
    func deleteAccount(password: String) async {
        
        do {
            
            try await FirestoreManager.shared.deleteUser(password: password)
            
            UserListHelper.shared.clearLists()
            
            let vc = MainAuthViewController()
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
            
        } catch {
            showError(text: "Incorrect password")
        }
        
    }
    
    
    func showError(text: String) {
        
        deleteAccountView.errorLabel.text = text
        deleteAccountView.errorSymbol.isHidden = false
        deleteAccountView.errorLabel.isHidden = false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
}

// MARK: - UITextFieldDelegate

extension DeleteAccountViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        deletePressed()
        return true
    }
    
}

