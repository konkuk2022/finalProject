//
//  SettingViewController.swift
//  MovieEmotion
//
//  Created by Inwoo Park on 2022/11/11.
//

import UIKit
import SafariServices

class SettingViewController: UIViewController {
    
    let logoLabel: UILabel = {
        let label = UILabel()
        label.text = "Emoving"
        label.font = .systemFont(ofSize: 30, weight: .heavy)
        label.textColor = UIColor(rgb: 0xEB6440)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var allDeleteButton: BasePaddingButtton = {
        let button = BasePaddingButtton()
        button.backgroundColor = UIColor(rgb: 0x497174)
        button.setTitle("전체 기록삭제", for: .normal)
        button.layer.cornerRadius = 10
        button.addAction(UIAction { _ in
            self.showDeleteAlert()
        }, for: .touchUpInside)
        return button
    }()
    
    private lazy var infoButton: BasePaddingButtton = {
        let button = BasePaddingButtton()
        button.backgroundColor = UIColor(rgb: 0x497174)
        button.setTitle("개발자 정보", for: .normal)
        button.layer.cornerRadius = 10
        button.addAction(UIAction { _ in
            guard let wikiURL = URL(string: "https://github.com/konkuk2022/finalProject") else { return }
            let developSafariView: SFSafariViewController = SFSafariViewController(url: wikiURL)
            self.present(developSafariView, animated: true, completion: nil)
        }, for: .touchUpInside)
        return button
    }()
    
    let infoLabel: UILabel = {
        let label = UILabel()
        label.text = "Emoving은 2022년 건국대학교 컴퓨터공학부 졸업프로젝트에서 만들어진 서비스로, 일기에서 추출된 감정을 기반으로 관련 영화를 추천해주는 서비스입니다."
        label.font = .systemFont(ofSize: 10, weight: .ultraLight)
        label.numberOfLines = 3
        label.textAlignment = .center
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    private func setUI() {
        view.backgroundColor = .systemBackground
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.addArrangedSubview(logoLabel)
        stackView.addArrangedSubview(allDeleteButton)
        stackView.addArrangedSubview(infoButton)
        stackView.addArrangedSubview(infoLabel)
        
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30)
        ])
    }
    
    private func showDeleteAlert() {
        let alert = UIAlertController(title: "전체 기록삭제", message: "정말 전체 기록을 삭제하시겠습니까? 삭제된 기록은 복구할 수 없습니다", preferredStyle: UIAlertController.Style.alert)
        let yes = UIAlertAction(title: "예", style: .default, handler: { _ in
            MainViewController.diaryList.removeAll()
            do {
                let data = try JSONEncoder().encode(MainViewController.diaryList)
                UserDefaults.standard.set(data, forKey: "list")
            } catch {
                print("error")
            }
            if let tabBar = self.tabBarController as? TabBarController {
                tabBar.resetSavedDiary()
            }
        })
        alert.addAction(yes)
        let no = UIAlertAction(title: "아니오", style: .default, handler: { _ in })
        alert.addAction(no)
        self.present(alert, animated: true, completion: nil)
    }
    
}
