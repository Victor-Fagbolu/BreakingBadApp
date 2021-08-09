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
    var season: String
    var episode: String
}
extension Episode: Identifiable {
    var id: Int { return episode_id }
}
