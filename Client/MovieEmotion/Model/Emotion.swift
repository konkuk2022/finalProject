//
//  Emotion.swift
//  MovieEmotion
//
//  Created by Inwoo Park on 2022/11/07.
//

import UIKit

enum Emotion: String, Codable {
    case complaints = "불평/불만"
    case welcome = "환영/호의"
    case impressed = "감동/감탄"
    case sickOfIt = "지긋지긋"
    case thanks = "고마움"
    case sad = "슬픔"
    case angry = "화남/분노"
    case respect = "존경"
    case expectation = "기대감"
    case ignoring = "우쭐댐/무시함"
    case sorry = "안타까움/실망"
    case wretched = "비장함"
    case doubt = "의심/불신"
    case pleasure = "뿌듯함"
    case comfort = "편안/쾌적"
    case novelty = "신기함/관심"
    case caring = "아껴주는"
    case shame = "부끄러움"
    case fear = "공포/무서움"
    case despair = "절망"
    case pathetic = "한심함"
    case disgusting = "역겨움/징그러움"
    case irritable = "짜증"
    case absurd = "어이없음"
    case none = "없음"
    case defeat = "패배/자기혐오"
    case annoyance = "귀찮음"
    case difficulty = "힘듦/지침"
    case excitement = "즐거움/신남"
    case realization = "깨달음"
    case guilt = "죄책감"
    case hate = "증오/혐오"
    case happy = "흐뭇함(귀여움/예쁨)"
    case embarrassed = "당황/난처"
    case surprised = "경악"
    case burden = "부담/안_내킴"
    case sorrow = "서러움"
    case noFun = "재미없음"
    case pity = "불쌍함/연민"
    case surprise = "놀람"
    case happiness = "행복"
    case anxiety = "불안/걱정"
    case joy = "기쁨"
    case reliance = "안심/신뢰"
}

extension Emotion {
    func backgroundColor() -> UIColor {
        switch self {
        case .complaints:
            return UIColor(rgb: 0x6D8A73)
        case .welcome:
            return UIColor(rgb: 0xB6D9BD)
        case .impressed:
            return UIColor(rgb: 0xD9D4C1)
        case .sickOfIt:
            return UIColor(rgb: 0x8C716F)
        case .thanks:
            return UIColor(rgb: 0xDB8C85)
        case .sad:
            return UIColor(rgb: 0x6D8A73)
        case .angry:
            return UIColor(rgb: 0xB6D9BD)
        case .respect:
            return UIColor(rgb: 0xD9D4C1)
        case .expectation:
            return UIColor(rgb: 0x8C716F)
        case .ignoring:
            return UIColor(rgb: 0xDB8C85)
        case .sorry:
            return UIColor(rgb: 0x6D8A73)
        case .wretched:
            return UIColor(rgb: 0xB6D9BD)
        case .doubt:
            return UIColor(rgb: 0xD9D4C1)
        case .pleasure:
            return UIColor(rgb: 0x8C716F)
        case .comfort:
            return UIColor(rgb: 0xDB8C85)
        case .novelty:
            return UIColor(rgb: 0x6D8A73)
        case .caring:
            return UIColor(rgb: 0xB6D9BD)
        case .shame:
            return UIColor(rgb: 0xD9D4C1)
        case .fear:
            return UIColor(rgb: 0x8C716F)
        case .despair:
            return UIColor(rgb: 0xDB8C85)
        case .pathetic:
            return UIColor(rgb: 0x6D8A73)
        case .disgusting:
            return UIColor(rgb: 0xB6D9BD)
        case .irritable:
            return UIColor(rgb: 0xD9D4C1)
        case .absurd:
            return UIColor(rgb: 0x8C716F)
        case .none:
            return UIColor(rgb: 0xDB8C85)
        case .defeat:
            return UIColor(rgb: 0x6D8A73)
        case .annoyance:
            return UIColor(rgb: 0xB6D9BD)
        case .difficulty:
            return UIColor(rgb: 0xD9D4C1)
        case .excitement:
            return UIColor(rgb: 0x8C716F)
        case .realization:
            return UIColor(rgb: 0xDB8C85)
        case .guilt:
            return UIColor(rgb: 0x6D8A73)
        case .hate:
            return UIColor(rgb: 0xB6D9BD)
        case .happy:
            return UIColor(rgb: 0xD9D4C1)
        case .embarrassed:
            return UIColor(rgb: 0x8C716F)
        case .surprised:
            return UIColor(rgb: 0xDB8C85)
        case .burden:
            return UIColor(rgb: 0x6D8A73)
        case .sorrow:
            return UIColor(rgb: 0xB6D9BD)
        case .noFun:
            return UIColor(rgb: 0xD9D4C1)
        case .pity:
            return UIColor(rgb: 0x8C716F)
        case .surprise:
            return UIColor(rgb: 0xDB8C85)
        case .happiness:
            return UIColor(rgb: 0x6D8A73)
        case .anxiety:
            return UIColor(rgb: 0xB6D9BD)
        case .joy:
            return UIColor(rgb: 0xD9D4C1)
        case .reliance:
            return UIColor(rgb: 0x8C716F)
        }
    }
}

struct EmotionInfo: Codable, Hashable {
    var emotion: Emotion
    var percentage: Double
    
    func info() -> String {
        return "\(emotion.rawValue) \(Int(percentage*100))점"
    }
}

extension UIColor {

    convenience init(red: Int, green: Int, blue: Int, a: Int = 0xFF) {
        self.init(
            red: CGFloat(red) / 255.0,
            green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0,
            alpha: CGFloat(a) / 255.0
        )
    }
    
    convenience init(rgb: Int) {
       self.init(
           red: (rgb >> 16) & 0xFF,
           green: (rgb >> 8) & 0xFF,
           blue: rgb & 0xFF
       )
   }

    convenience init(argb: Int) {
        self.init(
            red: (argb >> 16) & 0xFF,
            green: (argb >> 8) & 0xFF,
            blue: argb & 0xFF,
            a: (argb >> 24) & 0xFF
        )
    }

}
