import UIKit
import RealmSwift

class CartViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var discountLabel: UILabel!
    @IBOutlet weak var endPriceLabel: UILabel!
    
    @IBOutlet weak var checkoutButton: UIButton!
    
    let realm = try! Realm()
    
    var all = [ItemsRealm]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkoutButton.layer.cornerRadius = 15
        all = listAll()
        countPrices()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        all = listAll()
        tableView.reloadData()
        countPrices()
    }
    
    @IBAction func deleteCart() {
        let alert = UIAlertController(title: "Очистить корзину", message: "Вы точно уверены что хотите очистить всю корзину?", preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "Очистить", style: .default) { (action: UIAlertAction!) -> Void in
            self.remove()
            self.all = self.listAll()
            self.countPrices()
            self.tableView.reloadData()
        }
        let cancelAction = UIAlertAction(title: "Отмена", style: .default) { (action: UIAlertAction!) -> Void in }
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        present(alert, animated: true, completion: nil)

    }
    
    func countPrices() {
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
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? UITableViewCell, let index = tableView.indexPath(for: cell) {
            let vc = segue.destination as! ItemViewController
            let all = realm.objects(ItemsRealm.self)
            let el = all[index.row]
            var pr = [ProductImage]()
            for a in el.productImagesURL {
                pr.append(ProductImage(imageURL: a, sortOrder: 0))
            }
            vc.info = OneItemWithAllColors(name: el.name, description: el.descript, colorName: [el.colorName], sortOrder: 0, mainImage: [el.mainImageURL], productImages: [pr], offers: [], price: [String(el.price)], oldPrice: [String(el.oldPrice)], tag: [el.tag])
            vc.checker = 1
        }
        if segue.identifier == "goodbye" {
            let vc = segue.destination as! FinishViewController
            if countAll() == 0 {
                vc.text = "Добавьте товары в корзину чтобы оформить заказ.\nЧтобы продолжить тестирование нажмите кнопку назад."
            } else {
                vc.text = "Вот и конец моего проекта, вполне вероятно, что он будет дальше развиваться, желаем удачи!\nЧтобы продолжить тестирование нажмите кнопку назад."
            }
        }
    }

}

extension CartViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countAll()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        all = listAll()
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
            delete(index: indexPath.row)
            all = listAll()
            countPrices()
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.reloadData()
        }
    }
}

extension CartViewController: RealmTableFunctional {
    func countAll() -> Int {
        let all = realm.objects(ItemsRealm.self)
        return all.count
    }
    
    func delete(index: Int) {
        let all = realm.objects(ItemsRealm.self)
        try! realm.write {
            realm.delete(all[index])
        }
    }
    
    func remove() {
        let all = realm.objects(ItemsRealm.self)
        if all.count == 0 { return }
        try! realm.write {
            realm.delete(all)
        }
    }
    
    func listAll() -> [ItemsRealm] {
        let all = realm.objects(ItemsRealm.self)
        return all.createArray()
    }

}

extension Results {
    func createArray() -> [Element] {
        return self.map { $0 }
    }
}
