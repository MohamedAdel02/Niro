//
//  ForgotPasswordView.swift
//  Niro
//
//  Created by Mohamed Adel on 07/08/2023.
//

import UIKit
import SnapKit

class ForgotPasswordView: UIView {

    let subView: UIView = {
       let view = UIView()
        view.backgroundColor = UIColor(named: "cellMainColor")
        view.layer.cornerRadius = 30
        return view
    }()
    
    let mainLabel: UILabel = {
       let label = UILabel()
        label.text = "Reset your password"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    let emailLabel: UILabel = {
       let label = UILabel()
        label.text = "Email"
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    let emailTextField: CustomTextField = {
       let textField = CustomTextField()
        textField.keyboardType = .emailAddress
        textField.backgroundColor = .darkGray
        textField.textColor = .white
        textField.returnKeyType = UIReturnKeyType.go
        textField.placeholder = "Enter your email"
        return textField
    }()
    
    let checkEmailLabel: UILabel = {
        let label = UILabel()
        label.text = "We sent a reset password link to your email, please check your email"
        label.font = .systemFont(ofSize: 14)
        label.textColor = .white
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
    
    let sendButton: CustomButton = {
        let button = CustomButton()
        button.configuration?.title = "SEND"
        button.configuration?.baseForegroundColor = .white
        return button
    }()
    
    let backButton: CustomButton = {
        let button = CustomButton()
        button.configuration?.title = "BACK"
        button.configuration?.baseForegroundColor = .white
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .black.withAlphaComponent(0.7)
        overrideUserInterfaceStyle = .dark
        
        subView.addSubview(mainLabel)
        subView.addSubview(emailLabel)
        subView.addSubview(emailTextField)
        subView.addSubview(checkEmailLabel)
        subView.addSubview(errorSymbol)
        subView.addSubview(errorLabel)
        subView.addSubview(sendButton)
        subView.addSubview(backButton)
        addSubview(subView)
        
        checkEmailLabel.isHidden = true
        errorSymbol.isHidden = true
        errorLabel.isHidden = true

        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setConstraints() {
        
        subView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.greaterThanOrEqualToSuperview().multipliedBy(0.35)
        }
        
        mainLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
        }
        
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(mainLabel.snp.bottom).offset(30)
            make.leading.equalToSuperview().offset(25)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(emailLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(30)
        }
        
        checkEmailLabel.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(30)
            make.trailing.equalToSuperview().offset(-30)
        }
        
        errorSymbol.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(30)
            make.width.height.equalTo(18)
        }
        
        errorLabel.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(20)
            make.leading.equalTo(errorSymbol.snp.trailing).offset(5)
            make.trailing.equalToSuperview().offset(-30)
        }
        
        sendButton.snp.makeConstraints { make in
            make.top.equalTo(checkEmailLabel.snp.bottom).offset(30)
            make.bottom.equalToSuperview().offset(-30)
            make.width.equalTo(subView.snp.width).multipliedBy(0.4)
            make.leading.equalTo(subView.snp.centerX).offset(10)
        }
        
        backButton.snp.makeConstraints { make in
            make.top.equalTo(checkEmailLabel.snp.bottom).offset(30)
            make.bottom.equalToSuperview().offset(-30)
            make.width.equalTo(subView.snp.width).multipliedBy(0.4)
            make.trailing.equalTo(subView.snp.centerX).offset(-10)
        }
         
    }
    

}
