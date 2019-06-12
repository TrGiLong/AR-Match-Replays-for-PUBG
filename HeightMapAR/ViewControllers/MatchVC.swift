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
    let replaySegue = "replay"
    
    var player : Player!
    var match : Match!
    
    @IBOutlet weak var mapName: UILabel!
    @IBOutlet weak var createdDate: UILabel!
    @IBOutlet weak var duration: UILabel!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let attr = match.data.attributes
        
        createdDate.text = dateToString(attr.createdAt)
        mapName.text = match.data.attributes.mapName
        
        let map = PubgAsset.shared.map[attr.mapName]
        mapName.text = map ?? attr.mapName
        
        duration.text = "\(Int(attr.duration/60)) minute"
    }

    private var events : [Event]?
    @IBAction func arShow(_ sender: Any) {
        
        if toMap(map: match.data.attributes.mapName) == nil {
            _ = showAlert(self, title: "Ops!", message: "This map is not support to show")
            return
        }
        
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
    @IBAction func replayShow(_ sender: Any) {
        
        if (toMap(map: match.data.attributes.mapName) ==  nil) {
            _ = showAlert(self, title: "Ops!", message: "Unsupported map")
            return
        }
        
        let id = match.data.relationships.assets.data.first!.id
        let url = match.included.first(where: { (matchIncuded) -> Bool in
            return matchIncuded.id == id
        })
        
        let alert = showLoadingAlert(viewController: self)
        PubgAPI.getTelemtry(url: url!.attributes.url!).subscribe(onSuccess: { (events) in
            alert.dismiss(animated: true, completion: {
                self.events = events
                self.performSegue(withIdentifier: self.replaySegue, sender: nil)
            })
        }, onError: { (error) in
            print(error)
        }).disposed(by: disposeBag)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == arReplaySegue) {
            (segue.destination as! ARReplay).map = toMap(map: match.data.attributes.mapName)!
            (segue.destination as! ARReplay).events = events!
            (segue.destination as! ARReplay).mainPlayer = player
            (segue.destination as! ARReplay).speed = Double(Int(speed.value))
        } else if (segue.identifier == replaySegue) {
            (segue.destination as! SCReplay).map = toMap(map: match.data.attributes.mapName)!
            (segue.destination as! SCReplay).events = events!
            (segue.destination as! SCReplay).mainPlayer = player
            (segue.destination as! SCReplay).speed = Double(Int(speed.value))
        }
    }
    
    @IBOutlet weak var speed: UISlider!
    @IBAction func speed(_ sender: UISlider) {
        speedLabel.text = "\(Int(sender.value))x"
    }
    @IBOutlet weak var speedLabel: UILabel!
    
    private func toMap(map : String) -> Map? {
        if map == "Desert_Main" {
            return .miramar
        } else if map == "Erangel_Main" {
            return .erangel
        } else if map == "Savage_Main" {
            return .sanhok
        } else if map == "DihorOtok_Main" {
            return .vikendi
        }
        
        return nil
    }
}
