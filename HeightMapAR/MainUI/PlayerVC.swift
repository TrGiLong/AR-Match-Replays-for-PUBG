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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
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
            return player.data.first?.relationships.matches.data.count ?? 0
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
            cell = UITableViewCell(style: .default, reuseIdentifier: matchCellIden)
        }
        
        cell!.textLabel?.text = player.data.first?.relationships.matches.data[indexPath.row].id ?? "Error"
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            currentAlert = showLoadingAlert(viewController: self)
            PubgAPI.getMatch(playerMatch: (player.data.first?.relationships.matches.data[indexPath.row])!, platform: platform).subscribe(onSuccess: { (match) in
                self.currentAlert?.dismiss(animated: true
                    , completion: {
                        self.performSegue(withIdentifier: self.matchSegue, sender: match)
                })
            }) { (error) in
                print(error)
            }.disposed(by: disposeBag)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == matchSegue {
            (segue.destination as? MatchVC)?.match = (sender as! Match)
        }
    }
}
