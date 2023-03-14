//
//  UserDefaults+set.swift
//  ValidSudoku
//
//  Created by Григорий Селезнев on 2/2/23.
//

import UIKit

extension UserDefaults {
    
    func set(_ color: UIColor?, forKey defaultName: String) {
        guard let data = color?.data else {
            removeObject(forKey: defaultName)
            return
        }
        set(data, forKey: defaultName)
    }
    
    func color(forKey defaultName: String) -> UIColor? {
        data(forKey: defaultName)?.color
    }
    
    public var gameState: GameState? {
        get {
            if let data = object(forKey: "gameState") as? Data, let gameState = try? JSONDecoder().decode(GameState.self, from: data) {
                return gameState
            } else {
                return nil
            }
            
        }
        set {
            if let encoded = try? JSONEncoder().encode(newValue) {
                set(encoded, forKey: "gameState")
            } else {
                let any: Any? = nil
                set(any, forKey: "gameState")
            }
            
        }
    }
    
    public var mainColor: UIColor? {
        get { color(forKey: "mainColor") }
        set { set(newValue, forKey: "mainColor") }
    }
    
    public var mainFieldColor: UIColor? {
        get { color(forKey: "mainFieldColor") }
        set { set(newValue, forKey: "mainFieldColor")}
    }
    
    public var secondaryFieldColor: UIColor? {
        get { color(forKey: "secondaryFieldColor") }
        set { set(newValue, forKey: "secondaryFieldColor") }
    }
    
    public var isDarkMode: Bool {
        get { bool(forKey: "darkMode") }
        set { set(newValue, forKey: "darkMode")}
    }
    
    public var isSystemThemeOn: Bool {
        get { bool(forKey: "systemTheme") }
        set { set(newValue, forKey: "systemTheme")}
    }
    
    public var isMistakesLimitSet: Bool {
        get { bool(forKey: "mistakesLimit") }
        set { set(newValue, forKey: "mistakesLimit") }
    }
    
    public var isMistakesIndicates: Bool {
        get { bool(forKey: "mistakesIndicate") }
        set { set(newValue, forKey: "mistakesIndicate") }
    }
    
    public var isAutoRemoveNoteOn: Bool {
        get { bool(forKey: "autoRemoveNote") }
        set { set(newValue, forKey: "autoRemoveNote") }
    }
    
    public var isHighlightingOn: Bool {
        get { bool(forKey: "highlightSameNumber") }
        set { set(newValue, forKey: "highlightSameNumber") }
    }
    
    
    public var winStreak: Int {
        get { Int(double(forKey: "winStreak")) }
        set { set(newValue, forKey: "winStreak") }
    }
    public var bestStreak: Int {
        get { Int(double(forKey: "bestStreak")) }
        set { set(newValue, forKey: "bestStreak") }
    }
    
    public var easyGameStarted: Int {
        get { Int(double(forKey: "easyGameStarted")) }
        set { set(newValue, forKey: "easyGameStarted") }
    }
    public var easyGameWon: Int {
        get { Int(double(forKey: "easyGameWon")) }
        set { set(newValue, forKey: "easyGameWon") }
    }
    public var easyGameWinWithNoMistakes: Int {
        get { Int(double(forKey: "easyGameWinWNM")) }
        set { set(newValue, forKey: "easyGameWinWNM") }
    }
    public var easyGameAveTime: Double {
        get { double(forKey: "easyGameAveTime") }
        set { set(newValue, forKey: "easyGameAveTime") }
    }
    public var easyGameBestTime: Double {
        get { double(forKey: "easyGameBestTime") }
        set { set(newValue, forKey: "easyGameBestTime") }
    }
    
    
    public var mediumGameStarted: Int {
        get { Int(double(forKey: "mediumGameStarted")) }
        set { set(newValue, forKey: "mediumGameStarted") }
    }
    public var mediumGameWon: Int {
        get { Int(double(forKey: "mediumGameWon")) }
        set { set(newValue, forKey: "mediumGameWon") }
    }
    public var mediumGameWinWithNoMistakes: Int {
        get { Int(double(forKey: "mediumGameWinWNM")) }
        set { set(newValue, forKey: "mediumGameWinWNM") }
    }
    public var mediumGameAveTime: Double {
        get { double(forKey: "mediumGameAveTime") }
        set { set(newValue, forKey: "mediumGameAveTime") }
    }
    public var mediumGameBestTime: Double {
        get { double(forKey: "mediumGameBestTime") }
        set { set(newValue, forKey: "mediumGameBestTime") }
    }
    
    
    public var hardGameStarted: Int {
        get { Int(double(forKey: "hardGameStarted")) }
        set { set(newValue, forKey: "hardGameStarted") }
    }
    public var hardGameWon: Int {
        get { Int(double(forKey: "hardGameWon")) }
        set { set(newValue, forKey: "hardGameWon") }
    }
    public var hardGameWinWithNoMistakes: Int {
        get { Int(double(forKey: "hardGameWinWNM")) }
        set { set(newValue, forKey: "hardGameWinWNM") }
    }
    public var hardGameAveTime: Double {
        get { double(forKey: "hardGameAveTime") }
        set { set(newValue, forKey: "hardGameAveTime") }
    }
    public var hardGameBestTime: Double {
        get { double(forKey: "hardGameBestTime") }
        set { set(newValue, forKey: "hardGameBestTime") }
    }
    
    
    public var customGameStarted: Int {
        get { Int(double(forKey: "customGameStarted")) }
        set { set(newValue, forKey: "customGameStarted") }
    }
    public var customGameWon: Int {
        get { Int(double(forKey: "customGameWon")) }
        set { set(newValue, forKey: "customGameWon") }
    }
    public var customGameWinWithNoMistakes: Int {
        get { Int(double(forKey: "customGameWinWNM")) }
        set { set(newValue, forKey: "customGameWinWNM") }
    }
    public var customGameAveTime: Double {
        get { double(forKey: "customGameAveTime") }
        set { set(newValue, forKey: "customGameAveTime") }
    }
    public var customGameBestTime: Double {
        get { double(forKey: "customGameBestTime") }
        set { set(newValue, forKey: "customGameBestTime") }
    }
}
