//
//  MovieDetailViewController.swift
//  MovieEmotion
//
//  Created by Inwoo Park on 2022/11/09.
//

import UIKit

class MovieDetailViewController: UIViewController {
    
    private var emotionInfos = [EmotionInfo]()
    
    private lazy var titleLabel: UILabel = {
        var label = UILabel()
        label.text = "영화 세부정보"
        label.font = .systemFont(ofSize: 16, weight: .medium)
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
    
    private var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .black
        return imageView
    }()
    
    private var simLabel: BasePaddingLabel = {
        let label = BasePaddingLabel()
        label.text = "유사도 어쩌구저쩌구"
        label.backgroundColor = UIColor(rgb: 0x497174).withAlphaComponent(0.7)
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .white
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 10
        return label
    }()
    
    private var movieTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "제목"
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.numberOfLines = 2
        label.lineBreakMode = .byCharWrapping
        return label
    }()
    
    private var movieYearLabel: UILabel = {
        let label = UILabel()
        label.text = "연도 및 러닝타임"
        label.font = .systemFont(ofSize: 13, weight: .light)
        return label
    }()
    
    private var movieGenreLabel: UILabel = {
        let label = UILabel()
        label.text = "장르"
        label.font = .systemFont(ofSize: 13, weight: .light)
        return label
    }()
    
    private var movieActorLabel: UILabel = {
        let label = UILabel()
        label.text = "배우"
        label.font = .systemFont(ofSize: 12, weight: .ultraLight)
        return label
    }()
    
    private var movieOTTView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var movieOTTStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 5
        return stackView
    }()
    
    private var movieContentLabel: UILabel = {
        let label = UILabel()
        label.text = "영화내용"
        label.font = .systemFont(ofSize: 14, weight: .ultraLight)
        label.numberOfLines = 10
        label.lineBreakMode = .byCharWrapping
        return label
    }()
    
    private lazy var emotionLabelCollectionView: UICollectionView = {
        var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(EmotionBadgeCollectionViewCell.self, forCellWithReuseIdentifier: EmotionBadgeCollectionViewCell.identifier)
        let layout = LeftAlignedCollectionViewFlowLayout()
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        layout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = layout
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isUserInteractionEnabled = true
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    private func setUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(titleLabel)
        view.addSubview(closeButton)
        view.addSubview(imageView)
        view.addSubview(simLabel)
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 5
        view.addSubview(stackView)
        stackView.addArrangedSubview(movieTitleLabel)
        stackView.addArrangedSubview(movieYearLabel)
        stackView.addArrangedSubview(movieGenreLabel)
        stackView.addArrangedSubview(movieActorLabel)
        stackView.addArrangedSubview(movieOTTView)
        
        view.addSubview(movieContentLabel)
        view.addSubview(emotionLabelCollectionView)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        simLabel.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        movieTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        movieGenreLabel.translatesAutoresizingMaskIntoConstraints = false
        movieActorLabel.translatesAutoresizingMaskIntoConstraints = false
        movieContentLabel.translatesAutoresizingMaskIntoConstraints = false
        emotionLabelCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        movieOTTView.addSubview(movieOTTStackView)
        movieOTTStackView.translatesAutoresizingMaskIntoConstraints = false
        movieOTTStackView.leadingAnchor.constraint(equalTo: movieOTTView.leadingAnchor).isActive = true
        movieOTTStackView.trailingAnchor.constraint(lessThanOrEqualTo: movieOTTView.trailingAnchor).isActive = true
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            closeButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            closeButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            imageView.heightAnchor.constraint(equalToConstant: 180),
            imageView.widthAnchor.constraint(equalToConstant: 120),
            imageView.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 30),
            imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            stackView.centerYAnchor.constraint(equalTo: imageView.centerYAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 15),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            simLabel.bottomAnchor.constraint(equalTo: stackView.topAnchor, constant: -10),
            simLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 15),
            simLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            emotionLabelCollectionView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            emotionLabelCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            emotionLabelCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            emotionLabelCollectionView.heightAnchor.constraint(equalToConstant: 20),
            movieContentLabel.topAnchor.constraint(equalTo: emotionLabelCollectionView.bottomAnchor, constant: 20),
            movieContentLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            movieContentLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
        ])
    }

    public func configure(by movie: MovieData) {
        DispatchQueue.global().async {
            guard let url = URL(string: movie.poster) else { return }
            let data = try? Data(contentsOf: url)
            DispatchQueue.main.async {
                self.imageView.image = UIImage(data: data!)
            }
        }
        
        simLabel.text = "이 날의 감정과 \(Int(movie.cosSim*100))% 유사한 영화입니다"
        
        var countryLogo = "🏴"
        var countyStr = movie.country
        countyStr.removeFirst()
        countyStr.removeLast()
        let countyList = countyStr.components(separatedBy: ", ")
        switch countyList[0] {
        case "'한국'":
            countryLogo = "🇰🇷"
        case "'일본'":
            countryLogo = "🇯🇵"
        case "'미국'":
            countryLogo = "🇺🇸"
        case "'대만'":
            countryLogo = "🇹🇼"
        case "'중국'":
            countryLogo = "🇨🇳"
        case "'영국'":
            countryLogo = "🇬🇧"
        case "'홍콩'":
            countryLogo = "🇭🇰"
        default:
            break
        }
        movieTitleLabel.text = "\(movie.title) \(countryLogo)"
        
        movieYearLabel.text = "\(movie.openingDate) · \(movie.playTime)"
        var genreStr = movie.genre
        if genreStr.count == 2 {
            genreStr = "장르정보 없음"
        } else {
            genreStr.removeFirst()
            genreStr.removeFirst()
            genreStr.removeLast()
            genreStr.removeLast()
        }
        var genreList = genreStr.components(separatedBy: "', '")
        while genreList.count > 3 {
            genreList.removeLast()
        }
        let labelStr = genreList.joined(separator: " · ")
        movieGenreLabel.text = labelStr
        
        var actorStr = movie.actor
        if actorStr.count == 2 {
            actorStr = "배우정보 없음"
        } else {
            actorStr.removeFirst()
            actorStr.removeFirst()
            actorStr.removeLast()
            actorStr.removeLast()
        }
        let actorList = actorStr.components(separatedBy: "', '")
        let actorLabelStr = actorList.joined(separator: " · ")
        movieActorLabel.text = actorLabelStr
        
        addOTTInfo(by: movie.ott)
        
        movieContentLabel.text = movie.text
        movieContentLabel.numberOfLines = 0
        let attrString = NSMutableAttributedString(string: movieContentLabel.text!)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
        movieContentLabel.attributedText = attrString
        
        for idx in 0..<movie.emotion.count {
            emotionInfos.append(EmotionInfo(emotion: Emotion(rawValue: movie.emotion[idx])!, percentage: movie.pbEmotion[idx]))
        }
        emotionInfos = emotionInfos.sorted { lhs, rhs in
            return lhs.percentage > rhs.percentage
        }
        emotionLabelCollectionView.reloadData()
    }
    
    private func addOTTInfo(by ottInfo: String) {
        var ottString = ottInfo
        ottString.removeFirst()
        ottString.removeLast()
        let otts = ottString.components(separatedBy: ", ")
        for ott in otts {
            var imageName = "basicOTT"
            switch ott {
            case "'넷플릭스'":
                imageName = "netflix"
            case "'웨이브'":
                imageName = "wave"
            case "'왓챠'":
                imageName = "watcha"
            case "'디즈니+'":
                imageName = "disneyPlus"
            case "'티빙'":
                imageName = "tving"
            default:
                break
            }
            if imageName == "basicOTT" {
                continue
            }
            let button = UIButton()
            button.setImage(UIImage(named: imageName), for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.widthAnchor.constraint(equalToConstant: 20).isActive = true
            button.heightAnchor.constraint(equalToConstant: 20).isActive = true
            button.addAction(UIAction { [weak self] _ in
                self?.showToast(message: ott)
            }, for: .touchUpInside)
            button.isUserInteractionEnabled = true
            movieOTTStackView.addArrangedSubview(button)
        }
    }
    
    func showToast(message : String) {
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = .systemFont(ofSize: 12, weight: .medium)
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
             toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
}

extension MovieDetailViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return emotionInfos.count >= 5 ? 5 : emotionInfos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmotionBadgeCollectionViewCell.identifier, for: indexPath) as? EmotionBadgeCollectionViewCell {
            cell.configure(by: emotionInfos[indexPath.item])
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == emotionLabelCollectionView,
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmotionBadgeCollectionViewCell.identifier, for: indexPath) as? EmotionBadgeCollectionViewCell {
            return cell.adjustCellSize(height: 10, label: emotionInfos[indexPath.item].info())
        }
        return .zero
    }
}
