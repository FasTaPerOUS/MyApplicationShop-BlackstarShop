//
//  SubCategoriesViewController.swift
//  infoShop_BlackStar
//
//  Created by Norik on 28.11.2020.
//  Copyright © 2020 Norik. All rights reserved.
//

import UIKit

class SubCategoriesViewController: UIViewController {
    
    @IBOutlet weak var subCategoriesTable: UITableView!
    @IBOutlet weak var extraLabel: UILabel!
    @IBOutlet weak var extraButton: UIButton!
    
    var info = [SubCategory]()
    var extraID: Int? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checker()
    }
    
    func checker() {
        if info.count == 0 {
            self.subCategoriesTable.isHidden = true
            return
        }
        info.sort(by: {$0.sortOrder < $1.sortOrder && $0.name < $1.name})
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? UITableViewCell, let index = subCategoriesTable.indexPath(for: cell) {
            let vc = segue.destination as! ItemsViewController
            vc.urlString += String(info[index.row].id)
        }
        if let _ = sender as? UIButton {
            let vc = segue.destination as! ItemsViewController
            vc.urlString += String(extraID!)
        }
    }
}

extension SubCategoriesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return info.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "subCategory") as! CategoryTableViewCell
        if info[indexPath.row].iconImage != "" {
            let url = URL(string: "https://blackstarshop.ru/" + info[indexPath.row].iconImage)!
            let data = try? Data(contentsOf: url)
            cell.logoImageView.image = UIImage(data: data!)
        } else {
            let url = URL(string: "https://wahki.mameau.com/images/0/0a/NoLogo.jpg")!
            let data = try? Data(contentsOf: url)
            cell.logoImageView.image = UIImage(data: data!)
        }
        cell.nameLabel.text = info[indexPath.row].name
        return cell
    }
}
