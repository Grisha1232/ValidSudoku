//
//  SettingsModel.swift
//  ValidSudoku
//
//  Created by Григорий Селезнев on 2/2/23.
//

import UIKit
import CoreData

// entity "Settings"
class SettingsModel {
    
    private static var delegates: [ChangedColorProtocol] = []
    
    public static func appendTo(content: ChangedColorProtocol) {
        delegates.append(content)
    }
    
    // get main color for app
    public static func getMainColor() -> UIColor {
        let color = UserDefaults.standard.mainColor
        if let mainColor = color {
            return mainColor
        } else {
            UserDefaults.standard.mainColor = .systemBlue
            return .systemBlue
        }
    }
    
    public static func getIncorrectColor() -> UIColor {
        .systemRed
    }
    
    // get is it dark mode on attribute "darkMode"
    public static func isDarkMode() -> Bool {
        UserDefaults.standard.isDarkMode
    }
    // switch the dark mode
    public static func switchDarkMode() {
        let currentTheme = UserDefaults.standard.isDarkMode
        UserDefaults.standard.isDarkMode = !currentTheme
    }
    
    public static func getMainBackgroundColor() -> UIColor {
        if (isDarkMode()) {
            return .init(red: 24 / 255, green: 24 / 255, blue: 24 / 255, alpha: 1)
        } else {
            return .white
        }
    }
    
    public static func setThemeMode() {
        
    }
    
    public static func setMainColor(color: UIColor) {
        UserDefaults.standard.mainColor = color
        
        for delegate in delegates {
            delegate.changeColor()
        }
        print("SAVED")
    }
}
