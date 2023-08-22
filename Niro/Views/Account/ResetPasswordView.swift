//
//  ResetPasswordView.swift
//  Niro
//
//  Created by Mohamed Adel on 14/08/2023.
//

import UIKit
import SnapKit

class ResetPasswordView: UIView {

    let mainLabel: UILabel = {
       let label = UILabel()
        label.text = "Reset password"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .label
        label.numberOfLines = 0
        return label
    }()
    
    let currentPasswordLabel: UILabel = {
       let label = UILabel()
        label.text = "Current password"
        label.textColor = .lightGray
        label.numberOfLines = 0
        return label
    }()
    
    let currentPasswordTextField: CustomTextField = {
       let textField = CustomTextField()
        textField.placeholder = ""
        textField.isSecureTextEntry = true
        textField.textColor = .label
        return textField
    }()
    
    let newPasswordLabel: UILabel = {
       let label = UILabel()
        label.text = "New password"
        label.textColor = .lightGray
        label.numberOfLines = 0
        return label
    }()
    
    let newPasswordTextField: CustomTextField = {
       let textField = CustomTextField()
        textField.placeholder = "At least 6 characters"
        textField.isSecureTextEntry = true
        textField.textColor = .label
        return textField
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

    let resetButton: CustomButton = {
        let button = CustomButton()
        button.configuration?.title = "Reset"
        button.configuration?.baseForegroundColor = .white
        return button
    }()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor(named: "mainColor")
        
        addSubview(mainLabel)
        addSubview(currentPasswordLabel)
        addSubview(currentPasswordTextField)
        addSubview(newPasswordLabel)
        addSubview(newPasswordTextField)
        addSubview(errorSymbol)
        addSubview(errorLabel)
        addSubview(resetButton)
        
        errorSymbol.isHidden = true
        errorLabel.isHidden = true

        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setConstraints() {

        mainLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(20)
            make.centerX.equalToSuperview()
        }
        
        currentPasswordLabel.snp.makeConstraints { make in
            make.top.equalTo(mainLabel.snp.bottom).offset(30)
            make.leading.equalToSuperview().offset(25)
        }
        
        currentPasswordTextField.snp.makeConstraints { make in
            make.top.equalTo(currentPasswordLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(30)
        }
        
        newPasswordLabel.snp.makeConstraints { make in
            make.top.equalTo(currentPasswordTextField.snp.bottom).offset(30)
            make.leading.equalToSuperview().offset(25)
        }
        
        newPasswordTextField.snp.makeConstraints { make in
            make.top.equalTo(newPasswordLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(30)
        }
        
        errorSymbol.snp.makeConstraints { make in
            make.top.equalTo(newPasswordTextField.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(30)
            make.width.height.equalTo(18)
        }
        
        errorLabel.snp.makeConstraints { make in
            make.top.equalTo(newPasswordTextField.snp.bottom).offset(20)
            make.leading.equalTo(errorSymbol.snp.trailing).offset(5)
            make.trailing.equalToSuperview().offset(-30)
        }
        
        resetButton.snp.makeConstraints { make in
            make.top.equalTo(newPasswordTextField.snp.bottom).offset(50)
            make.width.equalToSuperview().multipliedBy(0.4)
            make.trailing.equalTo(newPasswordTextField.snp.trailing)
        }
         
    }
    

}
