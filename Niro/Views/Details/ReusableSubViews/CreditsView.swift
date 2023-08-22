//
//  CreditsView.swift
//  Niro
//
//  Created by Mohamed Adel on 15/08/2023.
//

import UIKit
import SnapKit

class CreditsView: UIView {

    let label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 28)
        return label
    }()
    
    let seeAllButton: UIButton = {
        let button = UIButton()
        button.setTitle("See All", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18)
        button.setTitleColor( .systemBlue, for: .normal)
        return button
    }()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: CGRect(), collectionViewLayout: layout)
        collectionView.backgroundColor = .systemGray5
        collectionView.collectionViewLayout = layout
        collectionView.layer.cornerRadius = 10
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
        
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemGray5
        
        addSubview(label)
        addSubview(seeAllButton)
        addSubview(collectionView)
        
        setContraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setContraints() {
        
        label.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview().offset(15)
        }
        
        seeAllButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom).offset(5)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        
    }

}
