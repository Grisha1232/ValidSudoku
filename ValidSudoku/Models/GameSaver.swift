//
//  GameSaver.swift
//  ValidSudoku
//
//  Created by Григорий Селезнев on 3/3/23.
//

import UIKit

class GameSaver {
    
    private var states: [GameState]
    
    init() {
        states = []
    }
    
    init(save: GameSaver) {
        self.states = save.states
    }
    
    init(state: GameState) {
        self.states = []
        self.states.append(state)
    }
    
    public func canUndo() -> Bool {
        states.count > 1
    }
    
    public func save(state: GameState) {
        states.append(state)
    }
    
    public func getPrevSave() -> GameState? {
        return states.last
    }
    
    public func getRemoveLast() -> GameState? {
        if (states.count == 0) {
            return nil
        }
        return states.removeLast()
    }
    
    public func getFirstSave() -> GameState? {
        if (states.count == 0) {
            return nil
        }
        return states.first
    }
}
