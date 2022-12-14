//
//  Movie.swift
//  MovieEmotion
//
//  Created by Inwoo Park on 2022/11/07.
//

import Foundation

struct MovieData: Codable, Hashable {
    let country, rotten, ageLimit: String
    let cosSim, imdb: Double
    let playTime: String
    let poster: String
    let genre, text: String
    let pbEmotion: [Double]
    let ott, title: String
    let emotion: [String]
    let actor: String
    let openingDate: Int

    enum CodingKeys: String, CodingKey {
        case country, rotten
        case ageLimit = "age_limit"
        case cosSim = "cos_sim"
        case imdb
        case playTime = "play_time"
        case poster, genre, text
        case pbEmotion = "pb_emotion"
        case ott, title, emotion, actor
        case openingDate = "opening_date"
    }
}
