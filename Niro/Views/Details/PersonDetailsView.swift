//
//  PersonDetailsView.swift
//  Niro
//
//  Created by Mohamed Adel on 13/08/2023.
//

import UIKit
import SnapKit

class PersonDetailsView: UIView {
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    let contentView = UIView()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .systemGray4
        return imageView
    }()
    
    let defaultImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .gray
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.numberOfLines = 0
        return label
    }()
    
    let bornTextLabel: UILabel = {
        let label = UILabel()
        label.text = "Born:"
        label.font = .systemFont(ofSize: 15)
        label.textColor = .gray
        return label
    }()
    
    let dateOfBirthLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.numberOfLines = 0
        return label
    }()
    
    let diedTextLabel: UILabel = {
        let label = UILabel()
        label.text = "Died:"
        label.font = .systemFont(ofSize: 15)
        label.textColor = .gray
        return label
    }()
    
    let dateOfDeathLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.numberOfLines = 0
        return label
    }()
    
    let filmographyView = CreditsView()
    
    let exploreMoreTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = UIColor(named: "mainColor")
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor(named: "mainColor")

        filmographyView.label.text = "Filmography"
        filmographyView.label.font = .systemFont(ofSize: 23)
        
        profileImageView.addSubview(defaultImageView)
        contentView.addSubview(profileImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(bornTextLabel)
        contentView.addSubview(dateOfBirthLabel)
        contentView.addSubview(diedTextLabel)
        contentView.addSubview(dateOfDeathLabel)
        contentView.addSubview(filmographyView)
        contentView.addSubview(exploreMoreTableView)
        
        scrollView.addSubview(contentView)
        addSubview(scrollView)
        
        bornTextLabel.isHidden = true
        dateOfBirthLabel.isHidden = true
        diedTextLabel.isHidden = true
        dateOfDeathLabel.isHidden = true
        defaultImageView.isHidden = true
        
        setConstraints()

    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setConstraints() {

        scrollView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
        }
        
        contentView.snp.makeConstraints { make in
            make.leading.trailing.top.width.equalToSuperview()
            make.bottom.equalTo(exploreMoreTableView.snp.bottom)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview().offset(30)
            make.height.equalTo(180)
            make.width.equalTo(125)
        }
        
        defaultImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(70)
        }

        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileImageView.snp.trailing).offset(20)
            make.top.equalTo(profileImageView.snp.top).offset(40)
            make.trailing.equalToSuperview().offset(-10)
        }
        
        bornTextLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(40)
            make.leading.equalTo(nameLabel.snp.leading)
        }
        
        dateOfBirthLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(40)
            make.leading.equalTo(bornTextLabel.snp.trailing).offset(3)
        }
        
        diedTextLabel.snp.makeConstraints { make in
            make.top.equalTo(bornTextLabel.snp.bottom).offset(10)
            make.leading.equalTo(nameLabel.snp.leading)
        }
        
        dateOfDeathLabel.snp.makeConstraints { make in
            make.top.equalTo(bornTextLabel.snp.bottom).offset(10)
            make.leading.equalTo(diedTextLabel.snp.trailing).offset(3)
        }
        
        filmographyView.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(35)
            make.width.equalToSuperview()
            make.height.equalTo(225)
        }
        
        exploreMoreTableView.snp.makeConstraints { make in
            make.top.equalTo(filmographyView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(160)
        }
        
    }

}
