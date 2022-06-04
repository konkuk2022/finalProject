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
        return textView
    }()
    
    private lazy var completeButton: UIButton = {
        var completeButton = UIButton(type: .system)
        completeButton.setTitle(" 완료 ", for: .normal)
        completeButton.tintColor = .black
        completeButton.layer.borderColor = UIColor.black.cgColor
        completeButton.layer.borderWidth = 1
        completeButton.layer.cornerRadius = 5
        completeButton.addAction(UIAction { _ in
            let new = Diary(date: Date(), content: self.dairyTextView.text)
            self.dairyTextView.text = ""
            var now = self.diaryListSubject.value
            now.append(new)
            self.diaryListSubject.accept(now)
        }, for: .touchUpInside)
        return completeButton
    }()
    
    private let diaryTableView: UITableView = {
        var tableView = UITableView()
        tableView.register(DiaryTableViewCell.self, forCellReuseIdentifier: DiaryTableViewCell.identifier)
        return tableView
    }()
    
    private let diaryListSubject = BehaviorRelay(value: [Diary]())
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
            dairyTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            dairyTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            dairyTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            dairyTextView.heightAnchor.constraint(equalToConstant: 150)
        ])
        
        view.addSubview(completeButton)
        completeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            completeButton.topAnchor.constraint(equalTo: dairyTextView.bottomAnchor, constant: 10),
            completeButton.trailingAnchor.constraint(equalTo: dairyTextView.trailingAnchor)
        ])
        
        view.addSubview(diaryTableView)
        diaryTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            diaryTableView.topAnchor.constraint(equalTo: completeButton.bottomAnchor, constant: 10),
            diaryTableView.leadingAnchor.constraint(equalTo: dairyTextView.leadingAnchor),
            diaryTableView.trailingAnchor.constraint(equalTo: dairyTextView.trailingAnchor),
            diaryTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func bind() {
        diaryListSubject
            .bind(to: diaryTableView.rx.items(cellIdentifier: DiaryTableViewCell.identifier, cellType: DiaryTableViewCell.self)) { (row, element, cell) in
                cell.configure(date: element.date, content: element.content)
            }
            .disposed(by: disposeBag)
    }

}
