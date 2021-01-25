//
//  ItemsViewController.swift
//  MyShop_BlackStar
//
//  Created by Norik on 04.12.2020.
//  Copyright © 2020 Norik. All rights reserved.
//

import UIKit

class ItemsViewController: UIViewController, ItemsLoad {
    
    @IBOutlet weak var itemsCollectionView: UICollectionView!
    
    var urlString: String = "https://blackstarshop.ru/index.php?route=api/v1/products&cat_id="
    var info = [Item]()
    var items = [OneItemWithAllColors]()
    
    var myAI: ActivityIndicator?

    override func viewDidLoad() {
        myAI = ActivityIndicator(view: self.view)
        DispatchQueue.main.async {
            super.viewDidLoad()
            self.startAnimating()
        }
        
        itemsLoad(completion: { result in
        switch result {
            case .success(let z):
                for value in z.values {
                    self.info.append(value)
                }
                self.info.sort(by: { $0.sortOrder < $1.sortOrder })
                self.creatingItemsForCollection()
                DispatchQueue.main.async {
                    self.itemsCollectionView.reloadData()
                    self.stopAnimating()
                }
            case .failure(let err):
                DispatchQueue.main.async {
                    self.itemsCollectionView.isHidden = true
                    self.stopAnimating()
                }
                print(err.localizedDescription)
            }
        })
    }
        

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? UICollectionViewCell, let index = itemsCollectionView.indexPath(for: cell) {
            let vc = segue.destination as! ItemViewController
            vc.info = items[index.row]
        }
    }
    
    func creatingItemsForCollection() {
        for (index, el) in info.enumerated() {
            let i = el.price.firstIndex(of: ".") ?? el.price.endIndex
            let i2 = el.oldPrice.firstIndex(of: ".") ?? el.oldPrice.endIndex
            var oldPrice: String
            var tag: String
            if el.oldPrice == "No old price" {
                oldPrice = "No old price"
                tag = "No discount"
            } else {
                oldPrice = String(el.oldPrice[..<i2])
                tag = el.tag
            }
            let newEl = OneItemWithAllColors(name: el.name, description: el.description, colorName: [el.colorName], sortOrder: el.sortOrder, mainImage: [el.mainImage], productImages: [el.productImages], offers: [el.offers], price: [String(el.price[..<i])], oldPrice: [oldPrice], tag: [tag])
            if index == 0 {
                items.append(newEl)
            } else {
                if el.name == items[items.count - 1].name {
                    items[items.count - 1].colorName.append(el.colorName)
                    items[items.count - 1].mainImage.append(el.mainImage)
                    items[items.count - 1].price.append(String(el.price[..<i]))
                    items[items.count - 1].offers.append(el.offers)
                    items[items.count - 1].productImages.append(el.productImages)
                    items[items.count - 1].oldPrice.append(oldPrice)
                    items[items.count - 1].tag.append(tag)
                } else { items.append(newEl) }
            }
        }
    }
    
    func itemsLoad(completion: @escaping (Result<ItemsWithID, Error>) -> Void) {
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url, completionHandler: {(data, response, error) in
            guard let data = data else { return }
            let decoder = JSONDecoder()
            do {
                completion(.success(try decoder.decode(ItemsWithID.self, from: data)))
            } catch {
                completion(.failure(error))
            }
        }).resume()
    }

}

extension ItemsViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "item", for: indexPath) as! ItemCollectionViewCell
        cell.nameLabel.text = items[indexPath.row].name
        
        var url = URL(string: "https://blackstarshop.ru/")
        if items[indexPath.row].mainImage[0] != "" {
            url = URL(string: "https://blackstarshop.ru/" + items[indexPath.row].mainImage[0])!
        } else {
            url = URL(string: "https://wahki.mameau.com/images/0/0a/NoLogo.jpg")!
        }
        let data = try? Data(contentsOf: url!)
        cell.itemImageView.image = UIImage(data: data!)
        
        if items[indexPath.row].oldPrice[0] == "No old price" {
            cell.oldPriceLabel.isHidden = true
        } else {
            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: items[indexPath.row].oldPrice[0])
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSMakeRange(0, attributeString.length))
            cell.oldPriceLabel.attributedText = attributeString
            cell.leftConstraint.constant = 30 + cell.oldPriceLabel.frame.width
        }

        cell.priceLabel.text = items[indexPath.row].price[0] + " ₽"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfCell: CGFloat = 2
        let cellWidth = UIScreen.main.bounds.size.width / numberOfCell
        return CGSize(width: cellWidth - 5, height: 67 + (cellWidth * 84 / 63) - 20)
    }
    
}

extension ItemsViewController: AIFunctional {
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
