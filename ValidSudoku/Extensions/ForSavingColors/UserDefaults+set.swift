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
    
    public var mainColor: UIColor? {
        get { color(forKey: "mainColor") }
        set { set(newValue, forKey: "mainColor") }
    }
    
    public var isDarkMode: Bool {
        get { bool(forKey: "darkMode") }
        set { set(newValue, forKey: "darkMode")}
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
}
