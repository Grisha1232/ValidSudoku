//
//  UIWindow+changeColor.swift
//  ValidSudoku
//
//  Created by Григорий Селезнев on 3/11/23.
//

import UIKit

extension UIWindow {
    public func changeColor() {
        if SettingsModel.isDarkMode() {
            self.overrideUserInterfaceStyle = .dark
        } else {
            self.overrideUserInterfaceStyle = .light
        }
    }
}
