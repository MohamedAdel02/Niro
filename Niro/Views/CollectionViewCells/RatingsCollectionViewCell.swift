//
//  RatingsCollectionViewCell.swift
//  Niro
//
//  Created by Mohamed Adel on 13/08/2023.
//

import UIKit
import SnapKit

class RatingsCollectionViewCell: UICollectionViewCell {
    
    let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .systemGray4
        return imageView
    }()
    
    let ratingImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.tintColor = UIColor(named: "goldColor")
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor(named: "cellMainColor")
        
        layer.cornerRadius = 10
        clipsToBounds = true
        
        addSubview(posterImageView)
        posterImageView.addSubview(nameLabel)

        addSubview(ratingImageView)
        
        nameLabel.isHidden = true
        setImageViewConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setImageViewConstraints() {
        
        posterImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.8)
        }

        nameLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        ratingImageView.snp.makeConstraints { make in
            make.top.equalTo(posterImageView.snp.bottom).offset(3)
            make.width.height.equalTo(snp.height).multipliedBy(0.15)
            make.centerX.equalToSuperview()
        }
        
    }
    
}
