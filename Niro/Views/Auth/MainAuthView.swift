//
//  MainAuthView.swift
//  Niro
//
//  Created by Mohamed Adel on 04/08/2023.
//

import UIKit
import SnapKit

class MainAuthView: UIView {

    let imageView = UIImageView()
    let gradientView = UIView()
    
    let niroLabel: UILabel = {
       let label = UILabel()
        label.text = "Niro"
        label.font = UIFont(name: "Gagalin-Regular", size: 80)
        label.textColor = UIColor(named: "logoColor")
        label.numberOfLines = 0
        return label
    }()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = UIColor(named: "mainColor")
        return tableView
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor(named: "mainColor")
        overrideUserInterfaceStyle = .dark

        addSubview(imageView)
        addSubview(gradientView)
        addSubview(tableView)
        addSubview(niroLabel)

        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setConstraints() {
        
        imageView.snp.makeConstraints { make in
            make.top.trailing.leading.equalToSuperview()
            make.height.equalTo(snp.height).multipliedBy(0.6)
        }
        
        gradientView.snp.makeConstraints { make in
            make.bottom.equalTo(imageView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(snp.height).multipliedBy(0.3)
        }
        
        niroLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom)
            make.centerX.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(niroLabel.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(100)
        }
        
    }

}
