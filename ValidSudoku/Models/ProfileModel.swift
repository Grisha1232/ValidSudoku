//
//  ProfileModel.swift
//  ValidSudoku
//
//  Created by Григорий Селезнев on 3/6/23.
//

import UIKit

class ProfileModel {
    
    // MARK: - Game started
    ///
    public static func countUpGameStarted(_ level: String) {
        switch (level) {
        case "Easy":
            countUpEasyGameStarted()
            break;
        case "Medium":
            countUpMediumGameStarted()
            break;
        case "Hard":
            countUpHardGameStarted()
            break;
        case "Expert":
            countUpCustomGameStarted()
            break;
        default:
            break;
            
        }
        
    }
    
    ///
    private static func countUpEasyGameStarted() {
        UserDefaults.standard.easyGameStarted += 1
    }
    ///
    public static func getEasyGameStarted() -> Int {
        UserDefaults.standard.easyGameStarted
    }
    
    ///
    private static func countUpMediumGameStarted() {
        UserDefaults.standard.mediumGameStarted += 1
    }
    ///
    public static func getMediumGameStarted() -> Int {
        UserDefaults.standard.mediumGameStarted
    }
    
    ///
    private static func countUpHardGameStarted() {
        UserDefaults.standard.hardGameStarted += 1
    }
    ///
    public static func getHardGamesStarted() -> Int {
        UserDefaults.standard.hardGameStarted
    }
    
    ///
    private static func countUpCustomGameStarted() {
        UserDefaults.standard.customGameStarted += 1
    }
    ///
    public static func getCustomGameStarted() -> Int {
        UserDefaults.standard.customGameStarted
    }
    
    
    //MARK: - Game won
    ///
    public static func countUpGameWon(_ level: String) {
        switch (level) {
        case "Easy":
            countUpEasyGameWon()
            break;
        case "Medium":
            countUpMediumGameWon()
            break;
        case "Hard":
            countUpHardGameWon()
            break;
        case "Expert":
            countUpCustomGameWon()
            break;
        default:
            break;
            
        }
        
    }
    
    ///
    private static func countUpEasyGameWon() {
        UserDefaults.standard.easyGameWon += 1
    }
    ///
    public static func getEasyGameWon() -> Int {
        UserDefaults.standard.easyGameWon
    }
    
    ///
    private static func countUpMediumGameWon() {
        UserDefaults.standard.mediumGameWon += 1
    }
    ///
    public static func getMediumGameWon() -> Int {
        UserDefaults.standard.mediumGameWon
    }
    
    ///
    private static func countUpHardGameWon() {
        UserDefaults.standard.hardGameWon += 1
    }
    ///
    public static func getHardGamesWon() -> Int {
        UserDefaults.standard.hardGameWon
    }
    
    ///
    private static func countUpCustomGameWon() {
        UserDefaults.standard.customGameWon += 1
    }
    ///
    public static func getCustomGameWon() -> Int {
        UserDefaults.standard.customGameWon
    }
    

    //MARK: - Win rate
    public static func calcWinRate(filters: [Bool]) -> Double {
        var countWonGames = 0
        var countAllGames = 0
        if (filters[0]) {
            countAllGames += getEasyGameStarted()
            countWonGames += getEasyGameWon()
        }
        if (filters[1]) {
            countAllGames += getMediumGameStarted()
            countWonGames += getMediumGameWon()
        }
        if (filters[2]) {
            countAllGames += getHardGamesStarted()
            countWonGames += getHardGamesWon()
        }
        if (filters[3]) {
            countAllGames += getCustomGameStarted()
            countWonGames += getCustomGameWon()
        }
        return countAllGames == 0 ? 0.0 : Double(countWonGames) / Double(countAllGames)
    }
    
    
    //MARK: - Wins with no mistakes
    public static func countUpWinWithMoMistakes(_ level: String) {
        switch (level) {
        case "Easy":
            countUpEasyGameWinWithNoMistakes()
            break;
        case "Medium":
            countUpMediumGameWinWithNoMistakes()
            break;
        case "Hard":
            countUpHardGameWinWithNoMistakes()
            break;
        case "Expert":
            countUpCustomGameWinWithNoMistakes()
            break;
        default:
            break;
            
        }
    }
    
    private static func countUpEasyGameWinWithNoMistakes() {
        UserDefaults.standard.easyGameWinWithNoMistakes += 1
    }
    public static func getEasyGameWinWithNoMistakes() -> Int {
        UserDefaults.standard.easyGameWinWithNoMistakes
    }
    
    private static func countUpMediumGameWinWithNoMistakes() {
        UserDefaults.standard.mediumGameWinWithNoMistakes += 1
    }
    public static func getMediumGameWinWithNoMistakes() -> Int {
        UserDefaults.standard.mediumGameWinWithNoMistakes
    }
    
    private static func countUpHardGameWinWithNoMistakes() {
        UserDefaults.standard.hardGameWinWithNoMistakes += 1
    }
    public static func getHardGameWinWithNoMistakes() -> Int {
        UserDefaults.standard.hardGameWinWithNoMistakes
    }
    
    private static func countUpCustomGameWinWithNoMistakes() {
        UserDefaults.standard.customGameWinWithNoMistakes += 1
    }
    public static func getCustomGameWinWithNoMistakes() -> Int {
        UserDefaults.standard.customGameWinWithNoMistakes
    }
}
