//
//  DetailsCollectionViewCell.swift
//  Niro
//
//  Created by Mohamed Adel on 09/08/2023.
//

import UIKit
import SnapKit

class DetailsCollectionViewCell: UICollectionViewCell {

    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .systemGray4
        return imageView
    }()
    
    let defaultImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .gray
        return imageView
    }()
    
    let mainTextLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 10)
        return label
    }()
    
    let subTextLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 9)
        label.textColor = .systemGray
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = 3
        clipsToBounds = true
        
        backgroundColor = .systemGray3
        
        imageView.addSubview(defaultImageView)
        addSubview(imageView)
  
        addSubview(mainTextLabel)
        addSubview(subTextLabel)
        
        defaultImageView.isHidden = true
        
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setConstraints() {
        
        imageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.7)
        }
        
        defaultImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(50)
        }
        
        mainTextLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(5)
            make.leading.equalToSuperview().offset(2)
            make.trailing.equalToSuperview().offset(-2)
        }
        
        subTextLabel.snp.makeConstraints { make in
            make.top.equalTo(mainTextLabel.snp.bottom).offset(2)
            make.leading.equalToSuperview().offset(2)
            make.trailing.equalToSuperview().offset(-2)
        }
        
    }

}
