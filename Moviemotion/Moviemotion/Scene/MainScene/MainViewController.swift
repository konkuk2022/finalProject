//
//  MainViewController.swift
//  Moviemotion
//
//  Created by Inwoo Park on 2022/05/12.
//

import UIKit

class MainViewController: UIViewController {
    private let dairyTextView: UITextView = {
        var textView = UITextView()
        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = 5
        return textView
    }()
    
    private let completeButton: UIButton = {
        var completeButton = UIButton(type: .system)
        completeButton.setTitle(" 완료 ", for: .normal)
        completeButton.tintColor = .black
        completeButton.layer.borderColor = UIColor.black.cgColor
        completeButton.layer.borderWidth = 1
        completeButton.layer.cornerRadius = 5
        return completeButton
    }()
    
    private let diaryTableView: UITableView = {
        var tableView = UITableView()
        tableView.register(DiaryTableViewCell.self, forCellReuseIdentifier: DiaryTableViewCell.identifier)
        tableView.backgroundColor = .systemBlue
        return tableView
    }()
    
    private let viewModel = MainViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    private func setUI() {
        view.backgroundColor = .white
        view.addSubview(dairyTextView)
        dairyTextView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dairyTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            dairyTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            dairyTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
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
            diaryTableView.leadingAnchor.constraint(equalTo: dairyTextView.leadingAnchor, constant: 10),
            diaryTableView.trailingAnchor.constraint(equalTo: dairyTextView.trailingAnchor, constant: -10),
            diaryTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

}
