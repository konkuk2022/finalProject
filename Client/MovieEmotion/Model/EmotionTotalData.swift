//
//  EmotionTotalData.swift
//  MovieEmotion
//
//  Created by Inwoo Park on 2022/11/08.
//

import Foundation

struct EmotionTotalData: Codable {
    let text: String
    let pbEmotionSelected: [Double]
    let labelsSelected: [String]
    let movies: [MovieData]

    enum CodingKeys: String, CodingKey {
        case text
        case pbEmotionSelected = "pb_emotion_selected"
        case labelsSelected = "labels_selected"
        case movies
    }
    
    public func toDiary(in date: Date) -> Diary {
        var newDiary = Diary(date: date, content: text, emotionList: [EmotionInfo](), movieList: movies)
        for idx in 0..<labelsSelected.count {
            newDiary.emotionList.append(EmotionInfo(emotion: Emotion(rawValue: labelsSelected[idx])!, percentage: pbEmotionSelected[idx]))
        }
        return newDiary
    }
}

struct Diary: Codable, Hashable {
    var uuid: UUID = UUID()
    var date: Date
    var content: String
    var emotionList: [EmotionInfo]
    var movieList: [MovieData]
    
    var dateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일"
        return formatter.string(from: date)
    }
    
    var mainMovie: MovieData {
        movieList.sorted { lhs, rhs in
            lhs.cosSim > rhs.cosSim
        }.first!
    }
}
