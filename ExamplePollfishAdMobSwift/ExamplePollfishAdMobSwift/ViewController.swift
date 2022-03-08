//
//  ViewController.swift
//  ExamplePollfishAdMobSwift
//
//  Created by Fotis Mitropoulos on 7/12/21.
//

import UIKit
import PollfishAdMobAdapter
import GoogleMobileAds

class ViewController: UIViewController, GADFullScreenContentDelegate {
    
    @IBOutlet weak var rewardedAdBtn: UIButton!
    private var rewardedAd: GADRewardedAd?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createAndLoadRewardedAd()
    }
    
    @IBAction func showRewardedAd(_ sender: Any) {
        if (rewardedAd != nil) {
            rewardedAd?.present(fromRootViewController: self) {
                let reward = self.rewardedAd!.adReward
                print("Reward received with currency \(reward.type), amount \(reward.amount)")
            }
        } else {
            print("Ad wasn't ready")
        }
    }
    
    func createAndLoadRewardedAd() {
        rewardedAdBtn.isHidden = true
        
        let request = GADRequest()
        
        let pollfishNetworkExtras = GADPollfishRewardedNetworkExtras()
        pollfishNetworkExtras.pollfishAPIKey = "POLLFISH_API_KEY"
        pollfishNetworkExtras.releaseMode = false
        pollfishNetworkExtras.requestUUID = "USER_ID";
        
        request.register(pollfishNetworkExtras)
        
        GADRewardedAd.load(withAdUnitID: "ADMOB_AD_UNIT_KEY",
                           request: request) { (ad, error) in
            if (error != nil) {
                print("Failed to load ad with error: \(error!.localizedDescription)")
                return
            }
            self.rewardedAdBtn.isHidden = false
            self.rewardedAd = ad
            self.rewardedAd?.fullScreenContentDelegate = self
        }
    }

    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Rewarded ad is closed")
        createAndLoadRewardedAd()
    }
    
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("Rewarded ad failed to present with error: \(error.localizedDescription)")
    }
    
    func adDidPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Reward ad has presented")
    }
}

