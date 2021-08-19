//
//  SearchedImageCell.swift
//  TestApp
//
//  Created by Михаил Красильник on 16.08.2021.
//

import UIKit

class SearchedImageCell: UICollectionViewCell {
    
    static let reuseID = "SearchedImageCell"
    
    var imageVeiw = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupConstraints()
        configureImageView()
        
        self.backgroundColor = .gray
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureImageView() {
        imageVeiw.contentMode = .scaleAspectFill
        imageVeiw.layer.cornerRadius = 5
        imageVeiw.clipsToBounds = true
    }
    
    func setupConstraints() {
        
        imageVeiw.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(imageVeiw)
        
        NSLayoutConstraint.activate([
            imageVeiw.topAnchor.constraint(equalTo: self.topAnchor),
            imageVeiw.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imageVeiw.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            imageVeiw.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}
