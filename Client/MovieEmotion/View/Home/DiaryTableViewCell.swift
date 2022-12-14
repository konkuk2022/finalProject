//
//  DiaryTableViewCell.swift
//  MovieEmotion
//
//  Created by Inwoo Park on 2022/11/07.
//

import UIKit

class DiaryTableViewCell: UITableViewCell {
    static let indentifier: String = "DiaryTableViewCell"
    
    var emotionInfos: [EmotionInfo] = []
    
    private lazy var dateLabel: UILabel = {
        var label = UILabel()
        label.text = "0000년 0월 0일"
        label.font = .systemFont(ofSize: 12, weight: .ultraLight)
        return label
    }()
    
    private lazy var contentDataLabel: UILabel = {
        var label = UILabel()
        label.text = "일기내용"
        label.font = .systemFont(ofSize: 14, weight: .light)
        label.numberOfLines = 3
        label.lineBreakMode = .byCharWrapping
        return label
    }()
    
    private lazy var emotionLabelCollectionView: UICollectionView = {
        var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(EmotionBadgeCollectionViewCell.self, forCellWithReuseIdentifier: EmotionBadgeCollectionViewCell.identifier)
        let layout = LeftAlignedCollectionViewFlowLayout()
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        collectionView.collectionViewLayout = layout
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    private lazy var posterImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.backgroundColor = .black
        return imageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setUI() {
        contentView.addSubview(dateLabel)
        contentView.addSubview(contentDataLabel)
        contentView.addSubview(emotionLabelCollectionView)
        contentView.addSubview(posterImageView)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        contentDataLabel.translatesAutoresizingMaskIntoConstraints = false
        emotionLabelCollectionView.translatesAutoresizingMaskIntoConstraints = false
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            contentDataLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 10),
            contentDataLabel.centerYAnchor.constraint(equalTo: posterImageView.centerYAnchor),
            contentDataLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            contentDataLabel.trailingAnchor.constraint(equalTo: posterImageView.leadingAnchor, constant: -20),
            emotionLabelCollectionView.topAnchor.constraint(equalTo: contentDataLabel.bottomAnchor, constant: 10),
            emotionLabelCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            emotionLabelCollectionView.trailingAnchor.constraint(lessThanOrEqualTo: posterImageView.leadingAnchor, constant: -20),
            emotionLabelCollectionView.heightAnchor.constraint(equalToConstant: 20),
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            posterImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            posterImageView.widthAnchor.constraint(equalToConstant: 100),
            posterImageView.heightAnchor.constraint(equalToConstant: 150),
            posterImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    
    public func configure(by diary: Diary) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일"
        dateLabel.text = formatter.string(from: diary.date)
        contentDataLabel.text = diary.content
        var count = 0
        for emotionInfo in diary.emotionList.sorted(by: { lhs, rhs in
            lhs.percentage > rhs.percentage
        }) {
            emotionInfos.append(emotionInfo)
            count += 1
            if count == 3 {
                break
            }
        }
        DispatchQueue.global().async {
            guard let url = URL(string: diary.movieList.first?.poster ?? "") else {
                return
            }
            let data = try? Data(contentsOf: url)
            DispatchQueue.main.async {
                guard let data = data else { return }
                self.posterImageView.image = UIImage(data: data)
            }
        }
        emotionLabelCollectionView.reloadData()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        emotionInfos.removeAll()
    }
}

extension DiaryTableViewCell: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return emotionInfos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmotionBadgeCollectionViewCell.identifier, for: indexPath) as? EmotionBadgeCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(by: emotionInfos[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmotionBadgeCollectionViewCell.identifier, for: indexPath) as? EmotionBadgeCollectionViewCell else {
            return .zero
        }
        return cell.adjustCellSize(height: 10, label: emotionInfos[indexPath.item].info())
    }
}

class LeftAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)

        var leftMargin = sectionInset.left
        var maxY: CGFloat = -1.0
        attributes?.forEach { layoutAttribute in
            if layoutAttribute.frame.origin.y >= maxY {
                leftMargin = sectionInset.left
            }

            layoutAttribute.frame.origin.x = leftMargin

            leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing
            maxY = max(layoutAttribute.frame.maxY , maxY)
        }

        return attributes
    }
}
