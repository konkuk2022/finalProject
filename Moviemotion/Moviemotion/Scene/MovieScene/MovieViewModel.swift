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
        Movie(title: "브로커", year: 2022, genre: ["드라마"], summary: """
            세탁소를 운영하지만 늘 빚에 시달리는 ‘상현’(송강호)과 베이비 박스 시설에서 일하는 보육원 출신의 ‘동수’(강동원). 거센 비가 내리는 어느 날 밤, 그들은 베이비 박스에 놓인 한 아기를 몰래 데려간다.
            """, imageUrl: "broker"),
        Movie(title: "닥터 스트레인지: 대혼돈의 멀티버스", year: 2022, genre: ["액션","판타지","모험"], summary: "지금껏 본 적 없는 마블의 극한 상상력! 광기의 멀티버스가 깨어난다 끝없이 균열되는 차원과 뒤엉킨 시공간의 멀티버스가 열리며 오랜 동료들, 그리고 차원을 넘어 들어온 새로운 존재들을 맞닥뜨리게 된 ‘닥터 스트레인지’. 대혼돈 속, 그는 예상치 못한 극한의 적과 맞서 싸워야만 하는데….", imageUrl: "doctorstrange"),
        Movie(title: "마녀(魔女) Part2. The Other One", year: 2022, genre: ["액션"], summary: """
            통제불능의 존재가 세상 밖으로 나왔다! ’자윤’이 사라진 뒤, 정체불명의 집단의 무차별 습격으로 마녀 프로젝트가 진행되고 있는 ‘아크’가 초토화된다. 그곳에서 홀로 살아남은 ‘소녀’는 생애 처음 세상 밖으로 발을 내딛고 우연히 만난 ‘경희’의 도움으로 농장에서 지내며 따뜻한 일상에 적응해간다.
            """, imageUrl: "witch2"),
        Movie(title: "범죄도시2", year: 2022, genre: ["범죄","액션"], summary: "\"느낌 오지? 이 놈 잡아야 하는 거\" 가리봉동 소탕작전 후 4년 뒤, 금천서 강력반은 베트남으로 도주한 용의자를 인도받아 오라는 미션을 받는다. 괴물형사 ‘마석도’(마동석)와 ‘전일만’(최귀화) 반장은 현지 용의자에게서 수상함을 느끼고, 그의 뒤에 무자비한 악행을 벌이는 ‘강해상’(손석구)이 있음을 알게 된다. ‘마석도’와 금천서 강력반은 한국과 베트남을 오가며 역대급 범죄를 저지르는 ‘강해상’을 본격적으로 쫓기 시작하는데...", imageUrl: "crime")
    ])
    private let disposeBag = DisposeBag()
    
    func setMovieList(by movieList: [Movie]) {
        movieListSubject.accept(movieList)
    }
}
