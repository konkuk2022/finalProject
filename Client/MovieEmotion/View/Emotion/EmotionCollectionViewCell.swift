//
//  EmotionCollectionViewCell.swift
//  Moviemotion
//
//  Created by Inwoo Park on 2022/06/05.
//

import UIKit

class EmotionCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "EmotionCollectionViewCell"
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "감정"
        return label
    }()
    
    private let percentageView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBlue
        return view
    }()
    
    private let percentageLabel: UILabel = {
        let label = UILabel()
        label.text = "0점"
        label.textColor = .systemGray
        label.font = .systemFont(ofSize: 13)
        return label
    }()
    
    lazy var percentageWidthConstraint = {
        return percentageView.widthAnchor.constraint(equalToConstant: 0)
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
        contentView.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
        ])
        
        contentView.addSubview(percentageView)
        percentageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            percentageView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            percentageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            percentageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            percentageWidthConstraint
        ])
        
        contentView.addSubview(percentageLabel)
        percentageLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            percentageLabel.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 10),
            percentageLabel.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor)
        ])
    }
    
    func configure(name: String, color: UIColor, percentage: Double) {
        nameLabel.text = name
        percentageLabel.text = "\(Int(percentage*100)) 점"
        percentageView.backgroundColor = color
        barAnimate(now: 0.0, goal: percentage)
    }
    
    func barAnimate(now: Double, goal: Double) {
        UIView.animate(withDuration: 0.01, animations: {
            self.percentageWidthConstraint.constant = self.contentView.frame.width * CGFloat(now)
            self.layoutIfNeeded()
        }) { _ in
            if now < goal {
                self.barAnimate(now: now+goal/25, goal: goal)
            }
        }
    }
}
