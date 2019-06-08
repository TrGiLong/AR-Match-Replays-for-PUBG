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

    let disposeBag = DisposeBag()
    let playerSubject = BehaviorSubject<Player?>(value: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playerSubject.subscribe { (event) in
            print(event)
        }.disposed(by: disposeBag)
        
        PubgAPI.getPlayer(name: "WackyJacky101", platform: .steam, subject: playerSubject)
        
        
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
