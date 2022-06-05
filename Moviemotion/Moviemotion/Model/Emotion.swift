//
//  Emotion.swift
//  Moviemotion
//
//  Created by Inwoo Park on 2022/05/12.
//

import Foundation

struct Emotion: Hashable {
    let kind: EmotionKind
    var percentage: Float
    
    static func randomEmotionState() -> [Emotion] {
        var result = [Emotion]()
        var candidate = [Int]()
        var total = 100
        
        for _ in EmotionKind.allCases {
            let percent = Int.random(in: 0...total)
            total -= percent
            candidate.append(percent)
        }
        
        for kind in EmotionKind.allCases {
            let idx = Int.random(in: 0..<candidate.count)
            result.append(Emotion(kind: kind, percentage: Float(candidate[idx])/100))
            candidate.remove(at: idx)
        }
        
        return result
    }
}

enum EmotionKind: String, CaseIterable {
    case happy = "행복"
    case sad = "슬픔"
    case surprise = "놀라움"
    case angry = "분노"
    case fear = "공포"
    case aversion = "당황"
    case neutral = "중립"
}
