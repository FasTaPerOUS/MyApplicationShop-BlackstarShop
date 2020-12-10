//
//  ItemStruct.swift
//  MyShop_BlackStar
//
//  Created by Norik on 06.12.2020.
//  Copyright © 2020 Norik. All rights reserved.
//

import Foundation

struct Item: Codable {
    let name: String
    let description: String
    let colorName: String
    let sortOrder: Int
    let mainImage: String
    let productImages: [ProductImage]
    let offers: [Offer]
    let price: String
    
    private enum CodingKeys: String, CodingKey {
        case name
        case description
        case colorName
        case sortOrder
        case mainImage
        case productImages
        case offers
        case price
    }
    	
    init(from decoder: Decoder) {
        let container = try! decoder.container(keyedBy: CodingKeys.self)
        name = try! container.decode(String.self, forKey: .name)
        description = try! container.decode(String.self, forKey: .description)
        colorName = try! container.decode(String.self, forKey: .colorName)
        if let sortOrderString = try? container.decode(String.self, forKey: .sortOrder) {
            sortOrder = Int(sortOrderString)!
        } else {
            sortOrder = try! container.decode(Int.self, forKey: .sortOrder)
        }
        mainImage = try! container.decode(String.self, forKey: .mainImage)
        productImages = try! container.decode([ProductImage].self, forKey: .productImages)
        offers = try! container.decode([Offer].self, forKey: .offers)
        price = try! container.decode(String.self, forKey: .price)
    }
}

struct ProductImage: Codable {
    let imageURL: String
    let sortOrder: Int
    
    private enum CodingKeys: String, CodingKey {
        case imageURL
        case sortOrder
    }
    
    init(from decoder: Decoder) {
        let container = try! decoder.container(keyedBy: CodingKeys.self)
        imageURL = try! container.decode(String.self, forKey: .imageURL)
        if let sortOrderString = try? container.decode(String.self, forKey: .sortOrder) {
            sortOrder = Int(sortOrderString)!
        } else {
            sortOrder = try! container.decode(Int.self, forKey: .sortOrder)
        }
    }
}

struct Offer: Codable {
    let size: String
    let productOfferID: Int
    let quantity: Int
    
    private enum CodingKeys: String, CodingKey {
        case size
        case productOfferID
        case quantity
    }
    
    init(from decoder: Decoder) {
        let container = try! decoder.container(keyedBy: CodingKeys.self)
        size = try! container.decode(String.self, forKey: .size)
        if let productOfferIDString = try? container.decode(String.self, forKey: .productOfferID) {
            productOfferID = Int(productOfferIDString)!
        } else {
            productOfferID = try! container.decode(Int.self, forKey: .quantity)
        }
        if let quantityString = try? container.decode(String.self, forKey: .quantity) {
            quantity = Int(quantityString) ?? 0
        } else {
            quantity = try! container.decode(Int.self, forKey: .quantity)
        }
    }
}

typealias ItemsWithID = [String: Item]

struct OneItemWithAllColors {
    let name: String
    let description: String
    var colorName: [String]
    let sortOrder: Int
    var mainImage: [String]
    var productImages: [[ProductImage]]
    var offers: [[Offer]]
    var price: [String]
}


