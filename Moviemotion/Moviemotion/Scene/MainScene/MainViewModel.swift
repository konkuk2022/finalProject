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
    let diaryListSubject = BehaviorRelay(value: [Diary]())
    
    private let disposeBag = DisposeBag()
    
    func addNewDiray(_ new: Diary) {
        var now = self.diaryListSubject.value
        now.insert(new, at: 0)
        self.diaryListSubject.accept(now)
    }
}
