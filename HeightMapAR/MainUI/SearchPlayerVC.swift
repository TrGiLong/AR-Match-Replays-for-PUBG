//
//  SearchPlayerVC.swift
//  HeightMapAR
//
//  Created by Tran Giang Long on 09.06.19.
//  Copyright © 2019 Tran Giang Long. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

class SearchPlayerVC: UITableViewController {
    
    private let PlayerSegue = "player"
    
    @IBOutlet weak var playerTextField: UITextField!
    
    @IBOutlet weak var platformPicker: UIPickerView!
    var currentPlatform : PubgPlatform!
    
    var currentAlert : UIAlertController?
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let source = [PubgPlatform.steam,PubgPlatform.xbox,PubgPlatform.psn,PubgPlatform.kakao]
        let items = Observable<[PubgPlatform]>.of(source)
        items.bind(to: platformPicker.rx.itemTitles) { (row, element) in return element.rawValue }.disposed(by: disposeBag)
        platformPicker.rx.itemSelected.bind { (row, element) in
            self.currentPlatform = source[row]
        }.disposed(by: disposeBag)
        
        currentPlatform = source[0]
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func search(_ sender: Any) {
        
        if (playerTextField.text?.count == 0) {
            missingPlayerNameAlert()
            return
        }
        
        loadingAlert()
        PubgAPI.getPlayer(name: playerTextField.text!, platform: currentPlatform).subscribe(onSuccess: { (player) in
            self.currentAlert?.dismiss(animated: true, completion: nil)
            self.performSegue(withIdentifier: self.PlayerSegue, sender: player)
        }) { (error) in
            self.currentAlert?.dismiss(animated: true, completion: nil)
            self.missingPlayerNameAlert()
        }.disposed(by: disposeBag)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == PlayerSegue {
            (segue.destination as! PlayerVC).player = (sender as! Player)
            (segue.destination as! PlayerVC).platform = currentPlatform
        }
    }

    func missingPlayerNameAlert() {
        let alert = UIAlertController(title: "Error", message: "Player name is empty", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { action in }))
        self.currentAlert = alert
        present(alert, animated: true, completion: nil)
    }
    
    func playerNotFoundAlert() {
        let alert = UIAlertController(title: "Ops!", message: "Could not find player with this name", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { action in }))
        self.currentAlert = alert
        present(alert, animated: true, completion: nil)
    }

    func loadingAlert() {
        self.currentAlert = showLoadingAlert(viewController: self)
    }
    
}
