//
//  EmotionViewController.swift
//  Moviemotion
//
//  Created by Inwoo Park on 2022/05/12.
//

import UIKit
import RxSwift
import RxCocoa

class EmotionViewController: UIViewController {
    
    let colorList: [UIColor] = [UIColor(rgb: 0xF7A4A4), UIColor(rgb: 0xFEBE8C), UIColor(rgb: 0xFFFBC1), UIColor(rgb: 0xB6E2A1), UIColor(rgb: 0xB9E0FF)]
    
    private lazy var titleLabel: UILabel = {
        var label = UILabel()
        label.text = "이 날의 감정 세부정보"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    private lazy var closeButton: UIButton = {
        var button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .black
        button.addAction(UIAction { _ in
            self.dismiss(animated: true)
        }, for: .touchUpInside)
        return button
    }()
    
    private let emotionCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width - 40, height: 50)
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
        
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(closeButton)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(emotionCollectionView)
        emotionCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            closeButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            closeButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            emotionCollectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            emotionCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            emotionCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            emotionCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
    
    private func bind() {
        viewModel.emotionListSubject
            .bind(to: emotionCollectionView.rx.items(cellIdentifier: EmotionCollectionViewCell.identifier, cellType: EmotionCollectionViewCell.self)) { (row, element, cell) in
                let color = self.colorList[row % 5]
                cell.configure(name: element.emotion.rawValue, color: color, percentage: element.percentage)
            }
            .disposed(by: disposeBag)
    }

    func configure(diary: Diary) {
        viewModel.setEmotionList(by: diary.emotionList.sorted(by: { lhs, rhs in
            lhs.percentage > rhs.percentage
        }))
    }
}
