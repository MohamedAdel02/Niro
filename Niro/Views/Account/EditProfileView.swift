//
//  EditProfileView.swift
//  Niro
//
//  Created by Mohamed Adel on 13/08/2023.
//

import UIKit
import SnapKit

class EditProfileView: UIView {

    let nameLabel: UILabel = {
       let label = UILabel()
        label.text = "Name"
        label.textColor = .lightGray
        label.numberOfLines = 0
        return label
    }()
        
    let nameTextField: CustomTextField = {
       let textField = CustomTextField()
        textField.textColor = .label
        textField.returnKeyType = .done
        return textField
    }() 
    
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

    let updateButton: CustomButton = {
        let button = CustomButton()
        button.configuration?.title = "UPDATE"
        button.configuration?.baseForegroundColor = .white
        return button
    }()

    let resetPasswordButton: CustomButton = {
        let button = CustomButton()
        button.configuration?.title = "RESET PASSWORD"
        button.configuration?.baseForegroundColor = .white
        return button
    }()
    
    let deleteAccountButton: UIButton = {
        let button = UIButton()
        button.setTitle("DELETE ACCOUNT", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18)
        button.setTitleColor(.systemRed, for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.darkGray.cgColor
        return button
    }()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor(named: "mainColor")
        
        emailTextField.isEnabled = false

        addSubview(nameLabel)
        addSubview(nameTextField)
        addSubview(emailLabel)
        addSubview(emailTextField)
        addSubview(updateButton)
        addSubview(resetPasswordButton)
        addSubview(deleteAccountButton)

        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setConstraints() {

        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(40)
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
        
        updateButton.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(50)
            make.trailing.equalTo(emailTextField.snp.trailing)
            make.width.equalTo(snp.width).multipliedBy(0.3)
        }
        
        resetPasswordButton.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(50)
            make.trailing.equalTo(updateButton.snp.leading).offset(-20)
            make.width.equalTo(snp.width).multipliedBy(0.4)
        }
        
        deleteAccountButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().offset(-5)
            make.trailing.equalToSuperview().offset(5)
            make.height.equalTo(50)
            make.bottom.equalToSuperview().offset(-150)
        }
        
    }

}
