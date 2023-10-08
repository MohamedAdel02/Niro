//
//  ResetPasswordViewController.swift
//  Niro
//
//  Created by Mohamed Adel on 14/08/2023.
//

import UIKit

class ResetPasswordViewController: UIViewController {
    
    let resetPasswordView = ResetPasswordView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = resetPasswordView
        
        resetPasswordView.currentPasswordTextField.delegate = self
        resetPasswordView.newPasswordTextField.delegate = self
        
        resetPasswordView.resetButton.addTarget(self, action: #selector(resetPressed), for: UIControl.Event.touchUpInside)
    }
    
    
    @objc func resetPressed() {
        
        let currentPassword = resetPasswordView.currentPasswordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let newPassword = resetPasswordView.newPasswordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
        if areValidFields(currentPassword: currentPassword, newPassword: newPassword){
            
            Task {
                await resetPassword(currentPassword: currentPassword, newPassword: newPassword)
            }
        }
        
    }

    
    func areValidFields(currentPassword: String, newPassword: String) -> Bool {

        if currentPassword.isEmpty || newPassword.isEmpty {
            showError(text: "Please enter all required fields")
            return false
        }
        
        if newPassword.count < 6 {
            showError(text: "Password must be at least 6 characters")
            return false
        }
        
        return true
    }
    
    
    func resetPassword(currentPassword: String, newPassword: String) async {
        
        do {
            
            try await AuthManger.shared.resetPassword(currentPassword: currentPassword, newPassword: newPassword)
            navigationController?.popToRootViewController(animated: true)
        } catch {
            showError(text: "Incorrect password")
        }
        
    }
    

    func showError(text: String) {
        
        resetPasswordView.errorLabel.text = text
        resetPasswordView.errorSymbol.isHidden = false
        resetPasswordView.errorLabel.isHidden = false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

}

// MARK: - UITextFieldDelegate

extension ResetPasswordViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == resetPasswordView.currentPasswordTextField {
            return resetPasswordView.newPasswordTextField.becomeFirstResponder()
        } else {
            resetPressed()
            return true
        }
    }
    
}

