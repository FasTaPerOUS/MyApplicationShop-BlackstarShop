import UIKit
import RealmSwift

class CartTableViewCell: UITableViewCell {
    let realm = try! Realm()
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var oldPriceLabel: UILabel!
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var minusButton: UIButton!
    
    var index = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        minusButton.layer.cornerRadius = minusButton.bounds.height / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func gabella() {
        let num = Int(quantityLabel.text!)! - 1

        let all = realm.objects(ItemsRealm.self)
        try! realm.write {
            all[index].quantity = num
        }
        
        quantityLabel.text = String(num)
        priceLabel.text = String(all[index].price * num)
        oldPriceLabel.text = String(all[index].oldPrice * num)
        if quantityLabel.text == "1" {
            minusButton.isHidden = true
        }
    }
}
