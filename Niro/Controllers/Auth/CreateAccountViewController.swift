//
//  CreateAccountViewController.swift
//  Niro
//
//  Created by Mohamed Adel on 04/08/2023.
//

import UIKit

class CreateAccountViewController: UIViewController {

    let createAccountView = CreateAccountView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view = createAccountView
        
        createAccountView.emailTextField.delegate = self
        createAccountView.passwordTextField.delegate = self
        createAccountView.nameTextField.delegate = self

        createAccountView.signUpButton.addTarget(self, action: #selector(singUpPressed), for: UIControl.Event.touchUpInside)
        
    }

    
    @objc func singUpPressed() {
                
        let name = createAccountView.nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let email = createAccountView.emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let password = createAccountView.passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

        if areValidFields(name: name, email: email, password: password){
            
            Task {
                await createAccount(name: name, email: email, password: password)
            }
        }

    }
    
    
    func areValidFields(name: String, email: String, password: String) -> Bool {

        if name.isEmpty || email.isEmpty || password.isEmpty {
            showError(text: "Please enter all required fields")
            return false
        }
                
        if !email.isValidEmail() {
            showError(text: "Invalid email")
            return false
        }
        
        if password.count < 6 {
            showError(text: "Password must be at least 6 characters")
            return false
        }
        
        return true
    }


    func createAccount(name: String, email: String, password: String) async {
        
        do {
            try await AuthManger.shared.createAccount(name: name, email: email, password: password)
            
            let vc = TabBarController()
            vc.modalPresentationStyle = .fullScreen
            MainAuthViewController.timer.invalidate()
            present(vc, animated: true)
            
        } catch {
            showError(text: error.localizedDescription)
        }
        
    }
    
    
    func showError(text: String) {
        
        createAccountView.errorSymbol.isHidden = false
        createAccountView.errorLabel.isHidden = false
        createAccountView.errorLabel.text = text
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}


// MARK: - UITextFieldDelegate

extension CreateAccountViewController: UITextFieldDelegate {
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.3, animations: {
            self.view.frame = CGRect(x:self.view.frame.origin.x, y:self.view.frame.origin.y - 150, width:self.view.frame.size.width, height:self.view.frame.size.height)
        })
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.3, animations: {
            self.view.frame = CGRect(x:self.view.frame.origin.x, y:self.view.frame.origin.y + 150, width:self.view.frame.size.width, height:self.view.frame.size.height)
        })
    }
    
}
