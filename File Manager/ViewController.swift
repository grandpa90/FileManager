//
//  ViewController.swift
//  File Manager
//
//  Created by Zakaria Darwish on 09/11/2023.
//

import UIKit
import AppLovinSDK

class ViewController: UIViewController, MAAdViewAdDelegate{
    var adView: MAAdView!

    func didExpand(_ ad: MAAd) {
        
    }
    
    func didCollapse(_ ad: MAAd) {
        
    }
    
    func didLoad(_ ad: MAAd) {
        
    }
    
    func didFailToLoadAd(forAdUnitIdentifier adUnitIdentifier: String, withError error: MAError) {
        
    }
    
    func didDisplay(_ ad: MAAd) {
        
    }
    
    func didHide(_ ad: MAAd) {
        
    }
    
    func didClick(_ ad: MAAd) {
        
    }
    
    func didFail(toDisplay ad: MAAd, withError error: MAError) {
        
    }
    
    func createBannerAd()
     {
       adView = MAAdView(adUnitIdentifier: "39c296e9e49873e5")
       adView.delegate = self

       // Banner height on iPhone and iPad is 50 and 90, respectively
       let height: CGFloat = (UIDevice.current.userInterfaceIdiom == .pad) ? 90 : 50

       // Stretch to the width of the screen for banners to be fully functional
       let width: CGFloat = UIScreen.main.bounds.width

         adView.frame = CGRect(x: 0, y: UIScreen.main.bounds.height-125, width: width, height: height)

       // Set background or background color for banners to be fully functional
         adView.backgroundColor = .white

       view.addSubview(adView)

       // Load the first ad
       adView.loadAd()
     }

    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    
    
    func setupUI() {
                
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            versionLabel.text = String(format: "Version:%@", version)
        } else {
            versionLabel.text = "NA"
        }
        
        aboutUsTextView.text = "Welcome to File Manager App, your go-to solution for efficient file management on iOS devices. Our app is designed with simplicity and functionality in mind, providing you with a seamless experience to organize, access, and share your files effortlessly."
        
        createBannerAd()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        // Do any additional setup after loading the view.
    }


    @IBOutlet weak var aboutUsTextView: UITextView!
}

