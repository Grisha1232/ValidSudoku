//
//  cellTappedProtocol.swift
//  ValidSudoku
//
//  Created by Григорий Селезнев on 1/27/23.
//

import UIKit

protocol CellTappedProtocol {
    func tappedAtCell(fieldCellSelected: GameFieldCell, indexPathSelected indexPath: IndexPath)
}
