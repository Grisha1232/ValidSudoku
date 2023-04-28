//
//  GameViewController+reward.swift
//  ValidSudoku
//
//  Created by Григорий Селезнев on 4/28/23.
//

import UIKit
import YandexMobileAds

extension GameViewController: YMARewardedAdDelegate {
    
    func rewardedAd(_ rewardedAd: YMARewardedAd, didReward reward: YMAReward) {

        self.rewardAded()
    }
    
    func rewardedAdDidLoad(_ rewardedAd: YMARewardedAd) {
        print("Rewarded ad loaded")
        rewardedAd.present(from: self)
    }
        
    func rewardedAdDidFail(toLoad rewardedAd: YMARewardedAd, error: Error) {
        print("Loading failed. Error: %@", error)
    }

    func rewardedAdDidClick(_ rewardedAd: YMARewardedAd) {
        print("Ad clicked")
    }

    func rewardedAd(_ rewardedAd: YMARewardedAd, didTrackImpressionWith impressionData: YMAImpressionData?) {
        print("Impression tracked")
    }
    
    func rewardedAdWillLeaveApplication(_ rewardedAd: YMARewardedAd) {
        print("Rewarded ad will leave application")
    }
    
    func rewardedAdDidFail(toPresent rewardedAd: YMARewardedAd, error: Error) {
        print("Failed to present rewarded ad. Error: %@", error)
    }
    
    func rewardedAdWillAppear(_ rewardedAd: YMARewardedAd) {
        print("Rewarded ad will appear")
    }

    func rewardedAdDidAppear(_ rewardedAd: YMARewardedAd) {
        print("Rewarded ad did appear")
    }
    
    func rewardedAdWillDisappear(_ rewardedAd: YMARewardedAd) {
        print("Rewarded ad will disappear")
    }

    func rewardedAdDidDisappear(_ rewardedAd: YMARewardedAd) {
        print("Rewarded ad did disappear")
    }
    
    func rewardedAd(_ rewardedAd: YMARewardedAd, willPresentScreen viewController: UIViewController?) {
        print("Rewarded ad will present screen")
    }

}


extension GameViewController: YMAInterstitialAdDelegate {
    func interstitialAdDidLoad(_ interstitialAd: YMAInterstitialAd) {
        print("add loaded")
        self.pauseTimer()
        interstitialAd.present(from: self)
    }
    
    func interstitialAdWillDisappear(_ interstitialAd: YMAInterstitialAd) {
        print("add wil be closed")
    }
    
    func interstitialAdDidDisappear(_ interstitialAd: YMAInterstitialAd) {
        print("ad closed")
        self.resumeTimer()
    }
}
