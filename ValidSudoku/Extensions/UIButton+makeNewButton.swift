//
//  UIButton+makeNewButton.swift
//  ValidSudoku
//
//  Created by Григорий Селезнев on 1/24/23.
//

import UIKit

extension UIButton {
    
    static func makeNewButton(title: String) -> UIButton {
        let button = UIButton()
        button.setHeight(50)
        button.backgroundColor = SettingsModel.getMainColor()
        button.layer.cornerRadius = 16
        button.setTitle(title, for: .normal)
        button.setTitleColor(SettingsModel.isDarkMode() ? .darkText : .white, for: .normal)
        return button
    }
    
    static func makeNewColorButton(color: UIColor) -> UIButton {
        let button = UIButton()
        button.setHeight(30)
        button.setWidth(30)
        button.layer.cornerRadius = 15
        button.backgroundColor = color
        
        return button
    }
    
    static func makeStackViewButton(levelFilter: String) -> UIButton {
        let button = UIButton()
        button.setTitle(levelFilter, for: .normal)
        button.setTitleColor(SettingsModel.getMainColor(), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16)
        button.setHeight(30)

        return button
    }
}
