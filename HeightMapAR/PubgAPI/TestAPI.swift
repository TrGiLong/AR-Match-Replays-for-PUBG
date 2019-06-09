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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        PubgAPI.getTelemtry(url: "https://telemetry-cdn.playbattlegrounds.com/bluehole-pubg/pc-eu/2019/06/08/19/26/62a355b7-8a23-11e9-9ff9-0a5864672603-telemetry.json").subscribe(onSuccess: { (event) in
            print(event.count)
        }) { (error) in
            print(error)
        }.disposed(by: disposeBag)
        
//        PubgAPI.getPlayer(name: "WackyJacky101", platform: .steam).flatMap { (player) -> Single<Match> in
//            return PubgAPI.getMatch(playerMatch: player.data.first!.relationships.matches.data.first!, platform: .steam)
//            }.flatMap({ (match) -> Single<[Event]> in
//
//                let id = match.data.relationships.assets.data.first!.id
//                let url = match.included.first(where: { (matchIncuded) -> Bool in
//                    return matchIncuded.id == id
//                })?.attributes.url
//
//                return PubgAPI.getTelemtry(url: url!)
//            }).subscribe(onSuccess: { (events) in
//                print(events.count)
//            }, onError: { (error) in
//                print(error)
//            }).disposed(by: disposeBag)
//
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
