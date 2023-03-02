//
//  Numeric+extension.swift
//  ValidSudoku
//
//  Created by Григорий Селезнев on 2/2/23.
//

import UIKit

extension Numeric {
    var data: Data {
        var bytes = self
        return Data(bytes: &bytes, count: MemoryLayout<Self>.size)
    }
}
