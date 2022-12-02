//
//  SettingsManager.swift
//  Alias
//
//  Created by Андрей Рыбалкин on 01.12.2022.
//

import Foundation

enum ValueType: String {
    case teamOneName = "teamOneName"
    case teamTwoName = "teamTwoName"
    case numOfWords = "numOfWords"
    case timeOfRound = "timeOfRound"
    case isTasksEnabled = "isTasksEnabled"
    case isPenaltyEnabled = "isPenaltyEnabled"
    case isSoundsEnabled = "isSoundsEnabled"
    
    
}

final class SettingsManager {
    
    static var shared = SettingsManager()
    
    private let defaults = UserDefaults.standard
    
    public var teamOneName: String { get { getValue(.teamOneName) } set { save(newValue, type: .teamOneName) } }
    public var teamTwoName: String { get { getValue(.teamTwoName) } set { save(newValue, type: .teamTwoName) } }
    public var numOfWords: Float { get { getValue(.numOfWords) } set { save(newValue, type: .numOfWords) } }
    public var timeOfRound: Float { get { getValue(.timeOfRound) } set { save(newValue, type: .timeOfRound) } }
    public var isTasksEnabled: Bool { get { getValue(.isTasksEnabled) } set { save(newValue, type: .isTasksEnabled) } }
    public var isPenaltyEnabled: Bool { get { getValue(.isPenaltyEnabled) } set { save(newValue, type: .isPenaltyEnabled) } }
    public var isSoundsEnabled: Bool { get { getValue(.isSoundsEnabled) } set { save(newValue, type: .isSoundsEnabled) } }
    
}

extension SettingsManager {
    
    private func save<T>(_ value: T, type: ValueType) {
        self.defaults.set(value, forKey: type.rawValue)
    }
    
    private func getValue<T>(_ type: ValueType) -> T {
        switch type {
        case .teamOneName, .teamTwoName:
            return self.defaults.string(forKey: type.rawValue) as! T
        case .numOfWords, .timeOfRound:
            return self.defaults.float(forKey: type.rawValue) as! T
        case .isTasksEnabled, .isPenaltyEnabled, .isSoundsEnabled:
            return self.defaults.bool(forKey: type.rawValue) as! T
        }
    }
}

