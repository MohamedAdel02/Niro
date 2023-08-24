//
//  ActivityIndicatorHelper.swift
//  Niro
//
//  Created by Mohamed Adel on 24/08/2023.
//

import UIKit
import SnapKit

class ActivityIndicatorHelper {
    
    let activityIndicatorView = ActivityIndicatorView()
    let view: UIView
    
    init(view: UIView) {
              
        self.view = view
        view.addSubview(activityIndicatorView)
        setConstraints()
    }

    
    func showIndicator() {
        activityIndicatorView.activityIndicator.startAnimating()
    }
    
    
    func hideIndicator() {
        
        activityIndicatorView.activityIndicator.stopAnimating()
                
        UIView.transition(with: view, duration: 0.5, options: .transitionCrossDissolve, animations: { [weak self] in
            self?.activityIndicatorView.isHidden = true
        })
        
    }
    
    
    func setConstraints() {
        
        activityIndicatorView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    
}
