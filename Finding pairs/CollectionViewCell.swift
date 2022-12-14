//
//  CollectionViewCell.swift
//  Finding pairs
//
//  Created by Constantin on 02.12.2022.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func config(img: UIImageView, backImg: UIImageView) {
        
        img.translatesAutoresizingMaskIntoConstraints = false
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        
        backImg.translatesAutoresizingMaskIntoConstraints = false
        backImg.contentMode = .scaleAspectFill
        backImg.clipsToBounds = true
        
        contentView.layer.cornerRadius = 12
        contentView.addSubview(backImg)
        contentView.addSubview(img)
        
        let size: CGFloat
        
        let orientation = UIApplication.shared.windows.first?.windowScene?.interfaceOrientation
        if orientation == .portrait || orientation == .portraitUpsideDown || UIDevice.current.orientation.isPortrait {
            size = (UIScreen.main.bounds.width - 8 * 5) / 4
//            size = ((UIApplication.shared.windows.first?.windowScene?.screen.bounds.width)! - 8 * 5) / 4
        } else {
            size = (UIScreen.main.bounds.height - 8 * 5) / 4
//            size = ((UIApplication.shared.windows.first?.windowScene?.screen.bounds.height)! - 8 * 5) / 4
        }
        
        NSLayoutConstraint.activate([
            img.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            img.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            img.topAnchor.constraint(equalTo: contentView.topAnchor),
            img.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            img.widthAnchor.constraint(equalToConstant: size),
            img.heightAnchor.constraint(equalToConstant: size),
            
            backImg.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            backImg.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            backImg.topAnchor.constraint(equalTo: contentView.topAnchor),
            backImg.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            backImg.widthAnchor.constraint(equalToConstant: size),
            backImg.heightAnchor.constraint(equalToConstant: size)
        ])
    }
}

