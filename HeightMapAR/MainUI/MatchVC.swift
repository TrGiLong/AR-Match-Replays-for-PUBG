//
//  MatchVC.swift
//  HeightMapAR
//
//  Created by Tran Giang Long on 09.06.19.
//  Copyright © 2019 Tran Giang Long. All rights reserved.
//

import UIKit

class MatchVC: UITableViewController {

    var match : Match!
    
    @IBOutlet weak var mapName: UILabel!
    @IBOutlet weak var createdDate: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        createdDate.text = match.data.attributes.createdAt.description
        mapName.text = match.data.attributes.mapName
    }

    @IBAction func arShow(_ sender: Any) {
        
    }
    
}
