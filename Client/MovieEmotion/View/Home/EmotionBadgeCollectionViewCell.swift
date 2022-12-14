//
//  EmotionBadgeCollectionViewCell.swift
//  MovieEmotion
//
//  Created by Inwoo Park on 2022/11/08.
//

import UIKit

class EmotionBadgeCollectionViewCell: UICollectionViewCell {
    static let identifier: String = "EmotionBadgeCollectionViewCell"
    var emotionLabel:UILabel = {
        var label = UILabel()
        label.font = .systemFont(ofSize: 10, weight: .light)
        return label
    }()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        contentView.addSubview(emotionLabel)
        emotionLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emotionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            emotionLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            emotionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            emotionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(emotionLabel)
        emotionLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emotionLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            emotionLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
        layer.cornerRadius = 5
    }
    
    public func configure(by emotionInfo: EmotionInfo) {
        emotionLabel.text = emotionInfo.info()
        backgroundColor = UIColor(rgb: 0xD6E4E5)
    }
    
    func adjustCellSize(height: CGFloat, label: String) -> CGSize {
        let height = (label as! NSString).size(withAttributes: [NSAttributedString.Key.font : emotionLabel.font]).height
        let width = (label as! NSString).size(withAttributes: [NSAttributedString.Key.font : emotionLabel.font]).width
        return CGSize(width: width+10, height: height+5)
    }
}
