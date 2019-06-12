//
//  BannerVC.swift
//  HeightMapAR
//
//  Created by Tran Giang Long on 11.06.19.
//  Copyright © 2019 Tran Giang Long. All rights reserved.
//

import UIKit
import GoogleMobileAds

class BannerVC: UIViewController {
    
    @IBOutlet weak var banner: GADBannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        banner.adUnitID = "ca-app-pub-3647931127850528/6383593374"
        
        banner.rootViewController = self
        
        let request = GADRequest()
        request.testDevices = [ "7c428108df7bb33ee80dac13a5296149" ]
        banner.load(request)
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
