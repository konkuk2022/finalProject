//
//  MovieCollectionViewCell.swift
//  MovieEmotion
//
//  Created by Inwoo Park on 2022/11/09.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
    
    static let identifier: String = "MovieCollectionViewCell"
    private var movie: MovieData?
    public var delegate: DetailViewController?
    
    private let imageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private var titleLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10, weight: .light)
        return label
    }()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    private func setUI() {
        contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 100),
            imageView.heightAnchor.constraint(equalToConstant: 150),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 3),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor)
        ])
    }
    
    public func configure(by movie: MovieData) {
        self.movie = movie
        titleLabel.text = movie.title
        DispatchQueue.global().async {
            guard let url = URL(string: movie.poster) else { return }
            let data = try? Data(contentsOf: url)
            DispatchQueue.main.async {
                self.imageView.image = UIImage(data: data!)
            }
        }
    }
    
}

