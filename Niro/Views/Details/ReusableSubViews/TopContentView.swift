//
//  TopContentView.swift
//  Niro
//
//  Created by Mohamed Adel on 15/08/2023.
//

import UIKit
import SnapKit

class TopContentView: UIView {

    let backdropImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    let gradientView = UIView()
    
    let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .systemGray4
        return imageView
    }()
    
    let defaultImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .gray
        return imageView
    }()

    let infoAboveTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.textColor = .gray
        return label
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.numberOfLines = 0
        return label
    }()
    

    let releaseDateTextLabel: UILabel = {
        let label = UILabel()
        label.text = "Release Date:"
        label.font = .systemFont(ofSize: 12)
        label.textColor = .gray
        label.isHidden = true
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17)
        label.numberOfLines = 0
        label.isHidden = true
        return label
    }()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(backdropImageView)
        addSubview(gradientView)

        posterImageView.addSubview(defaultImageView)
        addSubview(posterImageView)
        
        addSubview(infoAboveTitleLabel)
        addSubview(titleLabel)
        addSubview(releaseDateTextLabel)
        addSubview(dateLabel)
        
        releaseDateTextLabel.isHidden = true
        dateLabel.isHidden = true
        defaultImageView.isHidden = true
        
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setConstraints() {
        
        backdropImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(280)
        }
        
        gradientView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(backdropImageView.snp.bottom)
            make.height.equalTo(170)
        }
        
        posterImageView.snp.makeConstraints { make in
            make.top.equalTo(backdropImageView.snp.bottom).offset(-80)
            make.leading.equalToSuperview().offset(30)
            make.height.equalTo(200)
            make.width.equalTo(140)
        }
        
        defaultImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(70)
        }

        infoAboveTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(backdropImageView.snp.bottom).offset(-10)
            make.leading.equalTo(posterImageView.snp.trailing).offset(20)
            make.trailing.equalToSuperview().offset(-10)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(posterImageView.snp.trailing).offset(20)
            make.top.equalTo(backdropImageView.snp.bottom).offset(20)
            make.trailing.equalToSuperview().offset(-10)
        }
        
        releaseDateTextLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.leading)
            make.trailing.equalTo(titleLabel.snp.trailing)
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.leading)
            make.trailing.equalTo(titleLabel.snp.trailing)
            make.top.equalTo(releaseDateTextLabel.snp.bottom)
        }
        
        
    }
    
    
}
