import UIKit
import RealmSwift

class CartViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var endPriceLabel: UILabel!
    
    @IBOutlet weak var checkoutButton: UIButton!
    
    let realm = try! Realm()
    
    var all = [ItemsRealm]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkoutButton.layer.cornerRadius = 15
        all = listAll()
        endPriceLabel.text = endPrice()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        all = listAll()
        tableView.reloadData()
        endPriceLabel.text = endPrice()
    }
    
    @IBAction func deleteCart() {
        let alert = UIAlertController(title: "Очистить корзину", message: "Вы точно уверены что хотите очистить всю корзину?", preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "Очистить", style: .default) { (action: UIAlertAction!) -> Void in
            self.remove()
            self.all = self.listAll()
            self.tableView.reloadData()
            self.endPriceLabel.text = self.endPrice()
        }
        let cancelAction = UIAlertAction(title: "Отмена", style: .default) { (action: UIAlertAction!) -> Void in }
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        present(alert, animated: true, completion: nil)

    }
    
    func endPrice() -> String {
        var sum = 0
        for el in all {
            sum += Int(el.price)
        }
        return "Итого: " + String(sum) + " ₽"
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
                vc.text = "Добавьте товары в корзину чтобы оформить заказ\nчтобы продолжить тестирование нажмите кнопку назад"
            } else {
                vc.text = "Вот и конец моего проекта, вполне вероятно, что он будет дальше развиваться, желаем удачи!\nчтобы продолжить тестирование нажмите кнопку назад"
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
        cell.nameLabel.text = all[indexPath.row].name
        cell.sizeLabel.text = "Размер: " + all[indexPath.row].size
        cell.priceLabel.text = String(all[indexPath.row].price) + " ₽"
        let url = URL(string: "https://blackstarshop.ru/" + all[indexPath.row].mainImageURL)!
        let data = try? Data(contentsOf: url)
        cell.itemImageView.image = UIImage(data: data!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            delete(index: indexPath.row)
            all = listAll()
            endPriceLabel.text = endPrice()
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.reloadData()
        }
    }
}

extension CartViewController: RealmTableFunctional {
    func countAll() -> Int {
        let all = self.realm.objects(ItemsRealm.self)
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
        try! self.realm.write {
            self.realm.delete(all)
        }
    }
    
    func listAll() -> [ItemsRealm] {
        let all = self.realm.objects(ItemsRealm.self)
        return all.createArray()
    }

}

extension Results {
    func createArray() -> [Element] {
        return self.map { $0 }
    }
}
