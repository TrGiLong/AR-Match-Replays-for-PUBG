//
//  TestAPI.swift
//  HeightMapAR
//
//  Created by Tran Giang Long on 08.06.19.
//  Copyright © 2019 Tran Giang Long. All rights reserved.
//

import UIKit
import RxSwift

class TestAPI: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        PubgAPI.getPlayer(name: "WackyJacky101dsadsadsadaads", platform: .steam).subscribe(onSuccess: { (player) in
            
        }) { (error) in
            
        }
        
        
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
