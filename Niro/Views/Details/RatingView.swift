//
//  RatingView.swift
//  Niro
//
//  Created by Mohamed Adel on 12/08/2023.
//

import UIKit
import SnapKit
import Cosmos

class RatingView: UIView {

    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "0.circle.fill")
        imageView.tintColor = UIColor(named: "goldColor")
        return imageView
    }()
    
    let starsView: CosmosView = {
        let view = CosmosView()
        view.rating = 0
        view.settings.totalStars = 10
        view.settings.starSize = 26
        view.settings.filledColor = UIColor(named: "goldColor")!
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(imageView)
        addSubview(starsView)
        
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
        
    func setConstraints() {
        
        self.snp.makeConstraints { make in
            make.height.equalTo(130)
            make.width.equalTo(300)
        }
        
        imageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(15)
            make.width.height.equalTo(40)
        }
        
        starsView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(imageView.snp.bottom).offset(25)
        }
        
    }

    
}
