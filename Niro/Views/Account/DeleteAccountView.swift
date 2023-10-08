//
//  DeleteAccountView.swift
//  Niro
//
//  Created by Mohamed Adel on 13/08/2023.
//

import UIKit
import SnapKit

class DeleteAccountView: UIView {

    let mainLabel: UILabel = {
       let label = UILabel()
        label.text = "Delete your account"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .label
        label.numberOfLines = 0
        return label
    }()
    
    let subLabel: UILabel = {
       let label = UILabel()
        label.text = "Deleting your account is a permanent operation"
        label.font = .systemFont(ofSize: 15)
        label.textColor = .label
        label.numberOfLines = 0
        return label
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
        textField.placeholder = "Enter your password"
        textField.isSecureTextEntry = true
        textField.returnKeyType = .done
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
    
    let deleteButton: CustomButton = {
        let button = CustomButton()
        button.configuration?.title = "DELETE"
        button.configuration?.baseForegroundColor = .white
        return button
    }()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor(named: "mainColor")
        
        addSubview(mainLabel)
        addSubview(subLabel)
        addSubview(passwordLabel)
        addSubview(passwordTextField)
        addSubview(errorSymbol)
        addSubview(errorLabel)
        addSubview(deleteButton)
        
        errorSymbol.isHidden = true
        errorLabel.isHidden = true

        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setConstraints() {

        mainLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(30)
            make.centerX.equalToSuperview()
        }
        
        subLabel.snp.makeConstraints { make in
            make.top.equalTo(mainLabel.snp.bottom).offset(30)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)

        }
        
        passwordLabel.snp.makeConstraints { make in
            make.top.equalTo(subLabel.snp.bottom).offset(30)
            make.leading.equalToSuperview().offset(25)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(passwordLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(30)
        }
        
        
        errorSymbol.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(30)
            make.width.height.equalTo(18)
        }
        
        errorLabel.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(20)
            make.leading.equalTo(errorSymbol.snp.trailing).offset(5)
            make.trailing.equalToSuperview().offset(-30)
        }
        
        deleteButton.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(50)
            make.width.equalToSuperview().multipliedBy(0.4)
            make.trailing.equalTo(passwordTextField.snp.trailing)
        }
        

         
    }
    

}
