//
//  AllFilmographyView.swift
//  Niro
//
//  Created by Mohamed Adel on 14/08/2023.
//

import UIKit
import SnapKit

class AllFilmographyView: UIView {

   
    let departmentsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: CGRect(), collectionViewLayout: layout)
        collectionView.backgroundColor = .systemGray5
        collectionView.collectionViewLayout = layout
        collectionView.layer.cornerRadius = 10
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    let filmographyTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = UIColor(named: "mainColor")
        return tableView
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor(named: "mainColor")
        
        addSubview(departmentsCollectionView)
        addSubview(filmographyTableView)
        
        setContraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setContraints() {
        
        departmentsCollectionView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(5)
            make.leading.equalToSuperview().offset(5)
            make.trailing.equalToSuperview().offset(-5)
            make.height.equalTo(40)
        }
        
        filmographyTableView.snp.makeConstraints { make in
            make.top.equalTo(departmentsCollectionView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
        }
          
    }
    
}
