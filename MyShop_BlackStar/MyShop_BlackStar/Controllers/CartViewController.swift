import UIKit

class CartViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var discountLabel: UILabel!
    @IBOutlet weak var endPriceLabel: UILabel!
    
    @IBOutlet weak var checkoutButton: UIButton!
    
    let realmClass = RealmClass()
    
    var all = [ItemsRealm]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkoutButton.layer.cornerRadius = 15
        all = realmClass.listAll()
        countPrices()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        all = realmClass.listAll()
        tableView.reloadData()
        countPrices()
    }
    
    @IBAction func deleteCart() {
        let alert = UIAlertController(title: "Очистить корзину", message: "Вы точно уверены что хотите очистить всю корзину?", preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "Очистить", style: .default) { (action: UIAlertAction!) -> Void in
            self.realmClass.remove()
            
            if let tabItems = self.tabBarController?.tabBar.items {
                let tabItem = tabItems[1]
                tabItem.badgeValue = nil
            }
            
            self.all = self.realmClass.listAll()
            self.countPrices()
            self.tableView.reloadData()
        }
        let cancelAction = UIAlertAction(title: "Отмена", style: .default) { (action: UIAlertAction!) -> Void in }
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        present(alert, animated: true, completion: nil)

    }
    
    @objc func countPrices() {
        var sumPWD = 0
        var sumP = 0
        for el in all {
            if el.oldPrice != 99999 {
                sumPWD += Int(el.oldPrice * el.quantity)
            } else {
                sumPWD += Int(el.price * el.quantity)
            }
            sumP += Int(el.price * el.quantity)
        }
        priceLabel.text = "Стоимость: " + String(sumPWD)
        discountLabel.text = "Экономия: " + String(sumPWD - sumP)
        endPriceLabel.text = "Цена: " + String(sumP)
        if let tabItems = tabBarController?.tabBar.items {
            let tabItem = tabItems[1]
            tabItem.badgeValue = String(realmClass.countItems())
            if tabItem.badgeValue == "0" {
                tabItem.badgeValue = nil
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? UITableViewCell, let index = tableView.indexPath(for: cell) {
            let vc = segue.destination as! ItemViewController
            vc.info = realmClass.createItemType(index: index.row)
            vc.checker = 1
        }
        if segue.identifier == "goodbye" {
            let vc = segue.destination as! FinishViewController
            if realmClass.countAll() == 0 {
                vc.text = "Добавьте товары в корзину чтобы оформить заказ.\nЧтобы продолжить тестирование нажмите кнопку назад."
            } else {
                vc.text = "Вот и конец моего проекта, вполне вероятно, что он будет дальше развиваться, желаем удачи!\nЧтобы продолжить тестирование нажмите кнопку назад."
            }
        }
    }

}

extension CartViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return realmClass.countAll()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        all = realmClass.listAll()
        let cell = tableView.dequeueReusableCell(withIdentifier: "item") as! CartTableViewCell
        
        cell.index = indexPath.row
        
        
        cell.nameLabel.text = all[indexPath.row].name
        cell.sizeLabel.text = "Размер: " + all[indexPath.row].size
        cell.priceLabel.text = String(all[indexPath.row].price * all[indexPath.row].quantity) + " ₽"
        cell.quantityLabel.text = String( all[indexPath.row].quantity)
        	
        if all[indexPath.row].quantity == 1 {
            cell.minusButton.isHidden = true
        } else {
            cell.minusButton.isHidden = false
        }
        
        let url = URL(string: "https://blackstarshop.ru/" + all[indexPath.row].mainImageURL)!
        let data = try? Data(contentsOf: url)
        cell.itemImageView.image = UIImage(data: data!)
        
        if all[indexPath.row].tag == "No discount" {
            cell.oldPriceLabel.isHidden = true
            cell.tagLabel.isHidden = true
        } else {
            cell.oldPriceLabel.text = String(all[indexPath.row].oldPrice * all[indexPath.row].quantity)
            cell.tagLabel.text = all[indexPath.row].tag
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let tabItems = tabBarController?.tabBar.items {
                let tabItem = tabItems[1]
                let check = Int(tabItem.badgeValue!)! - realmClass.delete(index: indexPath.row)
                if check == 0 {
                    tabItem.badgeValue = nil
                } else {
                    tabItem.badgeValue = String(check)
                }
            }
            
            all = realmClass.listAll()
            countPrices()
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.reloadData()
        }
    }
}
