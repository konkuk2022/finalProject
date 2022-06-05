//
//  MovieViewModel.swift
//  Moviemotion
//
//  Created by Inwoo Park on 2022/05/12.
//

import Foundation

import RxRelay
import RxSwift


final class MovieViewModel {
    let movieListSubject = BehaviorRelay(value: [
        Movie(title: "그녀", year: 2013, genre: ["SF","로맨스"], summary: "2013년 개봉된 미국의 SF 로맨틱 코미디 드라마 영화이다. 스파이크 존즈가 제작과 감독을 맡은 첫 작품이다. 영화에 삽입된 곡들은 아케이드 파이어가 작곡했고 촬영은 호이터 판호이테마가 맡았다.", imageUrl: "her"),
        Movie(title: "브로커", year: 2022, genre: ["SF","로맨스"], summary: "2013년 개봉된 미국의 SF 로맨틱 코미디 드라마 영화이다. 스파이크 존즈가 제작과 감독을 맡은 첫 작품이다. 영화에 삽입된 곡들은 아케이드 파이어가 작곡했고 촬영은 호이터 판호이테마가 맡았다.", imageUrl: "broker"),
        Movie(title: "닥터스트레인지2", year: 2022, genre: ["SF","로맨스"], summary: "2013년 개봉된 미국의 SF 로맨틱 코미디 드라마 영화이다. 스파이크 존즈가 제작과 감독을 맡은 첫 작품이다. 영화에 삽입된 곡들은 아케이드 파이어가 작곡했고 촬영은 호이터 판호이테마가 맡았다.", imageUrl: "doctorstrange"),
        Movie(title: "마녀2", year: 2022, genre: ["SF","로맨스"], summary: "2013년 개봉된 미국의 SF 로맨틱 코미디 드라마 영화이다. 스파이크 존즈가 제작과 감독을 맡은 첫 작품이다. 영화에 삽입된 곡들은 아케이드 파이어가 작곡했고 촬영은 호이터 판호이테마가 맡았다.", imageUrl: "witch2"),
        Movie(title: "범죄도시2", year: 2022, genre: ["SF","로맨스"], summary: "2013년 개봉된 미국의 SF 로맨틱 코미디 드라마 영화이다. 스파이크 존즈가 제작과 감독을 맡은 첫 작품이다. 영화에 삽입된 곡들은 아케이드 파이어가 작곡했고 촬영은 호이터 판호이테마가 맡았다.", imageUrl: "crime")
    ])
    private let disposeBag = DisposeBag()
    
    func setMovieList(by movieList: [Movie]) {
        movieListSubject.accept(movieList)
    }
}
