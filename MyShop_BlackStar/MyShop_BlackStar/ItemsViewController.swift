//
//  ItemsViewController.swift
//  MyShop_BlackStar
//
//  Created by Norik on 04.12.2020.
//  Copyright © 2020 Norik. All rights reserved.
//

import UIKit

class ItemsViewController: UIViewController {
    
    var urlString: String = "https://blackstarshop.ru/index.php?route=api/v1/products&cat_id="
    var id: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        print(urlString)
        
        // Do any additional setup after loading the view.
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
