//
//  photoCollectionViewCell.swift
//  File Manager
//
//  Created by Zakaria Darwish on 14/11/2023.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var photo: UIImageView!
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override var isSelected: Bool {
            didSet {
                // Update UI based on the selection state
                if isSelected {
                    // Selected state
                    self.contentView.backgroundColor = UIColor.primary
                } else {
                    // Deselected state
                    self.contentView.backgroundColor = UIColor.white
                }
            }
        }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
