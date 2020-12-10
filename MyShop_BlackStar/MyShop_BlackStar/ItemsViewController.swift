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

    override func viewDidLoad() {
        super.viewDidLoad()
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
                }
            case .failure(let err):
                DispatchQueue.main.async {
                    self.itemsCollectionView.isHidden = true
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
            let newEl = OneItemWithAllColors(name: el.name, description: el.description, colorName: [el.colorName], sortOrder: el.sortOrder, mainImage: [el.mainImage], productImages: [el.productImages], offers: [el.offers], price: [String(el.price[..<i])])
            if index == 0 {
                items.append(newEl)
            } else {
                if el.name == items[items.count - 1].name {
                    items[items.count - 1].colorName.append(el.colorName)
                    items[items.count - 1].mainImage.append(el.mainImage)
                    items[items.count - 1].price.append(String(el.price[..<i]))
                    items[items.count - 1].offers.append(el.offers)
                    items[items.count - 1].productImages.append(el.productImages)
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
        cell.priceLabel.text = items[indexPath.row].price[0] + " руб."
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfCell: CGFloat = 2
        let cellWidth = UIScreen.main.bounds.size.width / numberOfCell
        return CGSize(width: cellWidth - 5, height: 67 + (cellWidth * 84 / 63) - 20)
    }
    
}
