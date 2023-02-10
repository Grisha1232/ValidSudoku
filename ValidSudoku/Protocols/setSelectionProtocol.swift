//
//  setSelectionProtocol.swift
//  ValidSudoku
//
//  Created by Григорий Селезнев on 2/9/23.
//

protocol SelectionProtocol {
    func setRowAndColumnOfSelection(_ gameSquare: GameFieldCell, _ row: Int, _ col: Int, _ preFilled: Bool)
}
