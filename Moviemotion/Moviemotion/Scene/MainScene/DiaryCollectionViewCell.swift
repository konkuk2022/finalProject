//
//  DiaryCollectionViewCell.swift
//  Moviemotion
//
//  Created by Inwoo Park on 2022/06/04.
//

import UIKit

class DiaryCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "DiaryCollectionViewCell"
    
    private let dateLabel: UILabel = {
        var label = UILabel()
        label.text = "0000.00.00"
        label.font = .systemFont(ofSize: 15, weight: .bold)
        return label
    }()
    
    private let contentLabel: UILabel = {
        var label = UILabel()
        label.text = "내용이 들어감"
        label.font = .systemFont(ofSize: 15)
        return label
    }()
    
    private let lineView: UIView = {
        var view = UIView()
        view.backgroundColor = .systemGray
        return view
    }()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    private func setUI() {
        contentView.addSubview(dateLabel)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10)
        ])
        
        contentView.addSubview(contentLabel)
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 10),
            contentLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            contentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ])
        
        contentView.addSubview(lineView)
        lineView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            lineView.topAnchor.constraint(equalTo: contentLabel.bottomAnchor, constant: 15),
            lineView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            lineView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            lineView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            lineView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
    func configure(date: Date, content: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        dateLabel.text = formatter.string(from: date)
        contentLabel.text = content
    }
}
