//
//  Episode.swift
//  Episode
//
//  Created by COE on 8/9/21.
//

import Foundation

struct Episode: Codable {
    var episode_id: Int
    var title: String
    var series: String
    var season: String
    var episode: String
    var air_date: String
    var characters: [String]
}
extension Episode: Identifiable {
    var id: Int { return episode_id }
}
