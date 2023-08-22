//
//  MovieDetailsView.swift
//  Niro
//
//  Created by Mohamed Adel on 08/08/2023.
//

import UIKit
import SnapKit

class MovieDetailsView: UIView {

    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    let contentView = UIView()
    let topContentView = TopContentView()
    
    let directedByTextLabel: UILabel = {
        let label = UILabel()
        label.text = "Directed by"
        label.font = .systemFont(ofSize: 15)
        label.textColor = .gray
        return label
    }()
    
    let directorNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20)
        label.numberOfLines = 0
        return label
    }()
    
    let genreCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: CGRect(), collectionViewLayout: layout)
        collectionView.collectionViewLayout = layout
        collectionView.backgroundColor = UIColor(named: "mainColor")
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    let overviewLabel: PaddingLabel = {
        let label = PaddingLabel()
        label.numberOfLines = 0
        label.layer.cornerRadius = 10
        label.font = .systemFont(ofSize: 14)
        label.layer.masksToBounds = true
        label.backgroundColor = .systemGray4
        return label
    }()
    
    let activityView = ActivityView()
    let castView = CreditsView()

    let exploreMoreTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = UIColor(named: "mainColor")
        return tableView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor(named: "mainColor")
        
        castView.label.text = "Cast"
        
        contentView.addSubview(topContentView)
        contentView.addSubview(directedByTextLabel)
        contentView.addSubview(directorNameLabel)
        contentView.addSubview(genreCollectionView)
        contentView.addSubview(overviewLabel)
        contentView.addSubview(activityView)
        contentView.addSubview(castView)
        contentView.addSubview(exploreMoreTableView)
        
        scrollView.addSubview(contentView)
        addSubview(scrollView)
        
        directedByTextLabel.isHidden = true
        directorNameLabel.isHidden = true
        
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
        
        topContentView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(400)
        }
        
        directedByTextLabel.snp.makeConstraints { make in
            make.top.equalTo(topContentView.snp.bottom).offset(15)
            make.leading.equalTo(topContentView.snp.leading).offset(30)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        directorNameLabel.snp.makeConstraints { make in
            make.top.equalTo(directedByTextLabel.snp.bottom).offset(-2)
            make.leading.equalTo(directedByTextLabel.snp.leading)
            make.trailing.equalTo(directedByTextLabel.snp.trailing)
        }

        genreCollectionView.snp.makeConstraints { make in
            make.top.equalTo(directorNameLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(30)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(87)
        }
        
        overviewLabel.snp.makeConstraints { make in
            make.top.equalTo(genreCollectionView.snp.bottom).offset(15)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }

        activityView.snp.makeConstraints { make in
            make.top.equalTo(overviewLabel.snp.bottom).offset(30)
            make.height.equalTo(100)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        castView.snp.makeConstraints { make in
            make.top.equalTo(activityView.snp.bottom).offset(30)
            make.width.equalToSuperview()
            make.height.equalTo(225)
        }
        
        exploreMoreTableView.snp.makeConstraints { make in
            make.top.equalTo(castView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(160)
        }

    }

}
