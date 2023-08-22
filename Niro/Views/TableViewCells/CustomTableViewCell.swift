//
//  CustomTableViewCell.swift
//  Niro
//
//  Created by Mohamed Adel on 11/08/2023.
//

import UIKit
import SnapKit

class CustomTableViewCell: UITableViewCell {
    
    
    let customImageView: UIImageView = {
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
        return label
    }()
    
    let subTextLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 13)
        label.textColor = .gray
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor(named: "cellMainColor")
        
        customImageView.addSubview(defaultImageView)
        addSubview(customImageView)
 
        addSubview(mainTextLabel)
        addSubview(subTextLabel)
        
        defaultImageView.isHidden = true
        
        setContraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setContraints() {
        
        customImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.top.equalToSuperview().offset(5)
            make.bottom.equalToSuperview().offset(-5)
            make.width.equalTo(80)
        }
        
        defaultImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(50)
        }
        
        mainTextLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalTo(customImageView.snp.trailing).offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        subTextLabel.snp.makeConstraints { make in
            make.top.equalTo(mainTextLabel.snp.bottom).offset(5)
            make.leading.equalTo(mainTextLabel.snp.leading)
            make.trailing.equalTo(mainTextLabel.snp.trailing) 
        }
        
    }
    
}
