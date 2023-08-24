//
//  ActivityIndicatorView.swift
//  Niro
//
//  Created by Mohamed Adel on 24/08/2023.
//

import UIKit
import SnapKit

class ActivityIndicatorView: UIView {
    
    let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.style = .large
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()
 
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(named: "mainColor")

        addSubview(activityIndicator)
        setConstraints()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setConstraints() {
        
        activityIndicator.snp.makeConstraints { make in
            make.height.width.equalTo(100)
            make.center.equalToSuperview()
        }
        
    }
    
}
