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
    
    public var teamOneName: String { get { get(.teamOneName) } set { save(newValue, of: .teamOneName) } }
    public var teamTwoName: String { get { get(.teamTwoName) } set { save(newValue, of: .teamTwoName) } }
    public var numOfWords: Int { get { get(.numOfWords) } set { save(newValue, of: .numOfWords) } }
    public var timeOfRound: Int { get { get(.timeOfRound) } set { save(newValue, of: .timeOfRound) } }
    public var isTasksEnabled: Bool { get { get(.isTasksEnabled) } set { save(newValue, of: .isTasksEnabled) } }
    public var isPenaltyEnabled: Bool { get { get(.isPenaltyEnabled) } set { save(newValue, of: .isPenaltyEnabled) } }
    public var isSoundsEnabled: Bool { get { get(.isSoundsEnabled) } set { save(newValue, of: .isSoundsEnabled) } }
    
}

extension SettingsManager {
    
    private func save<T>(_ value: T, of type: ValueType) {
        self.defaults.set(value, forKey: type.rawValue)
    }
    
    private func get<T>(_ type: ValueType) -> T {
        switch type {
        case .teamOneName, .teamTwoName:
            return self.defaults.string(forKey: type.rawValue) as! T
        case .numOfWords, .timeOfRound:
            return self.defaults.integer(forKey: type.rawValue) as! T
        case .isTasksEnabled, .isPenaltyEnabled, .isSoundsEnabled:
            return self.defaults.bool(forKey: type.rawValue) as! T
        }
    }
    
    func setDefaultValues() {
        save("Juniors", of: .teamOneName)
        save("Seniors", of: .teamTwoName)
        save(25, of: .numOfWords)
        save(60, of: .timeOfRound)
        save(false, of: .isTasksEnabled)
        save(false, of: .isPenaltyEnabled)
        save(false, of: .isSoundsEnabled)
    }
}

