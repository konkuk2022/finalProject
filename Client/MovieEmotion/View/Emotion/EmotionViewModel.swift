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
    let emotionListSubject = BehaviorRelay(value: [EmotionInfo]())
    
    private let disposeBag = DisposeBag()
    
    func setEmotionList(by emotionList: [EmotionInfo]) {
        emotionListSubject.accept(emotionList)
    }
}
