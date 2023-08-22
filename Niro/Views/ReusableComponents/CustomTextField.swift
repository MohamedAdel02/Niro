//
//  CustomTextField.swift
//  Niro
//
//  Created by Mohamed Adel on 05/08/2023.
//

import UIKit

class CustomTextField: UITextField {

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpTextField()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func setUpTextField() {
        
        textColor = .lightGray
        layer.cornerRadius = 10
        returnKeyType = UIReturnKeyType.next
        autocorrectionType = .no
        backgroundColor = UIColor(named: "cellMainColor")
        let equalPaddingView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 15, height: 2))
        leftView = equalPaddingView
        leftViewMode = .always
        rightView = equalPaddingView
        rightViewMode = .always
        autocapitalizationType = UITextAutocapitalizationType.none
        
    }
}
