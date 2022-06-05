//
//  Emotion.swift
//  Moviemotion
//
//  Created by Inwoo Park on 2022/05/12.
//

import Foundation

struct Emotion {
    let kind: EmotionKind
    var percentage: Float
}

enum EmotionKind: String {
    case happy = "행복"
    case sad = "슬픔"
    case surprise = "놀라움"
    case angry = "분노"
    case fear = "공포"
    case aversion = "당황"
    case neutral = "중립"
}
