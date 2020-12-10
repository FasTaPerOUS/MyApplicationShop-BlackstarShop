//
//  ItemsLoadProtocol.swift
//  MyShop_BlackStar
//
//  Created by Norik on 06.12.2020.
//  Copyright © 2020 Norik. All rights reserved.
//

import Foundation

protocol ItemsLoad {
    func itemsLoad(completion: @escaping (Result<ItemsWithID, Error>) -> Void)
}
