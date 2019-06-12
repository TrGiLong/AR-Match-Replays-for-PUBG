//
//  MapOpenVC.swift
//  HeightMapAR
//
//  Created by Tran Giang Long on 11.06.19.
//  Copyright © 2019 Tran Giang Long. All rights reserved.
//

import UIKit

class MapOpenVC: UITableViewController {

    private let kSK = "sk"
    private let kAR = "ar"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == kSK {
            (segue.destination as! SCMap).map = sender as! Map
        } else if segue.identifier == kAR {
            (segue.destination as! ARView).map = sender as! Map
        }
    }

    @IBAction func vikendiOpen(_ sender: Any) {
        performSegue(withIdentifier: kSK, sender: Map.vikendi)
    }
    @IBAction func vikendiAROpen(_ sender: Any) {
        performSegue(withIdentifier: kAR, sender: Map.vikendi)
    }
    @IBAction func sanhokOpen(_ sender: Any) {
        performSegue(withIdentifier: kSK, sender: Map.sanhok)
    }
    @IBAction func sanhokAROpen(_ sender: Any) {
        performSegue(withIdentifier: kAR, sender: Map.sanhok)
    }
    @IBAction func miramaOpen(_ sender: Any) {
        performSegue(withIdentifier: kSK, sender: Map.miramar)
    }
    @IBAction func miramaAROpen(_ sender: Any) {
        performSegue(withIdentifier: kAR, sender: Map.miramar)
    }
    @IBAction func erangelOpen(_ sender: Any) {
        performSegue(withIdentifier: kSK, sender: Map.erangel)
    }
    @IBAction func erangelAROpen(_ sender: Any) {
        performSegue(withIdentifier: kAR, sender: Map.erangel)
    }
}
