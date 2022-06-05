//
//  Diary.swift
//  Moviemotion
//
//  Created by Inwoo Park on 2022/05/12.
//

import Foundation

struct Diary: Hashable {
    static func == (lhs: Diary, rhs: Diary) -> Bool {
        return lhs.uuid == rhs.uuid
    }
    
    var emotion: [Emotion]
    let uuid: UUID = UUID()
    let date: Date
    let content: String
}
