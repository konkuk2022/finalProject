//
//  MainViewController.swift
//  Moviemotion
//
//  Created by Inwoo Park on 2022/05/12.
//

import UIKit

import RxSwift
import RxCocoa

class MainViewController: UIViewController {
    private let dairyTextView: UITextView = {
        var textView = UITextView()
        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = 5
        textView.font = .systemFont(ofSize: 20)
        return textView
    }()
    
    private lazy var completeButton: UIButton = {
        var completeButton = UIButton(type: .system)
        completeButton.setTitle("   완료   ", for: .normal)
        completeButton.tintColor = .black
        completeButton.layer.borderColor = UIColor.black.cgColor
        completeButton.layer.borderWidth = 1
        completeButton.layer.cornerRadius = 5
        completeButton.addAction(UIAction { _ in
            let new = Diary(date: Date(), content: self.dairyTextView.text)
            self.dairyTextView.text = ""
            self.viewModel.addNewDiray(new)
        }, for: .touchUpInside)
        return completeButton
    }()
    
    private let diaryCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width - 40, height: 80)
        var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(DiaryCollectionViewCell.self, forCellWithReuseIdentifier: DiaryCollectionViewCell.identifier)
        return collectionView
    }()
    
    private let viewModel = MainViewModel()
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        bind()
    }
    
    private func setUI() {
        view.backgroundColor = .white
        view.addSubview(dairyTextView)
        dairyTextView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dairyTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            dairyTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            dairyTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            dairyTextView.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        view.addSubview(completeButton)
        completeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            completeButton.topAnchor.constraint(equalTo: dairyTextView.bottomAnchor, constant: 10),
            completeButton.trailingAnchor.constraint(equalTo: dairyTextView.trailingAnchor, constant:  -10)
        ])
        
        view.addSubview(diaryCollectionView)
        diaryCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            diaryCollectionView.topAnchor.constraint(equalTo: completeButton.bottomAnchor, constant: 10),
            diaryCollectionView.leadingAnchor.constraint(equalTo: dairyTextView.leadingAnchor),
            diaryCollectionView.trailingAnchor.constraint(equalTo: dairyTextView.trailingAnchor),
            diaryCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func bind() {
        viewModel.diaryListSubject
            .bind(to: diaryCollectionView.rx.items(cellIdentifier: DiaryCollectionViewCell.identifier, cellType: DiaryCollectionViewCell.self)) { (row, element, cell) in
                cell.configure(date: element.date, content: element.content)
            }
            .disposed(by: disposeBag)
    }

}
