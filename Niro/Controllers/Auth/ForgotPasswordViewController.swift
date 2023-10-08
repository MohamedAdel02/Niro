//
//  ForgotPasswordViewController.swift
//  Niro
//
//  Created by Mohamed Adel on 07/08/2023.
//

import UIKit

class ForgotPasswordViewController: UIViewController {
    
    let forgotPasswordView = ForgotPasswordView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = forgotPasswordView
        
        forgotPasswordView.emailTextField.delegate = self
        
        forgotPasswordView.sendButton.addTarget(self, action: #selector(sendPressed), for: UIControl.Event.touchUpInside)
        forgotPasswordView.backButton.addTarget(self, action: #selector(backPressed), for: UIControl.Event.touchUpInside)
        
    }
    
    
    @objc func sendPressed() {
        
        let email = forgotPasswordView.emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
        if isValidEmail(email: email) {
            
            Task {
                await resetPassword(email: email)
            }
        }
        
    }
    
    
    func isValidEmail(email: String) -> Bool {
        
        if email.isEmpty {
            showError(text: "Please enter your email")
            return false
        }
        
        if !email.isValidEmail() {
            showError(text: "Invalid email")
            return false
        }
        
        return true
    }
    
    
    func resetPassword(email: String) async  {
        
        do {
            try await AuthManger.shared.resetPassword(email: email)
            showCheckEmailLabel()
            
        } catch {
            showError(text: "Sorry, we couldn't find your account")
        }
        
    }
    
    
    func showCheckEmailLabel() {
        
        forgotPasswordView.errorSymbol.isHidden = true
        forgotPasswordView.errorLabel.isHidden = true
        forgotPasswordView.checkEmailLabel.isHidden = false
    }
    
    
    func showError(text: String) {
        
        forgotPasswordView.checkEmailLabel.isHidden = true
        forgotPasswordView.errorSymbol.isHidden = false
        forgotPasswordView.errorLabel.isHidden = false
        forgotPasswordView.errorLabel.text = text
    }
    
    
    @objc func backPressed() {
        
        dismiss(animated: true)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
    }
    
}


// MARK: - UITextFieldDelegate

extension ForgotPasswordViewController: UITextFieldDelegate {
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.3, animations: {
            self.view.frame = CGRect(x:self.view.frame.origin.x, y:self.view.frame.origin.y - 80, width:self.view.frame.size.width, height:self.view.frame.size.height)
        })
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.3, animations: {
            self.view.frame = CGRect(x:self.view.frame.origin.x, y:self.view.frame.origin.y + 80, width:self.view.frame.size.width, height:self.view.frame.size.height)
        })
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        sendPressed()
        return textField.resignFirstResponder()
    }
    
}

