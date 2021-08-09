//
//  Character.swift
//  Character
//
//  Created by COE on 8/9/21.
//

import Foundation

struct Character: Codable {
    var char_id: Int
    var name: String
    var img: URL
    var status: String
    var nickname: String
}
extension Character: Identifiable {
    var id: Int { return char_id }
}

