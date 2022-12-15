//
//  RecordModel.swift
//  Alias
//
//  Created by Андрей Рыбалкин on 15.12.2022.
//

import Foundation

final class RecordModel {
    
    var winnerTeam: Team
    var looserTeam: Team
    
    init(winnerTeam: Team, looserTeam: Team) {
        self.winnerTeam = winnerTeam
        self.looserTeam = looserTeam
    }
    
}
