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
    
    var mainColor: UIColor? {
        get { color(forKey: "mainColor") }
        set { set(newValue, forKey: "mainColor") }
    }
    
    var isDarkMode: Bool {
        get { bool(forKey: "darkMode") }
        set { set(newValue, forKey: "darkMode")}
    }
}
