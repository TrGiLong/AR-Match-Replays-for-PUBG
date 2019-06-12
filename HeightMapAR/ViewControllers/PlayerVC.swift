//
//  PlayerVC.swift
//  HeightMapAR
//
//  Created by Tran Giang Long on 09.06.19.
//  Copyright © 2019 Tran Giang Long. All rights reserved.
//

import UIKit

import RxSwift

class PlayerVC: UIViewController {
    
    let matchSegue = "match"
    
    @IBOutlet weak var tableView: UITableView!
    
    var currentAlert : UIAlertController?
    let disposeBag = DisposeBag()
    
    var player : Player!
    var platform : PubgPlatform!
    
    var matches : [Match] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        if let data = player.data.first?.relationships.matches.data {
            
            let matches = Observable<PlayerMatchesDatum>.from(data).flatMap { (matchData) -> Single<Match> in
                return PubgAPI.getMatch(playerMatch: matchData, platform: self.platform)
            }
            
            matches.subscribe(onNext: { (match) in
                self.matches.append(match)
                self.tableView.reloadData()
            }, onError: { (error) in
                print("Error")
                _ = showAlert(self, title: "Error", message: error.localizedDescription)
            }, onCompleted: {
                
            }).disposed(by: disposeBag)
            
        }
        
    }
}

extension PlayerVC : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        case 1:
            return matches.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            return profilSection(tableView, cellForRowAt: indexPath)
        } else if indexPath.section == 1 {
            return matchesSection(tableView, cellForRowAt: indexPath)
        }
        return UITableViewCell()
    }
    
    func profilSection(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let profilCellIden = "profilCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: profilCellIden)
        
        if (cell == nil) {
            cell = UITableViewCell(style: .value1, reuseIdentifier: profilCellIden)
        }
        
        switch indexPath.row {
        case 0:
            cell?.textLabel?.text = "Name"
            cell?.detailTextLabel?.text =  player.data.first?.attributes.name
        case 1:
            cell?.textLabel?.text = "Platform"
            cell?.detailTextLabel?.text =  platform.rawValue
        default:
            ()
        }
        
        return cell!
    }
    
    func matchesSection(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let matchCellIden = "matchCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: matchCellIden)
        
        if (cell == nil) {
            cell = UITableViewCell(style: .value1, reuseIdentifier: matchCellIden)
        }
        
        let match = matches[indexPath.row]
        let attr = match.data.attributes
        let mapName = PubgAsset.shared.map[attr.mapName]
        
        cell!.textLabel?.text = "\(mapName ?? attr.mapName) (\(attr.gameMode))"
        cell!.detailTextLabel?.text = dateToString(match.data.attributes.createdAt)
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            self.performSegue(withIdentifier: self.matchSegue, sender: matches[indexPath.row])
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == matchSegue {
            (segue.destination as? MatchVC)?.match = (sender as! Match)
            (segue.destination as? MatchVC)?.player = player
        }
    }
    
}
