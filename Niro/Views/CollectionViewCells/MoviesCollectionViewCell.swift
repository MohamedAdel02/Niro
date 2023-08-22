//
//  MoviesCollectionViewCell.swift
//  Niro
//
//  Created by Mohamed Adel on 01/08/2023.
//

import UIKit
import SnapKit

class MoviesCollectionViewCell: UICollectionViewCell {
    
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .systemGray4
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
        
        layer.cornerRadius = 10
        clipsToBounds = true
        
        imageView.addSubview(nameLabel)
        addSubview(imageView)
        
        nameLabel.isHidden = true
        setImageViewConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setImageViewConstraints() {
        
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            
        }
        
        nameLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
    }
    
    
}
