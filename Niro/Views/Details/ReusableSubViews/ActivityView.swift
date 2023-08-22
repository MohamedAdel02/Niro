//
//  ActivityView.swift
//  Niro
//
//  Created by Mohamed Adel on 15/08/2023.
//

import UIKit
import SnapKit

class ActivityView: UIView {

    let ratingImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "star.fill")
        imageView.tintColor = UIColor(named: "goldColor")
        return imageView
    }()

    let ratingLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 19, weight: .bold)
        label.textAlignment = .right
        return label
    }()
    
    let outOfTenLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.text = "/10"
        label.textColor = .gray
        return label
    }()
    
    let voteCountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 11)
        label.textColor = .gray
        label.textAlignment = .center
        return label
    }()
    
    let userRatingButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "star.circle.fill"), for: .normal)
        button.tintColor = .label
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        return button
    }()
    
    let userRatingLabel: UILabel = {
        let label = UILabel()
        label.text = "Rate"
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .center
        return label
    }()
    
    let favoriteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "heart.circle.fill"), for: .normal)
        button.tintColor = .label
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        return button
    }()
    
    let favoriteLabel: UILabel = {
        let label = UILabel()
        label.text = "Favorite"
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .center
        return label
    }()
    
    let watchlistButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "bookmark.circle.fill"), for: .normal)
        button.tintColor = .label
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        return button
    }()
    
    let watchlistLabel: UILabel = {
        let label = UILabel()
        label.text = "Watchlist"
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .center
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = 20
        backgroundColor = .systemGray4
        
        
        addSubview(ratingImageView)
        addSubview(ratingLabel)
        addSubview(outOfTenLabel)
        addSubview(voteCountLabel)
        addSubview(userRatingButton)
        addSubview(userRatingLabel)
        addSubview(favoriteButton)
        addSubview(favoriteLabel)
        addSubview(watchlistButton)
        addSubview(watchlistLabel)
        
        setConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setConstraints() {
        
        ratingImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(-15)
            make.centerX.equalToSuperview().offset(-130)
            make.height.width.equalTo(30)
        }

        ratingLabel.snp.makeConstraints { make in
            make.top.equalTo(ratingImageView.snp.bottom).offset(-7)
            make.centerX.equalTo(ratingImageView.snp.centerX).offset(-12)
            make.width.height.equalTo(33)
        }
        
        outOfTenLabel.snp.makeConstraints { make in
            make.top.equalTo(ratingImageView.snp.bottom)
            make.centerX.equalTo(ratingImageView.snp.centerX).offset(15)
            make.width.height.equalTo(20)
        }
        

        voteCountLabel.snp.makeConstraints { make in
            make.top.equalTo(outOfTenLabel.snp.bottom).offset(-5)
            make.centerX.equalTo(ratingImageView.snp.centerX)
            make.height.equalTo(20)
            make.width.equalTo(70)
        }
        
        userRatingButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(-10)
            make.centerX.equalToSuperview().offset(-50)
            make.height.width.equalTo(30)
        }
        
        userRatingLabel.snp.makeConstraints { make in
            make.top.equalTo(userRatingButton.snp.bottom)
            make.centerX.equalTo(userRatingButton.snp.centerX)
            make.width.height.equalTo(30)
        }
        
        favoriteButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(-10)
            make.centerX.equalToSuperview().offset(40)
            make.height.width.equalTo(30)
        }
        
        favoriteLabel.snp.makeConstraints { make in
            make.top.equalTo(favoriteButton.snp.bottom)
            make.centerX.equalTo(favoriteButton.snp.centerX)
            make.width.equalTo(55)
            make.height.equalTo(30)
        }
        
        watchlistButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(-10)
            make.centerX.equalToSuperview().offset(130)
            make.height.width.equalTo(30)
        }
        
        watchlistLabel.snp.makeConstraints { make in
            make.top.equalTo(watchlistButton.snp.bottom)
            make.centerX.equalTo(watchlistButton.snp.centerX)
            make.width.equalTo(60)
            make.height.equalTo(30)
        }
        
        
        
    }
    
}
