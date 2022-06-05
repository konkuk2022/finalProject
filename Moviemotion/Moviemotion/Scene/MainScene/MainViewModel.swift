//
//  MainViewModel.swift
//  Moviemotion
//
//  Created by Inwoo Park on 2022/05/12.
//

import Foundation

import RxSwift
import RxRelay

final class MainViewModel {
    let diaryListSubject = BehaviorRelay(value: [
        Diary(emotionState: Emotion.randomEmotionState(), date: .now.addingTimeInterval(-86400), content: "배가 고파서"),
        Diary(emotionState: Emotion.randomEmotionState(), date: .now.addingTimeInterval(-86400*2), content: "밥을 먹었는데"),
        Diary(emotionState: Emotion.randomEmotionState(), date: .now.addingTimeInterval(-86400*3), content: "오노노 기억도 안나고 안할거"),
        Diary(emotionState: Emotion.randomEmotionState(), date: .now.addingTimeInterval(-86400*4), content: "눈물이 차올라서 고개들어"),
        Diary(emotionState: Emotion.randomEmotionState(), date: .now.addingTimeInterval(-86400*5), content: "이듬해질녘 꽃피는 봄"),
        Diary(emotionState: Emotion.randomEmotionState(), date: .now.addingTimeInterval(-86400*6), content: "한 여름 밤의 꿈"),
        Diary(emotionState: Emotion.randomEmotionState(), date: .now.addingTimeInterval(-86400*7), content: "가을 타 겨울 내린 눈")
    ])
    
    private let disposeBag = DisposeBag()
    
    func addNewDiray(_ new: Diary) {
        var now = self.diaryListSubject.value
        now.insert(new, at: 0)
        self.diaryListSubject.accept(now)
    }
    
    func removeDiary(at idx: Int) {
        var now = self.diaryListSubject.value
        now.remove(at: idx)
        self.diaryListSubject.accept(now)
    }
}
