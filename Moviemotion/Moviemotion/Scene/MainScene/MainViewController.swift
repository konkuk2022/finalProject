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
    
    private lazy var dairyTextView: UITextView = {
        var textView = UITextView()
        textView.layer.borderWidth = 0.5
        textView.layer.cornerRadius = 5
        textView.font = .systemFont(ofSize: 17)
        textView.text = "모임에 대한 메모를 적어주세요."
        textView.textColor = .systemGray
        textView.delegate = self
        return textView
    }()
    
    private lazy var completeButton: UIButton = {
        var completeButton = UIButton(type: .system)
        completeButton.setTitle("   완료   ", for: .normal)
        completeButton.backgroundColor = .systemBlue
        completeButton.tintColor = .white
        completeButton.layer.cornerRadius = 5
        completeButton.addAction(UIAction { _ in
            let new = Diary(emotion: [
                Emotion(kind: .happy, percentage: 0.6),
                Emotion(kind: .aversion, percentage: 0.1),
                Emotion(kind: .fear, percentage: 0.05),
                Emotion(kind: .angry, percentage: 0.05),
                Emotion(kind: .surprise, percentage: 0.1),
                Emotion(kind: .sad, percentage: 0.05),
                Emotion(kind: .neutral, percentage: 0.1)
            ], date: Date(), content: self.dairyTextView.text)
            self.dairyTextView.text = ""
            self.viewModel.addNewDiray(new)
        }, for: .touchUpInside)
        return completeButton
    }()
    
    private lazy var diaryCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width-10, height: 80)
        var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(DiaryCollectionViewCell.self, forCellWithReuseIdentifier: DiaryCollectionViewCell.identifier)
        collectionView.delegate = self
        return collectionView
    }()
    
    private lazy var diaryDataSource = UICollectionViewDiffableDataSource<Int, Diary>(collectionView: diaryCollectionView) { (collectionView: UICollectionView, indexPath: IndexPath, itemIdentifier: Diary) -> UICollectionViewCell? in
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DiaryCollectionViewCell.identifier, for: indexPath) as? DiaryCollectionViewCell else { preconditionFailure() }
        cell.configure(date: itemIdentifier.date, content: itemIdentifier.content)
        return cell
    }
    
    private let viewModel = MainViewModel()
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        bind()
    }
    
    private func setUI() {
        view.backgroundColor = .systemBackground
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
            diaryCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            diaryCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            diaryCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func bind() {
        viewModel.diaryListSubject
            .subscribe(onNext: { [weak self] diaryList in
                var snapshot = NSDiffableDataSourceSnapshot<Int, Diary>()
                snapshot.appendSections([Int.zero])
                snapshot.appendItems(diaryList)
                self?.diaryDataSource.apply(snapshot, animatingDifferences: true)
            })
            .disposed(by: disposeBag)
    }

}

extension MainViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .systemGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "모임에 대한 메모를 적어주세요."
            textView.textColor = .systemGray
        }
    }
    
}

extension MainViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let dailyViewController = DailyViewController()
        let diary = viewModel.diaryListSubject.value[indexPath.item]
        dailyViewController.configure(diary: diary)
        self.navigationController?.pushViewController(dailyViewController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil, actionProvider: { _ in
            let delete = UIAction(title: "삭제", image: UIImage(systemName: "trash")) { _ in
                self.viewModel.removeDiary(at: indexPath.item)
            }
            return UIMenu(title: "이 일기를", children: [delete])
        })
    }
    
}
