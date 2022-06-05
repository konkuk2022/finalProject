//
//  MovieCollectionViewCell.swift
//  Moviemotion
//
//  Created by Inwoo Park on 2022/06/05.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "MovieCollectionViewCell"
    
    private let movieImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "her")
        return imageView
    }()
    
    private let movieStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        let font = UIFont.systemFont(ofSize: 10, weight: .light)
        let fullText = "Her 2022"
        let range = (fullText as NSString).range(of: "2022")
        let attributedString = NSMutableAttributedString(string: fullText)
        attributedString.addAttribute(.font, value: font, range: range)
        label.font = .systemFont(ofSize: 25, weight: .bold)
        label.attributedText = attributedString
        label.numberOfLines = 0
        return label
    }()
    
    private let genreLabel: UILabel = {
        let label = UILabel()
        label.text = "장르"
        label.font = .systemFont(ofSize: 15, weight: .medium)
        return label
    }()
    
    private let summaryLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 5
        label.textAlignment = .natural
        label.text = "이것은 줄거리이다."
        label.font = .systemFont(ofSize: 14, weight: .light)
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
        contentView.addSubview(movieImageView)
        movieImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            movieImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            movieImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            movieImageView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width*0.4),
            movieImageView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width*0.4*16/10),
            movieImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        movieStackView.addArrangedSubview(titleLabel)
        movieStackView.addArrangedSubview(genreLabel)
        movieStackView.addArrangedSubview(summaryLabel)
        contentView.addSubview(movieStackView)
        movieStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            movieStackView.leadingAnchor.constraint(equalTo: movieImageView.trailingAnchor, constant: 20),
            movieStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            movieStackView.centerYAnchor.constraint(equalTo: movieImageView.centerYAnchor)
        ])
    }
    
    func configure(movie: Movie) {
        movieImageView.image = UIImage(named: movie.imageUrl)
        
        let font = UIFont.systemFont(ofSize: 10, weight: .light)
        let fullText = "\(movie.title)  \(movie.year)"
        let range = (fullText as NSString).range(of: " \(movie.year)")
        let attributedString = NSMutableAttributedString(string: fullText)
        attributedString.addAttribute(.font, value: font, range: range)
        titleLabel.font = .systemFont(ofSize: 25, weight: .bold)
        titleLabel.attributedText = attributedString
        
        genreLabel.text = movie.genre.joined(separator: " / ")
        summaryLabel.text = movie.summary
    }
    
}
