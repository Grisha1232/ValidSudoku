//
//  setSelectionProtocol.swift
//  ValidSudoku
//
//  Created by Григорий Селезнев on 2/9/23.
//

protocol SelectionProtocol {
    func setRowAndColumnOfSelection(_ gameSquare: GameFieldSquare, _ row: Int, _ col: Int, _ preFilled: Bool)
    
    func countUpMistakes()
}
