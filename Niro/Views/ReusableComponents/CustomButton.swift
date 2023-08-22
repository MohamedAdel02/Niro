//
//  CustomButton.swift
//  Niro
//
//  Created by Mohamed Adel on 05/08/2023.
//

import UIKit

class CustomButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUPButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUPButton() {
        
        configuration = .filled()
        configuration?.buttonSize = .small
        configuration?.baseBackgroundColor = .darkGray
        configuration?.baseForegroundColor = .lightGray
    }
    
}
