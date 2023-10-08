//
//  SignInViewController.swift
//  Niro
//
//  Created by Mohamed Adel on 04/08/2023.
//

import UIKit

class SignInViewController: UIViewController {

    let signInView = SignInView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = signInView
        
        signInView.emailTextField.delegate = self
        signInView.passwordTextField.delegate = self
        
        signInView.signInButton.addTarget(self, action: #selector(signInPressed), for: UIControl.Event.touchUpInside)
        signInView.forgotPasswordButton.addTarget(self, action: #selector(forgotPasswordPressed), for: UIControl.Event.touchUpInside)

    }
    

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    @objc func signInPressed() {
                
        let email = signInView.emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let password = signInView.passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

        if areValidFields(email: email, password: password){
            
            Task {
                await signIn(email: email, password: password)
            }
        }
        
    }
    
    func areValidFields(email: String, password: String) -> Bool {

        if email.isEmpty || password.isEmpty {
            showError(text: "Please enter all required fields")
            return false
        }
        
        return true
    }

    
    func signIn(email: String, password: String) async {
        
        do {
            try await AuthManger.shared.signIn(email: email, password: password)
            UserListHelper.shared.getUserLists()
            
            let vc = TabBarController()
            vc.modalPresentationStyle = .fullScreen
            MainAuthViewController.timer.invalidate()
            present(vc, animated: true)
            
        } catch {
            showError(text: "Incorrect email or password")
        }
    }

    func showError(text: String) {
        
        signInView.errorSymbol.isHidden = false
        signInView.errorLabel.isHidden = false
        signInView.errorLabel.text = text
    }
    
    @objc func forgotPasswordPressed() {
        let vc = ForgotPasswordViewController()
        
        self.view.endEditing(true)        
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        
        present(vc, animated: true)
        
    }

}


// MARK: - UITextFieldDelegate

extension SignInViewController: UITextFieldDelegate {
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.3, animations: {
            self.view.frame = CGRect(x:self.view.frame.origin.x, y:self.view.frame.origin.y - 250, width:self.view.frame.size.width, height:self.view.frame.size.height)
        })
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.3, animations: {
            self.view.frame = CGRect(x:self.view.frame.origin.x, y:self.view.frame.origin.y + 250, width:self.view.frame.size.width, height:self.view.frame.size.height)
        })
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == signInView.emailTextField {
            return signInView.passwordTextField.becomeFirstResponder()
        } else if textField == signInView.passwordTextField {
            signInPressed()
            return true
        } else {
            return textField.resignFirstResponder()
        }
        
    }
    
}
