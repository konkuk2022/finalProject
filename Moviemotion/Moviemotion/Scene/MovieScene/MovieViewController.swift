//
//  MovieViewController.swift
//  Moviemotion
//
//  Created by Inwoo Park on 2022/05/12.
//

import UIKit

import RxSwift
import RxCocoa

class MovieViewController: UIViewController {
    
    private let commentLabel: UILabel = {
        var label = UILabel()
        label.text = "이 날의 감정에 어울리는 영화입니다."
        label.font = .systemFont(ofSize: 25, weight: .bold)
        return label
    }()
    
    private let dateLabel: UILabel = {
        var label = UILabel()
        label.text = "2022.06.04"
        label.font = .systemFont(ofSize: 20, weight: .medium)
        return label
    }()
    
    private let movieCollectionView: UICollectionView = {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .estimated(500))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .estimated(500))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                         subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 20
        let layout = UICollectionViewCompositionalLayout(section: section)
        var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: MovieCollectionViewCell.identifier)
        return collectionView
    }()
    
    private let viewModel = MovieViewModel()
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        bind()
    }
    
    private func setUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(commentLabel)
        commentLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            commentLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            commentLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            commentLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
        
        view.addSubview(dateLabel)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: commentLabel.bottomAnchor, constant: 10),
            dateLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            dateLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
        
        view.addSubview(movieCollectionView)
        movieCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            movieCollectionView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 20),
            movieCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            movieCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            movieCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
    
    private func bind() {
        viewModel.movieListSubject
            .bind(to: movieCollectionView.rx.items(cellIdentifier: MovieCollectionViewCell.identifier, cellType: MovieCollectionViewCell.self)) { (row, element, cell) in
                cell.configure(movie: element)
            }
            .disposed(by: disposeBag)
    }
    
    func configure(diary: Diary) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        let dateString = formatter.string(from: diary.date)
        dateLabel.text = dateString
        guard let highestEmotion = diary.emotionState.max(by: {$0.percentage < $1.percentage}) else {
            return
        }
        commentLabel.text = "이 날은 \(highestEmotion.kind.rawValue)의 날이었네요!"
    }
}
