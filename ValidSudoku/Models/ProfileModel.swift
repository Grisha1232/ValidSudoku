//
//  ProfileModel.swift
//  ValidSudoku
//
//  Created by Григорий Селезнев on 3/6/23.
//

import UIKit

class ProfileModel {
    // MARK: - GAMES
    
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
        let result = Double(countAllGames == 0 ? 0.0 : Double(countWonGames) / Double(countAllGames))
        return (result * 100).rounded(.up) / 100
    }
    
    
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
    
    
    
    // MARK: - STREAK
    public static func countCurrentWinStreak(_ isWon: Bool) {
        if (isWon) {
            countUpCurrentWinStreak()
            updateBestWinStreak(getCurrentWinStreak())
        } else {
            let streak = getCurrentWinStreak()
            updateBestWinStreak(streak)
            breakCurrentWinStreak()
        }
    }
    
    /// add one to the current win streak
    private static func countUpCurrentWinStreak() {
        UserDefaults.standard.winStreak += 1
    }
    /// break down the win streak (set winStreak to zero)
    private static func breakCurrentWinStreak() {
        UserDefaults.standard.winStreak = 0
    }
    /// get current win streak
    public static func getCurrentWinStreak() -> Int {
        UserDefaults.standard.winStreak
    }
    
    /// update the best win streak
    private static func updateBestWinStreak(_ streak: Int) {
        UserDefaults.standard.bestStreak = UserDefaults.standard.bestStreak >= streak ? UserDefaults.standard.bestStreak : streak
    }
    /// get the best win streak
    public static func getBestWinStreak() -> Int {
        UserDefaults.standard.bestStreak
    }
    
    
    // MARK: - TIME
    public static func updateTime(_ level: String, _ seconds: Double) {
        switch (level) {
        case "Easy":
            easyGameUpdateTime(seconds)
            break;
        case "Medium":
            mediumGameUpdateTime(seconds)
            break;
        case "Hard":
            hardGameUpdateTime(seconds)
            break;
        case "Expert":
            customGameUpdateTime(seconds)
            break;
        default:
            break;
            
        }
    }
    
    private static func easyGameUpdateTime(_ seconds: Double) {
        UserDefaults.standard.easyGameAveTime += seconds
        if (getEasyGameBestTime() > seconds || getEasyGameBestTime() == 0) {
            easyGameUpdateBestTime(seconds)
        }
    }
    private static func easyGameUpdateBestTime(_ seconds: Double) {
        UserDefaults.standard.easyGameBestTime = seconds
    }
    public static func getEasyGameBestTime() -> Double {
        UserDefaults.standard.easyGameBestTime
    }
    public static func getEasyGameAveTime() -> Double {
        UserDefaults.standard.easyGameAveTime
    }
    
    
    private static func mediumGameUpdateTime(_ seconds: Double) {
        UserDefaults.standard.mediumGameAveTime += seconds
        if (getMediumGameBestTime() > seconds || getMediumGameBestTime() == 0) {
            mediumGameUpdateBestTime(seconds)
        }
    }
    private static func mediumGameUpdateBestTime(_ seconds: Double) {
        UserDefaults.standard.mediumGameBestTime = seconds
    }
    public static func getMediumGameBestTime() -> Double {
        UserDefaults.standard.mediumGameBestTime
    }
    public static func getMediumGameAveTime() -> Double {
        UserDefaults.standard.mediumGameAveTime
    }
    
    
    private static func hardGameUpdateTime(_ seconds: Double) {
        UserDefaults.standard.hardGameAveTime += seconds
        if (getHardGameBestTime() > seconds || getHardGameBestTime() == 0) {
            hardGameUpdateBestTime(seconds)
        }
    }
    private static func hardGameUpdateBestTime(_ seconds: Double) {
        UserDefaults.standard.hardGameBestTime = seconds
    }
    public static func getHardGameBestTime() -> Double {
        UserDefaults.standard.hardGameBestTime
    }
    public static func getHardGameAveTime() -> Double {
        UserDefaults.standard.hardGameAveTime
    }
    
    
    private static func customGameUpdateTime(_ seconds: Double) {
        UserDefaults.standard.customGameAveTime += seconds
        if (getCustomGameBestTime() > seconds || getCustomGameBestTime() == 0) {
            customGameUpdateBestTime(seconds)
        }
    }
    private static func customGameUpdateBestTime(_ seconds: Double) {
        UserDefaults.standard.customGameBestTime = seconds
    }
    public static func getCustomGameBestTime() -> Double {
        UserDefaults.standard.customGameBestTime
    }
    public static func getCustomGameAveTime() -> Double {
        UserDefaults.standard.customGameAveTime
    }
    
}
