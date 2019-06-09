//
//  MatchVC.swift
//  HeightMapAR
//
//  Created by Tran Giang Long on 09.06.19.
//  Copyright © 2019 Tran Giang Long. All rights reserved.
//

import UIKit
import RxSwift

class MatchVC: UITableViewController {

    let arReplaySegue = "arReplay"
    
    var match : Match!
    
    @IBOutlet weak var mapName: UILabel!
    @IBOutlet weak var createdDate: UILabel!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        createdDate.text = match.data.attributes.createdAt.description
        mapName.text = match.data.attributes.mapName
    }

    private var events : [Event]?
    @IBAction func arShow(_ sender: Any) {
        let id = match.data.relationships.assets.data.first!.id
        let url = match.included.first(where: { (matchIncuded) -> Bool in
            return matchIncuded.id == id
        })
        
        let alert = showLoadingAlert(viewController: self)
        PubgAPI.getTelemtry(url: url!.attributes.url!).subscribe(onSuccess: { (events) in
            alert.dismiss(animated: true, completion: {
                self.events = events
                self.performSegue(withIdentifier: self.arReplaySegue, sender: nil)
            })
        }, onError: { (error) in
            print(error)
        }).disposed(by: disposeBag)
 
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == arReplaySegue) {
            (segue.destination as! ARReplay).map = toMap(map: match.data.attributes.mapName)!
            (segue.destination as! ARReplay).events = events!
        }
    }
    
    private func toMap(map : String) -> Map? {
        if map == "Desert_Main" {
            return .miramar
        } else if map == "Erangel_Main" {
            return .erangel
        } else if map == "Savage_Main" {
            return .sanhok
        }
        return nil
    }
}
