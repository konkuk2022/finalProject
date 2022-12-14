//
//  PostViewController.swift
//  MovieEmotion
//
//  Created by Inwoo Park on 2022/11/09.
//

import UIKit

class PostViewController: UIViewController {
    
    public var delegate: MainViewController?
    
    private lazy var titleLabel: UILabel = {
        var label = UILabel()
        label.text = "새 기록 작성"
        label.font = .systemFont(ofSize: 15, weight: .medium)
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
    
    private let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "ko_KR")
        return datePicker
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 5
        view.layer.borderColor = UIColor.systemGray.cgColor
        view.layer.borderWidth = 0.5
        return view
    }()
    
    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.layer.cornerRadius = 5
        textView.backgroundColor = .systemGray6
        textView.textColor = .gray
        textView.textContainerInset = UIEdgeInsets(top: 16.0, left: 16.0, bottom: 16.0, right: 16.0)
        textView.text = "오늘 하루는 어떠셨나요?"
        textView.font = .systemFont(ofSize: 14)
        textView.textColor = .lightGray
        textView.delegate = self
        return textView
    }()
    
    private lazy var countLabel: UILabel = {
        let label = UILabel()
        label.text = "0/512"
        label.textColor = .systemGray
        label.font = .systemFont(ofSize: 11, weight: .light)
        return label
    }()
    
    private lazy var completeButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemGray3
        let myAttribute = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13, weight: .light),.foregroundColor : UIColor.white]
        let str = NSAttributedString(string: "작성완료", attributes: myAttribute)
        button.setAttributedTitle(str, for: .normal)
        button.layer.cornerRadius = 5
        button.addAction(UIAction { _ in
            let loadingVC = LoadingViewController()
            // Animate loadingVC over the existing views on screen
            loadingVC.modalPresentationStyle = .overCurrentContext
            // Animate loadingVC with a fade in animation
            loadingVC.modalTransitionStyle = .crossDissolve
            self.present(loadingVC, animated: true, completion: nil)
            
            guard let url = URL(string: "https://e70c-119-66-69-251.jp.ngrok.io/emotion") else { fatalError("Invalid URL") }
            let session = URLSession.shared

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            let body = ["content": self.textView.text]
            do {
                request.httpBody = try JSONEncoder().encode(body)
            } catch {
                print(error)
            }

            let task = session.dataTask(with: request) { (data, response, error) in
                DispatchQueue.main.async {
                    loadingVC.dismiss(animated: true)
                }
                guard let data = data else { fatalError("Empty Data") }
                do {
                    let decoder = JSONDecoder()
                    let emotionTotalData = try decoder.decode(EmotionTotalData.self, from: data)
                    DispatchQueue.main.async {
                        self.delegate?.insertNewDiary(emotionTotalData.toDiary(in: self.datePicker.date))
                        self.dismiss(animated: true)
                    }
                } catch {
                    print(error)
                }
            }
            task.resume()
        }, for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.didEmptySpacedTouched)))
    }
    
    private func setUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(titleLabel)
        view.addSubview(closeButton)
        view.addSubview(containerView)
        view.addSubview(countLabel)
        view.addSubview(completeButton)
        view.addSubview(datePicker)
        containerView.addSubview(textView)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        completeButton.translatesAutoresizingMaskIntoConstraints = false
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            closeButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            closeButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            datePicker.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            datePicker.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            containerView.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 20),
            containerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            containerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            containerView.heightAnchor.constraint(equalToConstant: 300),
            textView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            textView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20),
            textView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            textView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            countLabel.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 5),
            countLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30),
            completeButton.topAnchor.constraint(equalTo: countLabel.bottomAnchor, constant: 20),
            completeButton.heightAnchor.constraint(equalToConstant: 35),
            completeButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            completeButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
    }
    
    @objc private func didEmptySpacedTouched(){
        view.endEditing(true)
    }
    
}

extension PostViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        countLabel.text = "\(textView.text.count)/512"
        if textView.text.count > 512 {
            textView.text = String(textView.text.prefix(512))
            countLabel.text = "\(textView.text.count)/512"
        } else if textView.text.count > 0 {
            completeButton.backgroundColor = UIColor(rgb: 0x497174)
            completeButton.isEnabled = true
        } else {
            completeButton.backgroundColor = .systemGray3
            completeButton.isEnabled = false
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "오늘 하루는 어떠셨나요?" {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = "오늘 하루는 어떠셨나요?"
            textView.textColor = .lightGray
        }
    }
}
