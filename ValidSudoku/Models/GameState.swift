//
//  GameState.swift
//  ValidSudoku
//
//  Created by Григорий Селезнев on 3/3/23.
//

import UIKit

public struct GameState: Codable {
    private let levelString: String
    private let mistakesCount: Int
    private let timer: Double
    private let fieldState: FieldState
    
    init (levelString: String, mistakesCount: Int, timer: Double, fieldState: FieldState) {
        self.levelString = levelString
        self.mistakesCount = mistakesCount
        self.timer = timer
        self.fieldState = fieldState
    }
    
    public func getMistakes() -> Int {
        mistakesCount
    }
    
    public func getLevel() -> String {
        levelString
    }
    
    public func getTimer() -> Double {
        timer
    }
    
    internal func getFieldState() -> FieldState {
        fieldState
    }
}
