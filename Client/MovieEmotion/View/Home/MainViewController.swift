//
//  MainViewController.swift
//  MovieEmotion
//
//  Created by Inwoo Park on 2022/11/07.
//

import UIKit
import CoreData

class MainViewController: UIViewController {
    
    static public var diaryList: [Diary] = []
    var isSearching: Bool = false
    
    private lazy var logoLabel: UILabel = {
        var label = UILabel()
        label.text = "Emoving"
        label.font = .systemFont(ofSize: 23, weight: .bold)
        label.textColor = UIColor(rgb: 0xEB6440)
        return label
    }()
    
    private lazy var addButton: UIButton = {
        var button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "text.badge.plus"), for: .normal)
        button.layer.cornerRadius = 5
        button.backgroundColor = UIColor(rgb: 0x497174)
        button.tintColor = .white
        button.addAction(UIAction { _ in
            let postVC = PostViewController()
            postVC.delegate = self
            self.present(postVC, animated: true)
        }, for: .touchUpInside)
        return button
    }()
    
    private lazy var searchBar: UISearchBar = {
        var searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.placeholder = "날짜, 내용, 영화 검색"
        searchBar.searchTextField.font = .systemFont(ofSize: 13, weight: .light)
        return searchBar
    }()
    
    private lazy var diaryTableView: UITableView = {
        var tableView = UITableView()
        tableView.delegate = self
        tableView.backgroundColor = .clear
        tableView.layer.borderColor = UIColor.systemGray5.cgColor
        tableView.layer.borderWidth = 0.5
        tableView.showsVerticalScrollIndicator = false
        tableView.register(DiaryTableViewCell.self, forCellReuseIdentifier: DiaryTableViewCell.indentifier)
        return tableView
    }()
    
    private lazy var diaryDataSource = UITableViewDiffableDataSource<Int, Diary>(tableView: self.diaryTableView) { (tableView: UITableView, indexPath: IndexPath, itemIdentifier: Diary) -> UITableViewCell? in
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DiaryTableViewCell.indentifier, for: indexPath) as? DiaryTableViewCell else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        cell.configure(by: itemIdentifier)
        return cell
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    private func setUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(logoLabel)
        view.addSubview(addButton)
        view.addSubview(searchBar)
        view.addSubview(diaryTableView)
        logoLabel.translatesAutoresizingMaskIntoConstraints = false
        addButton.translatesAutoresizingMaskIntoConstraints = false
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        diaryTableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            logoLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            logoLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            addButton.centerYAnchor.constraint(equalTo: logoLabel.centerYAnchor),
            addButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30),
            searchBar.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            searchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            searchBar.topAnchor.constraint(equalTo: addButton.bottomAnchor, constant: 20),
            diaryTableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 10),
            diaryTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            diaryTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            diaryTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
    
    public func updateSnapshot() {
        if isSearching {
            let searchedList = MainViewController.diaryList.filter { diary in
                diary.dateString.contains(searchBar.text ?? "") ||
                diary.content.contains(searchBar.text ?? "") ||
                diary.mainMovie.title.contains(searchBar.text ?? "")
            }
            var snapShot = NSDiffableDataSourceSnapshot<Int, Diary>()
            snapShot.appendSections([Int.zero])
            snapShot.appendItems(searchedList)
            diaryDataSource.apply(snapShot, animatingDifferences: true)
        } else {
            var snapShot = NSDiffableDataSourceSnapshot<Int, Diary>()
            snapShot.appendSections([Int.zero])
            snapShot.appendItems(MainViewController.diaryList)
            diaryDataSource.apply(snapShot, animatingDifferences: true)
        }
    }
    
    public func insertNewDiary(_ diary: Diary) {
        MainViewController.diaryList.insert(diary, at: 0)
        do {
            let data = try JSONEncoder().encode(MainViewController.diaryList)
            UserDefaults.standard.set(data, forKey: "list")
        } catch {
            print("error")
        }
        DispatchQueue.main.async { [weak self] in
            self?.updateSnapshot()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
         self.view.endEditing(true)
   }

}

extension MainViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        isSearching = !searchText.isEmpty
        updateSnapshot()
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detail = DetailViewController()
        detail.configure(by: MainViewController.diaryList[indexPath.row])
        self.navigationController?.pushViewController(detail, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "삭제") { _, _, completion in
            MainViewController.diaryList.remove(at: indexPath.row)
            do {
                let data = try JSONEncoder().encode(MainViewController.diaryList)
                UserDefaults.standard.set(data, forKey: "list")
            } catch {
                print("error")
            }
            self.updateSnapshot()
        }
        deleteAction.backgroundColor = .systemRed
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
