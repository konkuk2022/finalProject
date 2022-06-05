//
//  EmotionViewController.swift
//  Moviemotion
//
//  Created by Inwoo Park on 2022/05/12.
//

import UIKit
import RxSwift

class EmotionViewController: UIViewController {
    
    private let commentLabel: UILabel = {
        var label = UILabel()
        label.text = "오늘은 아주 기쁜 날이었네요!"
        label.font = .systemFont(ofSize: 25, weight: .bold)
        return label
    }()
    
    private let dateLabel: UILabel = {
        var label = UILabel()
        label.text = "2022.06.04"
        label.font = .systemFont(ofSize: 20, weight: .medium)
        return label
    }()
    
    private let emotionCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width - 40, height: 80)
        var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(EmotionCollectionViewCell.self, forCellWithReuseIdentifier: EmotionCollectionViewCell.identifier)
        return collectionView
    }()
    
    private let viewModel = EmotionViewModel()
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
        
        view.addSubview(emotionCollectionView)
        emotionCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emotionCollectionView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 10),
            emotionCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            emotionCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            emotionCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
    
    private func bind() {
        viewModel.emotionListSubject
            .bind(to: emotionCollectionView.rx.items(cellIdentifier: EmotionCollectionViewCell.identifier, cellType: EmotionCollectionViewCell.self)) { (row, element, cell) in
                var color = UIColor.black
                switch element.kind {
                case .happy:
                    color = .systemPink
                case .sad:
                    color = .systemBlue
                case .surprise:
                    color = .systemTeal
                case .angry:
                    color = .systemRed
                case .fear:
                    color = .systemCyan
                case .aversion:
                    color = .systemGreen
                case .neutral:
                    color = .systemGray
                }
                cell.configure(name: element.kind.rawValue, color: color, percentage: element.percentage)
            }
            .disposed(by: disposeBag)
    }

    func configure(diary: Diary) {
        viewModel.setEmotionList(by: diary.emotionState)
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
