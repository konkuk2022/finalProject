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
        label.font = .systemFont(ofSize: 15, weight: .medium)
        return label
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
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.cornerRadius = 5
        
        contentView.addSubview(dateLabel)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10)
        ])
        
        contentView.addSubview(contentLabel)
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 10),
            contentLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            contentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            contentLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
        ])
    }
    
    func configure(date: Date, content: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        dateLabel.text = formatter.string(from: date)
        contentLabel.text = content
    }
}
