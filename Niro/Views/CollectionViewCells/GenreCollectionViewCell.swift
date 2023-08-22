//
//  GenreCollectionViewCell.swift
//  Niro
//
//  Created by Mohamed Adel on 08/08/2023.
//

import UIKit
import SnapKit

class GenreCollectionViewCell: UICollectionViewCell {
    
    let label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemGray4
        layer.cornerRadius = 7
        clipsToBounds = true
        
        addSubview(label)
        
        setConstraints()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setConstraints() {
        
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
    }
    
}
