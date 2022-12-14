//
//  DetailViewController.swift
//  MovieEmotion
//
//  Created by Inwoo Park on 2022/11/09.
//

import UIKit

class DetailViewController: UIViewController {
    
    var myDiary: Diary?
    var emotionInfos: [EmotionInfo] = []
    var movieList: [MovieData] = []
    
    private let scrollVIew: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.canCancelContentTouches = false
        return scrollView
    }()
    
    private lazy var mainMovieImageView: UIImageView = {
        let imageView = UIImageView()
        let tap = UITapGestureRecognizer(target: self, action: #selector(mainImageTouched))
        imageView.addGestureRecognizer(tap)
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private let mainMovieTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "제목"
        label.font = .systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    private let mainMovieGenreLabel: UILabel = {
        let label = UILabel()
        label.text = "장르"
        label.font = .systemFont(ofSize: 13, weight: .ultraLight)
        return label
    }()
    
    private let guideLabel: BasePaddingLabel = {
        let label = BasePaddingLabel()
        label.text = "이 날의 감정과 가장 잘 어울리는 영화입니다"
        label.backgroundColor = UIColor(rgb: 0xEB6440).withAlphaComponent(0.7)
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .white
        label.layer.cornerRadius = 10
        label.layer.masksToBounds = true
        return label
    }()
    
    private let todayEmotionLabel: UILabel = {
        let label = UILabel()
        label.text = "이 날의 기록"
        label.font = .systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.text = "일기내용"
        label.font = .systemFont(ofSize: 14, weight: .ultraLight)
        label.numberOfLines = 15
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
    
    private lazy var moreButton: UIButton = {
        var button = UIButton(type: .system)
        button.setImage(UIImage(named: "moreEmotion"), for: .normal)
        button.layer.cornerRadius = 5
        button.tintColor = .black
        button.addAction(UIAction { _ in
            let emotionVC = EmotionViewController()
            emotionVC.configure(diary: self.myDiary!)
            emotionVC.modalPresentationStyle = .pageSheet
            if let sheet = emotionVC.sheetPresentationController {
                sheet.detents = [.medium(), .large()]
            }
            self.present(emotionVC, animated: true, completion: nil)
        }, for: .touchUpInside)
        return button
    }()
    
    private let todayMovieLabel: UILabel = {
        let label = UILabel()
        label.text = "이 날의 영화"
        label.font = .systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    private lazy var movieCollectionView: UICollectionView = {
        var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: MovieCollectionViewCell.identifier)
        let layout = LeftAlignedCollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 100, height: 180)
        collectionView.collectionViewLayout = layout
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.canCancelContentTouches = false
        collectionView.delegate = self
        return collectionView
    }()
    
    private lazy var movieDataSource = UICollectionViewDiffableDataSource<Int, MovieData>(collectionView: self.movieCollectionView) { (collectionView: UICollectionView, indexPath: IndexPath, itemIdentifier: MovieData) -> UICollectionViewCell? in
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.identifier, for: indexPath) as? MovieCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(by: itemIdentifier)
        cell.delegate = self
        return cell
    }
    
    private var seperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray4
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        self.navigationController?.navigationBar.tintColor = .black
    }
    
    private func setUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(scrollVIew)
        scrollVIew.addSubview(mainMovieImageView)
        scrollVIew.addSubview(mainMovieTitleLabel)
        scrollVIew.addSubview(mainMovieGenreLabel)
        scrollVIew.addSubview(guideLabel)
        scrollVIew.addSubview(todayEmotionLabel)
        scrollVIew.addSubview(contentLabel)
        scrollVIew.addSubview(emotionLabelCollectionView)
        scrollVIew.addSubview(moreButton)
        scrollVIew.addSubview(todayMovieLabel)
        scrollVIew.addSubview(movieCollectionView)
        scrollVIew.addSubview(seperatorView)
        
        scrollVIew.translatesAutoresizingMaskIntoConstraints = false
        mainMovieImageView.translatesAutoresizingMaskIntoConstraints = false
        mainMovieTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        mainMovieGenreLabel.translatesAutoresizingMaskIntoConstraints = false
        guideLabel.translatesAutoresizingMaskIntoConstraints = false
        todayEmotionLabel.translatesAutoresizingMaskIntoConstraints = false
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        emotionLabelCollectionView.translatesAutoresizingMaskIntoConstraints = false
        moreButton.translatesAutoresizingMaskIntoConstraints = false
        todayMovieLabel.translatesAutoresizingMaskIntoConstraints = false
        movieCollectionView.translatesAutoresizingMaskIntoConstraints = false
        seperatorView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollVIew.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollVIew.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollVIew.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollVIew.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
        
        NSLayoutConstraint.activate([
            mainMovieImageView.topAnchor.constraint(equalTo: scrollVIew.topAnchor, constant: 10),
            mainMovieImageView.widthAnchor.constraint(equalToConstant: 150),
            mainMovieImageView.heightAnchor.constraint(equalToConstant: 225),
            mainMovieImageView.centerXAnchor.constraint(equalTo: scrollVIew.centerXAnchor),
            mainMovieTitleLabel.topAnchor.constraint(equalTo: mainMovieImageView.bottomAnchor, constant: 20),
            mainMovieTitleLabel.centerXAnchor.constraint(equalTo: scrollVIew.centerXAnchor),
            mainMovieGenreLabel.topAnchor.constraint(equalTo: mainMovieTitleLabel.bottomAnchor, constant: 5),
            mainMovieGenreLabel.centerXAnchor.constraint(equalTo: scrollVIew.centerXAnchor),
            guideLabel.topAnchor.constraint(equalTo: mainMovieGenreLabel.bottomAnchor, constant: 15),
            guideLabel.centerXAnchor.constraint(equalTo: scrollVIew.centerXAnchor),
            
            todayEmotionLabel.topAnchor.constraint(equalTo: guideLabel.bottomAnchor, constant: 25),
            todayEmotionLabel.leadingAnchor.constraint(equalTo: scrollVIew.leadingAnchor, constant: 20),
            contentLabel.topAnchor.constraint(equalTo: todayEmotionLabel.bottomAnchor, constant: 20),
            contentLabel.leadingAnchor.constraint(equalTo: scrollVIew.leadingAnchor, constant: 20),
            contentLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.width - 40),
            contentLabel.trailingAnchor.constraint(equalTo: scrollVIew.trailingAnchor, constant: -20),
            emotionLabelCollectionView.topAnchor.constraint(equalTo: contentLabel.bottomAnchor, constant: 15),
            emotionLabelCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            emotionLabelCollectionView.trailingAnchor.constraint(equalTo: moreButton.leadingAnchor, constant: -20),
            emotionLabelCollectionView.heightAnchor.constraint(equalToConstant: 20),
            moreButton.centerYAnchor.constraint(equalTo: emotionLabelCollectionView.centerYAnchor, constant: -3),
            moreButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            seperatorView.heightAnchor.constraint(equalToConstant: 0.5),
            seperatorView.topAnchor.constraint(equalTo: emotionLabelCollectionView.bottomAnchor, constant: 20),
            seperatorView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            seperatorView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30),
            todayMovieLabel.topAnchor.constraint(equalTo: seperatorView.bottomAnchor, constant: 20),
            todayMovieLabel.leadingAnchor.constraint(equalTo: scrollVIew.leadingAnchor, constant: 20),
            movieCollectionView.topAnchor.constraint(equalTo: todayMovieLabel.bottomAnchor, constant: 20),
            movieCollectionView.heightAnchor.constraint(equalToConstant: 180),
            movieCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            movieCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            movieCollectionView.bottomAnchor.constraint(equalTo: scrollVIew.bottomAnchor, constant: -10)
        ])
    }
    
    public func configure(by diary: Diary) {
        self.myDiary = diary
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일"
        title = formatter.string(from: diary.date)
        
        var sortedMovieList = diary.movieList.sorted { lhs, rhs in
            lhs.cosSim > rhs.cosSim
        }
        
        self.movieList = sortedMovieList
        guard let mainMovie = sortedMovieList.first else {
            return
        }
        
        DispatchQueue.global().async {
            guard let url = URL(string: mainMovie.poster) else { return }
            let data = try? Data(contentsOf: url)
            DispatchQueue.main.async {
                guard let data = data else { return }
                self.mainMovieImageView.image = UIImage(data: data)
            }
        }
        
        mainMovieTitleLabel.text = mainMovie.title
        var genreStr = mainMovie.genre
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
        mainMovieGenreLabel.text = labelStr
        contentLabel.text = diary.content
        
        for emotionInfo in diary.emotionList.sorted(by: { lhs, rhs in
            lhs.percentage > rhs.percentage
        }) {
            emotionInfos.append(emotionInfo)
        }
        emotionLabelCollectionView.reloadData()
        
        sortedMovieList.removeFirst()
        updateSnapshot(by: sortedMovieList)
    }
    
    private func updateSnapshot(by movieList: [MovieData]) {
        var snapShot = NSDiffableDataSourceSnapshot<Int, MovieData>()
        snapShot.appendSections([Int.zero])
        snapShot.appendItems(movieList)
        movieDataSource.apply(snapShot, animatingDifferences: true)
    }
    
    @objc
    private func mainImageTouched() {
        presentMovieDetail(by: movieList[0])
    }
    
    public func presentMovieDetail(by movie: MovieData) {
        let vc = MovieDetailViewController()
        vc.configure(by: movie)
        vc.modalPresentationStyle = .pageSheet
        if let sheet = vc.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
        }
        present(vc, animated: true, completion: nil)
    }

}

extension DetailViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
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
        if collectionView == movieCollectionView {
            return CGSize(width: 100, height: 180)
        }
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == emotionLabelCollectionView {
            let emotionVC = EmotionViewController()
            emotionVC.configure(diary: self.myDiary!)
            emotionVC.modalPresentationStyle = .pageSheet
            if let sheet = emotionVC.sheetPresentationController {
                sheet.detents = [.medium(), .large()]
            }
            self.present(emotionVC, animated: true, completion: nil)
        } else {
            presentMovieDetail(by: movieList[indexPath.item+1])
        }
    }
}
