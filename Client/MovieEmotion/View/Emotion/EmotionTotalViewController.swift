//
//  EmotionTotalViewController.swift
//  Moviemotion
//
//  Created by Inwoo Park on 2022/05/12.
//

import UIKit
import RxSwift
import RxCocoa

class EmotionTotalViewController: UIViewController {
    
    let colorList: [UIColor] = [UIColor(rgb: 0xF7A4A4), UIColor(rgb: 0xFEBE8C), UIColor(rgb: 0xFFFBC1), UIColor(rgb: 0xB6E2A1), UIColor(rgb: 0xB9E0FF)]
    
    private lazy var titleLabel: BasePaddingLabel = {
        var label = BasePaddingLabel()
        label.text = "회원님의 평균 감정정보입니다"
        label.font = .systemFont(ofSize: 15, weight: .light)
        label.backgroundColor = UIColor(rgb: 0x497174)
        label.layer.cornerRadius = 10
        label.layer.masksToBounds = true
        label.textColor = .white
        return label
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
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configure()
    }
    
    private func setUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(emotionCollectionView)
        emotionCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
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

    func configure() {
        var emotionDict: [Emotion:[Double]] = [:]
        for diary in MainViewController.diaryList {
            for emotionInfo in diary.emotionList {
                emotionDict[emotionInfo.emotion, default: [Double]()].append(emotionInfo.percentage)
            }
        }
        var emotionInfoList = [EmotionInfo]()
        for (key, value) in emotionDict {
            let percentage = value.reduce(0.0, +) / Double(value.count)
            emotionInfoList.append(EmotionInfo(emotion: key, percentage: percentage))
        }
        let sortedList = emotionInfoList.sorted { lhs, rhs in
            lhs.percentage > rhs.percentage
        }
        viewModel.setEmotionList(by: sortedList)
    }
}
