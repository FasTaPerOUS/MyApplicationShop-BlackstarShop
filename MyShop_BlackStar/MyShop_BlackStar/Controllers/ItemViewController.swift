import UIKit
import RealmSwift

class ItemViewController: UIViewController {
    
    let realm = try! Realm()
    
    var delegate: ItemControllerDelegate?
    
    var info = OneItemWithAllColors(name: "", description: "", colorName: [], sortOrder: 0, mainImage: [], productImages: [], offers: [], price: [], oldPrice: [], tag: [])
    
    @IBOutlet weak var imagesCollectionView: UICollectionView!
  
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var changeColorButton: UIButton!
    @IBOutlet weak var addItemButton: UIButton!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var currentColorLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var spaceLayoutConstraint: NSLayoutConstraint!

    var checker = 0
    var currIndex = 0
    var currImageIndex = 0
    var images = [UIImage]()
    
    var myAI: ActivityIndicator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myAI = ActivityIndicator(view: self.view)
        for var el in self.info.productImages {
            el.sort(by: {$0.sortOrder < $1.sortOrder})
        }
        if self.checker == 1 {
            self.addItemButton.isHidden = true
        }
        self.addItemButton.layer.cornerRadius = 15
        self.mainLabelsUpdate()
        self.checkAndUpdateColors()
        DispatchQueue.main.async {
            self.startAnimating()
            self.createArrayOfImages()
            self.stopAnimating()
        }
    }
    
    func createArrayOfImages() {
        images = []
        let err = URL(string: "https://wahki.mameau.com/images/0/0a/NoLogo.jpg")
        let errdata = try? Data(contentsOf: err!)
        
        let main = URL(string: "https://blackstarshop.ru/" + info.mainImage[currIndex])
        let maindata = try? Data(contentsOf: main!)
        images.append(UIImage(data: maindata!) ?? UIImage(data: errdata!)!)
        
        for el in info.productImages[currIndex] {
            let url = URL(string: "https://blackstarshop.ru/" + el.imageURL)
            let data = try? Data(contentsOf: url!)
            images.append(UIImage(data: data!) ?? UIImage(data: errdata!)!)
        }
        imagesCollectionView.reloadData()
        checkLeftRightButtons()
    }
    
    func checkLeftRightButtons() {
        if images.count == 1 {
            leftButton.isHidden = true
            rightButton.isHidden = true
            return
        }
        if images.count == 0 {	
            leftButton.isHidden = true
            rightButton.isHidden = true
        } else {
            if currImageIndex == 0 {
                leftButton.isHidden = true
                rightButton.isHidden = false
            } else {
                if currImageIndex == images.count - 1 {
                    leftButton.isHidden = false
                    rightButton.isHidden = true
                } else {
                    leftButton.isHidden = false
                    rightButton.isHidden = false
                }
            }
        }
    }
    
    func checkAndUpdateColors() {
        if info.colorName.count == 1 {
            currentColorLabel.isHidden = true
            changeColorButton.isHidden = true
            spaceLayoutConstraint.constant -= currentColorLabel.bounds.height + 15
        } else {
            changeColorButton.setTitle(info.colorName[currIndex], for: .normal)
        }
    }
    
    func mainLabelsUpdate() {
        nameLabel.text = info.name
        descriptionLabel.text = "    " + info.description
        priceLabel.text = info.price[currIndex] + " ₽"
    }
    
    func createArraySize() -> [String] {
        var arr: [String] = []
        for el in info.offers[currIndex] {
            if el.quantity > 0 { arr.append(el.size)}
        }
        return arr
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? MultiViewController, segue.identifier == "changeColor" {
            vc.text = "Выберите цвет."
            vc.info = info.colorName
            vc.checker = 0
            vc.delegate = self
        }
        if let vc = segue.destination as? MultiViewController, segue.identifier == "selectSize" {
            vc.text = "Выберите размер. После того как вы кликните по нему, товар с этим размером будет добавлен в корзину. Если не хотите выбирать размер, свайпните окно вниз."
            vc.info = createArraySize()
            vc.checker = 1
            vc.delegate = self
        }
    }
    
    
    @IBAction func leftClick() {
        currImageIndex -= 1
        imagesCollectionView.scrollToItem(at: IndexPath(row: currImageIndex, section: 0), at: .left, animated: true)
        checkLeftRightButtons()
    }
    
    @IBAction func rightClick() {
        currImageIndex += 1
        imagesCollectionView.scrollToItem(at: IndexPath(row: currImageIndex, section: 0), at: .right, animated: true)
        checkLeftRightButtons()
    }
    
    

}

extension ItemViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "picture", for: indexPath) as! PictureCollectionViewCell
        cell.imageView.image = images[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = collectionView.bounds.width
        let cellHeight = collectionView.bounds.height
        return CGSize(width: cellWidth, height: cellHeight)
    }
}

extension ItemViewController: ItemControllerDelegate {
    func addItem(withSize: String) {
        let all = self.realm.objects(ItemsRealm.self)
        for el in all {
            if el.name == info.name && el.colorName == info.colorName[currIndex] && el.size == withSize {
                try! realm.write {
                    el.quantity += 1
                }
                return
            }
        }
        let object = ItemsRealm()
        object.name = info.name
        object.descript = info.description
        object.colorName = info.colorName[currIndex]
        object.mainImageURL = info.mainImage[currIndex]
        for el in info.productImages[currIndex] {
            object.productImagesURL.append(el.imageURL)
        }
        object.size = withSize
        object.price = Int(info.price[currIndex]) ?? 99999
        object.oldPrice = Int(info.oldPrice[currIndex]) ?? 99999
        object.tag = info.tag[currIndex]
        object.quantity = 1
        try! realm.write {
            realm.add(object)
        }
    }
    
    func updateInfo(index: Int) {
        if currIndex == index { return }
        currIndex = index
        currImageIndex = 0
        mainLabelsUpdate()
        imagesCollectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .left, animated: true)
        changeColorButton.setTitle(info.colorName[currIndex], for: .normal)
        createArrayOfImages()
    }
}

extension ItemViewController: AIFunctional {
    func startAnimating() {
        myAI!.activityIndicator.startAnimating()
        self.view.addSubview(myAI!.backgorundView)
        self.view.addSubview(myAI!.activityIndicator)
    }
    
    func stopAnimating() {
        myAI!.activityIndicator.stopAnimating()
        myAI!.activityIndicator.removeFromSuperview()
        myAI!.backgorundView.removeFromSuperview()
    }
}
