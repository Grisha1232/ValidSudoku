//
//  SettingsModel.swift
//  ValidSudoku
//
//  Created by Григорий Селезнев on 2/2/23.
//

import UIKit
import CoreData

// MARK: - SettingsModel
class SettingsModel {
    
    /// delegate to the Protocol that changing main color in the app
    private static var delegates: [ChangedColorProtocol] = []
    public static func appendTo(content: ChangedColorProtocol) {
        delegates.append(content)
    }
    
    // MARK: - After game
    /// func for saving the game state for cintinuing game in the future
    public static func save(gameState: GameState?) {
        UserDefaults.standard.gameState = gameState
    }
    public static func getPrevGame() -> GameState? {
        UserDefaults.standard.gameState
    }
    
    // MARK: - Settings in the game
    private static var noteOn = false
    public static func switchNote() {
        noteOn.toggle()
    }
    public static func isNoteOn() -> Bool {
        noteOn
    }
    
    // MARK: - Settings of the Sudoku
    /// get is it Mistakes limit on or not
    public static func isMistakesLimitSet() -> Bool {
        UserDefaults.standard.isMistakesLimitSet
    }
    /// switch to the opposite value mistakes limit
    public static func switchMistakesLimit() {
        UserDefaults.standard.isMistakesLimitSet = !UserDefaults.standard.isMistakesLimitSet
    }
    
    /// get is it Mistakes indicate on or not
    public static func isMistakesIndicates() -> Bool {
        UserDefaults.standard.isMistakesIndicates
    }
    /// switch to the opposite value mistakes indicate
    public static func switchMistakesIndicate() {
        UserDefaults.standard.isMistakesIndicates = !UserDefaults.standard.isMistakesIndicates
    }
    
    /// get is it Auto remove note on or not
    public static func isAutoRemoveNoteOn() -> Bool {
        UserDefaults.standard.isAutoRemoveNoteOn
    }
    /// switch to the opposite value auto remove note
    public static func switchAutoRemoveNote() {
        UserDefaults.standard.isAutoRemoveNoteOn = !UserDefaults.standard.isAutoRemoveNoteOn
    }
    
    /// get is it highlight same numbers on or not
    public static func isHighlightingOn() -> Bool {
        UserDefaults.standard.isHighlightingOn
    }
    /// switch to the opposite value highlight same number
    public static func switchHighlighting() {
        UserDefaults.standard.isHighlightingOn = !UserDefaults.standard.isHighlightingOn
    }
    
    // MARK: - Color scheme settings
    /// Main color of the app
    public static func getMainColor() -> UIColor {
        let color = UserDefaults.standard.mainColor
        if let mainColor = color {
            return mainColor
        } else {
            UserDefaults.standard.mainColor = .systemBlue
            return .systemBlue
        }
    }
    /// Incorrect filled number color
    public static func getIncorrectColor() -> UIColor {
        .systemRed
    }
    
    public static func isSystemThemeOn() -> Bool {
        UserDefaults.standard.isSystemThemeOn
    }
    public static func switchSystemTheme() {
        UserDefaults.standard.isSystemThemeOn.toggle()
        for delegate in delegates {
            delegate.changeColor()
        }
    }
    
    /// get is it dark mode or not
    public static func isDarkMode() -> Bool {
        UserDefaults.standard.isDarkMode
    }
    /// switch to the opposite value field "dark mode"
    public static func switchDarkMode() {
        UserDefaults.standard.isDarkMode = !UserDefaults.standard.isDarkMode
        for delegate in delegates {
            delegate.changeColor()
        }
    }
    
    public static func getMainLabelColor() -> UIColor {
        if (isSystemThemeOn()) {
            return .label
        } else if (isDarkMode()) {
            return .white
        } else {
            return .black
        }
    }
    
    public static func getSecondaryLabelColor() -> UIColor {
        if (isSystemThemeOn()) {
            return .secondaryLabel
        } else if (isDarkMode()) {
            return .lightGray
        } else {
            return .gray
        }
    }
    
    /// main background color. Depends on the dark mode
    public static func getMainBackgroundColor() -> UIColor {
        if (isSystemThemeOn()) {
            if (UITraitCollection.current.userInterfaceStyle == .dark) {
                return .secondarySystemBackground
            } else {
                return .systemBackground
            }
        } else if isDarkMode() {
            return .init(red: 28 / 255, green: 28 / 255, blue: 30 / 255, alpha: 1)
        } else {
            return .white
        }
    }
    /// secondary background color. Depends on the dark mode
    public static func getSecondaryBackgroundColor() -> UIColor {
        if (isSystemThemeOn()) {
            if (UITraitCollection.current.userInterfaceStyle == .dark) {
                return .systemBackground
            } else {
                return .secondarySystemBackground
            }
        } else if (isDarkMode()) {
            return .init(red: 0, green: 0, blue: 0, alpha: 1)
        } else {
            return .init(red: 242 / 255, green: 242 / 255, blue: 247 / 255, alpha: 1)
        }
    }
    
    /// set main color of the app after choosing the color in the "SettingsViewController"
    public static func setMainColor(color: UIColor) {
        UserDefaults.standard.mainColor = color
        
        for delegate in delegates {
            delegate.changeColor()
        }
        print("SAVED")
    }
}
