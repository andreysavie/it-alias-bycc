//
//  Team.swift
//  Alias
//
//  Created by Андрей Рыбалкин on 15.12.2022.
//

import Foundation

struct Team {
    var type: TeamType
    var name: String
    var score: Int = 0
    var rounds: Int = 0
    var avatar: String = "person.2.circle.fill"
}

enum TeamType {
    case teamOne
    case teamTwo

    var desc: String {
        switch self {
        case .teamOne: return "first"
        case .teamTwo: return "second"
        }
    }
}
