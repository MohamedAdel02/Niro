//
//  CreateAccountView.swift
//  Niro
//
//  Created by Mohamed Adel on 04/08/2023.
//

import UIKit
import SnapKit

class CreateAccountView: UIView {

    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Hangover")
        return imageView
    }()
    
    let niroLabel: UILabel = {
       let label = UILabel()
        label.text = "Niro"
        label.font = UIFont(name: "Gagalin-Regular", size: 60)
        label.textColor = UIColor(named: "logoColor")
        label.numberOfLines = 0
        return label
    }()
    
    let errorSymbol: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "exclamationmark.circle")
        imageView.tintColor = UIColor(named: "errorColor")
        return imageView
    }()
    
    let errorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor(named: "errorColor")
        label.numberOfLines = 0
        return label
    }()
    
    let nameLabel: UILabel = {
       let label = UILabel()
        label.text = "Name"
        label.textColor = .lightGray
        label.numberOfLines = 0
        return label
    }()
    
    let nameTextField = CustomTextField()

    let emailLabel: UILabel = {
       let label = UILabel()
        label.text = "Email"
        label.textColor = .lightGray
        label.numberOfLines = 0
        return label
    }()
    
    let emailTextField: CustomTextField = {
       let textField = CustomTextField()
        textField.keyboardType = .emailAddress
        return textField
    }()
    
    let passwordLabel: UILabel = {
       let label = UILabel()
        label.text = "Password"
        label.textColor = .lightGray
        label.numberOfLines = 0
        return label
    }()
    
    let passwordTextField: CustomTextField = {
       let textField = CustomTextField()
        textField.isSecureTextEntry = true
        textField.returnKeyType = UIReturnKeyType.go
        textField.placeholder = "At least 6 characters"
        return textField
    }()
    
    let signUpButton: CustomButton = {
        let button = CustomButton()
        button.configuration?.title = "SIGN UP"
        return button
    }()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor(named: "mainColor")
        overrideUserInterfaceStyle = .dark
        
        addSubview(imageView)
        addSubview(niroLabel)
        addSubview(errorSymbol)
        addSubview(errorLabel)
        addSubview(nameLabel)
        addSubview(nameTextField)
        addSubview(emailLabel)
        addSubview(emailTextField)
        addSubview(passwordLabel)
        addSubview(passwordTextField)
        addSubview(signUpButton)

        errorLabel.isHidden = true
        errorSymbol.isHidden = true

        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setConstraints() {
        
        imageView.snp.makeConstraints { make in
            make.top.trailing.leading.equalToSuperview()
            make.height.equalTo(snp.height).multipliedBy(0.2)
        }
        
        niroLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom)
            make.centerX.equalTo(snp.centerX)
        }
        
        errorSymbol.snp.makeConstraints { make in
            make.top.equalTo(niroLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(35)
            make.width.height.equalTo(18)
        }
        
        errorLabel.snp.makeConstraints { make in
            make.top.equalTo(niroLabel.snp.bottom).offset(20)
            make.leading.equalTo(errorSymbol.snp.trailing).offset(5)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(errorLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(35)
        }
        
        nameTextField.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(30)
            make.trailing.equalToSuperview().offset(-30)
            make.height.equalTo(30)
        }

        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(nameTextField.snp.bottom).offset(30)
            make.leading.equalToSuperview().offset(35)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(emailLabel.snp.bottom).offset(10)
            make.leading.equalTo(nameTextField.snp.leading)
            make.trailing.equalTo(nameTextField.snp.trailing)
            make.height.equalTo(30)
        }
        
        passwordLabel.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(30)
            make.leading.equalToSuperview().offset(35)
        }

        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(passwordLabel.snp.bottom).offset(10)
            make.leading.equalTo(nameTextField.snp.leading)
            make.trailing.equalTo(nameTextField.snp.trailing)
            make.height.equalTo(30)
        }
        
        signUpButton.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(30)
            make.trailing.equalTo(passwordTextField.snp.trailing)
            make.width.equalTo(snp.width).multipliedBy(0.3)
        }

    }

}
