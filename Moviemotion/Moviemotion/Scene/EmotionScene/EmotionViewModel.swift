//
//  EmotionViewModel.swift
//  Moviemotion
//
//  Created by Inwoo Park on 2022/05/12.
//

import Foundation

import RxRelay
import RxSwift

final class EmotionViewModel {
    let emotionListSubject = BehaviorRelay(value: [
        Emotion(kind: .happy, percentage: 0.6),
        Emotion(kind: .aversion, percentage: 0.1),
        Emotion(kind: .fear, percentage: 0.05),
        Emotion(kind: .angry, percentage: 0.05),
        Emotion(kind: .surprise, percentage: 0.1),
        Emotion(kind: .sad, percentage: 0.05),
        Emotion(kind: .neutral, percentage: 0.1)
    ])
    
    private let disposeBag = DisposeBag()
}
