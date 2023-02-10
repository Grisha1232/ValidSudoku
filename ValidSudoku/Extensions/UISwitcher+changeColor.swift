//
//  UISwitcher+changeColor.swift
//  ValidSudoku
//
//  Created by Григорий Селезнев on 2/2/23.
//

import UIKit

extension UISwitch: ChangedColorProtocol {
    func changeColor() {
        onTintColor = SettingsModel.getMainColor()
    }
}
