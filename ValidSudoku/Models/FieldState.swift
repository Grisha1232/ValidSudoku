//
//  FieldState.swift
//  ValidSudoku
//
//  Created by Григорий Селезнев on 3/3/23.
//

import UIKit

class FieldState: Codable {
    /// field that enters the user
    private let field: [[Int]]
    /// field indicates wether this cell preFilled by game or by user
    private let preFilled: [[Bool]]
    /// answer for the game
    private let answerMatrix: [[Int]]

    init(field: [[Int]], preFilled: [[Bool]], answerMatrix: [[Int]]) {
        self.field = field
        self.preFilled = preFilled
        self.answerMatrix = answerMatrix
    }
    
    public func getField() -> [[Int]] {
        field
    }
    
    public func getPreFilled() -> [[Bool]] {
        preFilled
    }
    
    public func getAnswer() -> [[Int]] {
        answerMatrix
    }
}
